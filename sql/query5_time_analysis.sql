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
