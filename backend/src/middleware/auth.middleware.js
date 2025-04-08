const jwt = require('jsonwebtoken');
const { AppError } = require('./errorHandler');

// التحقق من وجود توكن صالح
const authenticateToken = (req, res, next) => {
  // استخراج التوكن من الترويسة
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return next(new AppError('غير مصرح لك. يرجى تسجيل الدخول', 401));
  }

  try {
    // التحقق من صحة التوكن
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return next(new AppError('توكن غير صالح. يرجى تسجيل الدخول مرة أخرى', 401));
  }
};

// التحقق من الصلاحيات
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return next(new AppError('غير مصرح لك. يرجى تسجيل الدخول', 401));
    }

    if (!roles.includes(req.user.role)) {
      return next(
        new AppError('غير مصرح لك للوصول إلى هذا المورد', 403)
      );
    }
    next();
  };
};

module.exports = {
  authenticateToken,
  authorize
};