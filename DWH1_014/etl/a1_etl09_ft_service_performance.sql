-- Make A1 dwh_014, stg_014 schemas the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Load ft_service_performance (seed, FK-safe)
-- =======================================

-- 1) Truncate target
TRUNCATE TABLE ft_service_performance RESTART IDENTITY CASCADE;

-- 2) Insert a small, valid seed set
INSERT INTO ft_service_performance (timeday_id, sensor_device_id, service_type_id, employee_id, average_sensor_altitude, average_min_level_per_sensor, sum_installed_sensors, number_employees_with_multiple_badges)
WITH avg_minlevel_per_sensor AS (
    SELECT 
        t_se.sensordevid,
        ROUND(AVG(t_st.minlevel), 4) AS avg_minlevel
    FROM stg_014.tb_serviceevent t_se
    JOIN stg_014.tb_servicetype t_st 
        ON t_se.servicetypeid = t_st.id
    GROUP BY t_se.sensordevid
), 
count_sensor_installed AS (
	SELECT 
		sensordevid,
		COUNT(*) AS sum_installed_sensors
	FROM stg_014.tb_serviceevent
	GROUP BY sensordevid
),
badges_per_employee AS (
	SELECT COUNT(*) AS cnt 
	FROM stg_014.tb_employee 
	GROUP BY badgenumber 
	HAVING COUNT(*) > 1
),
number_employees_multiple_badges AS (
	SELECT COUNT(*) AS count_emplyees_multiple_badges 
	FROM badges_per_employee
)
SELECT
    d_td.id AS day_id,
    d_sd.sk_sensor_device AS sensor_device,
    d_st.sk_service_type AS service_type,
    d_em.sk_employee AS employee,
    AVG(d_sd.altitude) AS average_sensor_altitude,
    avg_minlevel.avg_minlevel AS avg_minlevel_per_sensor,
    count_sensor.sum_installed_sensors AS sum_installed_sensors,
    num_badges.count_emplyees_multiple_badges AS number_employees_multiple_badges
FROM stg_014.tb_serviceevent t_se
JOIN dwh_014.dim_sensordevice d_sd 
    ON t_se.sensordevid = d_sd.tb_sensordevice_id
JOIN dwh_014.dim_timeday d_td 
    ON t_se.servicedat = d_td.full_date
JOIN dwh_014.dim_servicetype d_st
    ON t_se.servicetypeid = d_st.tb_servicetype_id
JOIN dwh_014.dim_employee d_em
    ON t_se.employeeid = d_em.tb_employee_id
JOIN avg_minlevel_per_sensor avg_minlevel
    ON avg_minlevel.sensordevid = t_se.sensordevid
JOIN count_sensor_installed count_sensor
	ON count_sensor.sensordevid = t_se.sensordevid
CROSS JOIN number_employees_multiple_badges num_badges
GROUP BY 
    day_id, 
    sensor_device, 
    service_type, 
    employee, 
    avg_minlevel.avg_minlevel, 
    count_sensor.sum_installed_sensors, 
    num_badges.count_emplyees_multiple_badges
ORDER BY sensor_device ASC;
