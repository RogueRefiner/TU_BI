-- Make A1 dwh_014 schema the default for this session
SET
  search_path TO dwh_014;

-- -------------------------------
-- 2) DROP TABLE before attempting to create DWH schema tables
-- -------------------------------
DROP TABLE IF EXISTS dim_parameter;
DROP TABLE IF EXISTS dim_technician_role_scd2;
DROP TABLE IF EXISTS dim_location;
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS ft_service_performance;
DROP TABLE IF EXISTS ft_employee_performance;
DROP TABLE IF EXISTS dim_servicetype;
DROP TABLE IF EXISTS dim_sensordevice;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_timeday;

-- -------------------------------
-- 3) CREATE TABLE statements for facts and dimensions
-- Please make sure the order in which individual statements are executed respects the FOREIGN KEY constraints
-- -------------------------------
CREATE TABLE
  dim_location (
    city_sk BIGSERIAL PRIMARY KEY,
    tb_city_id INT UNIQUE,
    city_name VARCHAR(255) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 4) NOT NULL,
    longitude DECIMAL(10, 4) NOT NULL,
    population INT NOT NULL,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  dim_timeday (
    id INT NOT NULL PRIMARY KEY,
    full_date DATE NOT NULL,
    day_ INT NOT NULL,
    month_ INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    year_ INT NOT NULL,
    weekday INT NOT NULL,
    weekday_name VARCHAR(20) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    day_of_year INT,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  dim_servicetype (
    sk_service_type BIGSERIAL PRIMARY KEY,
    tb_servicetype_id INT NOT NULL,
    typename VARCHAR(255) NOT NULL,
    etl_load_timestamp TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_servicetype_bk UNIQUE (tb_servicetype_id)
  );

CREATE TABLE
  dim_parameter (
    sk_parameter BIGSERIAL PRIMARY KEY,
    tb_param_id INT NOT NULL,
    paramname VARCHAR(255) NOT NULL, -- e.g., 'PM2', 'Mercury'
    category VARCHAR(255) NOT NULL, -- e.g. Particulate matter, Heavy Metal
    unit VARCHAR(255) NOT NULL, -- e.g., 'count/m3'
    threshold DECIMAL(10,4) NOT NULL,
    alertname VARCHAR(255) NOT NULL,
    colour VARCHAR(255) NOT NULL,
    details VARCHAR(255) NOT NULL,
    etl_load_timestamp TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  dim_technician_role_scd2 (
    sk_technician_role BIGSERIAL PRIMARY KEY,
    badgenumber VARCHAR(255) NOT NULL, -- business key
    rolelevel INT NOT NULL,
    category VARCHAR(255) NOT NULL,
    rolename VARCHAR(255) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE NOT NULL, -- '9999-12-31' for current
    is_current BOOLEAN NOT NULL,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    CONSTRAINT ux_techrole_bk_timerange UNIQUE (badgenumber, effective_from, effective_to)
  );

CREATE TABLE
  dim_employee (
    sk_employee BIGSERIAL PRIMARY KEY,
    tb_employee_id INT UNIQUE,
    badge_number VARCHAR(100),
    validfrom DATE NOT NULL,
    validto DATE NULL,
    rolelevel INT NOT NULL,
    category VARCHAR(255) NOT NULL,
    rolename VARCHAR(255) NOT NULL,
    current_flag BOOLEAN NOT NULL DEFAULT TRUE,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  dim_sensordevice (
    sk_sensor_device BIGSERIAL PRIMARY KEY,
    tb_sensordevice_id INT UNIQUE,
    city_name VARCHAR(255) NOT NULL,
    country_name VARCHAR(255) NOT NULL, 
    latitude DECIMAL(10, 4) NOT NULL,
    longitude DECIMAL(10, 4) NOT NULL,
    population INT NOT NULL,
    altitude INT NOT NULL,
    installedat DATE,
    sensor_typename VARCHAR(255) NOT NULL,
    sensor_manufacturer VARCHAR(255) NOT NULL,
    sensor_technology VARCHAR(255) NOT NULL,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE 
  dim_city (
    sk_city BIGSERIAL PRIMARY KEY,
    tb_city_id INT UNIQUE,
    city_name VARCHAR(255) NOT NULL,
    city_population INT NOT NULL,
    city_latitude DECIMAL(10,4) NOT NULL,
    city_longitude DECIMAL(10,4) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    country_population INT NOT NULL,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  ft_service_performance (
    id SERIAL PRIMARY KEY,
    service_type_id INT REFERENCES dim_servicetype (sk_service_type),
    sensor_device_id INT REFERENCES dim_sensordevice (sk_sensor_device),
    employee_id INT REFERENCES dim_employee (sk_employee),
    timeday_id INT REFERENCES dim_timeday (id),
    average_min_level_per_sensor DECIMAL(10, 2),
    sum_installed_sensors INT,
    average_sensor_altitude DECIMAL(10, 2),
    number_employees_with_multiple_badges INT,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE INDEX idx_ft_service_performance_servicetype ON ft_service_performance (service_type_id);
CREATE INDEX idx_ft_service_performance_sensordevice ON ft_service_performance (sensor_device_id);
CREATE INDEX idx_ft_service_performance_employee ON ft_service_performance (employee_id);
CREATE INDEX idx_ft_service_performance_timeday ON ft_service_performance (timeday_id);

CREATE TABLE 
    ft_employee_performance (
      id SERIAL PRIMARY KEY,
      employee_id INT REFERENCES dim_employee(sk_employee),
      timeday_id INT REFERENCES dim_timeday(id),
      total_services_performed_per_employee_per_day INT,
      avg_service_duration_per_employee_per_day DECIMAL(10, 2),
      avg_service_quality DECIMAL(10, 2),
      total_service_cost_per_employee_per_day INT,
      etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
  );

CREATE INDEX idx_ft_employee_performance_employee ON ft_employee_performance (employee_id);
CREATE INDEX idx_ft_employee_performance_timeday ON ft_employee_performance (timeday_id)