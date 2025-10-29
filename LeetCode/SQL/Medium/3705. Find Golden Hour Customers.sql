-- Table: restaurant_orders

-- +------------------+----------+
-- | Column Name      | Type     | 
-- +------------------+----------+
-- | order_id         | int      |
-- | customer_id      | int      |
-- | order_timestamp  | datetime |
-- | order_amount     | decimal  |
-- | payment_method   | varchar  |
-- | order_rating     | int      |
-- +------------------+----------+
-- order_id is the unique identifier for this table.
-- payment_method can be cash, card, or app.
-- order_rating is between 1 and 5, where 5 is the best (NULL if not rated).
-- order_timestamp contains both date and time information.

-- Write a solution to find golden hour customers - customers who consistently order during peak hours and provide high satisfaction. A customer is a golden hour customer if they meet ALL the following criteria:

--     Made at least 3 orders.
--     At least 60% of their orders are during peak hours (11:00-14:00 or 18:00-21:00).
--     Their average rating for rated orders is at least 4.0, round it to 2 decimal places.
--     Have rated at least 50% of their orders.

-- Return the result table ordered by average_rating in descending order, then by customer_id​​​​​​​ in descending order.

-- Write your PostgreSQL query statement below
SELECT customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(
        CASE 
            WHEN (order_hour >= 11 AND order_hour < 14) OR (order_hour = 14 AND order_minute = 0) THEN 1
            WHEN (order_hour >= 18 AND order_hour < 21) OR (order_hour = 21 AND order_minute = 0) THEN 1
            ELSE 0
        END
    )::NUMERIC / COUNT(*) * 100, 0) AS peak_hour_percentage,
    ROUND(AVG(order_rating), 2) AS average_rating
FROM (
    SELECT customer_id,
        order_id,
        EXTRACT(HOUR FROM order_timestamp) AS order_hour,
        EXTRACT(MINUTE FROM order_timestamp) AS order_minute,
        order_rating
    FROM restaurant_orders
) t
GROUP BY customer_id
HAVING COUNT(order_rating)::NUMERIC / COUNT(*) >= 0.5
    AND ROUND(AVG(order_rating), 2) >= 4.0
    AND ROUND(SUM(
        CASE 
            WHEN (order_hour >= 11 AND order_hour < 14) OR (order_hour = 14 AND order_minute = 0) THEN 1
            WHEN (order_hour >= 18 AND order_hour < 21) OR (order_hour = 21 AND order_minute = 0) THEN 1
            ELSE 0
        END
    )::NUMERIC / COUNT(*) * 100, 0) >= 60
    AND COUNT(*) >= 3
ORDER BY average_rating DESC, customer_id DESC;
