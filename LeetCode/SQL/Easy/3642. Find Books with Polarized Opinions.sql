-- Table: books

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | book_id     | int     |
-- | title       | varchar |
-- | author      | varchar |
-- | genre       | varchar |
-- | pages       | int     |
-- +-------------+---------+
-- book_id is the unique ID for this table.
-- Each row contains information about a book including its genre and page count.
-- Table: reading_sessions

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | session_id     | int     |
-- | book_id        | int     |
-- | reader_name    | varchar |
-- | pages_read     | int     |
-- | session_rating | int     |
-- +----------------+---------+
-- session_id is the unique ID for this table.
-- Each row represents a reading session where someone read a portion of a book. session_rating is on a scale of 1-5.
-- Write a solution to find books that have polarized opinions - books that receive both very high ratings and very low ratings from different readers.

-- A book has polarized opinions if it has at least one rating ≥ 4 and at least one rating ≤ 2
-- Only consider books that have at least 5 reading sessions
-- Calculate the rating spread as (highest_rating - lowest_rating)
-- Calculate the polarization score as the number of extreme ratings (ratings ≤ 2 or ≥ 4) divided by total sessions
-- Only include books where polarization score ≥ 0.6 (at least 60% extreme ratings)
-- Return the result table ordered by polarization score in descending order, then by title in descending order.

-- Write your PostgreSQL query statement below
WITH polarized_books AS (
    SELECT b.book_id,
        b.title,
        b.author,
        b.genre,
        b.pages,
        MIN(rs.session_rating) AS min_session_rating,
        MAX(rs.session_rating) AS max_session_rating,
        COUNT(*) FILTER (WHERE rs.session_rating <= 2) AS cnt_session_rating_le_2,
        COUNT(*) FILTER (WHERE rs.session_rating >= 4) AS cnt_session_rating_ge_4,
        COUNT(*) AS cnt_sessions
    FROM books b
    JOIN reading_sessions rs USING(book_id)
    GROUP BY b.book_id, b.title, b.author, b.genre, b.pages
)
SELECT pb.book_id,
    pb.title,
    pb.author,
    pb.genre,
    pb.pages,
    (pb.max_session_rating - pb.min_session_rating) AS rating_spread,
    ROUND(((pb.cnt_session_rating_le_2 + pb.cnt_session_rating_ge_4)::NUMERIC / pb.cnt_sessions), 2) AS polarization_score
FROM polarized_books pb
WHERE pb.min_session_rating <= 2 AND pb.max_session_rating >= 4 AND pb.cnt_sessions >= 5
    AND ((pb.cnt_session_rating_le_2 + pb.cnt_session_rating_ge_4)::NUMERIC / pb.cnt_sessions) >= 0.6
ORDER BY polarization_score DESC, title DESC;
