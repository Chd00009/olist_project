-- Business question: 
-- Which states consistently receive orders faster or slower than estimated delivery times?

-- Approach: 
-- 1. Join orders → customers → geolocation for regional info.
-- 2. Calculate delivery delays per order.
-- 3. Aggregate delays per state and rank states by average delay.

-- 1:
WITH order_locations AS (
    SELECT
        o.order_id,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        c.customer_id,
        c.customer_city,
        c.customer_state,
        g.geolocation_lat,
        g.geolocation_lng,
        g.geolocation_city,
        g.geolocation_state
    FROM orders o
    JOIN customers c USING(customer_id)
    LEFT JOIN geolocation g
           ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
    WHERE o.order_delivered_customer_date IS NOT NULL
),
-- 2:
delivery_times AS (
    SELECT
        order_id,
        customer_state,
        DATEDIFF(
            'day',
            order_estimated_delivery_date,
            order_delivered_customer_date
        ) AS delivery_delay
    FROM order_locations
),
-- 3:
region_summary AS (
    SELECT
        customer_state,
        COUNT(*) AS total_orders,
        AVG(delivery_delay) AS avg_delay,
        MIN(delivery_delay) AS min_delay,
        MAX(delivery_delay) AS max_delay
    FROM delivery_times
    GROUP BY customer_state
)
-- 4: Rank states by average delay:
SELECT
    customer_state,
    total_orders,
    ROUND(avg_delay, 2) AS avg_delay,
    min_delay,
    max_delay,
    RANK() OVER (ORDER BY avg_delay DESC) AS state_rank
FROM region_summary
ORDER BY state_rank;
