-- For parameters PM1 and NO2, show Avg Recorded Value by Country for 2024. 
-- Return Countries on rows and two columns - PM1 and NO2 (Avg Recorded Value) - for the year 2024.
SET
    search_path TO dwh2_014,
    stg2_014;

WITH param AS (
SELECT
	c.country_name,
	p.param_key,
	AVG(pcm.recordedvalue_avg) AS recordedvalue_avg
FROM
    dwh2_014.ft_param_city_month pcm
    JOIN dwh2_014.dim_city c ON c.city_key = pcm.city_key
    JOIN dwh2_014.dim_timemonth tm ON tm.month_key = pcm.month_key
    JOIN dwh2_014.dim_param p ON p.param_key = pcm.param_key
WHERE
    tm.year_num = 2024 AND p.param_key IN (1, 9)
GROUP BY 
	c.country_name,
    p.param_key
)
SELECT 
	country_name,
	AVG(CASE WHEN param_key = 1 THEN recordedvalue_avg END) AS recordedvalue_avg_PM1,
	AVG(CASE WHEN param_key = 9 THEN recordedvalue_avg END) AS recordedvalued_avg_NO2
FROM param 
GROUP BY country_name