CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    city VARCHAR(80) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('PLACED','SHIPPED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PLACED',
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE (order_id, product_id)
);

INSERT INTO customers(full_name,email,city) VALUES
('Aarav Sharma','aarav@example.com','Pune'),
('Meera Patel','meera@example.com','Indore'),
('Rohan Verma','rohan@example.com','Bhopal');

INSERT INTO products(product_name,category,price,stock) VALUES
('Wireless Mouse','Accessories',599.00,40),
('Keyboard','Accessories',999.00,25),
('USB-C Hub','Electronics',1499.00,15),
('Notebook','Stationery',99.00,100),
('Desk Lamp','Home',799.00,20);

INSERT INTO orders(customer_id,order_date,status) VALUES
(1,'2026-11-01','DELIVERED'),
(1,'2026-11-08','SHIPPED'),
(2,'2026-11-10','PLACED'),
(3,'2026-11-12','CANCELLED');

INSERT INTO order_items(order_id,product_id,quantity,unit_price) VALUES
(1,1,2,599.00),(1,4,3,99.00),
(2,3,1,1499.00),(3,2,1,999.00),(3,5,2,799.00);

-- 1. Display all products.
SELECT * FROM products;

-- 2. Products with stock below 20.
SELECT product_name, stock FROM products WHERE stock < 20 ORDER BY stock;

-- 3. Order details with customer names.
SELECT o.order_id, c.full_name, o.order_date, o.status
FROM orders o JOIN customers c ON o.customer_id = c.customer_id;

-- 4. Calculate each order total.
SELECT oi.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM order_items oi GROUP BY oi.order_id;

-- 5. Customer-wise spending (exclude cancelled orders).
SELECT c.customer_id, c.full_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- 6. Products that have never been ordered.
SELECT p.product_id, p.product_name
FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 7. Product price above average product price (subquery).
SELECT product_name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 8. View for order summary.
CREATE OR REPLACE VIEW order_summary AS
SELECT o.order_id, c.full_name, o.order_date, o.status,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name, o.order_date, o.status;

SELECT * FROM order_summary;

-- 9. Update stock for a product after a sale (example transaction).
START TRANSACTION;
UPDATE products SET stock = stock - 1 WHERE product_id = 1 AND stock >= 1;
-- Check affected rows before committing in a real application.
COMMIT;

-- 10. Example customer insert.
INSERT INTO customers(full_name,email,city)
VALUES ('Nisha Joshi','nisha@example.com','Mumbai');
