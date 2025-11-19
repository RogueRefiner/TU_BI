-- Make A1 dwh_014, stg_014 schemas the default for this session
SET
    search_path TO dwh_014,
    stg_014;

-- =======================================
-- Load dim_employee
-- =======================================
-- Step 1: Truncate target table, the dim_timeday in this case
TRUNCATE TABLE dim_sensordevice RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_sensordevice
INSERT INTO
    dim_sensordevice (
        tb_sensordevice_id,
        city_name,
        country_name,
        latitude,
        longitude,
        population,
        altitude,
        installedat,
        sensor_typename,
        sensor_manufacturer,
        sensor_technology
    )
SELECT
    sd.id,
    ci.cityname,
    co.countryname,
    ci.latitude,
    ci.longitude,
    co.population,
    sd.altitude,
    sd.installedat,
    st.typename,
    st.manufacturer,
    st.technology
FROM
    stg_014.tb_sensordevice sd
    JOIN stg_014.tb_sensortype st ON sd.sensortypeid = st.id
    JOIN stg_014.tb_city ci ON sd.cityid = ci.id
    JOIN stg_014.tb_country co ON ci.countryid = co.id;