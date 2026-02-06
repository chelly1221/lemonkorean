/**
 * Web Deployment Service
 *
 * Handles web app deployment workflow:
 * 1. Execute build_web.sh on host
 * 2. Track progress and capture logs
 * 3. Validate deployment
 */

const { exec } = require('child_process');
const { Pool } = require('pg');
const Redis = require('redis');

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

// Redis client - use existing connection from config
const { getRedisClient } = require('../config/redis');

// Get Redis client lazily
function getRedis() {
  return getRedisClient();
}

// Constants
const BUILD_SCRIPT_PATH = '/project/mobile/lemon_korean/build_web.sh';
const DEPLOY_LOCK_KEY = 'deploy:web:lock';
const DEPLOY_LOCK_TTL = 900; // 15 minutes

// Web deployment phase milestones for progress tracking
const WEB_DEPLOY_PHASES = [
  // 초기화 (0-15%)
  { pattern: /Creating deployment trigger/i, progress: 5, status: 'pending' },
  { pattern: /Starting (web )?deployment( \d+)?/i, progress: 10, status: 'building' },
  { pattern: /Executing build script/i, progress: 12, status: 'building' },

  // 빌드 준비 (15-30%)
  { pattern: /Cleaning previous build/i, progress: 15, status: 'building' },
  { pattern: /Deleting build\.\.\./i, progress: 16, status: 'building' },
  { pattern: /Getting dependencies/i, progress: 20, status: 'building' },
  { pattern: /Resolving dependencies/i, progress: 25, status: 'building' },
  { pattern: /Downloading packages|Got dependencies/i, progress: 30, status: 'building' },

  // 컴파일 (30-75%) - 가장 긴 단계
  { pattern: /Building Flutter web app/i, progress: 35, status: 'building' },
  { pattern: /Compiling lib\/main\.dart for the Web\.{3,}$/m, progress: 40, status: 'building' },
  { pattern: /Font asset .* was tree-shaken/i, progress: 60, status: 'building' },
  { pattern: /Compiling lib\/main\.dart for the Web\.{3,}\d+\.\d+s$/m, progress: 75, status: 'building' },
  { pattern: /✓ Built build\/web/i, progress: 78, status: 'building' },

  // 배포 (75-95%)
  { pattern: /Syncing to NAS deployment directory/i, progress: 80, status: 'syncing' },
  { pattern: /sending incremental file list/i, progress: 82, status: 'syncing' },
  { pattern: /sent .* bytes.*received .* bytes/i, progress: 88, status: 'syncing' },
  { pattern: /Restarting nginx/i, progress: 92, status: 'restarting' },
  { pattern: /Container lemon-nginx/i, progress: 95, status: 'restarting' },

  // 완료 (95-100%)
  { pattern: /Done! Web app deployed/i, progress: 98, status: 'validating' },
  { pattern: /Deployment completed successfully/i, progress: 99, status: 'validating' }
];

// Error patterns for early failure detection
const ERROR_PATTERNS = [
  /Error: Failed to compile/i,
  /Target dart2js failed/i,
  /ProcessException/i,
  /BUILD FAILED/i,
  /Exception:/i,
  /fatal:/i
];

/**
 * Start web deployment
 * @param {number} adminId - Admin user ID
 * @param {string} adminEmail - Admin email
 * @returns {Promise<number>} Deployment ID
 */
async function startDeployment(adminId, adminEmail) {
  const redis = getRedis();

  // Check for concurrent deployment
  const isLocked = await redis.get(DEPLOY_LOCK_KEY);
  if (isLocked) {
    throw new Error('Deployment already in progress');
  }

  // Create deployment record
  const result = await pool.query(
    `INSERT INTO web_deployments (admin_id, admin_email, status, progress)
     VALUES ($1, $2, 'pending', 0)
     RETURNING id`,
    [adminId, adminEmail]
  );
  const deploymentId = result.rows[0].id;

  // Acquire lock
  await redis.setEx(DEPLOY_LOCK_KEY, DEPLOY_LOCK_TTL, deploymentId.toString());

  // Execute deployment asynchronously
  executeDeployment(deploymentId).catch(err => {
    console.error('[DEPLOY] Unhandled error:', err);
  });

  return deploymentId;
}

/**
 * Update status with retry logic
 */
async function updateStatusWithRetry(deploymentId, status, options = {}) {
  const maxRetries = 3;
  const { completedAt, duration, errorMessage, progress } = options;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const updates = ['status = $1'];
      const params = [status];
      let paramIndex = 2;

      if (progress !== undefined) {
        updates.push(`progress = $${paramIndex++}`);
        params.push(progress);
      }
      if (completedAt) {
        updates.push(`completed_at = NOW()`);
      }
      if (duration !== undefined) {
        updates.push(`duration_seconds = $${paramIndex++}`);
        params.push(duration);
      }
      if (errorMessage !== undefined) {
        updates.push(`error_message = $${paramIndex++}`);
        params.push(errorMessage);
      }

      params.push(deploymentId);

      await pool.query(
        `UPDATE web_deployments SET ${updates.join(', ')} WHERE id = $${paramIndex}`,
        params
      );

      return; // Success
    } catch (err) {
      console.error(`[DEPLOY] Status update attempt ${attempt} failed:`, err);

      if (attempt === maxRetries) {
        // Last attempt failed - write to recovery log
        const fs = require('fs').promises;
        const recoveryLog = '/app/src/deploy-triggers/status-update-failures.log';
        const entry = JSON.stringify({
          deploymentId,
          status,
          options,
          timestamp: new Date().toISOString(),
          error: err.message
        }) + '\n';

        try {
          await fs.appendFile(recoveryLog, entry);
        } catch (logErr) {
          console.error('[DEPLOY] Failed to write recovery log:', logErr);
        }

        throw err;
      }

      // Exponential backoff: 1s, 2s, 4s
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt - 1) * 1000));
    }
  }
}

/**
 * Execute deployment process
 * Runs build_web.sh, captures output, updates status
 */
async function executeDeployment(deploymentId) {
  const startTime = Date.now();
  let isCancelled = false;
  let currentProgress = 0; // Track current progress for log-based updates

  try {
    // Update status: building
    await updateStatus(deploymentId, 'building', 10);
    await appendLog(deploymentId, 'info', 'Starting web deployment...');

    // Get git info
    try {
      const gitBranch = await getGitBranch();
      const gitCommit = await getGitCommit();

      await pool.query(
        `UPDATE web_deployments SET git_branch = $1, git_commit_hash = $2 WHERE id = $3`,
        [gitBranch, gitCommit, deploymentId]
      );

      await appendLog(deploymentId, 'info', `Branch: ${gitBranch}, Commit: ${gitCommit.substring(0, 7)}`);
    } catch (err) {
      console.error('[DEPLOY] Failed to get git info:', err);
    }

    // Execute build using file-based trigger system
    // The build script runs on the host via a deploy agent
    await appendLog(deploymentId, 'info', 'Creating deployment trigger...');

    const fs = require('fs').promises;
    const path = require('path');

    // Use /app/src/deploy-triggers which is writable
    const triggerDir = '/app/src/deploy-triggers';
    const triggerFile = path.join(triggerDir, 'deploy.trigger');
    const statusFile = path.join(triggerDir, `deploy-${deploymentId}.status`);
    const logFile = path.join(triggerDir, `deploy-${deploymentId}.log`);

    try {
      // Ensure directory exists
      await fs.mkdir(triggerDir, { recursive: true });

      // Write trigger file with deployment ID
      await fs.writeFile(triggerFile, deploymentId.toString(), 'utf8');
      await appendLog(deploymentId, 'info', 'Trigger created, waiting for deploy agent...');

      // Monitor for completion (check every 2 seconds for max 15 minutes)
      let attempts = 0;
      const maxAttempts = 450; // 15 minutes
      let lastLogSize = 0;

      while (attempts < maxAttempts && !isCancelled) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        attempts++;

        // Check for cancellation signal
        const cancelFile = path.join(triggerDir, `deploy-${deploymentId}.cancel`);
        try {
          await fs.access(cancelFile);
          // Cancel file exists
          isCancelled = true;
          await fs.unlink(cancelFile).catch(() => {});
          throw new Error('Deployment cancelled by admin');
        } catch (err) {
          if (err.code !== 'ENOENT' && err.message.includes('cancelled')) {
            throw err;
          }
        }

        // Check for new logs and append them
        try {
          const logs = await fs.readFile(logFile, 'utf8');
          if (logs.length > lastLogSize) {
            const newLogs = logs.substring(lastLogSize);
            const lines = newLogs.split('\n').filter(line => line.trim());
            for (const line of lines) {
              await appendLog(deploymentId, 'info', line.trim());

              // Log-based progress update
              try {
                currentProgress = await updateProgressFromLog(
                  deploymentId,
                  line.trim(),
                  currentProgress
                );
              } catch (err) {
                // Error detected in log - propagate to outer catch
                throw err;
              }
            }
            lastLogSize = logs.length;
          }
        } catch (err) {
          // If it's a build error, propagate it
          if (err.message && err.message.includes('Build failed')) {
            throw err;
          }
          // Otherwise, log file doesn't exist yet - ignore
        }

        // Check status
        try {
          const status = await fs.readFile(statusFile, 'utf8');

          if (status.includes('SUCCESS')) {
            await appendLog(deploymentId, 'info', '✅ Build completed successfully!');

            // Cleanup trigger files
            await fs.unlink(triggerFile).catch(() => {});
            await fs.unlink(statusFile).catch(() => {});
            await fs.unlink(logFile).catch(() => {});

            // Break out of monitoring loop to continue to validation
            break;
          } else if (status.includes('FAILED')) {
            throw new Error('Build script failed - check logs above');
          }
        } catch (err) {
          if (err.code !== 'ENOENT') {
            throw err;
          }
        }

        // Fallback progress update (only if no log-based progress detected)
        // This prevents UI from showing 0% if logs are delayed
        if (attempts % 30 === 0 && currentProgress < 15) {
          const fallbackProgress = Math.min(currentProgress + 2, 14);
          await updateStatus(deploymentId, 'building', fallbackProgress);
          currentProgress = fallbackProgress;
          console.log(`[DEPLOY] Fallback progress update: ${fallbackProgress}%`);
        }
      }

      if (isCancelled) {
        throw new Error('Deployment cancelled by admin');
      }

      if (attempts >= maxAttempts) {
        throw new Error('Deployment timeout - deploy agent may not be running. Check agent status: systemctl status lemon-deploy-agent');
      }

    } catch (error) {
      await appendLog(deploymentId, 'error', `Deployment error: ${error.message}`);
      throw error;
    }

    // Validate deployment
    await updateStatus(deploymentId, 'validating', 98);
    await appendLog(deploymentId, 'info', 'Validating deployment...');

    const isValid = await validateDeployment();

    if (!isValid) {
      throw new Error('Deployment validation failed - app not accessible');
    }

    // Mark as completed
    const duration = Math.floor((Date.now() - startTime) / 1000);
    await updateStatusWithRetry(deploymentId, 'completed', {
      completedAt: true,
      duration,
      progress: 100
    });

    await appendLog(deploymentId, 'info', `✅ Deployment completed successfully in ${duration}s`);

  } catch (error) {
    console.error('[DEPLOY] Error:', error);

    const duration = Math.floor((Date.now() - startTime) / 1000);

    try {
      await updateStatusWithRetry(deploymentId, 'failed', {
        completedAt: true,
        duration,
        errorMessage: error.message
      });
    } catch (updateErr) {
      console.error('[DEPLOY] CRITICAL: Failed to update status after all retries');
    }

    await appendLog(deploymentId, 'error', `❌ Deployment failed: ${error.message}`);

  } finally {
    // Release lock
    const redis = getRedis();
    await redis.del(DEPLOY_LOCK_KEY);
  }
}

/**
 * Get current git branch
 */
async function getGitBranch() {
  return new Promise((resolve) => {
    exec('git rev-parse --abbrev-ref HEAD', { cwd: '/project' }, (err, stdout) => {
      if (err) {
        resolve('unknown');
      } else {
        resolve(stdout.trim());
      }
    });
  });
}

/**
 * Get current git commit hash
 */
async function getGitCommit() {
  return new Promise((resolve) => {
    exec('git rev-parse HEAD', { cwd: '/project' }, (err, stdout) => {
      if (err) {
        resolve('unknown');
      } else {
        resolve(stdout.trim());
      }
    });
  });
}

/**
 * Update deployment status and progress
 */
async function updateStatus(deploymentId, status, progress) {
  await pool.query(
    `UPDATE web_deployments SET status = $1, progress = $2 WHERE id = $3`,
    [status, progress, deploymentId]
  );
}

/**
 * Append log entry
 */
async function appendLog(deploymentId, logType, message) {
  // Limit message length
  const truncatedMessage = message.length > 2000
    ? message.substring(0, 2000) + '... (truncated)'
    : message;

  await pool.query(
    `INSERT INTO web_deployment_logs (deployment_id, log_type, message)
     VALUES ($1, $2, $3)`,
    [deploymentId, logType, truncatedMessage]
  );
}

/**
 * Update progress based on log line parsing
 * @param {number} deploymentId - 배포 ID
 * @param {string} logLine - 로그 라인
 * @param {number} currentProgress - 현재 진행률
 * @returns {Promise<number>} 새로운 진행률
 */
async function updateProgressFromLog(deploymentId, logLine, currentProgress) {
  let newProgress = currentProgress;
  let newStatus = null;

  // Error detection - fail fast
  for (const errorPattern of ERROR_PATTERNS) {
    if (errorPattern.test(logLine)) {
      throw new Error(`Build failed: ${logLine}`);
    }
  }

  // Phase detection (역순으로 검사하여 나중 단계 우선)
  for (let i = WEB_DEPLOY_PHASES.length - 1; i >= 0; i--) {
    const phase = WEB_DEPLOY_PHASES[i];
    if (phase.pattern.test(logLine)) {
      // 진행률이 증가하는 경우에만 업데이트
      if (phase.progress > currentProgress) {
        newProgress = phase.progress;
        newStatus = phase.status;
        console.log(`[DEPLOY] Phase detected: ${logLine.substring(0, 60)} → ${newProgress}%`);
        break;
      }
    }
  }

  // 진행률 업데이트 (증가한 경우에만)
  if (newProgress > currentProgress) {
    await pool.query(
      `UPDATE web_deployments SET progress = $1, status = $2
       WHERE id = $3 AND progress < $1`,
      [newProgress, newStatus || 'building', deploymentId]
    );
  }

  return newProgress;
}

/**
 * Validate deployment by checking if app is accessible
 */
async function validateDeployment() {
  try {
    const response = await fetch('https://lemon.3chan.kr/app/', {
      method: 'HEAD',
      timeout: 10000
    });
    return response.ok;
  } catch (error) {
    console.error('[DEPLOY] Validation error:', error);
    return false;
  }
}

/**
 * Get deployment status
 */
async function getDeploymentStatus(deploymentId) {
  const result = await pool.query(
    `SELECT * FROM web_deployments WHERE id = $1`,
    [deploymentId]
  );

  if (result.rows.length === 0) {
    throw new Error('Deployment not found');
  }

  return result.rows[0];
}

/**
 * Get deployment logs
 * @param {number} deploymentId
 * @param {number} sinceId - Get logs after this ID (for polling)
 */
async function getDeploymentLogs(deploymentId, sinceId = 0) {
  const result = await pool.query(
    `SELECT * FROM web_deployment_logs
     WHERE deployment_id = $1 AND id > $2
     ORDER BY id ASC
     LIMIT 500`,
    [deploymentId, sinceId]
  );

  return result.rows;
}

/**
 * List deployment history
 */
async function listDeploymentHistory(page = 1, limit = 20) {
  const offset = (page - 1) * limit;

  const result = await pool.query(
    `SELECT * FROM web_deployments
     ORDER BY started_at DESC
     LIMIT $1 OFFSET $2`,
    [limit, offset]
  );

  const countResult = await pool.query(
    `SELECT COUNT(*) FROM web_deployments`
  );

  return {
    data: result.rows,
    pagination: {
      page,
      limit,
      total: parseInt(countResult.rows[0].count)
    }
  };
}

/**
 * Cancel running deployment
 */
async function cancelDeployment(deploymentId) {
  // Mark as cancelled
  const result = await pool.query(
    `UPDATE web_deployments
     SET status = 'cancelled', completed_at = NOW()
     WHERE id = $1 AND status NOT IN ('completed', 'failed', 'cancelled')
     RETURNING id`,
    [deploymentId]
  );

  if (result.rows.length === 0) {
    throw new Error('Deployment not found or already completed');
  }

  // Write cancel signal file
  const fs = require('fs').promises;
  const path = require('path');
  const triggerDir = '/app/src/deploy-triggers';
  const cancelFile = path.join(triggerDir, `deploy-${deploymentId}.cancel`);

  try {
    await fs.writeFile(cancelFile, 'CANCEL', 'utf8');
  } catch (err) {
    console.error('[DEPLOY] Failed to write cancel file:', err);
  }

  // Release lock
  const redis = getRedis();
  await redis.del(DEPLOY_LOCK_KEY);

  await appendLog(deploymentId, 'warning', 'Deployment cancelled by admin');
}

module.exports = {
  startDeployment,
  getDeploymentStatus,
  getDeploymentLogs,
  listDeploymentHistory,
  cancelDeployment
};
