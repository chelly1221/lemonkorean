/**
 * Deploy Controller
 *
 * HTTP request handlers for web deployment
 */

const deployService = require('../services/web-deploy.service');

/**
 * POST /api/admin/deploy/web/start
 * Start web deployment
 */
const startWebDeploy = async (req, res) => {
  try {
    const adminId = req.user.id;
    const adminEmail = req.user.email;

    const deploymentId = await deployService.startDeployment(adminId, adminEmail);

    res.status(201).json({
      success: true,
      message: 'Deployment started',
      data: { deploymentId }
    });
  } catch (error) {
    console.error('[DEPLOY_CONTROLLER] Error starting deployment:', error);

    if (error.message === 'Deployment already in progress') {
      return res.status(409).json({
        error: 'Conflict',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to start deployment',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/deploy/web/status/:id
 * Get deployment status
 */
const getDeploymentStatus = async (req, res) => {
  try {
    const deploymentId = parseInt(req.params.id);

    if (isNaN(deploymentId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid deployment ID'
      });
    }

    const status = await deployService.getDeploymentStatus(deploymentId);

    res.json({
      success: true,
      data: status
    });
  } catch (error) {
    console.error('[DEPLOY_CONTROLLER] Error getting status:', error);

    if (error.message === 'Deployment not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get deployment status',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/deploy/web/logs/:id
 * Get deployment logs (supports polling with ?since=ID)
 */
const getDeploymentLogs = async (req, res) => {
  try {
    const deploymentId = parseInt(req.params.id);
    const sinceId = parseInt(req.query.since) || 0;

    if (isNaN(deploymentId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid deployment ID'
      });
    }

    const logs = await deployService.getDeploymentLogs(deploymentId, sinceId);

    res.json({
      success: true,
      data: logs,
      count: logs.length
    });
  } catch (error) {
    console.error('[DEPLOY_CONTROLLER] Error getting logs:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get deployment logs',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/deploy/web/history
 * List deployment history
 */
const listDeploymentHistory = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 20, 100);

    const result = await deployService.listDeploymentHistory(page, limit);

    res.json({
      success: true,
      ...result
    });
  } catch (error) {
    console.error('[DEPLOY_CONTROLLER] Error listing history:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to list deployment history',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/deploy/web/:id
 * Cancel running deployment
 */
const cancelDeployment = async (req, res) => {
  try {
    const deploymentId = parseInt(req.params.id);

    if (isNaN(deploymentId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid deployment ID'
      });
    }

    await deployService.cancelDeployment(deploymentId);

    res.json({
      success: true,
      message: 'Deployment cancelled'
    });
  } catch (error) {
    console.error('[DEPLOY_CONTROLLER] Error cancelling deployment:', error);

    if (error.message === 'Deployment not found or already completed') {
      return res.status(404).json({
        error: 'Not Found',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to cancel deployment',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  startWebDeploy,
  getDeploymentStatus,
  getDeploymentLogs,
  listDeploymentHistory,
  cancelDeployment
};
