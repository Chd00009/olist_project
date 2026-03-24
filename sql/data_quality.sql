-- Section A: Row Counts
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

-- Section B: NULL Rate for Key Columns
WITH null_rates AS (
    SELECT 'orders' AS table_name, 'customer_id' AS column_name,
           COUNT(*) FILTER (WHERE customer_id IS NULL) * 1.0 / COUNT(*) AS null_rate
    FROM orders
    UNION ALL
    SELECT 'orders', 'order_id',
           COUNT(*) FILTER (WHERE order_id IS NULL) * 1.0 / COUNT(*) FROM orders
    UNION ALL
    SELECT 'order_items', 'product_id',
           COUNT(*) FILTER (WHERE product_id IS NULL) * 1.0 / COUNT(*) FROM order_items
)
SELECT * FROM null_rates;

-- Section C: Orphaned Foreign Keys
WITH orphan_orders AS (
    SELECT COUNT(*) AS orphan_count
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
),
orphan_order_items AS (
    SELECT COUNT(*) AS orphan_count
    FROM order_items oi
    LEFT JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL
),
orphan_payments AS (
    SELECT COUNT(*) AS orphan_count
    FROM order_payments op
    LEFT JOIN orders o ON op.order_id = o.order_id
    WHERE o.order_id IS NULL
)
SELECT * FROM orphan_orders
UNION ALL
SELECT * FROM orphan_order_items
UNION ALL
SELECT * FROM orphan_payments;

-- Section D: Date Coverage
WITH order_dates AS (
    SELECT MIN(order_purchase_timestamp) AS min_date,
           MAX(order_purchase_timestamp) AS max_date
    FROM orders
)
SELECT * FROM order_dates;

-- Section E: Duplicates
WITH duplicate_customers AS (
    SELECT customer_id, COUNT(*) AS cnt
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
SELECT * FROM duplicate_customers;
