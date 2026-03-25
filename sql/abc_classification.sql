-- Business question:
-- Classify products into A/B/C tiers based on revenue contribution (Pareto principle).

-- Approach:
-- 1. Calculate total revenue per product.
-- 2. Compute cumulative revenue and percent of total revenue using window functions.
-- 3. Assign ABC class: A (top 80%), B (next 15%), C (bottom 5%).
