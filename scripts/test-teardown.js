require('dotenv').config({ path: '.env.test' });
const mysql = require('mysql2/promise');

module.exports = async () => {
  const conn = await mysql.createConnection({
    host:     process.env.TEST_DB_HOST,
    port:     process.env.TEST_DB_PORT,
    user:     process.env.TEST_DB_ADMIN_USER,
    password: process.env.TEST_DB_ADMIN_PASS,
  });
  await conn.query(`DROP DATABASE IF EXISTS \`${process.env.TEST_DB_NAME}\`;`);
  await conn.end();
  console.log(`Dropped database ${process.env.TEST_DB_NAME}`);
};
