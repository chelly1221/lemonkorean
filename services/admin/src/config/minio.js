const { Client } = require('minio');

// MinIO client
let minioClient;

// Initialize MinIO client
const initMinIO = () => {
  try {
    const endpoint = process.env.MINIO_ENDPOINT || 'localhost:9000';
    const [host, port] = endpoint.split(':');

    minioClient = new Client({
      endPoint: host,
      port: parseInt(port) || 9000,
      useSSL: process.env.MINIO_USE_SSL === 'true',
      accessKey: process.env.MINIO_ACCESS_KEY,
      secretKey: process.env.MINIO_SECRET_KEY,
      region: 'us-east-1'  // Required for minio-js 7.x
    });

    console.log('[MINIO] Client initialized');
    return minioClient;
  } catch (error) {
    console.error('[MINIO] Initialization error:', error);
    throw error;
  }
};

// Test MinIO connection
const testMinIOConnection = async () => {
  try {
    if (!minioClient) {
      initMinIO();
    }

    const buckets = await minioClient.listBuckets();
    console.log('[MINIO] Connection successful, buckets:', buckets.length);
    return true;
  } catch (error) {
    console.error('[MINIO] Test connection error:', error);
    throw error;
  }
};

// Ensure bucket exists
const ensureBucket = async (bucketName) => {
  try {
    if (!minioClient) {
      initMinIO();
    }

    const exists = await minioClient.bucketExists(bucketName);

    if (!exists) {
      await minioClient.makeBucket(bucketName, 'us-east-1');
      console.log('[MINIO] Bucket created:', bucketName);
    } else {
      console.log('[MINIO] Bucket exists:', bucketName);
    }

    return true;
  } catch (error) {
    console.error('[MINIO] Ensure bucket error:', error);
    throw error;
  }
};

// Get MinIO client
const getMinioClient = () => {
  if (!minioClient) {
    initMinIO();
  }
  return minioClient;
};

module.exports = {
  initMinIO,
  testMinIOConnection,
  ensureBucket,
  getMinioClient
};
