const { Pool } = require('pg');

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Handle pool errors
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle PostgreSQL client', err);
});

// Test database connection
const testPostgresConnection = async () => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    client.release();
    console.log('PostgreSQL connected at:', result.rows[0].now);
    return true;
  } catch (error) {
    console.error('PostgreSQL connection error:', error);
    throw error;
  }
};

// Execute query helper
const query = async (text, params) => {
  const start = Date.now();
  try {
    const result = await pool.query(text, params);
    const duration = Date.now() - start;
    console.log('Executed query', { text: text.substring(0, 100), duration, rows: result.rowCount });
    return result;
  } catch (error) {
    console.error('Query error:', error);
    throw error;
  }
};

// Get a client from the pool (for transactions)
const getClient = async () => {
  const client = await pool.connect();
  return client;
};

// Connect to PostgreSQL
const connectPostgres = async () => {
  try {
    await testPostgresConnection();
    console.log('PostgreSQL pool initialized');
  } catch (error) {
    console.error('Failed to initialize PostgreSQL pool:', error);
    throw error;
  }
};

module.exports = {
  pool,
  query,
  getClient,
  connectPostgres,
  testPostgresConnection
};
