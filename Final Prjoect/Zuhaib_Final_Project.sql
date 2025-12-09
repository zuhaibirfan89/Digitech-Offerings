drop database if exists olist;
create database olist;
use olist;


-- 1. CUSTOMERS
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

-- 2. GEOLOCATION
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);

-- 3. ORDERS
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 4. PRODUCTS
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 5. SELLERS
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

-- 6. ORDER ITEMS
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- 7. ORDER PAYMENTS
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 8. ORDER REVIEWS
CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);




-- END OF SCHEMA

select count(*) from customers;
select * from customers limit 5;

select  count(*) from orders;
select * from orders limit 5;

select  count(*) from order_items;
select * from order_items limit 5;

select  count(*) from order_items;
select * from order_items limit 5;

select  count(*) from order_payments;
select * from order_payments limit 5;

select  count(*) from products;
select * from products limit 5;

select  count(*) from sellers;
select * from sellers limit 5;


show tables;



SELECT o.order_id, c.customer_city, c.customer_state, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT oi.order_id, p.product_category_name, oi.price, oi.freight_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;


SELECT s.seller_id, s.seller_city, COUNT(*) AS total_items_sold
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city;


SELECT SUM(price + freight_value) AS total_revenue
FROM order_items;

SELECT p.product_category_name, SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
       SUM(price + freight_value) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY month
ORDER BY month;


SELECT payment_type, COUNT(*) AS total
FROM order_payments
GROUP BY payment_type
ORDER BY total DESC;

SELECT AVG(payment_value) AS avg_payment
FROM order_payments;