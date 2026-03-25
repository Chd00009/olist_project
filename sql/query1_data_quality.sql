-- Business Question:
-- How reliable and complete is the Olist dataset, and are there any anomalies 
-- (missing values, orphaned foreign keys, duplicates, or gaps in date coverage) 
-- that could affect downstream analysis?

-- Approach:
-- 1. Row Counts
-- 2. NULL Rate for Key Columns
-- 3. Orphaned Foreign Keys
-- 4. Date Coverage
-- 5. Duplicates

-- 1:
WITH row_counts AS (
    SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
    UNION ALL
    SELECT 'order_items', COUNT(*) FROM order_items
    UNION ALL
    SELECT 'order_payments', COUNT(*) FROM order_payments
    UNION ALL
    SELECT 'order_reviews', COUNT(*) FROM order_reviews
    UNION ALL
    SELECT 'customers', COUNT(*) FROM customers
    UNION ALL
    SELECT 'sellers', COUNT(*) FROM sellers
    UNION ALL
    SELECT 'products', COUNT(*) FROM products
    UNION ALL
    SELECT 'category_translation', COUNT(*) FROM category_translation
    UNION ALL
    SELECT 'geolocation', COUNT(*) FROM geolocation
)
SELECT * FROM row_counts;
