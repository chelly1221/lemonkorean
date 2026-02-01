const { getMinioClient, ensureBucket } = require('../config/minio');
const path = require('path');
const crypto = require('crypto');

/**
 * Media Upload Service
 * Handles file uploads to MinIO
 */

const BUCKET_NAME = process.env.MINIO_BUCKET || 'lemon-korean-media';
const PUBLIC_URL = process.env.API_BASE_URL || 'https://lemon.3chan.kr';

/**
 * Upload file to MinIO
 * @param {Object} file - Multer file object
 * @param {string} type - Media type (images, audio, video, documents)
 * @returns {Object} Upload result with URL
 */
const uploadFile = async (file, type = 'images', originalName = null) => {
  try {
    // Use provided originalName or fallback to file.originalname
    const displayName = originalName || file.originalname;
    console.log(`[MEDIA_SERVICE] Uploading file: ${displayName} (${type})`);

    // Ensure bucket exists
    await ensureBucket(BUCKET_NAME);

    // Generate unique filename
    const fileExt = path.extname(file.originalname);
    const randomName = crypto.randomBytes(16).toString('hex');
    const fileName = `${randomName}${fileExt}`;
    const objectKey = `${type}/${fileName}`;

    // Upload to MinIO
    const minioClient = getMinioClient();
    await minioClient.putObject(
      BUCKET_NAME,
      objectKey,
      file.buffer,
      file.size,
      {
        'Content-Type': file.mimetype,
        'X-Original-Name': Buffer.from(displayName, 'utf8').toString('base64'),
        'X-Uploaded-By': 'admin-service'
      }
    );

    console.log(`[MEDIA_SERVICE] File uploaded: ${objectKey}`);

    // Generate URL (public URL for external access)
    const mediaUrl = `${PUBLIC_URL}/media/${type}/${fileName}`;

    return {
      key: objectKey,
      url: mediaUrl,
      originalName: displayName,
      mimeType: file.mimetype,
      size: file.size,
      type: type
    };
  } catch (error) {
    console.error('[MEDIA_SERVICE] Error uploading file:', error);
    throw error;
  }
};

/**
 * List files in MinIO bucket
 * @param {string} type - Media type filter (optional)
 * @param {number} limit - Max number of files to return
 * @returns {Array} List of file objects
 */
const listFiles = async (type = null, limit = 100) => {
  try {
    console.log(`[MEDIA_SERVICE] Listing files (type: ${type}, limit: ${limit})`);

    const minioClient = getMinioClient();
    const prefix = type ? `${type}/` : '';

    const files = [];
    const stream = minioClient.listObjects(BUCKET_NAME, prefix, true);

    // First, collect all file keys
    const fileKeys = await new Promise((resolve, reject) => {
      const keys = [];
      stream.on('data', (obj) => {
        if (keys.length < limit) {
          const objectKey = obj.name || obj.key;
          if (objectKey) {
            keys.push({
              key: objectKey,
              size: obj.size,
              lastModified: obj.lastModified
            });
          }
        }
      });
      stream.on('error', reject);
      stream.on('end', () => resolve(keys));
    });

    // Then, fetch metadata for each file to get original name
    const filesWithMetadata = await Promise.all(
      fileKeys.map(async (fileInfo) => {
        const parts = fileInfo.key.split('/');
        const fileType = parts[0];
        const fileName = parts[1];

        let originalName = fileName;
        try {
          const stat = await minioClient.statObject(BUCKET_NAME, fileInfo.key);
          if (stat.metaData) {
            // 대소문자 무관하게 키 찾기
            const metaKeys = Object.keys(stat.metaData);
            const nameKey = metaKeys.find(k => k.toLowerCase() === 'x-original-name');
            if (nameKey && stat.metaData[nameKey]) {
              const rawValue = stat.metaData[nameKey];
              // Base64 디코딩 시도, 실패 시 URL 디코딩 시도 (기존 파일 호환)
              try {
                originalName = Buffer.from(rawValue, 'base64').toString('utf8');
              } catch (decodeErr) {
                try {
                  originalName = decodeURIComponent(rawValue);
                } catch (urlDecodeErr) {
                  originalName = rawValue;
                }
              }
            }
          }
        } catch (err) {
          // If metadata fetch fails, use filename as fallback
          console.warn(`[MEDIA_SERVICE] Could not fetch metadata for ${fileInfo.key}`);
        }

        return {
          key: fileInfo.key,
          name: fileName,
          originalName: originalName,
          type: fileType,
          size: fileInfo.size,
          lastModified: fileInfo.lastModified,
          url: `${PUBLIC_URL}/media/${fileType}/${fileName}`
        };
      })
    );

    console.log(`[MEDIA_SERVICE] Listed ${filesWithMetadata.length} files`);
    return filesWithMetadata;
  } catch (error) {
    console.error('[MEDIA_SERVICE] Error listing files:', error);
    throw error;
  }
};

/**
 * Delete file from MinIO
 * @param {string} key - Object key (e.g., "images/abc123.jpg")
 * @returns {boolean} Success
 */
const deleteFile = async (key) => {
  try {
    console.log(`[MEDIA_SERVICE] Deleting file: ${key}`);

    const minioClient = getMinioClient();
    await minioClient.removeObject(BUCKET_NAME, key);

    console.log(`[MEDIA_SERVICE] File deleted: ${key}`);
    return true;
  } catch (error) {
    console.error('[MEDIA_SERVICE] Error deleting file:', error);
    throw error;
  }
};

/**
 * Get file metadata
 * @param {string} key - Object key
 * @returns {Object} File metadata
 */
const getFileMetadata = async (key) => {
  try {
    const minioClient = getMinioClient();
    const stat = await minioClient.statObject(BUCKET_NAME, key);

    const parts = key.split('/');
    const fileType = parts[0];
    const fileName = parts[1];

    return {
      key: key,
      name: fileName,
      type: fileType,
      size: stat.size,
      lastModified: stat.lastModified,
      contentType: stat.metaData['content-type'],
      url: `${PUBLIC_URL}/media/${fileType}/${fileName}`
    };
  } catch (error) {
    console.error('[MEDIA_SERVICE] Error getting file metadata:', error);
    throw error;
  }
};

/**
 * Validate file type
 * @param {string} mimetype - File MIME type
 * @param {string} category - Media category (images, audio, video, documents)
 * @returns {boolean} Is valid
 */
const validateFileType = (mimetype, category) => {
  const allowedTypes = {
    images: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'],
    audio: ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/ogg', 'audio/aac', 'audio/m4a'],
    video: ['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime'],
    documents: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  };

  if (!allowedTypes[category]) {
    return false;
  }

  return allowedTypes[category].includes(mimetype);
};

/**
 * Validate file size
 * @param {number} size - File size in bytes
 * @param {string} category - Media category
 * @returns {boolean} Is valid
 */
const validateFileSize = (size, category) => {
  const maxSizes = {
    images: 10 * 1024 * 1024,      // 10 MB
    audio: 50 * 1024 * 1024,       // 50 MB
    video: 200 * 1024 * 1024,      // 200 MB
    documents: 20 * 1024 * 1024    // 20 MB
  };

  if (!maxSizes[category]) {
    return false;
  }

  return size <= maxSizes[category];
};

module.exports = {
  uploadFile,
  listFiles,
  deleteFile,
  getFileMetadata,
  validateFileType,
  validateFileSize,
  BUCKET_NAME
};
