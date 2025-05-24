-- Table Activities:

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | sell_date   | date    |
-- | product     | varchar |
-- +-------------+---------+
-- There is no primary key (column with unique values) for this table. It may contain duplicates.
-- Each row of this table contains the product name and the date it was sold in a market.
 

-- Write a solution to find for each date the number of different products sold and their names.

-- The sold products names for each date should be sorted lexicographically.

-- Return the result table ordered by sell_date.

-- Write your PostgreSQL query statement below
SELECT a.sell_date
    ,COUNT(DISTINCT a.product) AS num_sold
    ,STRING_AGG(DISTINCT a.product, ',' ORDER BY a.product ASC) AS products
FROM Activities a
GROUP BY a.sell_date
ORDER BY a.sell_date ASC;