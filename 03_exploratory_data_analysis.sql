/*
===========================================================
SECTION 1: BUSINESS OVERVIEW
===========================================================

Business Question:
What is the overall size of the Olist marketplace?

Purpose:
Provide a high-level snapshot of the business by reporting
the total number of customers, orders, products, sellers,
product categories, payments, and reviews.
===========================================================
*/

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM sellers) AS total_sellers,
    (SELECT COUNT(*) FROM category_translation) AS total_categories,
    (SELECT COUNT(*) FROM payments) AS total_payments,
    (SELECT COUNT(*) FROM reviews) AS total_reviews;


/*
===========================================================
SECTION 2: TIME ANALYSIS
===========================================================
*/


/*
-----------------------------------------------------------
2.1 Dataset Time Range
-----------------------------------------------------------

Business Question:
What period does the dataset cover?

Purpose:
Understand how much historical data is available before
performing trend analysis.
*/

SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order,
    DATEDIFF(
        MAX(order_purchase_timestamp),
        MIN(order_purchase_timestamp)
    ) AS days_covered
FROM orders;


/*
-----------------------------------------------------------
2.2 Orders by Year
-----------------------------------------------------------

Business Question:
How many orders were placed each year?

Purpose:
Provide a high-level view of business growth over time.
*/

SELECT
    YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY year;


/*
-----------------------------------------------------------
2.3 Orders by Month
-----------------------------------------------------------

Business Question:
How many orders were placed each month?

Purpose:
Analyze monthly order trends and identify seasonality.
*/

SELECT
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month_number,
    MONTHNAME(order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    MONTHNAME(order_purchase_timestamp)
ORDER BY 
    year,
    month_number;

/*
-----------------------------------------------------------
2.4 Month with the Highest Number of Orders
-----------------------------------------------------------

Business Question:
Which month recorded the highest number of orders?

Purpose:
Identify the strongest performing month in terms of order
volume.
*/

WITH monthly_orders AS
(
    SELECT
        YEAR(order_purchase_timestamp) AS year,
        MONTH(order_purchase_timestamp) AS month_number,
        MONTHNAME(order_purchase_timestamp) AS month,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY
        YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp),
        MONTHNAME(order_purchase_timestamp)
)

SELECT
    year,
    month,
    total_orders
FROM monthly_orders
ORDER BY total_orders DESC
LIMIT 1;

/*
-----------------------------------------------------------
2.5 Orders by Weekday

Business Question:
On which day of the week are customers placing the most orders?

Purpose:
Identify the busiest weekdays to help support operational
planning such as staffing, logistics, and marketing.

Expected Insight:
Determine which weekdays experience the highest order
volume and identify patterns in customer purchasing behavior.
-----------------------------------------------------------
*/

SELECT
    DAYNAME(order_purchase_timestamp) AS weekday,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    WEEKDAY(order_purchase_timestamp),
    DAYNAME(order_purchase_timestamp)
ORDER BY total_orders DESC;
/*
-----------------------------------------------------------
2.6 Orders by Hour

Business Question:
At what hour of the day are customers placing the most orders?

Purpose:
Identify peak ordering hours to support staffing, logistics,
and customer service planning.

Expected Insight:
Reveal the hours with the highest customer activity and
identify peak purchasing periods throughout the day.
-----------------------------------------------------------
*/

SELECT
    HOUR(order_purchase_timestamp) AS order_hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY total_orders DESC;

/*
-----------------------------------------------------------
3.1 Order Status & Fulfillment Distribution

Business Question:
How are orders distributed across different statuses,
and what percentage are delivered or cancelled?

Purpose:
Understand the overall fulfillment status of orders and
measure the proportion of successfully delivered and
cancelled orders.
-----------------------------------------------------------
*/

WITH order_status_distribution AS (
    SELECT
        order_status,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY order_status
)
SELECT
    order_status,
    total_orders,
    ROUND(
        total_orders / (SELECT COUNT(*) FROM orders) * 100,
        2
    ) AS percentage_of_total_orders
FROM order_status_distribution
ORDER BY total_orders DESC;

/*
-----------------------------------------------------------
3.2 Average Delivery Time

Business Question:
How many days does it take, on average, for an order
to be delivered?

Purpose:
Measure the average time between order placement and
delivery to evaluate overall delivery performance.

Expected Insight:
Determine the typical delivery time experienced by
customers and establish a baseline for logistics performance.
-----------------------------------------------------------
*/

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*
-----------------------------------------------------------
3.3 Delivery Performance

Business Question:
Are orders being delivered by the estimated delivery date?

Purpose:
Compare actual delivery dates with estimated delivery dates
to classify orders as early, on time, or late.

Expected Insight:
Measure delivery performance and identify whether delays are
a significant issue for customers.
-----------------------------------------------------------
*/

WITH delivery_status AS (
    SELECT
        CASE
            WHEN DATE(order_delivered_customer_date)
                 > DATE(order_estimated_delivery_date)
                THEN 'delivered late'

            WHEN DATE(order_delivered_customer_date)
                 < DATE(order_estimated_delivery_date)
                THEN 'delivered early'

            ELSE 'delivered on time'
        END AS delivery_status
    FROM orders
    WHERE order_delivered_customer_date IS NOT NULL
)

SELECT
    delivery_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM delivery_status) * 100,
        2
    ) AS percentage
FROM delivery_status
GROUP BY delivery_status
ORDER BY total_orders DESC;

/*
-----------------------------------------------------------
4.1 Customers by State

Business Question:
Which states have the largest number of customers and what
percentage of the total customer base does each state represent?

Purpose:
Identify the geographic concentration of the customer base
and understand the contribution of each state.

Expected Insight:
Determine the largest customer markets and identify how
concentrated the customer base is geographically.
-----------------------------------------------------------
*/

SELECT
    customer_state,
    COUNT(*) AS number_of_customers,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM customers) * 100,
        2
    ) AS percentage_of_customers
FROM customers
GROUP BY customer_state
ORDER BY number_of_customers DESC;

/*
-----------------------------------------------------------
4.2 Top 10 Customer Cities

Business Question:
Which cities have the largest number of customers?

Purpose:
Identify the cities with the largest customer base and
understand where customers are geographically concentrated.

Expected Insight:
Identify the strongest urban markets and potential priority
locations for marketing and logistics.
-----------------------------------------------------------
*/

SELECT
    customer_city,
    COUNT(*) AS number_of_customers,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM customers) * 100,
        2
    ) AS percentage_of_customers
FROM customers
GROUP BY customer_city
ORDER BY number_of_customers DESC
LIMIT 10;

/*
-----------------------------------------------------------
4.3 Top Customer City by State

Business Question:
For each state, which city has the largest number of customers?

Purpose:
Identify the strongest customer market within each state.

Expected Insight:
Determine the leading city in each state and capture all
cities tied for the highest customer count.
-----------------------------------------------------------
*/

WITH city_rankings AS (
    SELECT
        customer_state,
        customer_city,
        COUNT(*) AS number_of_customers,
        DENSE_RANK() OVER (
            PARTITION BY customer_state
            ORDER BY COUNT(*) DESC
        ) AS city_rank
    FROM customers
    GROUP BY
        customer_state,
        customer_city
)

SELECT
    customer_state,
    customer_city,
    number_of_customers
FROM city_rankings
WHERE city_rank = 1
ORDER BY customer_state;

/*
-----------------------------------------------------------
5.1 Total Product Categories

Business Question:
How many distinct product categories are represented
in the marketplace?

Purpose:
Understand the variety of products available on the
marketplace.
-----------------------------------------------------------
*/

SELECT
    COUNT(DISTINCT product_category_name) AS total_product_categories
FROM products;


/*
-----------------------------------------------------------
5.2 Products per Category

Business Question:
How many products are listed in each product category?

Purpose:
Understand how the marketplace's product catalog is
distributed across categories.
-----------------------------------------------------------
*/

SELECT
    product_category_name,
    COUNT(*) AS number_of_products
FROM products
GROUP BY product_category_name
ORDER BY number_of_products DESC;


/*
-----------------------------------------------------------
5.3 Revenue & Revenue Contribution by Category

Business Question:
Which product categories generate the most revenue,
and what percentage of total revenue does each category
contribute?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Measure the financial contribution of each product
category to the marketplace.
-----------------------------------------------------------
*/

WITH revenue_per_category AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
)
SELECT
    product_category_name,
    total_revenue,
    ROUND(
        total_revenue /
        (SELECT SUM(total_revenue) FROM revenue_per_category) * 100,
        2
    ) AS percentage_of_total_revenue
FROM revenue_per_category
ORDER BY total_revenue DESC;


/*
-----------------------------------------------------------
5.4 Category Sales Volume & Revenue Efficiency

Business Question:
Which product categories have the highest sales volume,
and how much revenue does each generate per item sold?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Compare category demand with the revenue generated
per item sold.
-----------------------------------------------------------
*/

SELECT
    p.product_category_name,
    COUNT(*) AS number_of_items_sold,
    SUM(oi.price) AS total_revenue,
    ROUND(
        SUM(oi.price) / COUNT(*),
        2
    ) AS average_revenue_per_item
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY number_of_items_sold DESC;

/*
-----------------------------------------------------------
6.1 Seller Revenue Performance

Business Question:
Which sellers generate the highest revenue?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Identify the sellers generating the most revenue for
the marketplace.
-----------------------------------------------------------
*/

SELECT
    s.seller_id,
    SUM(oi.price) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY total_revenue DESC;


/*
-----------------------------------------------------------
6.2 Seller Sales Volume & Order Volume

Business Question:
Which sellers sell the most items and fulfill the highest
number of unique orders?

Revenue Definition:
Only delivered orders are considered.

Purpose:
Compare seller activity based on both items sold and
unique orders fulfilled.
-----------------------------------------------------------
*/

SELECT
    s.seller_id,
    COUNT(*) AS number_of_items_sold,
    COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY number_of_items_sold DESC;


/*
-----------------------------------------------------------
6.3 Seller Revenue per Order

Business Question:
Which sellers generate the highest average revenue
per order?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Compare the average value of orders fulfilled by each
seller.
-----------------------------------------------------------
*/

SELECT
    s.seller_id,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS number_of_orders,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS average_revenue_per_order
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY average_revenue_per_order DESC;


/*
-----------------------------------------------------------
6.4 Seller Geographic Distribution & Revenue by State

Business Question:
Which states have the most sellers, and which seller
states generate the most revenue?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Analyze the geographic distribution of sellers and
compare marketplace revenue across seller states.
-----------------------------------------------------------
*/

SELECT
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS number_of_sellers,
    SUM(oi.price) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY total_revenue DESC;


/*
-----------------------------------------------------------
6.5 Seller Revenue Concentration

Business Question:
What percentage of total marketplace revenue is generated
by the top 10 sellers?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Measure how concentrated marketplace revenue is among
the highest-performing sellers.
-----------------------------------------------------------
*/

WITH revenue_per_seller AS (
    SELECT
        s.seller_id,
        SUM(oi.price) AS total_revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id
),
top_10_sellers AS (
    SELECT
        seller_id,
        total_revenue
    FROM revenue_per_seller
    ORDER BY total_revenue DESC
    LIMIT 10
)
SELECT
    SUM(total_revenue) AS top_10_revenue,
    ROUND(
        SUM(total_revenue) /
        (SELECT SUM(total_revenue)
         FROM revenue_per_seller) * 100,
        2
    ) AS percentage_of_total_revenue
FROM top_10_sellers;
    
 
/*
-----------------------------------------------------------
7.1 Payment Method Distribution

Business Question:
Which payment methods are used most frequently?

Purpose:
Understand customer payment preferences.

Expected Insight:
Identify the most and least frequently used payment methods.
-----------------------------------------------------------
*/

SELECT
    payment_type,
    COUNT(*) AS payments_per_type
FROM payments
GROUP BY payment_type
ORDER BY payments_per_type DESC;

 
 /*
-----------------------------------------------------------
7.2 Payment Value & Average Payment Value by Payment Method

Business Question: 
Which payment methods generate the highest payment value and are associated with higher-value payments?

Payment Value Definition:
Payment values from the payments table are considered.
Only payments associated with delivered orders are included.

Purpose:
Compare the financial contribution and average payment value associated with each payment method.

Expected Insight:
Identify payment methods associated with higher-value
customer orders.
-----------------------------------------------------------
*/

SELECT
    p.payment_type,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    COUNT(DISTINCT p.order_id) AS number_of_orders,
    ROUND(
        SUM(p.payment_value) / COUNT(DISTINCT p.order_id),
        2
    ) AS average_payment_value_per_order
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY average_payment_value_per_order DESC;
 
/*
-----------------------------------------------------------
7.3 Payment Installments

Business Question:
How does the number of installments vary across payment
methods?

Purpose:
Compare installment behavior across different payment
methods.

Expected Insight:
Identify which payment methods are typically associated
with more or fewer installments.
-----------------------------------------------------------
*/

SELECT
    payment_type,
    ROUND(AVG(payment_installments), 2) AS average_number_of_installments
FROM payments
GROUP BY payment_type
ORDER BY average_number_of_installments DESC; 

/*
-----------------------------------------------------------
7.4 Installments vs Payment Value

Business Question:
Do higher-value payments tend to use more payment
installments?

Payment Value Definition:
Payment values from the payments table are considered.
Only payments associated with delivered orders are included.

Purpose:
Compare average payment value across different installment
counts.

Expected Insight:
Determine whether higher-value payments tend to be
associated with more installments.
-----------------------------------------------------------
*/

SELECT
    p.payment_installments,
    COUNT(*) AS number_of_payment_records,
    ROUND(AVG(p.payment_value), 2) AS average_payment_value
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_installments
ORDER BY average_payment_value DESC;
    
/*
-----------------------------------------------------------
8.1 Review Score Distribution

Business Question:
What is the distribution of customer review scores?

Purpose:
Understand how customer reviews are distributed across
the 1-to-5 rating scale.

Expected Insight:
Determine whether customer feedback is generally positive,
negative, or mixed.
-----------------------------------------------------------
*/

SELECT
    review_score,
    COUNT(*) AS number_of_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;

/*
-----------------------------------------------------------
8.2 Overall Average Review Score

Business Question:
What is the overall average customer review score?

Purpose:
Establish an overall customer satisfaction benchmark.

Expected Insight:
Understand the general level of customer satisfaction
across all reviews.
-----------------------------------------------------------
*/

SELECT
    ROUND(AVG(review_score), 2) AS overall_average_score
FROM reviews;

/*
-----------------------------------------------------------
8.3 Review Score by Product Category

Business Question:
Which product categories receive the highest and lowest
average review scores?

Purpose:
Compare customer satisfaction across product categories.

Expected Insight:
Identify categories associated with particularly positive
or negative customer feedback.
-----------------------------------------------------------
*/

SELECT
    p.product_category_name,
    AVG(r.review_score) AS overall_average_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY overall_average_score DESC;

/*
-----------------------------------------------------------
8.4 Review Score by Seller

Business Question:
Which sellers receive the highest and lowest average
review scores?

Purpose:
Compare customer satisfaction across sellers.

Expected Insight:
Identify sellers associated with particularly positive
or negative customer feedback.
-----------------------------------------------------------
*/

SELECT
    s.seller_id,
    AVG(r.review_score) AS overall_average_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN sellers s
    ON s.seller_id = oi.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY overall_average_score DESC;

/*
-----------------------------------------------------------
8.5 Delivery Time vs Review Score

Business Question:
Do longer delivery times tend to result in lower review
scores?

Purpose:
Analyze the relationship between delivery time and
customer satisfaction.

Expected Insight:
Determine whether longer delivery times are associated
with lower customer review scores.
-----------------------------------------------------------
*/

SELECT
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    ) AS time_to_delivery,
    ROUND(AVG(r.review_score), 2) AS overall_average_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY time_to_delivery
ORDER BY time_to_delivery DESC;    