const app = require('./app');
const dotenv = require('dotenv');

// تحميل متغيرات البيئة
dotenv.config();

const PORT = process.env.PORT || 3001;

// بدء تشغيل الخادم
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📚 API Documentation available at http://localhost:${PORT}/api-docs`);
});