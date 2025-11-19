-- Make A1 dwh_014 schema the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Check [dim_city.city_pupulation < dim_city.country_population] 
-- =======================================
WITH
    country_population AS (
        SELECT
            country_name,
            SUM(country_population) AS total_country_population
        FROM
            dwh_014.dim_city
        GROUP BY
            country_name
    )
SELECT
    CASE
        WHEN COUNT(*) FILTER (
            WHERE
                d_c.city_population > cp.total_country_population
        ) = 0 THEN 'success'
        ELSE 'fail'
    END AS validation_result
FROM
    dwh_014.dim_city d_c
    JOIN country_population cp ON cp.country_name = d_c.country_name;