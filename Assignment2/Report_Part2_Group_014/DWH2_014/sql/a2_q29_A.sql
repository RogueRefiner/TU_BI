-- Show Data Volume (KB) by Country in Eastern Europe for 2023 and 2024. 
-- Return Eastern European countries on rows and two columns—2023 and 2024 totals of Data Volume (KB).
SET
    search_path TO dwh2_014,
    stg2_014;

WITH
    yearly AS (
        SELECT
            c.country_name,
            tm.year_num,
            SUM(pcm.data_volume_kb_sum) AS data_volume_kb_sum
        FROM
            dwh2_014.ft_param_city_month pcm
            JOIN dwh2_014.dim_city c ON c.city_key = pcm.city_key
            JOIN dwh2_014.dim_timemonth tm ON tm.month_key = pcm.month_key
        WHERE
            tm.year_num IN (2023, 2024)
            AND c.region_name = 'Eastern Europe'
        GROUP BY
            c.country_name,
            tm.year_num
    )
SELECT
    country_name,
    MAX(
        CASE
            WHEN year_num = 2023 THEN data_volume_kb_sum
        END
    ) AS data_volume_kb_sum_2023,
    MAX(
        CASE
            WHEN year_num = 2024 THEN data_volume_kb_sum
        END
    ) AS data_volume_kb_sum_2024
FROM
    yearly
GROUP BY
    country_name
ORDER BY
    country_name