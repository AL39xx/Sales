const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config();

// إعدادات الاتصال بقاعدة البيانات
const dbConfig = {
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'salesuser',
  password: process.env.DB_PASSWORD || 'salespass',
  database: process.env.DB_NAME || 'salesapp',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

// إنشاء تجمع الاتصالات
const pool = mysql.createPool(dbConfig);

// اختبار الاتصال بقاعدة البيانات
const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log('🔌 Database connection established successfully');
    connection.release();
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
    return false;
  }
};

// تصدير وحدة الاتصال
module.exports = {
  pool,
  testConnection
};