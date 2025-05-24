-- Table: Department

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | revenue     | int     |
-- | month       | varchar |
-- +-------------+---------+
-- In SQL,(id, month) is the primary key of this table.
-- The table has information about the revenue of each department per month.
-- The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].
 

-- Reformat the table such that there is a department id column and a revenue column for each month.

-- Return the result table in any order.

-- Write your PostgreSQL query statement below
SELECT dep.id
    ,SUM((CASE WHEN dep.month = 'Jan' THEN dep.revenue END)) AS "Jan_Revenue"
    ,SUM((CASE WHEN dep.month = 'Feb' THEN dep.revenue END)) AS "Feb_Revenue"
    ,SUM((CASE WHEN dep.month = 'Mar' THEN dep.revenue END)) AS "Mar_Revenue"
    ,SUM((CASE WHEN dep.month = 'Apr' THEN dep.revenue END)) AS "Apr_Revenue"
    ,SUM((CASE WHEN dep.month = 'May' THEN dep.revenue END)) AS "May_Revenue"
    ,SUM((CASE WHEN dep.month = 'Jun' THEN dep.revenue END)) AS "Jun_Revenue"
    ,SUM((CASE WHEN dep.month = 'Jul' THEN dep.revenue END)) AS "Jul_Revenue"
    ,SUM((CASE WHEN dep.month = 'Aug' THEN dep.revenue END)) AS "Aug_Revenue"
    ,SUM((CASE WHEN dep.month = 'Sep' THEN dep.revenue END)) AS "Sep_Revenue"
    ,SUM((CASE WHEN dep.month = 'Oct' THEN dep.revenue END)) AS "Oct_Revenue"
    ,SUM((CASE WHEN dep.month = 'Nov' THEN dep.revenue END)) AS "Nov_Revenue"
    ,SUM((CASE WHEN dep.month = 'Dec' THEN dep.revenue END)) AS "Dec_Revenue"
FROM Department dep
GROUP BY dep.id;