-- Business question:
-- Identify regions where deliveries are consistently faster or slower than estimated.

-- Approach:
-- 1. Join orders -> customers -> geolocation for regional info
-- 2. Compute delivery delay (days actual vs estimated)
-- 3. Aggregate by customer_state and optionally customer_city
-- 4. Rank states by average delay to find consistent over/under-delivery regions
