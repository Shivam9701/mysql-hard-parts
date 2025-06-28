-- =========================================================
-- 🧠 SQL Interview Problem: Largest Visit Window by User
-- =========================================================

-- 📝 QUESTION:
-- For each user, calculate the largest number of days between 
-- two of their visits. If there is no next visit, assume the 
-- gap is between the current visit and CURRENT_DATE().
--
-- Use LEAD() and DATEDIFF(), and return the largest gap 
-- in days for each user.

-- =========================================================
-- 🧱 Step 1: Create Table
-- =========================================================

DROP TABLE IF EXISTS user_visits;

CREATE TABLE user_visits (
    user_id INT,
    visit_date DATE
);

-- =========================================================
-- 📥 Step 2: Insert Sample Data
-- =========================================================

INSERT INTO user_visits (user_id, visit_date)
VALUES
  (1, '2023-01-01'),
  (1, '2023-01-10'),
  (1, '2023-01-15'),
  (2, '2023-02-01'),
  (2, '2023-02-01'),
  (2, '2023-02-14'),
  (3, '2023-03-10'),
  (3, '2023-03-11'),
  (3, '2023-03-13'),
  (4, '2023-04-20'),
  (4, '2023-05-20'),
  (5, '2023-06-01'),
  (5, '2023-06-15'),
  (5, '2023-06-25'),
  (5, '2023-07-01'),
  (6, '2023-08-15'), -- single visit
  (7, '2023-09-01'),
  (7, '2023-09-20'),
  (7, '2023-09-22'),
  (8, '2023-10-10'),
  (8, '2023-10-30'),
  (9, '2023-11-05'),
  (9, '2023-12-01'),
  (10, '2023-12-20');

-- =========================================================
-- 💡 Step 3: Approach
-- =========================================================

-- 1. Use LEAD(visit_date, 1, CURRENT_DATE()) OVER (...) to 
--    get the next visit date per user. If no next visit, 
--    use CURRENT_DATE().
--
-- 2. Calculate DATEDIFF(next_visit, current_visit) 
--    for each row.
--
-- 3. Group by user and take MAX of all gaps to get 
--    the largest inactivity window per user.

-- =========================================================
-- ✅ Step 4: Final Query
-- =========================================================

SELECT 
    user_id,
    MAX(biggest_window) AS biggest_window
FROM (
    SELECT 
        user_id,
        DATEDIFF(
            LEAD(visit_date, 1, CURRENT_DATE()) OVER (
                PARTITION BY user_id 
                ORDER BY visit_date
            ),
            visit_date
        ) AS biggest_window
    FROM user_visits
) AS gp
GROUP BY user_id
ORDER BY biggest_window DESC;

-- =========================================================
-- 🧾 Sample Output (assuming CURRENT_DATE = '2025-06-28'):
-- =========================================================
-- | user_id | biggest_window |
-- |---------|----------------|
-- | 6       | 683            |
-- | 10      | 556            |
-- | 9       | 209            |
-- | ...     | ...            |
