-- Make A1 dwh_014, stg_014 schemas the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Load dim_city
-- =======================================
-- Step 1: Truncate target table, the dim_city in this case
TRUNCATE TABLE dim_city RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_city
INSERT INTO dim_city (tb_city_id, city_name, city_population, city_latitude, city_longitude, country_name, country_population)
SELECT c.id, c.cityname, c.population, c.latitude, c.longitude, co.countryname, co.population
FROM stg_014.tb_city c 
JOIN stg_014.tb_country co ON co.id = c.countryid;
