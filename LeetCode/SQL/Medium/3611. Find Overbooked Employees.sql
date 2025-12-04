-- Table: employees

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | department    | varchar |
-- +---------------+---------+
-- employee_id is the unique identifier for this table.
-- Each row contains information about an employee and their department.

-- Table: meetings

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | meeting_id    | int     |
-- | employee_id   | int     |
-- | meeting_date  | date    |
-- | meeting_type  | varchar |
-- | duration_hours| decimal |
-- +---------------+---------+
-- meeting_id is the unique identifier for this table.
-- Each row represents a meeting attended by an employee. meeting_type can be 'Team', 'Client', or 'Training'.

-- Write a solution to find employees who are meeting-heavy - employees who spend more than 50% of their working time in meetings during any given week.

--     Assume a standard work week is 40 hours
--     Calculate total meeting hours per employee per week (Monday to Sunday)
--     An employee is meeting-heavy if their weekly meeting hours > 20 hours (50% of 40 hours)
--     Count how many weeks each employee was meeting-heavy
--     Only include employees who were meeting-heavy for at least 2 weeks

-- Return the result table ordered by the number of meeting-heavy weeks in descending order, then by employee name in ascending order.

-- Write your PostgreSQL query statement below
WITH employees_over20h_for_week AS (
    SELECT employee_id,
        DATE_TRUNC('week', meeting_date)::DATE AS meeting_week_date,
        SUM(duration_hours) AS total_meeting_hours
    FROM meetings
    GROUP BY employee_id, DATE_TRUNC('week', meeting_date)::DATE
    HAVING SUM(duration_hours) > 20
),
employees_over20h_for_2weeks_more AS (
    SELECT employee_id, COUNT(*) AS meeting_heavy_weeks
    FROM employees_over20h_for_week
    GROUP BY employee_id
    HAVING COUNT(*) >= 2
)
SELECT emp.employee_id, emp.employee_name, emp.department, emp_filter.meeting_heavy_weeks
FROM employees_over20h_for_2weeks_more emp_filter
JOIN employees emp USING (employee_id)
ORDER BY emp_filter.meeting_heavy_weeks DESC, emp.employee_name ASC;
