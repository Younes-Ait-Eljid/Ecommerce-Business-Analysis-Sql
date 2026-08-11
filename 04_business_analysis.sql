/*
-----------------------------------------------------------
4.1.1 Month-over-Month Revenue Growth

Business Question:
What is the month-over-month revenue growth rate?

Revenue Definition:
Only delivered orders are considered revenue.

Analysis Period:
January 2017 onward. The 2016 data is partial and contains
sparse monthly observations, so it is excluded from the
month-over-month growth calculation to avoid misleading
comparisons from an incomplete starting period.

Purpose:
Measure how marketplace revenue changes from one month
to the next.
-----------------------------------------------------------
*/

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY month
),
monthly_growth AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS revenue_growth_rate
FROM monthly_growth
ORDER BY month;
/*
-----------------------------------------------------------
4.1.2 Year-over-Year Revenue Growth

Business Question:
What is the year-over-year revenue growth rate?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Measure how marketplace revenue changes from one year
to the next.
-----------------------------------------------------------
*/

WITH yearly_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY year
),
yearly_growth AS (
    SELECT
        year,
        revenue,
        LAG(revenue) OVER (
            ORDER BY year
        ) AS previous_year_revenue
    FROM yearly_revenue
)
SELECT
    year,
    revenue,
    previous_year_revenue,
    ROUND(
        (revenue - previous_year_revenue)
        / previous_year_revenue * 100,
        2
    ) AS revenue_growth_rate
FROM yearly_growth
ORDER BY year;
/*
-----------------------------------------------------------
4.1.3 Monthly Revenue Contribution

Business Question:
What percentage of total marketplace revenue was generated
in each month?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Measure each month's contribution to total marketplace
revenue.
-----------------------------------------------------------
*/

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(oi.price) AS revenue,
    ROUND(
        SUM(oi.price) /
        (
            SELECT SUM(oi2.price)
            FROM orders o2
            JOIN order_items oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.order_status = 'delivered'
        ) * 100,
        2
    ) AS percentage_of_total_marketplace_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
/*
-----------------------------------------------------------
4.1.4 Cumulative Revenue Progression

Business Question:
What was the cumulative revenue progression over time?

Revenue Definition:
Only delivered orders are considered revenue.

Time Grain:
Monthly

Purpose:
Track how total marketplace revenue accumulated over time.
-----------------------------------------------------------
*/

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT
    month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY month
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;
/*
-----------------------------------------------------------
4.1.5 Top Revenue-Generating Months

Business Question:
Which months generated the highest revenue?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Identify the months with the strongest marketplace
revenue performance.
-----------------------------------------------------------
*/

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    SUM(oi.price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY monthly_revenue DESC
LIMIT 5;

/*
-----------------------------------------------------------
4.2.1 Repeat Customers

Business Question:
How many customers made more than one purchase?

Definition:
A repeat customer is a customer_unique_id associated with
more than one delivered order.

Purpose:
Measure the number of customers who made repeat purchases
on the marketplace.
-----------------------------------------------------------
*/

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS number_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS customers_who_purchased_more_than_once
FROM customer_orders
WHERE number_of_orders > 1;

/*
-----------------------------------------------------------
4.2.2 Repeat Customer Percentage

Business Question:
What percentage of the customer base consists of
repeat customers?

Definition:
A repeat customer is a customer_unique_id associated with
more than one delivered order.

Purpose:
Measure the proportion of the active customer base that
makes repeat purchases.
-----------------------------------------------------------
*/

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS number_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS customers_who_purchased_more_than_once,
    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM customer_orders) * 100,
        2
    ) AS percentage_of_repeat_customers
FROM customer_orders
WHERE number_of_orders > 1;

/*
-----------------------------------------------------------
4.2.3 Top Customers by Revenue

Business Question:
Which customers generated the highest total revenue?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Identify the highest-value customers based on their total
revenue contribution to the marketplace.
-----------------------------------------------------------
*/

SELECT
    c.customer_unique_id,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 5;
/*
-----------------------------------------------------------
4.2.4 Spending: Repeat vs One-Time Customers

Business Question:
How does spending differ between repeat and one-time
customers?

Revenue Definition:
Only delivered orders are considered revenue.

Customer Definition:
A repeat customer has more than one delivered order.
A one-time customer has exactly one delivered order.

Purpose:
Compare average customer spending between repeat and
one-time customers.
-----------------------------------------------------------
*/

WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS number_of_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN number_of_orders > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer
FROM customer_revenue
GROUP BY customer_type
ORDER BY average_revenue_per_customer DESC;

/*
-----------------------------------------------------------
4.3.1 Top Products by Revenue

Business Question:
Which individual products generate the most revenue?

Revenue Definition:
Only delivered orders are considered revenue.

Purpose:
Identify the highest-revenue-generating products in the
marketplace.
-----------------------------------------------------------
*/

SELECT
    oi.product_id,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY total_revenue DESC
LIMIT 10;
/*
-----------------------------------------------------------
4.3.2 Top Products by Sales Volume

Business Question:
Which individual products have the highest sales volume?

Revenue Definition:
Only delivered orders are considered.

Purpose:
Identify the products with the highest number of units
sold and provide their corresponding revenue for context.
-----------------------------------------------------------
*/

SELECT
    oi.product_id,
    COUNT(*) AS number_of_items_sold,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY number_of_items_sold DESC
LIMIT 10;

/*
-----------------------------------------------------------
4.4.1 Sellers Above Average Revenue

Business Question:
Which sellers generate significantly more revenue than
the average seller?

Revenue Definition:
Only delivered orders are considered revenue.

Definition:
A high-performing seller is one whose total revenue is
above the average total revenue generated per seller.

Purpose:
Identify sellers performing above the marketplace-wide
seller revenue average.
-----------------------------------------------------------
*/

WITH seller_revenue AS (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
)
SELECT
    seller_id,
    total_revenue
FROM seller_revenue
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM seller_revenue
)
ORDER BY total_revenue DESC;

/*
-----------------------------------------------------------
4.5.1 Late Delivery Rate by State

Business Question:
Which states have the highest late-delivery rates?

Definition:
Late delivery = delivered customer date is later than
the estimated delivery date.

Purpose:
Identify states with the highest proportion of orders
delivered after the estimated delivery date.
-----------------------------------------------------------
*/

WITH customer_state_delivery AS (
    SELECT
        c.customer_state,
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
                THEN 'delivered late'
            WHEN DATE(o.order_delivered_customer_date)
                 < DATE(o.order_estimated_delivery_date)
                THEN 'delivered early'
            ELSE 'delivered on time'
        END AS delivery_status
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT
    customer_state,
    COUNT(*) AS total_delivered_orders,
    SUM(
        CASE
            WHEN delivery_status = 'delivered late' THEN 1
            ELSE 0
        END
    ) AS late_delivery_orders,
    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'delivered late' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS late_delivery_rate
FROM customer_state_delivery
GROUP BY customer_state
ORDER BY late_delivery_rate DESC
LIMIT 10;

/*
-----------------------------------------------------------
4.5.2 Late Delivery Rate Over Time

Business Question:
How has the late-delivery rate changed over time?

Definition:
Late delivery = actual delivery date is later than the
estimated delivery date.

Time Grain:
Monthly

Purpose:
Track changes in delivery performance over time and
identify periods with unusually high late-delivery rates.
-----------------------------------------------------------
*/

WITH monthly_delivery AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
                THEN 'delivered late'
            WHEN DATE(o.order_delivered_customer_date)
                 < DATE(o.order_estimated_delivery_date)
                THEN 'delivered early'
            ELSE 'delivered on time'
        END AS delivery_status
    FROM orders o
    WHERE o.order_status = 'delivered'
)
SELECT
    month,
    COUNT(*) AS total_delivered_orders,
    SUM(
        CASE
            WHEN delivery_status = 'delivered late' THEN 1
            ELSE 0
        END
    ) AS late_delivery_orders,
    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'delivered late' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS late_delivery_rate
FROM monthly_delivery
GROUP BY month
ORDER BY month;

/*
-----------------------------------------------------------
4.6.1 Delivery Performance vs Customer Satisfaction

Business Question:
How does delivery performance affect customer review scores?

Definition:
Late delivery = actual delivery date is later than the
estimated delivery date.

Purpose:
Compare customer satisfaction across early, on-time,
and late deliveries.
-----------------------------------------------------------
*/

WITH review_delivery_score AS (
    SELECT
        r.review_score,
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
                THEN 'delivered late'
            WHEN DATE(o.order_delivered_customer_date)
                 < DATE(o.order_estimated_delivery_date)
                THEN 'delivered early'
            ELSE 'delivered on time'
        END AS delivery_status
    FROM reviews r
    JOIN orders o
        ON r.order_id = o.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    delivery_status,
    COUNT(*) AS number_of_reviews,
    ROUND(AVG(review_score), 2) AS average_review_score
FROM review_delivery_score
GROUP BY delivery_status
ORDER BY average_review_score DESC;

/*
-----------------------------------------------------------
4.6.2 Product Category Satisfaction vs Marketplace Average

Business Question:
Which product categories have the largest difference
between their average review score and the marketplace
average?

Purpose:
Identify product categories that significantly outperform
or underperform the overall marketplace satisfaction level.
-----------------------------------------------------------
*/

WITH category_reviews AS (
    SELECT
        p.product_category_name,
        AVG(r.review_score) AS average_review_score
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN reviews r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
),
marketplace_average AS (
    SELECT
        AVG(r.review_score) AS average_marketplace_score
    FROM reviews r
    JOIN orders o
        ON r.order_id = o.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    cr.product_category_name,
    ROUND(cr.average_review_score, 2) AS average_review_score,
    ROUND(ma.average_marketplace_score, 2) AS average_marketplace_score,
    ROUND(
        cr.average_review_score - ma.average_marketplace_score,
        2
    ) AS score_difference
FROM category_reviews cr
CROSS JOIN marketplace_average ma
ORDER BY ABS(score_difference) DESC;

/*
-----------------------------------------------------------
4.7.1 High-Value Orders by Payment Method

Business Question:
Which payment methods are most commonly used for high-value
orders?

Definition:
A high-value order is defined as an order within the top
10% of delivered orders based on total payment value.

Purpose:
Identify which payment methods are most frequently associated
with the marketplace's highest-value orders.
-----------------------------------------------------------
*/

WITH order_payment_totals AS (
    SELECT
        p.order_id,
        SUM(p.payment_value) AS order_value
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.order_id
),

ranked_orders AS (
    SELECT
        order_id,
        order_value,
        NTILE(10) OVER (
            ORDER BY order_value DESC
        ) AS value_decile
    FROM order_payment_totals
),

high_value_orders AS (
    SELECT
        order_id,
        order_value
    FROM ranked_orders
    WHERE value_decile = 1
),

high_value_payment_methods AS (
    SELECT
        p.payment_type,
        COUNT(DISTINCT p.order_id) AS high_value_orders
    FROM payments p
    JOIN high_value_orders h
        ON p.order_id = h.order_id
    GROUP BY p.payment_type
)

SELECT
    payment_type,
    high_value_orders,
    ROUND(
        high_value_orders /
        (SELECT COUNT(*) FROM high_value_orders) * 100,
        2
    ) AS percentage_of_high_value_orders
FROM high_value_payment_methods
ORDER BY high_value_orders DESC;


/*
-----------------------------------------------------------
4.7.2 Payment Method Customer Value

Business Question:
Which payment methods are associated with higher average
customer spending?

Definition:
Customer spending represents the total payment value of
delivered orders associated with each customer.

Purpose:
Compare the average total customer spending among customers
who used each payment method.
-----------------------------------------------------------
*/

WITH customer_payment_method AS (
    SELECT
        c.customer_unique_id,
        p.payment_type,
        SUM(p.payment_value) AS customer_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique_id,
        p.payment_type
)

SELECT
    payment_type,
    COUNT(*) AS customers,
    ROUND(
        AVG(customer_spending),
        2
    ) AS average_customer_spending
FROM customer_payment_method
GROUP BY payment_type
ORDER BY average_customer_spending DESC;


/*
-----------------------------------------------------------
4.7.3 Installment Payment Customers vs Non-Installment
Customers

Business Question:
Do customers who use installment payments generate higher
total spending?

Definition:
Installment customers are customers who used at least one
payment with more than one installment.

Non-installment customers are customers whose payments were
always made using one installment.

Purpose:
Determine whether customers who use installment payments
have higher average total spending than customers who do not.
-----------------------------------------------------------
*/

WITH customer_installment_behavior AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS total_customer_spending,
        MAX(p.payment_installments) AS maximum_installments
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN maximum_installments > 1
            THEN 'Installment Customer'
        ELSE 'Non-Installment Customer'
    END AS customer_payment_type,

    COUNT(*) AS number_of_customers,

    ROUND(
        AVG(total_customer_spending),
        2
    ) AS average_customer_spending

FROM customer_installment_behavior

GROUP BY customer_payment_type

ORDER BY average_customer_spending DESC;