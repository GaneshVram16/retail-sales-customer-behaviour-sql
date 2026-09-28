-- MySQL 8+ schema for the retail analytics project

CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    city VARCHAR(50),
    segment VARCHAR(20),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120),
    category VARCHAR(50),
    unit_price DECIMAL(12,2),
    margin_rate DECIMAL(6,3)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    payment_method VARCHAR(30),
    channel VARCHAR(30),
    delivery_days INT,
    promised_days INT,
    delivery_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(12,2),
    discount_rate DECIMAL(6,2),
    net_revenue DECIMAL(14,2),
    estimated_cost DECIMAL(14,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    order_id INT PRIMARY KEY,
    review_score INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);