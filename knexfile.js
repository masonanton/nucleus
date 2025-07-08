require('dotenv').config();
module.exports = {
  development: {
    client: 'mysql2',
    connection: {
      host:     process.env.DB_HOST,
      port:     process.env.DB_PORT,
      user:     process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
      charset:  'utf8mb4'
    }
  },
  test: {
    client: 'mysql2',
    connection: {
      host:     process.env.TEST_DB_HOST,
      port:     process.env.TEST_DB_PORT,
      user:     process.env.TEST_DB_USER,
      password: process.env.TEST_DB_PASS,
      database: process.env.TEST_DB_NAME,
      charset:  'utf8mb4'
    }
  }
};
