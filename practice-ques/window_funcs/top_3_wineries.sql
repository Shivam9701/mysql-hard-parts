WITH 
ranked_wineries AS (
    SELECT
        country,
        winery,
        SUM(points) AS points,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(points) DESC, winery) AS rnk
    FROM Wineries
    GROUP BY country, winery
),
countries AS (
    SELECT DISTINCT country FROM Wineries
),
top AS (
    SELECT country, CONCAT(winery, ' (', points, ')') AS top_winery
    FROM ranked_wineries WHERE rnk = 1
),
second AS (
    SELECT country, CONCAT(winery, ' (', points, ')') AS second_winery
    FROM ranked_wineries WHERE rnk = 2
),
third AS (
    SELECT country, CONCAT(winery, ' (', points, ')') AS third_winery
    FROM ranked_wineries WHERE rnk = 3
)
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
