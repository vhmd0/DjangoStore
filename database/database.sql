CREATE DATABASE IF NOT EXISTS s3r_store;
USE s3r_store;

BEGIN;

-- =====================================================
-- Core / Content
-- =====================================================
CREATE TABLE IF NOT EXISTS banner (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image VARCHAR(100) NOT NULL,
    image_mobile VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    subtitle TEXT NOT NULL,
    title_ar VARCHAR(200) NOT NULL,
    subtitle_ar TEXT NOT NULL,
    link VARCHAR(200) NOT NULL,
    link_text VARCHAR(50) NOT NULL,
    link_text_ar VARCHAR(50) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX banner_active_order_idx ON banner (is_active, sort_order);

-- =====================================================
-- Product Catalog
-- =====================================================
CREATE TABLE IF NOT EXISTS category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    image VARCHAR(100) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    sku VARCHAR(100) UNIQUE,
    img VARCHAR(100) NOT NULL,
    img_link VARCHAR(200),
    price DECIMAL(10, 2) NOT NULL,
    stock INT UNSIGNED NOT NULL DEFAULT 0,
    product_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    external_link VARCHAR(200),
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES brand (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX product_category_created_idx ON product (category_id, created_at);
CREATE INDEX product_created_idx ON product (created_at);
CREATE INDEX product_stock_idx ON product (stock);

-- Many-to-many between product and tag
CREATE TABLE IF NOT EXISTS product_tag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    tag_id INT NOT NULL,
    UNIQUE KEY uq_product_tag (product_id, tag_id),
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================
-- User Reviews & Wishlist (depends on auth_user)
-- =====================================================
CREATE TABLE IF NOT EXISTS review (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT UNSIGNED NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    UNIQUE KEY uq_product_user (product_id, user_id),
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    UNIQUE KEY uq_user_product (user_id, product_id),
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================
-- User Profile & Addresses
-- =====================================================
CREATE TABLE IF NOT EXISTS user_profile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    avatar VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_address (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    area VARCHAR(100) NOT NULL,
    is_default TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX user_address_user_default_idx ON user_address (user_id, is_default);
CREATE INDEX user_address_created_idx ON user_address (created_at);

-- =====================================================
-- Shopping Cart
-- =====================================================
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cart_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    UNIQUE KEY uq_cart_product (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES cart (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================
-- Orders
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (   
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    payment_method VARCHAR(20) NOT NULL DEFAULT 'cash_on_delivery',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    shipping_address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    notes TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX order_user_created_idx ON orders (user_id, created_at);
CREATE INDEX order_status_idx ON orders (status);
CREATE INDEX order_payment_method_idx ON orders (payment_method);
CREATE INDEX order_payment_status_idx ON orders (payment_status);

CREATE TABLE IF NOT EXISTS order_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

COMMIT;