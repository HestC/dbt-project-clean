-- This SQL file calculates Customer Lifetime Value for the DBT pipeline

CREATE VIEW "public"."customer_lifetime_value" AS
    WITH customer_revenue AS (
      SELECT
        customer_id,                     -- Unique identifier for each customer
        COUNT(order_id) AS total_orders, -- Total number of orders placed
        SUM(total_price) AS total_revenue, -- Total amount spent
        AVG(total_price) AS avg_order_value -- Average value of an order
    FROM "public"."stg_sales"          -- Use the staging table stg_sales
    GROUP BY customer_id                 -- Group by customer to calculate metrics
)
SELECT
    customer_id,
    total_orders,
    total_revenue,
    avg_order_value
FROM customer_revenue
ORDER BY total_revenue DESC; -- Sort customers by total revenue

)
