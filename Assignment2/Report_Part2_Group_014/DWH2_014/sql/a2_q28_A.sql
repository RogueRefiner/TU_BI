-- For 2024, list the Top 10 Countries by Missing Days. 
-- Return the 10 countries with the highest totals on rows (highest → lowest) and one column with Missing Days for 2024.
SET
    search_path TO dwh2_014,
    stg2_014;

SELECT
    c.country_name,
    SUM(pcm.missing_days) AS missing_days_2024
FROM
    dwh2_014.ft_param_city_month pcm
    JOIN dwh2_014.dim_city c ON c.city_key = pcm.city_key
    JOIN dwh2_014.dim_timemonth tm ON tm.month_key = pcm.month_key
WHERE
    tm.year_num = 2024
GROUP BY
    c.country_name
ORDER BY
    missing_days_2024 DESC
LIMIT
    10