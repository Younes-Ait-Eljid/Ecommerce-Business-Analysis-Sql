/*
===========================================================
                OLIST E-COMMERCE DATA AUDIT
===========================================================

Purpose:
Perform an initial audit of the dataset before any analysis.

Checks Included:
1. Row counts
2. Primary key duplicates
3. Missing values
4. Date range
5. Order status distribution

===========================================================
*/

USE olist;

-- =========================================================
-- 1. ROW COUNTS
-- =========================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;

-- =========================================================
-- 2. PRIMARY KEY DUPLICATE CHECKS
-- =========================================================

-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Customers
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Products
SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Sellers
SELECT seller_id, COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Reviews
SELECT review_id, COUNT(*) AS duplicate_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Order Items (Composite PK)
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Payments (Composite PK)
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- Category Translation
SELECT
    product_category_name,
    COUNT(*) AS duplicate_count
FROM category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

-- =========================================================
-- 3. MISSING VALUE CHECKS
-- =========================================================

-- Orders
SELECT
    SUM(order_approved_at IS NULL) AS missing_order_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer_delivery_date,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_delivery_date
FROM orders;

-- Customers
SELECT
    SUM(customer_city IS NULL) AS missing_customer_city,
    SUM(customer_state IS NULL) AS missing_customer_state
FROM customers;

-- Products
SELECT
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products;

-- Payments
SELECT
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM payments;

-- Reviews
SELECT
    SUM(review_score IS NULL) AS missing_review_score,
    SUM(review_comment_title IS NULL) AS missing_review_title,
    SUM(review_comment_message IS NULL) AS missing_review_message
FROM reviews;

-- Sellers
SELECT
    SUM(seller_city IS NULL) AS missing_seller_city,
    SUM(seller_state IS NULL) AS missing_seller_state
FROM sellers;

-- =========================================================
-- 4. DATE RANGE
-- =========================================================

SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- =========================================================
-- 5. ORDER STATUS DISTRIBUTION
-- =========================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*
===========================================================
AUDIT SUMMARY

- All tables imported successfully.
- No duplicate primary keys detected.
- Missing review comments were identified and cleaned
  in 02_data_cleaning.sql.
- Dataset covers orders from [first date] to [last date].
- Majority of orders are delivered.

Dataset is ready for exploratory data analysis.
===========================================================
*/