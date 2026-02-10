const { Client } = require('minio');

let minioClient;

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
      region: 'us-east-1'
    });

    console.log('[SNS] MinIO client initialized');
    return minioClient;
  } catch (error) {
    console.error('[SNS] MinIO initialization error:', error);
    throw error;
  }
};

const ensureBucket = async (bucketName) => {
  try {
    if (!minioClient) initMinIO();
    const exists = await minioClient.bucketExists(bucketName);
    if (!exists) {
      await minioClient.makeBucket(bucketName, 'us-east-1');
      console.log('[SNS] Bucket created:', bucketName);
    }
    return true;
  } catch (error) {
    console.error('[SNS] Ensure bucket error:', error);
    throw error;
  }
};

const getMinioClient = () => {
  if (!minioClient) initMinIO();
  return minioClient;
};

module.exports = { initMinIO, ensureBucket, getMinioClient };
