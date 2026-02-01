const mediaService = require('../services/media-upload.service');

/**
 * Media Controller
 * Handles HTTP requests for media management
 */

/**
 * POST /api/admin/media/upload
 * Upload file to MinIO
 */
const uploadFile = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No file provided'
      });
    }

    const { type = 'images', originalName } = req.body;

    // 원본 파일명 사용 (프론트엔드에서 그대로 전송)
    const displayName = originalName || req.file.originalname;

    // Validate type
    const validTypes = ['images', 'audio', 'video', 'documents'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid type. Must be one of: ${validTypes.join(', ')}`
      });
    }

    // Validate file type
    if (!mediaService.validateFileType(req.file.mimetype, type)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid file type for ${type} category`
      });
    }

    // Validate file size
    if (!mediaService.validateFileSize(req.file.size, type)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `File too large for ${type} category`
      });
    }

    const result = await mediaService.uploadFile(req.file, type, displayName);

    res.status(201).json({
      success: true,
      message: 'File uploaded successfully',
      data: result
    });
  } catch (error) {
    console.error('[MEDIA_CONTROLLER] Error uploading file:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to upload file',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/media
 * List uploaded media files
 */
const listFiles = async (req, res) => {
  try {
    const { type = null, limit = 100 } = req.query;

    // Validate type if provided
    if (type) {
      const validTypes = ['images', 'audio', 'video', 'documents'];
      if (!validTypes.includes(type)) {
        return res.status(400).json({
          error: 'Bad Request',
          message: `Invalid type. Must be one of: ${validTypes.join(', ')}`
        });
      }
    }

    const files = await mediaService.listFiles(type, Math.min(parseInt(limit), 500));

    res.json({
      success: true,
      data: files,
      count: files.length
    });
  } catch (error) {
    console.error('[MEDIA_CONTROLLER] Error listing files:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to list files',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/media/:key
 * Delete media file
 * Key should be in format: type/filename (e.g., "images/abc123.jpg")
 */
const deleteFile = async (req, res) => {
  try {
    const key = req.params.key;

    if (!key || !key.includes('/')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid key format. Expected: type/filename'
      });
    }

    // Check if file exists
    try {
      await mediaService.getFileMetadata(key);
    } catch (error) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'File not found'
      });
    }

    await mediaService.deleteFile(key);

    res.json({
      success: true,
      message: 'File deleted successfully'
    });
  } catch (error) {
    console.error('[MEDIA_CONTROLLER] Error deleting file:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete file',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/media/:key
 * Get file metadata
 */
const getFileMetadata = async (req, res) => {
  try {
    const key = req.params.key;

    if (!key || !key.includes('/')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid key format. Expected: type/filename'
      });
    }

    const metadata = await mediaService.getFileMetadata(key);

    res.json({
      success: true,
      data: metadata
    });
  } catch (error) {
    console.error('[MEDIA_CONTROLLER] Error getting file metadata:', error);

    if (error.code === 'NotFound') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'File not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get file metadata',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  uploadFile,
  listFiles,
  deleteFile,
  getFileMetadata
};
