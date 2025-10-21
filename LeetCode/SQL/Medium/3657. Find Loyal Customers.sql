-- Table: customer_transactions

-- +------------------+---------+
-- | Column Name      | Type    | 
-- +------------------+---------+
-- | transaction_id   | int     |
-- | customer_id      | int     |
-- | transaction_date | date    |
-- | amount           | decimal |
-- | transaction_type | varchar |
-- +------------------+---------+
-- transaction_id is the unique identifier for this table.
-- transaction_type can be either 'purchase' or 'refund'.
-- Write a solution to find loyal customers. A customer is considered loyal if they meet ALL the following criteria:

-- Made at least 3 purchase transactions.
-- Have been active for at least 30 days.
-- Their refund rate is less than 20% .
-- Refund rate is the proportion of transactions that are refunds, calculated as the number of refund transactions divided by the total number of transactions (purchases plus refunds).

-- Return the result table ordered by customer_id in ascending order.

-- Write your PostgreSQL query statement below
SELECT customer_id
FROM (
    SELECT customer_id,
        COUNT(*) AS number_of_purchases,
        MIN(transaction_date) AS min_transaction_date,
        MAX(transaction_date) AS max_transaction_date,
        SUM(
            CASE transaction_type
                WHEN 'refund' THEN 1
                ELSE 0
            END
        ) AS number_of_refunds
    FROM customer_transactions
    GROUP BY customer_id
) t
WHERE max_transaction_date - min_transaction_date >= 30
    AND number_of_refunds::NUMERIC / number_of_purchases::NUMERIC < 0.2
    AND number_of_purchases >= 3
ORDER BY customer_id ASC;
