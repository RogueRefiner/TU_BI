-- Make A1 dwh_014, stg_014 schemas the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Load ft_employee_performance (seed, FK-safe)
-- =======================================
-- 1) Truncate target
TRUNCATE TABLE ft_employee_performance RESTART IDENTITY CASCADE;

-- 2) Insert a small, valid seed set
INSERT INTO
    dwh_014.ft_employee_performance (
        employee_id,
        timeday_id,
        total_services_performed_per_employee_per_day,
        avg_service_duration_per_employee_per_day,
        avg_service_quality,
        total_service_cost_per_employee_per_day
    )
SELECT
    d_em.sk_employee AS employee_id,
    d_td.id AS day_id,
    COUNT(t_se.id) AS total_services_performed_per_employee_per_day,
    AVG(t_se.durationminutes) AS avg_service_duration_per_employee_per_day,
    AVG(t_se.servicequality) AS avg_service_quality,
    SUM(t_se.servicecost) AS total_service_cost_per_employee_per_day
FROM
    stg_014.tb_serviceevent t_se
    JOIN dwh_014.dim_employee d_em ON d_em.tb_employee_id = t_se.employeeid
    JOIN dwh_014.dim_timeday d_td ON t_se.servicedat = d_td.full_date
GROUP BY
    day_id,
    employee_id