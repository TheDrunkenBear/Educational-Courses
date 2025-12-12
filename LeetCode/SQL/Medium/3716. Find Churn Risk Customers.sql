-- Table: subscription_events

-- +------------------+---------+
-- | Column Name      | Type    | 
-- +------------------+---------+
-- | event_id         | int     |
-- | user_id          | int     |
-- | event_date       | date    |
-- | event_type       | varchar |
-- | plan_name        | varchar |
-- | monthly_amount   | decimal |
-- +------------------+---------+
-- event_id is the unique identifier for this table.
-- event_type can be start, upgrade, downgrade, or cancel.
-- plan_name can be basic, standard, premium, or NULL (when event_type is cancel).
-- monthly_amount represents the monthly subscription cost after this event.
-- For cancel events, monthly_amount is 0.

-- Write a solution to Find Churn Risk Customers - users who show warning signs before churning. A user is considered churn risk customer if they meet ALL the following criteria:

--     Currently have an active subscription (their last event is not cancel).
--     Have performed at least one downgrade in their subscription history.
--     Their current plan revenue is less than 50% of their historical maximum plan revenue.
--     Have been a subscriber for at least 60 days.

-- Return the result table ordered by days_as_subscriber in descending order, then by user_id in ascending order.

-- Write your PostgreSQL query statement below
WITH ranked_events AS (
    SELECT user_id,
        event_type,
        plan_name,
        monthly_amount,
        event_date,
        MAX(monthly_amount) OVER (PARTITION BY user_id) AS max_monthly_amount,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date DESC) AS rn
    FROM subscription_events
),
start_subscriptions AS (
    SELECT user_id,
        event_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date DESC) AS rn
    FROM subscription_events
    WHERE event_type = 'start'
)
SELECT re.user_id,
    re.plan_name AS current_plan,
    re.monthly_amount AS current_monthly_amount,
    re.max_monthly_amount AS max_historical_amount,
    re.event_date - ss.event_date AS days_as_subscriber
FROM ranked_events re
JOIN start_subscriptions ss USING (user_id)
WHERE 1=1
    AND re.rn = 1
    AND re.event_type != 'cancel'
    AND re.user_id IN (
        SELECT DISTINCT user_id
        FROM subscription_events
        WHERE event_type = 'downgrade'
    )
    AND monthly_amount / max_monthly_amount < 0.5
    AND ss.rn = 1
    AND re.event_date - ss.event_date > 60
ORDER BY days_as_subscriber DESC, user_id ASC;
