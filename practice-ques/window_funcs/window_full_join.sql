-- ================================================================
-- 🏆 LeetCode 1194 – Tournament Winners (MySQL FULL JOIN Approach)
-- Objective:
--     Find the winner in each group – the player with the highest 
--     total score across all matches (from both sides of the match).
--     If there’s a tie, the player with the smaller player_id wins.
-- ================================================================

-- 🧱 TABLE SETUP: Players & Matches
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Players;

CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    group_id INT
);

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    first_player INT,
    second_player INT,
    first_score INT,
    second_score INT
);

-- 🧪 SAMPLE DATA
INSERT INTO Players (player_id, group_id) VALUES
(15, 1), (25, 1), (30, 1), (45, 1),
(10, 2), (35, 2), (50, 2),
(20, 3), (40, 3);

INSERT INTO Matches (match_id, first_player, second_player, first_score, second_score) VALUES
(1, 15, 45, 3, 0),
(2, 30, 25, 1, 2),
(3, 30, 15, 2, 0),
(4, 40, 20, 5, 2),
(5, 35, 50, 1, 1);

-- ================================================================
-- 🧠 SOLUTION OVERVIEW
-- Steps:
-- 1. Calculate total score per player from both sides (first and second).
-- 2. Simulate a FULL OUTER JOIN using LEFT JOIN + RIGHT JOIN + UNION.
-- 3. Join scores with player groups.
-- 4. Use RANK() to find max scorer per group. Resolve ties with MIN(player_id).
-- ================================================================

WITH 
-- 🎯 Step 1: Score when the player is in first_player
first_player_scores AS (
    SELECT first_player AS player_id, SUM(first_score) AS score
    FROM Matches
    GROUP BY first_player
),

-- 🎯 Step 2: Score when the player is in second_player
second_player_scores AS (
    SELECT second_player AS player_id, SUM(second_score) AS score
    FROM Matches
    GROUP BY second_player
),

-- 🔀 Step 3: Simulate FULL OUTER JOIN on player_id from both tables
total_scores AS (
    SELECT 
        fp.player_id, 
        COALESCE(fp.score, 0) + COALESCE(sp.score, 0) AS score
    FROM first_player_scores fp
    LEFT JOIN second_player_scores sp ON fp.player_id = sp.player_id

    UNION

    SELECT 
        sp.player_id, 
        COALESCE(fp.score, 0) + COALESCE(sp.score, 0) AS score
    FROM first_player_scores fp
    RIGHT JOIN second_player_scores sp ON fp.player_id = sp.player_id
),

-- 📎 Step 4: Attach group_id to each player
grouped_scores AS (
    SELECT 
        ts.player_id, 
        ts.score, 
        p.group_id
    FROM total_scores ts
    JOIN Players p ON ts.player_id = p.player_id
),

-- 🏁 Step 5: RANK players within each group by score DESC, player_id ASC
ranked AS (
    SELECT 
        group_id,
        player_id,
        RANK() OVER (
            PARTITION BY group_id 
            ORDER BY score DESC, player_id ASC
        ) AS rnk
    FROM grouped_scores
)

-- ✅ Final Output: Return only top-ranked player per group
SELECT 
    group_id, 
    player_id
FROM ranked
WHERE rnk = 1
ORDER BY group_id;

-- ================================================================
-- ✅ Expected Output:
-- +-----------+------------+
-- | group_id  | player_id  |
-- +-----------+------------+
-- |     1     |     15     |
-- |     2     |     35     |
-- |     3     |     40     |
-- +-----------+------------+
-- ================================================================
