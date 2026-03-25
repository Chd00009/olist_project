-- Business Question:
-- Which customer cohorts retain the most over 30, 60, and 90 days after their first purchase?

-- Approach:
-- 1. Identify each customer's first purchase date.
-- 2. For each subsequent order, calculate days since the first purchase.
-- 3. Aggregate by cohort (first purchase month) and calculate the % of customers 
--    who placed a second order within 30, 60, and 90 days.
-- 4. Use multiple CTEs to build intermediate tables for clarity and maintainability.

-- 1:
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_order_date,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
