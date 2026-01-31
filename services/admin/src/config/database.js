const { Pool } = require('pg');

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 50,  // Increased from 20 to 50 for concurrent dashboard loads
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,  // Increased from 2000 to 5000
});

// Handle pool errors
pool.on('error', (err, client) => {
  console.error('[DATABASE] Unexpected error on idle PostgreSQL client', err);
});

// Test database connection
const testConnection = async () => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    client.release();
    console.log('[DATABASE] PostgreSQL connected at:', result.rows[0].now);
    return true;
  } catch (error) {
    console.error('[DATABASE] Connection error:', error);
    throw error;
  }
};

// Execute query helper
const query = async (text, params) => {
  const start = Date.now();
  try {
    // Support both formats: query(text, params) and query({text, values})
    const result = typeof text === 'object'
      ? await pool.query(text)
      : await pool.query(text, params);
    const duration = Date.now() - start;
    console.log('[DATABASE] Executed query', { duration, rows: result.rowCount });
    return result;
  } catch (error) {
    console.error('[DATABASE] Query error:', error);
    throw error;
  }
};

// Get a client from the pool (for transactions)
const getClient = async () => {
  const client = await pool.connect();
  return client;
};

module.exports = {
  pool,
  query,
  getClient,
  testConnection
};
