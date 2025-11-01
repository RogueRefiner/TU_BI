-- Make A1 dwh_014, stg_014 schemas the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Load dim_parameter
-- =======================================

-- Step 1: Truncate target table
TRUNCATE TABLE dim_parameter RESTART IDENTITY CASCADE;

INSERT INTO dim_parameter (tb_param_id, paramname, category, unit, threshold, alertname, colour, details)
SELECT DISTINCT p.id, p.paramname, p.category, p.unit, pa.threshold, a.alertname, a.colour, a.details
FROM stg_014.tb_param p
JOIN stg_014.tb_paramalert pa ON pa.paramid = p.id
JOIN stg_014.tb_alert a ON pa.alertid = a.id
ORDER BY p.id;





