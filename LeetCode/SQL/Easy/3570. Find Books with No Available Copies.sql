-- Table: library_books

-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | book_id          | int     |
-- | title            | varchar |
-- | author           | varchar |
-- | genre            | varchar |
-- | publication_year | int     |
-- | total_copies     | int     |
-- +------------------+---------+
-- book_id is the unique identifier for this table.
-- Each row contains information about a book in the library, including the total number of copies owned by the library.
-- Table: borrowing_records

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | record_id     | int     |
-- | book_id       | int     |
-- | borrower_name | varchar |
-- | borrow_date   | date    |
-- | return_date   | date    |
-- +---------------+---------+
-- record_id is the unique identifier for this table.
-- Each row represents a borrowing transaction and return_date is NULL if the book is currently borrowed and hasn't been returned yet.
-- Write a solution to find all books that are currently borrowed (not returned) and have zero copies available in the library.

-- A book is considered currently borrowed if there exists a borrowing record with a NULL return_date
-- Return the result table ordered by current borrowers in descending order, then by book title in ascending order.

-- Write your PostgreSQL query statement below
SELECT lib_books.book_id
    ,lib_books.title
    ,lib_books.author
    ,lib_books.genre
    ,lib_books.publication_year
    ,lib_books.total_copies AS current_borrowers
FROM (
    SELECT bor_rec.book_id
        ,COUNT(*) AS borrower_count
    FROM borrowing_records bor_rec
    WHERE bor_rec.return_date IS NULL
    GROUP BY bor_rec.book_id
) bor_rec
JOIN library_books lib_books USING(book_id)
WHERE bor_rec.borrower_count = lib_books.total_copies
ORDER BY current_borrowers DESC, title ASC;
