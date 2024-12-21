
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM {{ ref('stg_sales') }}
    GROUP BY customer_id
),
order_intervals AS (
    SELECT
        customer_id,
        (order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
    FROM {{ ref('stg_sales') }}
),
average_intervals AS (
    SELECT
        customer_id,
        AVG(days_between_orders) AS avg_days_between_orders
    FROM order_intervals
    WHERE days_between_orders IS NOT NULL
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.total_orders,
    c.first_order,
    c.last_order,
    a.avg_days_between_orders
FROM customer_orders c
LEFT JOIN average_intervals a
    ON c.customer_id = a.customer_id
ORDER BY c.customer_id
