

WITH customer_revenue AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_price) AS total_revenue
    FROM {{ ref('stg_sales') }}
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM customer_revenue
)
SELECT
    customer_id,
    total_orders,
    total_revenue
FROM ranked_customers
WHERE revenue_rank <= 10
ORDER BY total_revenue DESC
