-- Make A1 dwh_014 schema the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Check [ft_employee_performance NO NULL] 
-- =======================================
WITH
    validation AS (
        SELECT
            COUNT(t_se) AS total_events,
            COUNT(
                CASE
                    WHEN d_em.sk_employee IS NULL THEN 1
                END
            ) AS missing_employee_links,
            COUNT(
                CASE
                    WHEN d_td.id IS NULL THEN 1
                END
            ) AS missing_day_links
        FROM
            stg_014.tb_serviceevent t_se
            LEFT JOIN dwh_014.dim_employee d_em ON d_em.tb_employee_id = t_se.employeeid
            LEFT JOIN dwh_014.dim_timeday d_td ON t_se.servicedat = d_td.full_date
    )
SELECT
    validation.missing_employee_links,
    validation.missing_day_links,
    CASE
        WHEN (
            validation.missing_employee_links = 0
            AND validation.missing_day_links = 0
        ) THEN 'success'
        ELSE 'fail'
    END
FROM
    validation
GROUP BY
    validation.missing_employee_links,
    validation.missing_day_links