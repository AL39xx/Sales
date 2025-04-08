-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS salesapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salesapp;

-- جدول المستخدمين
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin', 'manager', 'sales') NOT NULL DEFAULT 'sales',
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_email (email),
  INDEX idx_user_role (role)
);

-- جدول العملاء
CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  company VARCHAR(100),
  contact_person VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20),
  address TEXT,
  city VARCHAR(50),
  notes TEXT,
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  user_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_customer_email (email),
  INDEX idx_customer_phone (phone),
  INDEX idx_customer_city (city),
  INDEX idx_customer_status (status)
);

-- جدول فئات المنتجات
CREATE TABLE IF NOT EXISTS product_categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- جدول المنتجات
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  sku VARCHAR(30) UNIQUE,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL DEFAULT 0,
  cost DECIMAL(10, 2) DEFAULT 0,
  stock INT DEFAULT 0,
  category_id INT,
  image_url VARCHAR(255),
  status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE SET NULL,
  INDEX idx_product_sku (sku),
  INDEX idx_product_status (status),
  INDEX idx_product_category (category_id)
);

-- جدول عروض الأسعار
CREATE TABLE IF NOT EXISTS quotes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quote_number VARCHAR(20) NOT NULL UNIQUE,
  customer_id INT NOT NULL,
  user_id INT NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
  tax_rate DECIMAL(5, 2) DEFAULT 15.00,
  tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  discount_type ENUM('percentage', 'fixed') DEFAULT NULL,
  discount_value DECIMAL(10, 2) DEFAULT 0,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  total DECIMAL(10, 2) NOT NULL DEFAULT 0,
  notes TEXT,
  terms_conditions TEXT,
  status ENUM('draft', 'sent', 'approved', 'rejected', 'expired') NOT NULL DEFAULT 'draft',
  valid_until DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_quote_number (quote_number),
  INDEX idx_quote_status (status),
  INDEX idx_quote_customer (customer_id),
  INDEX idx_quote_user (user_id),
  INDEX idx_quote_valid_until (valid_until)
);

-- جدول عناصر عروض الأسعار
CREATE TABLE IF NOT EXISTS quote_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quote_id INT NOT NULL,
  product_id INT NOT NULL,
  description TEXT,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10, 2) NOT NULL,
  discount_percentage DECIMAL(5, 2) DEFAULT 0,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  tax_percentage DECIMAL(5, 2) DEFAULT 15.00,
  tax_amount DECIMAL(10, 2) DEFAULT 0,
  total DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_quote_item_quote (quote_id),
  INDEX idx_quote_item_product (product_id)
);

-- جدول تاريخ عروض الأسعار
CREATE TABLE IF NOT EXISTS quote_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quote_id INT NOT NULL,
  user_id INT NOT NULL,
  action VARCHAR(50) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_quote_history_quote (quote_id),
  INDEX idx_quote_history_user (user_id),
  INDEX idx_quote_history_action (action)
);

-- إدخال بيانات المستخدمين الافتراضيين (كلمة المرور: P@ssw0rd)
-- هنا استخدمنا هاش صالح تم إنشاؤه فعلياً باستخدام bcrypt
INSERT INTO users (name, email, password, role) VALUES 
('مدير النظام', 'admin@salesapp.com', '$2b$10$3ubbaTFSuEWCYx4CZXXhcODMkgvb.D8V0XHxVVQRytbaEoRwvK9/y', 'admin'),
('مدير المبيعات', 'manager@salesapp.com', '$2b$10$3ubbaTFSuEWCYx4CZXXhcODMkgvb.D8V0XHxVVQRytbaEoRwvK9/y', 'manager'),
('مندوب مبيعات', 'sales@salesapp.com', '$2b$10$3ubbaTFSuEWCYx4CZXXhcODMkgvb.D8V0XHxVVQRytbaEoRwvK9/y', 'sales');

-- إدخال فئات المنتجات الافتراضية
INSERT INTO product_categories (name, description) VALUES 
('أجهزة كمبيوتر', 'أجهزة كمبيوتر مكتبية ومحمولة'),
('طابعات', 'طابعات ليزر وحبر'),
('ملحقات', 'ملحقات الكمبيوتر المختلفة');

-- إدخال منتجات افتراضية
INSERT INTO products (name, sku, description, price, cost, stock, category_id) VALUES 
('لابتوب ديل XPS 13', 'LAP-001', 'لابتوب ديل XPS 13 بمعالج الجيل الحادي عشر', 5999.00, 4500.00, 10, 1),
('طابعة HP ليزر جيت', 'PRN-001', 'طابعة ليزر أحادية اللون', 899.00, 650.00, 20, 2),
('لوحة مفاتيح لاسلكية', 'ACC-001', 'لوحة مفاتيح لاسلكية مع ماوس', 199.00, 120.00, 50, 3);

-- إدخال عملاء افتراضيين
INSERT INTO customers (name, company, contact_person, email, phone, address, city, user_id) VALUES 
('أحمد محمد', 'شركة التقنية الحديثة', 'أحمد محمد', 'ahmed@modern-tech.com', '0501234567', 'شارع العليا الرئيسي، برج الأعمال، الطابق 12', 'الرياض', 3),
('سارة عبدالله', 'مؤسسة النور للتجارة', 'سارة عبدالله', 'sara@alnoor.com', '0551234567', 'حي الحمراء، شارع الأمير سلطان', 'جدة', 3),
('خالد علي', 'شركة الخليج للحلول التقنية', 'خالد علي', 'khalid@gulf-tech.com', '0561234567', 'طريق الملك فهد، برج الخليج، الطابق 5', 'الدمام', 3);