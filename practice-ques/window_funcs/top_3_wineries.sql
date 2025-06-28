-- ============================================================
-- 🍷 Top 3 Wineries Per Country
-- For each country, return the top 3 wineries by total points.
-- Format: <winery> (<points>)
-- Show 'No Second Winery' / 'No Third Winery' when not present.
-- ============================================================

-- 🔄 Drop table if exists
DROP TABLE IF EXISTS Wineries;

-- 🧱 Table Setup
CREATE TABLE Wineries (
    id INT PRIMARY KEY,
    country VARCHAR(100),
    points INT,
    winery VARCHAR(100)
);

-- 🧪 Sample Data
INSERT INTO Wineries (id, country, points, winery) VALUES
(103, 'Australia', 84, 'WhisperingPines'),
(737, 'Australia', 85, 'GrapesGalore'),
(848, 'Australia', 100, 'HarmonyHill'),
(222, 'Hungary', 60, 'MoonlitCellars'),
(116, 'USA', 47, 'RoyalVines'),
(124, 'USA', 45, 'Eagle\'sNest'),
(648, 'India', 69, 'SunsetVines'),
(894, 'USA', 39, 'RoyalVines'),
(677, 'USA', 9, 'PacificCrest');

-- ============================================================
-- 🧠 Solution with CTEs
-- ============================================================
WITH 
-- 🎯 Step 1: Aggregate total points per winery in each country
ranked_wineries AS (
    SELECT
        country,
        winery,
        SUM(points) AS points,
        ROW_NUMBER() OVER (
            PARTITION BY country 
            ORDER BY SUM(points) DESC, winery
        ) AS rnk
    FROM Wineries
    GROUP BY country, winery
),

-- 🧾 Step 2: Get all distinct countries to ensure full coverage
countries AS (
    SELECT DISTINCT country FROM Wineries
),

-- 🥇 Step 3: Get Top Winery (Rank 1)
top AS (
    SELECT 
        country, 
        CONCAT(winery, ' (', points, ')') AS top_winery
    FROM ranked_wineries
    WHERE rnk = 1
),

-- 🥈 Step 4: Get Second Winery (Rank 2)
second AS (
    SELECT 
        country, 
        CONCAT(winery, ' (', points, ')') AS second_winery
    FROM ranked_wineries
    WHERE rnk = 2
),

-- 🥉 Step 5: Get Third Winery (Rank 3)
third AS (
    SELECT 
        country, 
        CONCAT(winery, ' (', points, ')') AS third_winery
    FROM ranked_wineries
    WHERE rnk = 3
)

-- 🧾 Step 6: Final Output with COALESCE for missing ranks
SELECT 
    c.country,
    COALESCE(t.top_winery, 'No Top Winery') AS top_winery,
    COALESCE(s.second_winery, 'No Second Winery') AS second_winery,
    COALESCE(th.third_winery, 'No Third Winery') AS third_winery
FROM countries c
LEFT JOIN top t ON c.country = t.country
LEFT JOIN second s ON c.country = s.country
LEFT JOIN third th ON c.country = th.country
ORDER BY c.country;

-- ✅ Output:
-- +-----------+---------------------+-------------------+----------------------+
-- | country   | top_winery          | second_winery     | third_winery         |
-- +-----------+---------------------+-------------------+----------------------+
-- | Australia | HarmonyHill (100)   | GrapesGalore (85) | WhisperingPines (84) |
-- | Hungary   | MoonlitCellars (60) | No Second Winery  | No Third Winery      |
-- | India     | SunsetVines (69)    | No Second Winery  | No Third Winery      |
-- | USA       | RoyalVines (86)     | Eagle'sNest (45)  | PacificCrest (9)     |
-- +-----------+---------------------+-------------------+----------------------+
