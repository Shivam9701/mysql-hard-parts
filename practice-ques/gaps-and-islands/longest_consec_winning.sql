-- ==========================================================
-- 🧠 SQL Problem: Longest Consecutive Winning Streak (Gaps & Islands)
-- Inspired by LeetCode #2173 - Navigation Bar Avatar
-- ==========================================================

-- 🎯 Objective:
-- For each player, determine the length of their longest streak of consecutive 'Win' results
-- on different match days. Players may have Wins, Losses, or Draws.
-- A "streak" ends when a result is not a 'Win' (i.e., Lose or Draw).

-- 🧠 Recognizing the Pattern:
-- This is a classic "Gaps and Islands" problem:
-- - "Islands" are consecutive rows that satisfy a condition (e.g., result = 'Win').
-- - "Gaps" break the sequence (e.g., a 'Draw' or 'Lose').
-- 
-- 👉 Our goal is to group consecutive Wins into the same streak ID,
-- then count the size of each streak, and find the longest one per player.

-- ==========================================================
-- 🧱 Step 1: Setup Matches Table with Sample Data
-- ==========================================================

DROP TABLE IF EXISTS Matches;

CREATE TABLE Matches (
    player_id INT,
    match_day DATE,
    result ENUM('Win', 'Lose', 'Draw')
);

-- Sample Data for Testing
INSERT INTO Matches (player_id, match_day, result)
VALUES 
    (1, '2022-01-17', 'Win'),
    (1, '2022-01-18', 'Win'),
    (1, '2022-01-25', 'Win'),
    (1, '2022-01-31', 'Draw'),
    (1, '2022-02-08', 'Win'),
    (2, '2022-02-06', 'Lose'),
    (2, '2022-02-08', 'Lose'),
    (3, '2022-03-30', 'Win');

-- ==========================================================
-- 🧠 Step-by-Step Gaps & Islands Implementation
-- ==========================================================

-- ----------------------------------------------------------
-- 🧮 Step 1: wins_only_rnk
-- ----------------------------------------------------------
-- This CTE assigns a ROW_NUMBER (called win_rank) to only those matches
-- where the result is a 'Win', ordered by match_day per player.
-- It gives us a sequence of wins only.

WITH wins_only_rnk AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_day) AS win_rank
    FROM Matches
    WHERE result = 'Win'
),

-- ----------------------------------------------------------
-- 🧮 Step 2: overall_rank
-- ----------------------------------------------------------
-- This CTE assigns a ROW_NUMBER (over_rank) to *all* matches per player
-- regardless of result. This preserves the true position of each match
-- in the timeline.

overall_rank AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_day) AS over_rank
    FROM Matches
),

-- ----------------------------------------------------------
-- 🧠 Step 3: grouped_id (Gaps & Islands Applied)
-- ----------------------------------------------------------
-- This is the heart of the Gaps & Islands logic.
-- We LEFT JOIN the full set of matches with the wins-only set
-- using player_id and match_day.
--
-- If the match is a 'Win', we will have a valid win_rank.
-- For each row, we compute:
--   over_rank - win_rank → a constant ID for each streak of consecutive Wins.
--
-- If a player has no wins, win_rank will be NULL. We use -9999 as a dummy group
-- so that players with no wins can still appear in the result.

grouped_id AS (
    SELECT
        om.player_id,
        CASE 
            WHEN wor.win_rank IS NULL THEN -9999  -- Dummy ID for no-wins
            ELSE om.over_rank - wor.win_rank      -- Gaps & Islands streak ID
        END AS streak_id
    FROM 
        overall_rank om
    LEFT JOIN 
        wins_only_rnk wor
    ON 
        om.player_id = wor.player_id 
        AND om.match_day = wor.match_day
),

-- ----------------------------------------------------------
-- 📊 Step 4: imd_result (Compute Longest Streak per Player)
-- ----------------------------------------------------------
-- We group by player and streak_id, count the size of each streak,
-- then take the maximum streak per player.
-- If the streak_id is our dummy (-9999), we assign 0 instead of counting it.

imd_result AS (
    SELECT 
        player_id, 
        MAX(CASE WHEN streak_id = -9999 THEN 0 ELSE streak_count END) AS longest_streak
    FROM (
        SELECT 
            player_id, 
            streak_id, 
            COUNT(*) AS streak_count
        FROM grouped_id 
        WHERE streak_id IS NOT NULL
        GROUP BY player_id, streak_id
    ) temp
    GROUP BY player_id
)

-- ----------------------------------------------------------
-- ✅ Final Output: Longest Winning Streak per Player
-- ----------------------------------------------------------

SELECT * FROM imd_result
ORDER BY player_id;

-- ==========================================================
-- ✅ Example Output
-- ==========================================================
-- | player_id | longest_streak |
-- |-----------|----------------|
-- |     1     |        3       |
-- |     2     |        0       |
-- |     3     |        1       |

-- ==========================================================
-- 🔁 Notes:
-- - We used the "ROW_NUMBER difference" trick from Gaps & Islands to identify groups.
-- - Players with no wins are gracefully handled using NULL-safe logic.
-- - The solution is scalable and works for any number of matches per player.
-- ==========================================================
