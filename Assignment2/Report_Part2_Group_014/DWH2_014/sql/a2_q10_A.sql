-- For 2024, list the Top 10 Countries by Avg Data Quality. 
-- Return the 10 countries with the highest values on rows (highest → lowest) and one column with Avg Data Quality for 2024.
SET
    search_path TO dwh2_014,
    stg2_014;

SELECT
    c.country_name,
    AVG(pcm.data_quality_avg) AS avg_data_quality_2024
FROM
    dwh2_014.ft_param_city_month pcm
    JOIN dwh2_014.dim_city c ON c.city_key = pcm.city_key
    JOIN dwh2_014.dim_timemonth tm ON tm.month_key = pcm.month_key
WHERE
    tm.year_num = 2024
GROUP BY
    c.country_name
ORDER BY
    avg_data_quality_2024 DESC
LIMIT
    10;