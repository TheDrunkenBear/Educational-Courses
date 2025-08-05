-- Table: Employees

-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | employee_id | int      |
-- | name        | varchar  |
-- | reports_to  | int      |
-- | age         | int      |
-- +-------------+----------+
-- employee_id is the column with unique values for this table.
-- This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
 

-- For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

-- Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

-- Return the result table ordered by employee_id.

-- Write your PostgreSQL query statement below
SELECT Employees.reports_to AS employee_id,
    EmployeesManager."name",
    COUNT(*) AS reports_count,
    ROUND(AVG(Employees.age)::NUMERIC) AS average_age
FROM Employees
JOIN (
    SELECT employee_id AS reports_to, "name"
    FROM Employees
) EmployeesManager USING(reports_to)
WHERE Employees.reports_to IS NOT NULL
GROUP BY Employees.reports_to, EmployeesManager."name"
ORDER BY employee_id;
