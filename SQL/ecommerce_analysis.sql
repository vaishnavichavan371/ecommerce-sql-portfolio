-- ============================================
-- E-Commerce Sales & Customer Analytics
-- SQL Portfolio Project
-- ============================================


-- ============================================
-- 1. DATA QUALITY CHECKS
-- ============================================

-- Check row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders;


-- Check for NULL values in orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_present,
    COUNT(product_id) AS product_id_present,
    COUNT(quantity) AS quantity_present,
    COUNT(order_date) AS order_date_present
FROM orders;


-- Check for duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Check for duplicate product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check for duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Check order date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM orders;


-- Check quantity range
SELECT
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity
FROM orders;

-- ============================================
-- 2. BUSINESS ANALYSIS
-- ============================================


-- Total Revenue
SELECT
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id;


-- Total Orders
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- Total Units Sold
SELECT
    SUM(quantity) AS total_units_sold
FROM orders;


-- Average Order Value (AOV)
SELECT
    ROUND(
        SUM(p.price * o.quantity) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id;


-- Average Units Per Order
SELECT
    ROUND(
        SUM(quantity)::numeric / COUNT(*),
        2
    ) AS average_units_per_order
FROM orders;


-- Monthly Revenue
SELECT
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(p.price * o.quantity) AS revenue
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY EXTRACT(MONTH FROM o.order_date)
ORDER BY month;


-- Revenue by Category
SELECT
    p.category,
    SUM(p.price * o.quantity) AS revenue
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- Units Sold by Category
SELECT
    p.category,
    SUM(o.quantity) AS total_units
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_units DESC;


-- Top 5 Products by Revenue
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS revenue
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- Top 5 Products by Units Sold
SELECT
    p.product_name,
    SUM(o.quantity) AS total_units
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units DESC
LIMIT 5;

-- ============================================
-- 3. CUSTOMER ANALYSIS
-- ============================================


-- Top 5 Customers by Revenue
SELECT
    c.customer_name,
    SUM(p.price * o.quantity) AS revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON p.product_id = o.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC
LIMIT 5;


-- Top 5 Cities by Revenue
SELECT
    c.city,
    SUM(p.price * o.quantity) AS revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON p.product_id = o.product_id
GROUP BY c.city
ORDER BY revenue DESC
LIMIT 5;


-- Customers with More Than 10 Orders
SELECT
    c.customer_name,
    COUNT(*) AS customer_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) > 10;


-- Customers Spending More Than ₹10,000
SELECT
    c.customer_name,
    SUM(p.price * o.quantity) AS revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON p.product_id = o.product_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(p.price * o.quantity) > 10000;


-- Customer with the Most Orders
SELECT
    c.customer_name,
    COUNT(*) AS customer_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_orders DESC
LIMIT 1;


-- Customer with the Greatest Number of Different Products
SELECT
    c.customer_name,
    COUNT(DISTINCT p.product_id) AS different_products
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON p.product_id = o.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY different_products DESC
LIMIT 1;


-- Customer with the Greatest Total Units
SELECT
    c.customer_name,
    SUM(o.quantity) AS total_units
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_units DESC
LIMIT 1;

-- ============================================
-- 4. CUSTOMER RETENTION ANALYSIS
-- ============================================


-- Customers Active in at Least 3 Different Months
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) AS active_months
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) >= 3;


-- Percentage of Customers Active in 3+ Different Months
WITH active_customers AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) AS active_months
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) >= 3
)
SELECT
    ROUND(
        COUNT(*)::numeric / (SELECT COUNT(*) FROM customers) * 100,
        2
    ) AS percentage_customers
FROM active_customers;


-- Average Orders per Customer for Customers with 3+ Orders
WITH customer_count AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(*) AS order_count
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    HAVING COUNT(*) >= 3
)
SELECT
    ROUND(AVG(order_count), 2) AS average_orders
FROM customer_count;


-- Customers Ordering in Both Halves of 2025
SELECT
    COUNT(*) AS customers_in_both_halves
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING
        COUNT(CASE
            WHEN EXTRACT(MONTH FROM order_date) <= 6 THEN 1
        END) > 0
        AND
        COUNT(CASE
            WHEN EXTRACT(MONTH FROM order_date) > 6 THEN 1
        END) > 0
) AS customer_halves;

-- ============================================
-- 5. ADVANCED CUSTOMER METRICS
-- ============================================


-- Customer with the Highest Average Quantity per Order
SELECT
    c.customer_name,
    AVG(o.quantity) AS average_quantity
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY average_quantity DESC
LIMIT 1;


-- Customer with the Highest Revenue per Order
WITH customer_behavior AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(p.price * o.quantity) AS total_revenue,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN products p
        ON p.product_id = o.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    ROUND(total_revenue / total_orders, 2) AS revenue_per_order
FROM customer_behavior
ORDER BY revenue_per_order DESC
LIMIT 1;


-- Customer with the Longest Gap Between First and Last Order
SELECT
    c.customer_name,
    MAX(o.order_date) - MIN(o.order_date) AS order_gap_days
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_gap_days DESC
LIMIT 1;