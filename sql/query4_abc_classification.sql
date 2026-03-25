-- Business question:
-- Classify products into A/B/C tiers based on revenue contribution (Pareto principle).

-- Approach:
-- 1. Calculate total revenue per product.
-- 2. Compute cumulative revenue and percent of total revenue using window functions.
-- 3. Assign ABC class: A (top 80%), B (next 15%), C (bottom 5%).

-- 1:
WITH product_revenue AS (
    SELECT
        oi.product_id,
        p.product_category_name,
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    JOIN products p USING(product_id)
    GROUP BY oi.product_id, p.product_category_name
),

-- 2:
revenue_cumsum AS (
    SELECT
        product_id,
        product_category_name,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC ROWS UNBOUNDED PRECEDING) AS cum_revenue,
        SUM(total_revenue) OVER () AS total_revenue_all,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC ROWS UNBOUNDED PRECEDING) * 1.0 / SUM(total_revenue) OVER () AS cum_revenue_pct
    FROM product_revenue
),

-- 3:
product_classification AS (
    SELECT
        product_id,
        product_category_name,
        total_revenue,
        cum_revenue,
        ROUND(cum_revenue_pct * 100, 2) AS cum_revenue_pct,
        CASE
            WHEN cum_revenue_pct <= 0.8 THEN 'A'
            WHEN cum_revenue_pct <= 0.95 THEN 'B'
            ELSE 'C'
        END AS abc_class
    FROM revenue_cumsum
)
-- 4: Final Select
SELECT *
FROM product_classification
ORDER BY abc_class, cum_revenue_pct DESC;
