-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.

-- Initially, all products have price 10.

-- Write a solution to find the prices of all products on the date 2019-08-16.

-- Return the result table in any order.

-- Write your PostgreSQL query statement below
WITH unique_products AS (
    SELECT DISTINCT product_id
    FROM Products
),
prices_to_2019_08_16 AS (
    SELECT product_id,
        new_price,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS rn
    FROM Products
    WHERE change_date <= '2019-08-16'
)
SELECT up.*, COALESCE(new_price, 10) AS price
FROM unique_products up
LEFT JOIN prices_to_2019_08_16 ON up.product_id = prices_to_2019_08_16.product_id AND rn = 1;
