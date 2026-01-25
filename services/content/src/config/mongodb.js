const { MongoClient } = require('mongodb');

// MongoDB connection URI
const MONGO_URL = process.env.MONGO_URL;

if (!MONGO_URL) {
  console.warn('Warning: MONGO_URL not set in environment variables');
}

// MongoDB client
let client;
let db;

// Connect to MongoDB
const connectMongoDB = async () => {
  try {
    if (!MONGO_URL) {
      throw new Error('MONGO_URL is not defined');
    }

    client = new MongoClient(MONGO_URL, {
      maxPoolSize: 10,
      minPoolSize: 5,
      serverSelectionTimeoutMS: 5000,
    });

    await client.connect();
    db = client.db(); // Uses database from connection string

    console.log('MongoDB connected successfully');
    return db;
  } catch (error) {
    console.error('MongoDB connection error:', error);
    throw error;
  }
};

// Test MongoDB connection
const testMongoConnection = async () => {
  try {
    if (!client) {
      await connectMongoDB();
    }

    await client.db().admin().ping();
    console.log('MongoDB ping successful');
    return true;
  } catch (error) {
    console.error('MongoDB test connection error:', error);
    throw error;
  }
};

// Get MongoDB database instance
const getDB = () => {
  if (!db) {
    throw new Error('MongoDB not connected. Call connectMongoDB() first.');
  }
  return db;
};

// Get specific collection
const getCollection = (collectionName) => {
  const database = getDB();
  return database.collection(collectionName);
};

// Collections
const collections = {
  lessonsContent: () => getCollection('lessons_content'),
  events: () => getCollection('events'),
  analytics: () => getCollection('analytics'),
};

// Close MongoDB connection
const closeMongoDB = async () => {
  if (client) {
    await client.close();
    console.log('MongoDB connection closed');
  }
};

module.exports = {
  connectMongoDB,
  testMongoConnection,
  getDB,
  getCollection,
  collections,
  closeMongoDB
};
