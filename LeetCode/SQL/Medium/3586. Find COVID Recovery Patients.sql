-- Table: patients

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | patient_id  | int     |
-- | patient_name| varchar |
-- | age         | int     |
-- +-------------+---------+
-- patient_id is the unique identifier for this table.
-- Each row contains information about a patient.
-- Table: covid_tests

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | test_id     | int     |
-- | patient_id  | int     |
-- | test_date   | date    |
-- | result      | varchar |
-- +-------------+---------+
-- test_id is the unique identifier for this table.
-- Each row represents a COVID test result. The result can be Positive, Negative, or Inconclusive.
-- Write a solution to find patients who have recovered from COVID - patients who tested positive but later tested negative.

-- A patient is considered recovered if they have at least one Positive test followed by at least one Negative test on a later date
-- Calculate the recovery time in days as the difference between the first positive test and the first negative test after that positive test
-- Only include patients who have both positive and negative test results
-- Return the result table ordered by recovery_time in ascending order, then by patient_name in ascending order.

WITH first_positive_tests AS (
    SELECT patient_id, MIN(test_date) AS first_positive_test_date
    FROM covid_tests
    WHERE 1=1
        AND result = 'Positive'
    GROUP BY patient_id
),
first_negative_after_first_positive AS (
    SELECT ct.patient_id, MIN(ct.test_date) AS first_negative_test_date_after_first_positive
    FROM covid_tests ct
    JOIN first_positive_tests fpt USING (patient_id)
    WHERE 1=1
        AND ct.result = 'Negative'
        AND ct.test_date > fpt.first_positive_test_date
    GROUP BY ct.patient_id
)
SELECT p.*, (first_negative_test_date_after_first_positive - first_positive_test_date) AS recovery_time
FROM patients p
JOIN first_positive_tests fpt USING (patient_id)
JOIN first_negative_after_first_positive fnafp USING (patient_id)
ORDER BY recovery_time ASC, p.patient_name ASC;
