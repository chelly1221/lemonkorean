/**
 * APK Build Service
 *
 * Handles APK build workflow:
 * 1. Execute build_apk.sh on host
 * 2. Track progress and capture logs
 * 3. Save APK to NAS
 */

const { exec } = require('child_process');
const { Pool } = require('pg');
const path = require('path');

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
const APK_BUILD_SCRIPT = '/project/mobile/lemon_korean/build_apk.sh';
const BUILD_LOCK_KEY = 'deploy:apk:lock';
const BUILD_LOCK_TTL = 1800; // 30 minutes
const APK_STORAGE_PATH = '/apk-builds';

// APK build phase milestones for progress tracking
const APK_BUILD_PHASES = [
  // 초기화 (0-15%)
  { pattern: /Creating build trigger/i, progress: 5, status: 'pending' },
  { pattern: /Starting APK build/i, progress: 10, status: 'building' },
  { pattern: /Branch:/i, progress: 12, status: 'building' },

  // 빌드 준비 (15-30%)
  { pattern: /Cleaning previous build/i, progress: 15, status: 'building' },
  { pattern: /Deleting build\.\.\./i, progress: 16, status: 'building' },
  { pattern: /Getting dependencies/i, progress: 20, status: 'building' },
  { pattern: /Resolving dependencies/i, progress: 22, status: 'building' },
  { pattern: /Downloading packages|Got dependencies/i, progress: 25, status: 'building' },
  { pattern: /Running Gradle task/i, progress: 30, status: 'building' },

  // Gradle 빌드 (30-70%) - 가장 긴 단계
  { pattern: /Gradle task 'assembleRelease'/i, progress: 35, status: 'building' },
  { pattern: /> Task :app:preBuild/i, progress: 40, status: 'building' },
  { pattern: /> Task :app:compileReleaseKotlin/i, progress: 50, status: 'building' },
  { pattern: /Running.*kernel_snapshot/i, progress: 60, status: 'building' },
  { pattern: /Running.*gen_snapshot/i, progress: 70, status: 'building' },
  { pattern: /BUILD SUCCESSFUL/i, progress: 75, status: 'building' },

  // 최종화 (75-100%)
  { pattern: /✓ Built.*\.apk/i, progress: 85, status: 'building' },
  { pattern: /APK Path:/i, progress: 90, status: 'building' },
  { pattern: /APK Size:/i, progress: 92, status: 'building' },
  { pattern: /Filename:/i, progress: 95, status: 'building' },
  { pattern: /APK build completed successfully/i, progress: 99, status: 'building' }
];

// Error patterns for early failure detection
const APK_ERROR_PATTERNS = [
  /Error: Failed to compile/i,
  /ProcessException/i,
  /Gradle build failed/i,
  /FAILURE: Build failed/i,
  /Exception:/i,
  /fatal:/i,
  /Could not resolve/i,
  /Task failed/i
];

/**
 * Start APK build
 * @param {number} adminId - Admin user ID
 * @param {string} adminEmail - Admin email
 * @returns {Promise<number>} Build ID
 */
async function startBuild(adminId, adminEmail) {
  const redis = getRedis();

  // Check for concurrent build
  const isLocked = await redis.get(BUILD_LOCK_KEY);
  if (isLocked) {
    throw new Error('APK build already in progress');
  }

  // Create build record
  const result = await pool.query(
    `INSERT INTO apk_builds (admin_id, admin_email, status, progress)
     VALUES ($1, $2, 'pending', 0)
     RETURNING id`,
    [adminId, adminEmail]
  );
  const buildId = result.rows[0].id;

  // Acquire lock
  await redis.setEx(BUILD_LOCK_KEY, BUILD_LOCK_TTL, buildId.toString());

  // Execute build asynchronously
  executeBuild(buildId).catch(err => {
    console.error('[APK_BUILD] Unhandled error:', err);
  });

  return buildId;
}

/**
 * Update status with retry logic
 */
async function updateStatusWithRetry(buildId, status, options = {}) {
  const maxRetries = 3;
  const { completedAt, duration, errorMessage, progress, versionName, versionCode, apkSizeBytes, apkPath } = options;

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
      if (versionName !== undefined) {
        updates.push(`version_name = $${paramIndex++}`);
        params.push(versionName);
      }
      if (versionCode !== undefined) {
        updates.push(`version_code = $${paramIndex++}`);
        params.push(versionCode);
      }
      if (apkSizeBytes !== undefined) {
        updates.push(`apk_size_bytes = $${paramIndex++}`);
        params.push(apkSizeBytes);
      }
      if (apkPath !== undefined) {
        updates.push(`apk_path = $${paramIndex++}`);
        params.push(apkPath);
      }

      params.push(buildId);

      await pool.query(
        `UPDATE apk_builds SET ${updates.join(', ')} WHERE id = $${paramIndex}`,
        params
      );

      return; // Success
    } catch (err) {
      console.error(`[APK_BUILD] Status update attempt ${attempt} failed:`, err);

      if (attempt === maxRetries) {
        // Last attempt failed - write to recovery log
        const fs = require('fs').promises;
        const recoveryLog = '/app/src/deploy-triggers/apk-status-update-failures.log';
        const entry = JSON.stringify({
          buildId,
          status,
          options,
          timestamp: new Date().toISOString(),
          error: err.message
        }) + '\n';

        try {
          await fs.appendFile(recoveryLog, entry);
        } catch (logErr) {
          console.error('[APK_BUILD] Failed to write recovery log:', logErr);
        }

        throw err;
      }

      // Exponential backoff: 1s, 2s, 4s
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, attempt - 1) * 1000));
    }
  }
}

/**
 * Execute APK build process
 * Runs build_apk.sh, captures output, updates status
 */
async function executeBuild(buildId) {
  const startTime = Date.now();
  let isCancelled = false;
  let currentProgress = 0; // Track current progress for log-based updates

  try {
    // Update status: building
    await updateStatus(buildId, 'building', 10);
    await appendLog(buildId, 'info', 'Starting APK build...');

    // Get git info
    try {
      const gitBranch = await getGitBranch();
      const gitCommit = await getGitCommit();

      await pool.query(
        `UPDATE apk_builds SET git_branch = $1, git_commit_hash = $2 WHERE id = $3`,
        [gitBranch, gitCommit, buildId]
      );

      await appendLog(buildId, 'info', `Branch: ${gitBranch}, Commit: ${gitCommit.substring(0, 7)}`);
    } catch (err) {
      console.error('[APK_BUILD] Failed to get git info:', err);
    }

    // Execute build using file-based trigger system
    await appendLog(buildId, 'info', 'Creating build trigger...');

    const fs = require('fs').promises;

    // Use /app/src/deploy-triggers which is writable
    const triggerDir = '/app/src/deploy-triggers';
    const triggerFile = path.join(triggerDir, 'apk-build.trigger');
    const statusFile = path.join(triggerDir, `apk-build-${buildId}.status`);
    const logFile = path.join(triggerDir, `apk-build-${buildId}.log`);

    try {
      // Ensure directory exists
      await fs.mkdir(triggerDir, { recursive: true });

      // Write trigger file with build ID
      await fs.writeFile(triggerFile, buildId.toString(), 'utf8');
      await appendLog(buildId, 'info', 'Trigger created, waiting for deploy agent...');

      // Monitor for completion (check every 2 seconds for max 60 minutes)
      let attempts = 0;
      const maxAttempts = 1800; // 60 minutes (1 hour)
      let lastLogSize = 0;

      while (attempts < maxAttempts && !isCancelled) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        attempts++;

        // Check for cancellation signal
        const cancelFile = path.join(triggerDir, `apk-build-${buildId}.cancel`);
        try {
          await fs.access(cancelFile);
          // Cancel file exists
          isCancelled = true;
          await fs.unlink(cancelFile).catch(() => {});
          throw new Error('APK build cancelled by admin');
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
              await appendLog(buildId, 'info', line.trim());

              // Log-based progress update
              try {
                currentProgress = await updateProgressFromLog(
                  buildId,
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
            await appendLog(buildId, 'info', '✅ Build completed successfully!');

            // Parse log file to extract APK info
            try {
              const fullLog = await fs.readFile(logFile, 'utf8');
              const apkPathMatch = fullLog.match(/APK Path: (.+)/);
              const apkSizeMatch = fullLog.match(/APK Size: ([\d.]+) MB/);
              const apkFilenameMatch = fullLog.match(/Filename: (.+)/);

              if (apkPathMatch && apkFilenameMatch) {
                const apkPath = apkPathMatch[1].trim();
                const apkFilename = apkFilenameMatch[1].trim();
                const apkSizeMB = apkSizeMatch ? parseFloat(apkSizeMatch[1]) : null;
                const apkSizeBytes = apkSizeMB ? Math.round(apkSizeMB * 1024 * 1024) : null;

                await updateStatusWithRetry(buildId, 'building', {
                  apkPath: apkFilename,
                  apkSizeBytes: apkSizeBytes
                });
              }
            } catch (parseErr) {
              console.error('[APK_BUILD] Failed to parse APK info:', parseErr);
            }

            // Cleanup trigger files
            await fs.unlink(triggerFile).catch(() => {});
            await fs.unlink(statusFile).catch(() => {});
            await fs.unlink(logFile).catch(() => {});

            // Break out of monitoring loop to continue to completion
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
          await updateStatus(buildId, 'building', fallbackProgress);
          currentProgress = fallbackProgress;
          console.log(`[APK_BUILD] Fallback progress update: ${fallbackProgress}%`);
        }
      }

      if (isCancelled) {
        throw new Error('APK build cancelled by admin');
      }

      if (attempts >= maxAttempts) {
        throw new Error('Build timeout - deploy agent may not be running. Check agent status: systemctl status lemon-deploy-agent');
      }

    } catch (error) {
      await appendLog(buildId, 'error', `Build error: ${error.message}`);
      throw error;
    }

    // Mark as completed
    const duration = Math.floor((Date.now() - startTime) / 1000);
    await updateStatusWithRetry(buildId, 'completed', {
      completedAt: true,
      duration,
      progress: 100
    });

    await appendLog(buildId, 'info', `✅ APK build completed successfully in ${duration}s`);

  } catch (error) {
    console.error('[APK_BUILD] Error:', error);

    const duration = Math.floor((Date.now() - startTime) / 1000);

    try {
      await updateStatusWithRetry(buildId, 'failed', {
        completedAt: true,
        duration,
        errorMessage: error.message
      });
    } catch (updateErr) {
      console.error('[APK_BUILD] CRITICAL: Failed to update status after all retries');
    }

    await appendLog(buildId, 'error', `❌ APK build failed: ${error.message}`);

  } finally {
    // Release lock
    const redis = getRedis();
    await redis.del(BUILD_LOCK_KEY);
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
 * Update build status and progress
 */
async function updateStatus(buildId, status, progress) {
  await pool.query(
    `UPDATE apk_builds SET status = $1, progress = $2 WHERE id = $3`,
    [status, progress, buildId]
  );
}

/**
 * Append log entry
 */
async function appendLog(buildId, logType, message) {
  // Limit message length
  const truncatedMessage = message.length > 2000
    ? message.substring(0, 2000) + '... (truncated)'
    : message;

  await pool.query(
    `INSERT INTO apk_build_logs (build_id, log_type, message)
     VALUES ($1, $2, $3)`,
    [buildId, logType, truncatedMessage]
  );
}

/**
 * Update progress based on log line parsing
 * @param {number} buildId - 빌드 ID
 * @param {string} logLine - 로그 라인
 * @param {number} currentProgress - 현재 진행률
 * @returns {Promise<number>} 새로운 진행률
 */
async function updateProgressFromLog(buildId, logLine, currentProgress) {
  let newProgress = currentProgress;
  let newStatus = null;

  // Error detection - fail fast
  for (const errorPattern of APK_ERROR_PATTERNS) {
    if (errorPattern.test(logLine)) {
      throw new Error(`Build failed: ${logLine}`);
    }
  }

  // Phase detection (역순으로 검사하여 나중 단계 우선)
  for (let i = APK_BUILD_PHASES.length - 1; i >= 0; i--) {
    const phase = APK_BUILD_PHASES[i];
    if (phase.pattern.test(logLine)) {
      // 진행률이 증가하는 경우에만 업데이트
      if (phase.progress > currentProgress) {
        newProgress = phase.progress;
        newStatus = phase.status;
        console.log(`[APK_BUILD] Phase detected: ${logLine.substring(0, 60)} → ${newProgress}%`);
        break;
      }
    }
  }

  // 진행률 업데이트 (증가한 경우에만)
  if (newProgress > currentProgress) {
    await pool.query(
      `UPDATE apk_builds SET progress = $1, status = $2
       WHERE id = $3 AND progress < $1`,
      [newProgress, newStatus || 'building', buildId]
    );
  }

  return newProgress;
}

/**
 * Get build status
 */
async function getBuildStatus(buildId) {
  const result = await pool.query(
    `SELECT * FROM apk_builds WHERE id = $1`,
    [buildId]
  );

  if (result.rows.length === 0) {
    throw new Error('Build not found');
  }

  return result.rows[0];
}

/**
 * Get build logs
 * @param {number} buildId
 * @param {number} sinceId - Get logs after this ID (for polling)
 */
async function getBuildLogs(buildId, sinceId = 0) {
  const result = await pool.query(
    `SELECT * FROM apk_build_logs
     WHERE build_id = $1 AND id > $2
     ORDER BY id ASC
     LIMIT 500`,
    [buildId, sinceId]
  );

  return result.rows;
}

/**
 * List build history
 */
async function listBuildHistory(page = 1, limit = 20) {
  const offset = (page - 1) * limit;

  const result = await pool.query(
    `SELECT * FROM apk_builds
     ORDER BY started_at DESC
     LIMIT $1 OFFSET $2`,
    [limit, offset]
  );

  const countResult = await pool.query(
    `SELECT COUNT(*) FROM apk_builds`
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
 * Cancel running build
 */
async function cancelBuild(buildId) {
  // Mark as cancelled
  const result = await pool.query(
    `UPDATE apk_builds
     SET status = 'cancelled', completed_at = NOW()
     WHERE id = $1 AND status NOT IN ('completed', 'failed', 'cancelled')
     RETURNING id`,
    [buildId]
  );

  if (result.rows.length === 0) {
    throw new Error('Build not found or already completed');
  }

  // Write cancel signal file
  const fs = require('fs').promises;
  const triggerDir = '/app/src/deploy-triggers';
  const cancelFile = path.join(triggerDir, `apk-build-${buildId}.cancel`);

  try {
    await fs.writeFile(cancelFile, 'CANCEL', 'utf8');
  } catch (err) {
    console.error('[APK_BUILD] Failed to write cancel file:', err);
  }

  // Release lock
  const redis = getRedis();
  await redis.del(BUILD_LOCK_KEY);

  await appendLog(buildId, 'warning', 'APK build cancelled by admin');
}

/**
 * Get APK file path
 */
function getAPKPath(buildId, filename) {
  return path.join(APK_STORAGE_PATH, filename);
}

module.exports = {
  startBuild,
  getBuildStatus,
  getBuildLogs,
  listBuildHistory,
  cancelBuild,
  getAPKPath
};
