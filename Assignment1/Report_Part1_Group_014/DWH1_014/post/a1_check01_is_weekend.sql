-- Make A1 dwh_014 schema the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Check [is_weekend == count('Sunday', 'Saturday')] 
-- =======================================
WITH time AS (
    SELECT weekday_name AS wnm, is_weekend AS iw 
    FROM dwh_014.dim_timeday
), validation AS (
    SELECT 
        wnm, 
        iw, 
        CASE
            WHEN (TRIM(LOWER(wnm)) IN ('saturday', 'sunday') AND iw IS TRUE) THEN 'OK'
            WHEN (TRIM(LOWER(wnm)) NOT IN ('saturday', 'sunday') AND iw IS FALSE) THEN 'OK'
            ELSE 'fail'
        END AS validation,
        CURRENT_TIMESTAMP(0)::TIMESTAMP AS timestamp
    FROM time
)
SELECT 
    COUNT(*) AS cnt,
    SUM(CASE WHEN validation = 'OK' THEN 1 ELSE 0 END) AS validated,
    timestamp,
    CASE 
        WHEN COUNT(*) = SUM(CASE WHEN validation = 'OK' THEN 1 ELSE 0 END)
        THEN 'success' 
        ELSE 'fail' 
    END AS success
FROM validation
GROUP BY timestamp;