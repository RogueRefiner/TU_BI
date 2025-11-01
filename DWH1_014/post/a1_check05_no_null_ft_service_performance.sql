-- Make A1 dwh_014 schema the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Check [ft_service_performance NO NULL] 
-- =======================================
WITH
    validation AS (
        SELECT
            COUNT(t_se) AS total_events,
            COUNT(
                CASE
                    WHEN d_td.id IS NULL THEN 1
                END
            ) AS missing_day_links,
            COUNT(
                CASE
                    WHEN d_em.sk_employee IS NULL THEN 1
                END
            ) AS missing_employee_links,
            COUNT(
                CASE
                    WHEN d_sd.sk_sensor_device IS NULL THEN 1
                END
            ) AS missing_sensor_devices,
            COUNT(
                CASE
                    WHEN d_st.sk_service_type IS NULL THEN 1
                END
            ) AS missing_service_type
        FROM
            stg_014.tb_serviceevent t_se
            JOIN dwh_014.dim_sensordevice d_sd ON t_se.sensordevid = d_sd.tb_sensordevice_id
            JOIN dwh_014.dim_timeday d_td ON t_se.servicedat = d_td.full_date
            JOIN dwh_014.dim_servicetype d_st ON t_se.servicetypeid = d_st.tb_servicetype_id
            JOIN dwh_014.dim_employee d_em ON t_se.employeeid = d_em.tb_employee_id
    )
SELECT
    validation.missing_employee_links,
    validation.missing_day_links,
    validation.missing_sensor_devices,
    validation.missing_service_type,
    CASE
        WHEN (
            validation.missing_employee_links = 0
            AND validation.missing_day_links = 0
            AND missing_sensor_devices = 0
            AND missing_service_type = 0
        ) THEN 'success'
        ELSE 'fail'
    END
FROM
    validation
GROUP BY
    validation.missing_employee_links,
    validation.missing_day_links,
    validation.missing_sensor_devices,
    validation.missing_service_type