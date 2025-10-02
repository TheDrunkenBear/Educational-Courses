-- Table: Logs

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | num         | varchar |
-- +-------------+---------+
-- In SQL, id is the primary key for this table.
-- id is an autoincrement column starting from 1.
 

-- Find all numbers that appear at least three times consecutively.

-- Return the result table in any order.

-- Write your PostgreSQL query statement below
WITH digit_counts AS (
    SELECT l.*, ROW_NUMBER() OVER (ORDER BY l.id) - ROW_NUMBER() OVER (PARTITION BY l.num ORDER BY l.id) AS grp
    FROM logs l
)
SELECT DISTINCT dc.num AS "ConsecutiveNums"
FROM digit_counts dc
GROUP BY dc.num, dc.grp
HAVING COUNT(*) >= 3;
