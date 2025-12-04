-- Table: Samples

-- +----------------+---------+
-- | Column Name    | Type    | 
-- +----------------+---------+
-- | sample_id      | int     |
-- | dna_sequence   | varchar |
-- | species        | varchar |
-- +----------------+---------+
-- sample_id is the unique key for this table.
-- Each row contains a DNA sequence represented as a string of characters (A, T, G, C) and the species it was collected from.
-- Biologists are studying basic patterns in DNA sequences. Write a solution to identify sample_id with the following patterns:

-- Sequences that start with ATG (a common start codon)
-- Sequences that end with either TAA, TAG, or TGA (stop codons)
-- Sequences containing the motif ATAT (a simple repeated pattern)
-- Sequences that have at least 3 consecutive G (like GGG or GGGG)
-- Return the result table ordered by sample_id in ascending order.

-- Write your PostgreSQL query statement below
SELECT sample_id, dna_sequence, species,
    CASE
        WHEN dna_sequence ~ '^ATG' THEN 1
        ELSE 0
    END AS has_start,
    CASE
        WHEN dna_sequence ~ '(TAA|TAG|TGA)$' THEN 1
        ELSE 0
    END AS has_stop,
    CASE
        WHEN dna_sequence ~ 'ATAT' THEN 1
        ELSE 0
    END AS has_atat,
    CASE
        WHEN dna_sequence ~ 'G{3,}' THEN 1
        ELSE 0
    END AS has_ggg
FROM Samples
ORDER BY sample_id ASC;
