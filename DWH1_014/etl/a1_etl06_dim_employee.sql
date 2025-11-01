-- Make A1 dwh_014, stg_014 schemas the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Load dim_employee
-- =======================================

-- Step 1: Truncate target table, the dim_timeday in this case
TRUNCATE TABLE dim_employee RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_employee
INSERT INTO dim_employee (tb_employee_id, badge_number, validfrom, validto, rolelevel, category, rolename, current_flag)
SELECT em.id, em.badgenumber, em.validfrom, em.validto, ro.rolelevel, ro.category, ro.rolename,
	CASE 
	  WHEN em.validto IS NULL OR em.validto > CURRENT_DATE THEN TRUE 
	  ELSE FALSE 
	END AS current_flag
FROM stg_014.tb_employee em
JOIN stg_014.tb_role ro ON em.roleid=ro.id
