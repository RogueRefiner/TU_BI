-- Show Avg Data Quality by Country for 2023 and 2024. 
-- Return Countries on rows and two columns—2023 and 2024 values of Avg Data Quality.
SET
    search_path TO dwh2_014,
    stg2_014;

WITH
    yearly AS (
        SELECT
            c.country_name,
            tm.year_num,
            AVG(pcm.data_quality_avg) AS avg_quality
        FROM
            dwh2_014.ft_param_city_month pcm
            JOIN dwh2_014.dim_city c ON c.city_key = pcm.city_key
            JOIN dwh2_014.dim_timemonth tm ON tm.month_key = pcm.month_key
        WHERE
            tm.year_num IN (2023, 2024)
        GROUP BY
            c.country_name,
            tm.year_num
    )
SELECT
    country_name,
    MAX(
        CASE
            WHEN year_num = 2023 THEN avg_quality
        END
    ) AS avg_data_quality_2023,
    MAX(
        CASE
            WHEN year_num = 2024 THEN avg_quality
        END
    ) AS avg_data_quality_2024
FROM
    yearly
GROUP BY
    country_name
ORDER BY
    country_name;