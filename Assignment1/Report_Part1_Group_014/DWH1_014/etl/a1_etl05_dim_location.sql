-- Make A1 dwh_014, stg_014 schemas the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Load dim_location
-- =======================================

-- Step 1: Truncate target table, the dim_timeday in this case
TRUNCATE TABLE dim_location RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_location
INSERT INTO dim_location (tb_city_id, city_name, country_name, latitude, longitude, population)
SELECT DISTINCT ci.id, ci.cityname, co.countryname, ci.latitude, ci.longitude, co.population FROM tb_city ci 
JOIN tb_country co ON ci.countryid=co.id 