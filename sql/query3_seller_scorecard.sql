-- Business question: 
-- Which states consistently receive orders faster or slower than estimated delivery times?

-- Approach: 
-- 1. Join orders → customers → geolocation for regional info.
-- 2. Calculate delivery delays per order.
-- 3. Aggregate delays per state and rank states by average delay.
