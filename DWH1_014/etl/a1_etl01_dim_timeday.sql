-- Make A1 dwh_014, stg_014 schemas the default for this session
SET search_path TO dwh_014, stg_014;

-- =======================================
-- Load dim_timeday
-- =======================================

-- Step 1: Truncate target table, the dim_timeday in this case
TRUNCATE TABLE dim_timeday RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_timeday
INSERT INTO dim_timeday (id, full_date, day_, month_, month_name, quarter, year_, weekday, weekday_name, is_weekend, day_of_year, etl_load_timestamp)
SELECT
    to_char(d, 'YYYYMMDD')::INT AS id,
    d AS full_date,
    EXTRACT(DAY FROM d)::INT AS day_,
    EXTRACT(MONTH FROM d)::INT AS month_,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter,
    EXTRACT(YEAR FROM d)::INT AS year_,
    EXTRACT(ISODOW FROM d)::INT AS weekday,
    TO_CHAR(d, 'Day') AS weekday_name,
    CASE WHEN EXTRACT(ISODOW FROM d) IN (6,7) THEN TRUE ELSE FALSE END AS is_weekend,
    EXTRACT(DOY FROM d)::INT AS day_of_year,
    CURRENT_TIMESTAMP AS etl_load_timestamp
FROM generate_series(
    DATE '2023-01-01',  
    DATE '2024-12-31',  
    INTERVAL '1 day'
) AS g(d)
ORDER BY d;