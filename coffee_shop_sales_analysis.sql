
-- 1. Overall dataset summary
SELECT
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / COUNT(*), 2) AS average_transaction_value
FROM transactions;


-- 2. Performance by store
SELECT
    store_location,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY store_location
ORDER BY revenue DESC;


-- 3. Monthly sales trend
SELECT
    month_number,
    month,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY month_number, month
ORDER BY month_number;


-- 4. Sales by hour
SELECT
    hour,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY hour
ORDER BY hour;


-- 5. Revenue by product category
SELECT
    product_category,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY product_category
ORDER BY revenue DESC;


-- 6. Sales by day of week
SELECT
    weekday_number,
    day_of_week,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY weekday_number, day_of_week
ORDER BY weekday_number;


-- 7. Top 10 product types by revenue
SELECT
    product_category,
    product_type,
    SUM(transaction_qty) AS items_sold,
    ROUND(SUM(revenue), 2) AS revenue
FROM transactions
GROUP BY product_category, product_type
ORDER BY revenue DESC
LIMIT 10;


-- 8. Highest-revenue hour at each store
WITH hourly_sales AS (
    SELECT
        store_location,
        hour,
        ROUND(SUM(revenue), 2) AS revenue
    FROM transactions
    GROUP BY store_location, hour
),
ranked_hours AS (
    SELECT
        store_location,
        hour,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM hourly_sales
)
SELECT
    store_location,
    hour AS highest_revenue_hour,
    revenue
FROM ranked_hours
WHERE revenue_rank = 1
ORDER BY revenue DESC;
