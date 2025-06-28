-- ========================================
-- 🧪 TEMP TABLE EXAMPLE 1: MANUAL INSERTS
-- ========================================

-- Create a temporary table to test variable-based inserts
CREATE TEMPORARY TABLE temp_table (
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    movies     VARCHAR(100)
);

-- Define session-scoped variables
SET @fname = 'Shivam';
SET @lname = 'Mubu';

-- Insert rows using session variables
INSERT INTO temp_table 
VALUES (@fname, @fname, 'Bb');  -- Same first & last name

INSERT INTO temp_table 
VALUES (@fname, @lname, 'BA');  -- Different last name

INSERT INTO temp_table 
VALUES (@lname, @fname, 'BC');  -- Names reversed

-- View contents of the temp table
SELECT * FROM temp_table;



-- =====================================================
-- 🧪 TEMP TABLE EXAMPLE 2: SUBSET OF AN EXISTING TABLE
-- =====================================================

-- Drop the table if it already exists in the session
DROP TABLE IF EXISTS layoff_gt_100;

-- Create a temp table with rows filtered from 'layoffs'
CREATE TEMPORARY TABLE IF NOT EXISTS layoff_gt_100 AS
SELECT * FROM layoffs
WHERE total_laid_off > 100;

-- Query the temporary table
SELECT * FROM layoff_gt_100;
