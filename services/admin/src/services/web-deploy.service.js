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
 * Execute deployment process
 * Runs build_web.sh, captures output, updates status
 */
async function executeDeployment(deploymentId) {
  const startTime = Date.now();

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

      while (attempts < maxAttempts) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        attempts++;

        // Check for new logs and append them
        try {
          const logs = await fs.readFile(logFile, 'utf8');
          if (logs.length > lastLogSize) {
            const newLogs = logs.substring(lastLogSize);
            const lines = newLogs.split('\n').filter(line => line.trim());
            for (const line of lines) {
              await appendLog(deploymentId, 'info', line.trim());
            }
            lastLogSize = logs.length;
          }
        } catch (err) {
          // Log file doesn't exist yet
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

        // Update progress
        const progress = Math.min(15 + Math.floor((attempts / maxAttempts) * 80), 95);
        await updateStatus(deploymentId, 'building', progress);
      }

      throw new Error('Deployment timeout - deploy agent may not be running. Check agent status: systemctl status lemon-deploy-agent');

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
    await pool.query(
      `UPDATE web_deployments
       SET status = 'completed', progress = 100,
           completed_at = NOW(), duration_seconds = $1
       WHERE id = $2`,
      [duration, deploymentId]
    );

    await appendLog(deploymentId, 'info', `✅ Deployment completed successfully in ${duration}s`);

  } catch (error) {
    console.error('[DEPLOY] Error:', error);

    const duration = Math.floor((Date.now() - startTime) / 1000);
    await pool.query(
      `UPDATE web_deployments
       SET status = 'failed', completed_at = NOW(),
           duration_seconds = $1, error_message = $2
       WHERE id = $3`,
      [duration, error.message, deploymentId]
    );

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
 * Update progress based on build output
 * Parse flutter build output to estimate progress
 */
async function updateProgressFromOutput(deploymentId, output) {
  let progress = null;
  let status = null;

  if (output.includes('Building Flutter') || output.includes('flutter build')) {
    progress = 20;
    status = 'building';
  } else if (output.includes('Compiling') || output.includes('compiling')) {
    progress = 40;
    status = 'building';
  } else if (output.includes('Optimizing') || output.includes('optimizing')) {
    progress = 60;
    status = 'building';
  } else if (output.includes('✓ Built') || output.includes('Done!') || output.includes('build completed')) {
    progress = 85;
    status = 'building';
  } else if (output.includes('Syncing to NAS') || output.includes('rsync')) {
    progress = 90;
    status = 'syncing';
  } else if (output.includes('Restarting nginx') || output.includes('nginx')) {
    progress = 95;
    status = 'restarting';
  }

  if (progress !== null) {
    const currentStatus = status || 'building';
    await pool.query(
      `UPDATE web_deployments SET progress = $1, status = $2 WHERE id = $3 AND progress < $1`,
      [progress, currentStatus, deploymentId]
    );
  }
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
