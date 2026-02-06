/**
 * APK Build Controller
 *
 * HTTP request handlers for APK build operations
 */

const apkBuildService = require('../services/apk-build.service');
const path = require('path');
const fs = require('fs');

/**
 * Start APK build
 * POST /api/admin/deploy/apk/start
 */
async function startAPKBuild(req, res) {
  try {
    const adminId = req.user.id;
    const adminEmail = req.user.email;

    const buildId = await apkBuildService.startBuild(adminId, adminEmail);

    res.json({
      success: true,
      data: {
        buildId,
        message: 'APK build started successfully'
      }
    });
  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] Start build error:', error);

    if (error.message === 'APK build already in progress') {
      return res.status(409).json({
        success: false,
        error: error.message
      });
    }

    res.status(500).json({
      success: false,
      error: 'Failed to start APK build'
    });
  }
}

/**
 * Get build status
 * GET /api/admin/deploy/apk/status/:id
 */
async function getBuildStatus(req, res) {
  try {
    const buildId = parseInt(req.params.id);

    if (isNaN(buildId)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid build ID'
      });
    }

    const status = await apkBuildService.getBuildStatus(buildId);

    res.json({
      success: true,
      ...status
    });
  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] Get status error:', error);

    if (error.message === 'Build not found') {
      return res.status(404).json({
        success: false,
        error: error.message
      });
    }

    res.status(500).json({
      success: false,
      error: 'Failed to get build status'
    });
  }
}

/**
 * Get build logs
 * GET /api/admin/deploy/apk/logs/:id?since=0
 */
async function getBuildLogs(req, res) {
  try {
    const buildId = parseInt(req.params.id);
    const sinceId = parseInt(req.query.since) || 0;

    if (isNaN(buildId)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid build ID'
      });
    }

    const logs = await apkBuildService.getBuildLogs(buildId, sinceId);

    res.json({
      success: true,
      data: logs
    });
  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] Get logs error:', error);

    res.status(500).json({
      success: false,
      error: 'Failed to get build logs'
    });
  }
}

/**
 * List build history
 * GET /api/admin/deploy/apk/history?page=1&limit=20
 */
async function listBuildHistory(req, res) {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;

    const history = await apkBuildService.listBuildHistory(page, limit);

    res.json({
      success: true,
      ...history
    });
  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] List history error:', error);

    res.status(500).json({
      success: false,
      error: 'Failed to list build history'
    });
  }
}

/**
 * Download APK file
 * GET /api/admin/deploy/apk/download/:id
 */
async function downloadAPK(req, res) {
  try {
    const buildId = parseInt(req.params.id);

    if (isNaN(buildId)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid build ID'
      });
    }

    const build = await apkBuildService.getBuildStatus(buildId);
    console.log(`[APK_DOWNLOAD] Build ID ${buildId}: status=${build.status}, apk_path=${build.apk_path}`);

    if (build.status !== 'completed') {
      const statusMessages = {
        'pending': 'Build is pending - not started yet',
        'building': `Build is in progress (${build.progress || 0}%)`,
        'signing': 'Build is being signed',
        'failed': `Build failed: ${build.error_message || 'Unknown error'}`,
        'cancelled': 'Build was cancelled by admin'
      };

      return res.status(400).json({
        success: false,
        error: statusMessages[build.status] || `Build status: ${build.status}`,
        details: {
          buildId,
          status: build.status,
          progress: build.progress
        }
      });
    }

    if (!build.apk_path) {
      console.error(`[APK_DOWNLOAD] Build ${buildId} completed but apk_path is NULL/empty`);
      return res.status(404).json({
        success: false,
        error: 'APK file path not recorded in database',
        details: {
          buildId,
          status: build.status,
          suggestion: 'The build may have completed but failed to record the APK filename. Check build logs.'
        }
      });
    }

    const apkPath = apkBuildService.getAPKPath(buildId, build.apk_path);
    console.log(`[APK_DOWNLOAD] Checking APK file at: ${apkPath}`);

    // Check if file exists
    if (!fs.existsSync(apkPath)) {
      console.error(`[APK_DOWNLOAD] APK file not found at path: ${apkPath}`);
      return res.status(404).json({
        success: false,
        error: 'APK file not found on disk',
        details: {
          buildId,
          expectedPath: apkPath,
          filename: build.apk_path,
          suggestion: 'The APK may have been deleted or the storage volume is not mounted'
        }
      });
    }

    // Stream the file
    console.log(`[APK_DOWNLOAD] Starting download for build ${buildId}: ${build.apk_path}`);
    const filename = build.apk_path;
    res.setHeader('Content-Type', 'application/vnd.android.package-archive');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);

    const fileStream = fs.createReadStream(apkPath);
    fileStream.pipe(res);

    fileStream.on('error', (err) => {
      console.error('[APK_BUILD_CONTROLLER] Stream error:', err);
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          error: 'Failed to stream APK file'
        });
      }
    });

  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] Download APK error:', error);

    if (error.message === 'Build not found') {
      return res.status(404).json({
        success: false,
        error: error.message
      });
    }

    if (!res.headersSent) {
      res.status(500).json({
        success: false,
        error: 'Failed to download APK'
      });
    }
  }
}

/**
 * Cancel build
 * DELETE /api/admin/deploy/apk/:id
 */
async function cancelBuild(req, res) {
  try {
    const buildId = parseInt(req.params.id);

    if (isNaN(buildId)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid build ID'
      });
    }

    await apkBuildService.cancelBuild(buildId);

    res.json({
      success: true,
      message: 'APK build cancelled successfully'
    });
  } catch (error) {
    console.error('[APK_BUILD_CONTROLLER] Cancel build error:', error);

    if (error.message === 'Build not found or already completed') {
      return res.status(404).json({
        success: false,
        error: error.message
      });
    }

    res.status(500).json({
      success: false,
      error: 'Failed to cancel build'
    });
  }
}

module.exports = {
  startAPKBuild,
  getBuildStatus,
  getBuildLogs,
  listBuildHistory,
  downloadAPK,
  cancelBuild
};
