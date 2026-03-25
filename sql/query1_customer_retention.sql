-- Business Question:
-- Which customer cohorts retain the most over 30, 60, and 90 days after their first purchase?

-- Approach:
-- 1. Identify each customer's first purchase date.
-- 2. For each subsequent order, calculate days since the first purchase.
-- 3. Aggregate by cohort (first purchase month) and calculate the % of customers 
--    who placed a second order within 30, 60, and 90 days.
-- 4. Use multiple CTEs to build intermediate tables for clarity and maintainability.

-- CTE 1: First purchase per customer
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_order_date,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),

-- CTE 2: Subsequent orders with days since first purchase
subsequent_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        fp.first_order_date,
        fp.cohort_month,
        DATEDIFF('day', fp.first_order_date, o.order_purchase_timestamp) AS days_since_first
    FROM orders o
    JOIN first_purchase fp
      ON o.customer_id = fp.customer_id
    WHERE o.order_purchase_timestamp > fp.first_order_date
),

-- CTE 3: Count of customers who reordered within 30/60/90 days
retention_counts AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT CASE WHEN days_since_first <= 30 THEN customer_id END) AS day_30,
        COUNT(DISTINCT CASE WHEN days_since_first <= 60 THEN customer_id END) AS day_60,
        COUNT(DISTINCT CASE WHEN days_since_first <= 90 THEN customer_id END) AS day_90,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM subsequent_orders
    GROUP BY cohort_month
)

-- Final SELECT – calculate retention rates
SELECT
    cohort_month,
    cohort_size,
    ROUND(100.0 * day_30 / cohort_size, 2) AS retention_30_day_pct,
    ROUND(100.0 * day_60 / cohort_size, 2) AS retention_60_day_pct,
    ROUND(100.0 * day_90 / cohort_size, 2) AS retention_90_day_pct
FROM retention_counts
ORDER BY cohort_month;
