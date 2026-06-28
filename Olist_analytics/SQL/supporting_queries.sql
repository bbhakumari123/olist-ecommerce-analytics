-- Q5: Payment Methods vs Order Value
-- Business Question: Which payment methods 
-- correlate with higher order values?
-- Table: master_orders_table

SELECT
    payment_type,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(AVG(payment_value), 2)                AS avg_order_value,
    ROUND(SUM(payment_value), 2)                AS total_revenue,
    ROUND(MIN(payment_value), 2)                AS min_order_value,
    ROUND(MAX(payment_value), 2)                AS max_order_value
FROM master_orders_table
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY avg_order_value DESC;
-- BUSINESS INSIGHT:
-- Credit card is the dominant payment method with 75,991 orders 
-- and highest average order value at R$179.58, followed closely 
-- by boleto at R$177.41. Vouchers have the lowest average order 
-- value at R$64.62, suggesting they are used primarily for small 
-- or discounted purchases. Credit card drives 79% of total 
-- platform revenue.


-- Q6: Freight Cost as % of Revenue by Category
-- Business Question: Which categories have the 
-- highest freight burden relative to revenue?
-- Table: master_orders_table

SELECT
    category_english                            AS category,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(price), 2)                        AS total_revenue,
    ROUND(SUM(freight_value), 2)                AS total_freight,
    ROUND(SUM(freight_value) / 
          SUM(price) * 100, 2)                  AS freight_pct_of_revenue,
    ROUND(AVG(freight_value), 2)                AS avg_freight_per_item
FROM master_orders_table
WHERE order_status = 'delivered'
AND category_english IS NOT NULL
GROUP BY category_english
ORDER BY freight_pct_of_revenue DESC
LIMIT 20;
-- BUSINESS INSIGHT:
-- Furniture and home categories carry the highest freight burden,
-- with home_comfort_2 at 54.49% and flowers at 44.04% freight 
-- as % of revenue. These categories are likely unprofitable after 
-- logistics costs. Electronics sits at 29.1% despite high revenue 
-- volume — a significant margin risk. High revenue categories like 
-- health_beauty and watches_gifts likely have much lower freight 
-- burden, making them the most profitable categories end-to-end.


-- Q7: Monthly Revenue Trend
-- Business Question: What is the revenue 
-- trend over time?
-- Table: master_orders_table

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')  AS order_month,
    COUNT(DISTINCT order_id)                         AS total_orders,
    ROUND(SUM(price), 2)                             AS total_revenue,
    ROUND(AVG(price), 2)                             AS avg_order_value
FROM master_orders_table
WHERE order_status = 'delivered'
AND order_purchase_timestamp IS NOT NULL
GROUP BY order_month
ORDER BY order_month ASC;
-- BUSINESS INSIGHT:
-- Revenue grew consistently from R$41K in October 2016 to over 
-- R$1M per month by November 2017 -- a 25x increase in 13 months. 
-- Growth stabilized at R$900K-R$1M per month through 2018, 
-- suggesting the platform reached maturity. November 2017 shows 
-- a clear spike to R$1.03M likely driven by Black Friday promotions.


-- Q8: Order Status Breakdown
-- Business Question: What is the full picture 
-- of order outcomes on the platform?
-- Table: master_orders_table

SELECT
    order_status,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / 
          SUM(COUNT(DISTINCT order_id)) 
          OVER(), 2)                             AS pct_of_total
FROM master_orders_table
GROUP BY order_status
ORDER BY total_orders DESC;
-- BUSINESS INSIGHT:
-- 97.78% of orders are successfully delivered, indicating a healthy 
-- fulfillment operation. However the remaining 2.22% -- representing 
-- over 2,000 orders -- are cancelled, stuck in processing, or 
-- unavailable, representing direct revenue loss and potential 
-- customer dissatisfaction that warrants operational attention.


-- Q9: Average Delivery Time by State
-- Business Question: Which states have the 
-- longest and shortest delivery times?
-- Table: master_orders_table

SELECT
    customer_state                               AS state,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(AVG(DATEDIFF(
        order_delivered_customer_date,
        order_purchase_timestamp)), 1)           AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(
        order_estimated_delivery_date,
        order_purchase_timestamp)), 1)           AS avg_estimated_days,
    ROUND(AVG(delivery_delay_days), 1)           AS avg_delay_days
FROM master_orders_table
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
ORDER BY avg_delivery_days DESC;
-- BUSINESS INSIGHT:
-- Delivery time varies dramatically by geography. SP receives orders 
-- in just 8.7 days on average while RR and AP in the far north wait 
-- 28+ days -- a 3x difference driven by distance from São Paulo where 
-- most sellers are concentrated. Notably all states show negative 
-- avg_delay_days meaning deliveries consistently arrive earlier than 
-- estimated -- suggesting Olist deliberately sets conservative 
-- delivery estimates to manage customer expectations.


-- Q10: Top Cities by Order Volume
-- Business Question: Which cities generate 
-- the most orders on the platform?
-- Table: master_orders_table

SELECT
    customer_city                                AS city,
    customer_state                               AS state,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(SUM(price), 2)                         AS total_revenue,
    ROUND(AVG(price), 2)                         AS avg_order_value
FROM master_orders_table
WHERE order_status = 'delivered'
GROUP BY customer_city, customer_state
ORDER BY total_orders DESC
LIMIT 15;
-- BUSINESS INSIGHT:
-- São Paulo alone generates 15,045 orders -- more than double 
-- second-place Rio de Janeiro at 6,601. The top 15 cities are 
-- all major urban centers, with SP state commanding 8 of the 
-- 15 spots. This geographic concentration suggests marketing 
-- and logistics investment should prioritize SP state for 
-- maximum revenue impact.


-- Q11: Review Score Distribution
-- Business Question: What is the overall 
-- customer satisfaction picture?
-- Table: master_orders_table

SELECT
    review_score,
    COUNT(*)                                     AS total_reviews,
    ROUND(COUNT(*) * 100.0 / 
          SUM(COUNT(*)) OVER(), 2)               AS pct_of_total
FROM master_orders_table
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score DESC;
-- BUSINESS INSIGHT:
-- Customer satisfaction is strongly polarized. 56.48% of customers 
-- give a 5-star review while 12.66% give 1-star -- the second largest 
-- group. The middle scores (2, 3, 4) are relatively small, suggesting 
-- customers either love or hate their experience. This bimodal pattern 
-- points directly back to Q4 -- delivery performance is likely the 
-- primary driver splitting customers into these two camps.


-- Q12: Average Basket Size by Payment Method
-- Business Question: Do customers spending 
-- more use different payment methods?
-- Table: master_orders_table

SELECT
    payment_type,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(AVG(price), 2)                         AS avg_item_price,
    ROUND(SUM(price) / 
          COUNT(DISTINCT order_id), 2)           AS avg_basket_size,
    ROUND(MAX(price), 2)                         AS max_item_price
FROM master_orders_table
WHERE payment_type IS NOT NULL
AND order_status = 'delivered'
GROUP BY payment_type
ORDER BY avg_basket_size DESC;
-- BUSINESS INSIGHT:
-- Voucher users have the highest average basket size at R$173.55 
-- despite the lowest average item price at R$103.30 -- suggesting 
-- voucher users add more items per order to maximize their discount. 
-- Credit card leads in average item price at R$125.52 and dominates 
-- volume with 74,304 orders. Debit card has the lowest basket size 
-- at R$120.26 suggesting debit users are more budget conscious.