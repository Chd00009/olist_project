-- Business question:
-- Identify regions where deliveries are consistently faster or slower than estimated.

-- Approach:
-- 1. Join orders -> customers -> geolocation for regional info
-- 2. Compute delivery delay (days actual vs estimated)
-- 3. Aggregate by customer_state and optionally customer_city
-- 4. Rank states by average delay to find consistent over/under-delivery regions

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
        g.geolocation_lng
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
        customer_city,
        DATEDIFF('day', order_estimated_delivery_date, order_delivered_customer_date) AS delivery_delay
    FROM order_locations
),

-- 3:
region_summary AS (
    SELECT
        customer_state,
        customer_city,
        COUNT(*) AS total_orders,
        AVG(delivery_delay) AS avg_delay,
        MIN(delivery_delay) AS min_delay,
        MAX(delivery_delay) AS max_delay
    FROM delivery_times
    GROUP BY customer_state, customer_city
)

-- 4:
SELECT
    customer_state,
    customer_city,
    total_orders,
    ROUND(avg_delay, 2) AS avg_delay,
    min_delay,
    max_delay,
    RANK() OVER (PARTITION BY customer_state ORDER BY avg_delay DESC) AS city_rank_in_state
FROM region_summary
ORDER BY customer_state, city_rank_in_state;
