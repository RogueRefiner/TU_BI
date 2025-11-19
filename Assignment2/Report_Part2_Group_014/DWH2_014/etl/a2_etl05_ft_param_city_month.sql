-- Assignment 2 ETL: ft_param_city_month
-- GRAIN: month_key × city_key × param_key

-- EXAMPLE SHAPE (sketch only):
-- TRUNCATE TABLE ft_param_city_month;
-- WITH cte1 AS (...),
--      cte2 AS (...),
--      cte3 AS (...),
--      ... AS (...),
--      final_cte AS (...)
-- INSERT INTO ft_param_city_month (...columns...)
-- SELECT ... FROM final_cte;

-- Make A2 dwh2_014, stg2_014 schemas the default for this session
SET search_path TO dwh2_014, stg2_014;

-- =======================================
-- Load ft_param_city_month
-- =======================================

-- Step 1: Truncate target table - ft_param_city_month
TRUNCATE TABLE dwh2_014.ft_param_city_month RESTART IDENTITY CASCADE;
DROP SEQUENCE IF EXISTS dwh2_014.ft_param_city_month_seq;
CREATE SEQUENCE IF NOT EXISTS dwh2_014.ft_param_city_month_seq;

CREATE TEMP TABLE IF NOT EXISTS tmp_monthly_alerts AS
WITH daily_alerts AS (
    SELECT
        dt.month_key,
        dc.city_key,
        dp.param_key,
        DATE(re.readat) AS day_date,
        MAX(pa.alertid) AS daily_rank
    FROM stg2_014.tb_readingevent re
    JOIN stg2_014.tb_sensordevice se 
        ON re.sensordevid = se.id
    JOIN stg2_014.tb_city c 
        ON c.id = se.cityid
    JOIN stg2_014.tb_country co 
        ON co.id = c.countryid
    JOIN dwh2_014.dim_city dc 
        ON dc.city_name = c.cityname 
        AND dc.country_name = co.countryname
    JOIN stg2_014.tb_param p 
        ON p.id = re.paramid
    JOIN dwh2_014.dim_param dp 
        ON dp.param_name = p.paramname
    JOIN dwh2_014.dim_timemonth dt 
        ON re.readat BETWEEN dt.mfirst_day AND dt.mlast_day
    LEFT JOIN stg2_014.tb_paramalert pa 
        ON pa.paramid = p.id
        AND re.recordedvalue >= pa.threshold
    GROUP BY
        dt.month_key, 
        dc.city_key, 
        dp.param_key, 
        DATE(re.readat)
)
SELECT
    month_key,
    city_key,
    param_key,
    COUNT(*) FILTER (WHERE COALESCE(daily_rank, 0) >= 1) AS exceed_days_any,
    MAX(COALESCE(daily_rank, 1000)) AS alertpeak_rank
FROM daily_alerts
GROUP BY 
    month_key,
    city_key, 
    param_key;

INSERT INTO dwh2_014.ft_param_city_month (
    ft_pcm_key,
    month_key,
    city_key,
    param_key,
    reading_events_count,
    data_volume_kb_sum,
    devices_reporting_count,
    missing_days,
    recordedvalue_avg,
    data_quality_avg,
    recordedvalue_p95,
    exceed_days_any,
    alertpeak_key
)
SELECT
    nextval('dwh2_014.ft_param_city_month_seq'),
    dt.month_key,
    dc.city_key,
    dp.param_key,
    COUNT(DISTINCT re.sensordevid || ':' || re.readat) AS reading_events_count,
    SUM(re.datavolumekb) AS data_volume_kb_sum,
    COUNT(DISTINCT re.sensordevid) AS devices_reporting_count,
    dt.days_in_month - COUNT(DISTINCT DATE(re.readat)) AS missing_days,
    AVG(re.recordedvalue) AS recordedvalue_avg,
    AVG(re.dataquality) AS data_quality_avg,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY re.recordedvalue) AS recordedvalue_p95,
    COALESCE(ma.exceed_days_any, 0),
    COALESCE(ma.alertpeak_rank, 1000)
FROM stg2_014.tb_readingevent re
JOIN stg2_014.tb_sensordevice se 
    ON re.sensordevid = se.id
JOIN stg2_014.tb_city c 
    ON c.id = se.cityid
JOIN stg2_014.tb_country co 
    ON co.id = c.countryid
JOIN dwh2_014.dim_city dc 
    ON dc.city_name = c.cityname
    AND dc.country_name = co.countryname
JOIN stg2_014.tb_param p 
    ON p.id = re.paramid
JOIN dwh2_014.dim_param dp 
    ON dp.param_name = p.paramname
JOIN dwh2_014.dim_timemonth dt 
    ON re.readat BETWEEN dt.mfirst_day AND dt.mlast_day
LEFT JOIN tmp_monthly_alerts ma 
    ON ma.month_key = dt.month_key
    AND ma.city_key  = dc.city_key
    AND ma.param_key = dp.param_key
GROUP BY
    dt.month_key, 
    dc.city_key, 
    dp.param_key,
    ma.exceed_days_any, 
    ma.alertpeak_rank;
