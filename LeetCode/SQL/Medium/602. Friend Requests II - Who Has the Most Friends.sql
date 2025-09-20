-- Table: RequestAccepted

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | requester_id   | int     |
-- | accepter_id    | int     |
-- | accept_date    | date    |
-- +----------------+---------+
-- (requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
-- This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 

-- Write a solution to find the people who have the most friends and the most friends number.

-- The test cases are generated so that only one person has the most friends.

# Write your MySQL query statement below
WITH AllFriends AS (
    SELECT requester_id AS user_id,
        accepter_id AS friend_id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS user_id,
        requester_id AS friend_id
    FROM RequestAccepted
),
FriendCount AS (
    SELECT user_id, COUNT(DISTINCT friend_id) AS friend_num
    FROM AllFriends
    GROUP BY user_id
),
MaxFriendCount AS (
    SELECT MAX(friend_num) AS max_friend_num
    FROM FriendCount
)
SELECT user_id AS id, friend_num AS num
FROM FriendCount
JOIN MaxFriendCount ON friend_num = max_friend_num;
