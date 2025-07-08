require('dotenv').config({ path: '.env.test' });
const mysql = require('mysql2/promise');
const { spawnSync } = require('child_process');

module.exports = async () => {
  const conn = await mysql.createConnection({
    host:     process.env.TEST_DB_HOST,
    port:     process.env.TEST_DB_PORT,
    user:     process.env.TEST_DB_ADMIN_USER,
    password: process.env.TEST_DB_ADMIN_PASS,
  });
  await conn.query(
    `CREATE DATABASE IF NOT EXISTS \`${process.env.TEST_DB_NAME}\`
       CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
  );
  await conn.end();
  console.log(`Ensured database ${process.env.TEST_DB_NAME} exists`);

  const result = spawnSync('docker-compose', [
    'run', '--rm',
    '-e', `FLYWAY_URL=jdbc:mysql://db:${process.env.TEST_DB_PORT}/${process.env.TEST_DB_NAME}?allowPublicKeyRetrieval=true&useSSL=false`,
    '-e', `FLYWAY_USER=${process.env.TEST_DB_USER}`,
    '-e', `FLYWAY_PASSWORD=${process.env.TEST_DB_PASS}`,
    '-e', `FLYWAY_SCHEMAS=${process.env.TEST_DB_NAME}`,
    'flyway', 'migrate'
  ], { stdio: 'inherit' });
  if (result.error || result.status !== 0) {
    throw result.error || new Error('Flyway migration failed');
  }
};
