-- Table: Activity

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | machine_id     | int     |
-- | process_id     | int     |
-- | activity_type  | enum    |
-- | timestamp      | float   |
-- +----------------+---------+
-- The table shows the user activities for a factory website.
-- (machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
-- machine_id is the ID of a machine.
-- process_id is the ID of a process running on the machine with ID machine_id.
-- activity_type is an ENUM (category) of type ('start', 'end').
-- timestamp is a float representing the current time in seconds.
-- 'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
-- The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
-- It is guaranteed that each (machine_id, process_id) pair has a 'start' and 'end' timestamp.
 

-- There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

-- The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

-- The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

-- Return the result table in any order.

-- Write your PostgreSQL query statement below
SELECT activity_start.machine_id,
    ROUND(AVG(timestamp_end - timestamp_start)::NUMERIC, 3) AS processing_time
FROM (
    SELECT machine_id,
        process_id,
        timestamp AS timestamp_start
    FROM Activity
    WHERE activity_type = 'start'
) activity_start
JOIN (
    SELECT machine_id,
        process_id,
        timestamp AS timestamp_end
    FROM Activity
    WHERE activity_type = 'end'
) activity_end USING(machine_id, process_id)
GROUP BY activity_start.machine_id;
