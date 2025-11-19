-- Make A1 dwh_014 schema the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Check [tb_city.id = dim_location.tb_city_id AND tb_country.countryname = dim_location.country_name] 
-- =======================================
WITH
    validation AS (
        SELECT
            t_co.countryname AS country,
            COUNT(t_c) AS city_count,
            COUNT(d_l) AS dim_location_count,
            COUNT(d_l.country_name) AS dim_location_country_count,
            COUNT(t_co.countryname) AS country_count,
            CASE
                WHEN COUNT(t_c) = COUNT(d_l)
                AND COUNT(d_l.country_name) = COUNT(t_co.countryname) THEN 'success'
                ELSE 'fail'
            END AS res
        FROM
            dwh_014.dim_location d_l
            JOIN stg_014.tb_city t_c ON t_c.id = d_l.tb_city_id
            JOIN stg_014.tb_country t_co ON t_co.countryname = d_l.country_name
        GROUP BY
            country
    )
SELECT
    CASE
        WHEN SUM(
            CASE
                WHEN validation.res = 'success' THEN 1
                ELSE 0
            END
        ) = COUNT(validation.*) THEN 'success'
        ELSE 'fail'
    END AS validation_result
FROM
    validation