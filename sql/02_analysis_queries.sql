-- Business analysis queries (MySQL 8+)

-- 1. Monthly revenue and order count
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.net_revenue),2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 2. Revenue and gross profit by category
SELECT p.category,
       ROUND(SUM(oi.net_revenue),2) AS revenue,
       ROUND(SUM(oi.net_revenue - oi.estimated_cost),2) AS gross_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 3. Average order value by customer segment
WITH order_totals AS (
    SELECT o.order_id, o.customer_id, SUM(oi.net_revenue) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id
)
SELECT c.segment,
       ROUND(AVG(ot.order_value),2) AS avg_order_value
FROM order_totals ot
JOIN customers c ON ot.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY avg_order_value DESC;

-- 4. Late-delivery rate
SELECT delivery_status,
       COUNT(*) AS orders,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS pct_orders
FROM orders
GROUP BY delivery_status;

-- 5. Review score by delivery status
SELECT o.delivery_status,
       ROUND(AVG(r.review_score),2) AS avg_review_score,
       COUNT(*) AS reviewed_orders
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
GROUP BY o.delivery_status;

-- 6. Top 10 products by revenue
SELECT p.product_name, p.category,
       ROUND(SUM(oi.net_revenue),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- 7. Repeat customers
SELECT
    SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    COUNT(*) AS purchasing_customers,
    ROUND(SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS repeat_rate_pct
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x;

-- 8. Customer ranking by lifetime revenue
WITH customer_revenue AS (
    SELECT o.customer_id, SUM(oi.net_revenue) AS lifetime_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, ROUND(lifetime_revenue,2) AS lifetime_revenue,
       DENSE_RANK() OVER (ORDER BY lifetime_revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank
LIMIT 25;

-- 9. Channel performance
SELECT o.channel,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.net_revenue),2) AS revenue,
       ROUND(SUM(oi.net_revenue) / COUNT(DISTINCT o.order_id),2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.channel;

-- 10. Discount impact
SELECT
    CASE
        WHEN oi.discount_rate = 0 THEN 'No discount'
        WHEN oi.discount_rate <= 0.05 THEN '1-5%'
        WHEN oi.discount_rate <= 0.10 THEN '6-10%'
        WHEN oi.discount_rate <= 0.15 THEN '11-15%'
        ELSE '16-20%'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(AVG(oi.net_revenue),2) AS avg_line_revenue
FROM order_items oi
GROUP BY discount_band
ORDER BY MIN(oi.discount_rate);