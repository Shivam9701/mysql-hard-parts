-- ========================================================
-- 🪟 WINDOW FUNCTION: FULL COVERAGE OF `ROWS BETWEEN`
-- Demonstrating all variations of ROWS BETWEEN clauses
-- ========================================================

-- 🧱 Step 1: Setup
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    id INT PRIMARY KEY,
    sales_date DATE,
    employee VARCHAR(50),
    revenue INT
);

-- 🧪 Step 2: Sample Data
INSERT INTO sales (id, sales_date, employee, revenue) VALUES
(1, '2024-01-01', 'Alice', 100),
(2, '2024-01-02', 'Alice', 200),
(3, '2024-01-03', 'Alice', 300),
(4, '2024-01-04', 'Alice', 400),
(5, '2024-01-05', 'Alice', 500),
(6, '2024-01-01', 'Bob', 80),
(7, '2024-01-02', 'Bob', 90),
(8, '2024-01-03', 'Bob', 100),
(9, '2024-01-04', 'Bob', 110),
(10, '2024-01-05', 'Bob', 120);

-- ========================================================
-- 🎯 VARIATION 1: UNBOUNDED PRECEDING TO CURRENT ROW
-- Running total up to current row
-- Equivalent to SUM from beginning to current
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🎯 VARIATION 2: UNBOUNDED PRECEDING TO UNBOUNDED FOLLOWING
-- Total sum for the whole partition (employee)
-- Same value for all rows per employee
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS total_partition_sum
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🎯 VARIATION 3: N PRECEDING TO CURRENT ROW (rolling window)
-- 2-row rolling sum (current + previous 2 rows)
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_sum_3_rows
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🎯 VARIATION 4: CURRENT ROW TO N FOLLOWING
-- Forward-looking window (next N rows including current)
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS forward_looking_sum
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🎯 VARIATION 5: 1 PRECEDING TO 1 FOLLOWING
-- Centered 3-row moving window
-- Useful for smoothing, averages, trends
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS centered_window_sum
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🎯 VARIATION 6: CURRENT ROW ONLY
-- No previous/next rows. Aggregate only current row.
-- Equivalent to normal value for aggregation functions
-- ========================================================
SELECT 
    employee,
    sales_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY employee 
        ORDER BY sales_date
        ROWS BETWEEN CURRENT ROW AND CURRENT ROW
    ) AS current_row_value
FROM sales
ORDER BY employee, sales_date;

-- ========================================================
-- 🧾 RECAP:
-- ROWS BETWEEN variations let you define a precise window:
--   • UNBOUNDED PRECEDING: start of partition
--   • N PRECEDING: N rows before current
--   • CURRENT ROW: the row being processed
--   • N FOLLOWING: N rows after current
--   • UNBOUNDED FOLLOWING: end of partition
-- ========================================================
