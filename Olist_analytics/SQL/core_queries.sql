-- Q1: Category Revenue Pareto Analysis
-- Business Question: Which product categories 
-- drive 80% of total revenue?
-- Tables: order_items, orders, products, 
--         category_translation

SELECT
    COALESCE(ct.product_category_name_english, 
             'uncategorized')              AS category,
    COUNT(DISTINCT oi.order_id)            AS total_orders,
    ROUND(SUM(oi.price), 2)               AS total_revenue,
    ROUND(SUM(oi.price) / 
          SUM(SUM(oi.price)) OVER () 
          * 100, 2)                        AS revenue_pct,
    ROUND(SUM(SUM(oi.price)) OVER (
        ORDER BY SUM(oi.price) DESC) / 
        SUM(SUM(oi.price)) OVER () 
        * 100, 2)                          AS cumulative_pct
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct 
    ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 
    ct.product_category_name_english, 
    p.product_category_name
ORDER BY total_revenue DESC;

-- BUSINESS INSIGHT:
-- 18 categories drive 80% of total revenue. The business is heavily
-- concentrated in everyday lifestyle and household products.
-- The bottom 16 categories contribute less than 0.05% each and are
-- largely negligible for revenue strategy.


-- Q2: State-Level Delivery Profitability
-- Business Question: Which Brazilian states are
-- the most and least profitable delivery zones?
-- Tables: order_items, orders, customers

SELECT
    c.customer_state                                AS state,
    COUNT(DISTINCT o.order_id)                      AS total_orders,
    ROUND(SUM(oi.price), 2)                         AS total_revenue,
    ROUND(SUM(oi.freight_value), 2)                 AS total_freight,
    ROUND(SUM(oi.freight_value) /
          SUM(oi.price) * 100, 2)                   AS freight_pct_of_revenue,
    ROUND(SUM(oi.price) -
          SUM(oi.freight_value), 2)                 AS net_revenue,
    ROUND(AVG(oi.freight_value), 2)                 AS avg_freight_per_item
FROM order_items oi
JOIN orders o     
    ON oi.order_id   = o.order_id
JOIN customers c  
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY freight_pct_of_revenue DESC;

-- BUSINESS INSIGHT:
-- SP generates R$4,365,563 in net revenue with the lowest freight 
-- burden at 13.85%, while RR has the highest freight cost at 28.08% 
-- of revenue with only R$5,075 net revenue — delivery economics vary 
-- dramatically across Brazilian regions, with northern states being 
-- significantly less profitable due to high logistics costs.



SELECT COUNT(*) as row_count FROM master_orders_table;


-- Q3: Seller Underperformance Analysis
-- Business Question: Which sellers are 
-- underperforming on both revenue AND 
-- customer satisfaction?
-- Table: master_orders_table

SELECT
    seller_id,
    seller_state,
    COUNT(DISTINCT order_id)              AS total_orders,
    ROUND(SUM(price), 2)                  AS total_revenue,
    ROUND(AVG(review_score), 2)           AS avg_review_score,
    COUNT(CASE WHEN review_score <= 2
               THEN 1 END)                AS bad_reviews
FROM master_orders_table
WHERE order_status = 'delivered'
GROUP BY seller_id, seller_state
HAVING total_orders >= 10
ORDER BY avg_review_score ASC, total_revenue ;
 -- LIMIT 20;
-- BUSINESS INSIGHT:
-- The top 20 underperforming sellers all have average review scores 
-- below 3.0, with the worst scoring 1.93 out of 5. SP dominates 
-- the underperformer list with 11 sellers, suggesting high order 
-- volume does not guarantee customer satisfaction. Sellers with 
-- scores below 2.5 AND high bad review counts should be flagged 
-- for immediate performance review.

-- Q4: Late Delivery Impact on Review Scores
-- Business Question: How does late delivery 
-- impact customer review scores?
-- Table: master_orders_table

SELECT
    delivery_status,
    COUNT(*)                                    AS total_orders,
    ROUND(AVG(review_score), 2)                 AS avg_review_score,
    ROUND(AVG(delivery_delay_days), 1)          AS avg_delay_days,
    COUNT(CASE WHEN review_score <= 2
               THEN 1 END)                      AS bad_reviews,
    ROUND(COUNT(CASE WHEN review_score <= 2
                     THEN 1 END) * 100.0 /
          COUNT(*), 2)                          AS bad_review_pct
FROM master_orders_table
GROUP BY delivery_status
ORDER BY avg_review_score ASC;
-- BUSINESS INSIGHT:
-- Delivery status has a dramatic impact on customer satisfaction.
-- On-time deliveries average a 4.21 review score with only 11.44% 
-- bad reviews, while late deliveries drop to 2.25 with 61.44% bad 
-- reviews. Undelivered orders are the worst at 1.76 with 74.27% bad 
-- reviews. This confirms that logistics performance is the single 
-- biggest driver of customer dissatisfaction on the platform.