-- please remember to give a meaningful name to both Table X (instead of tb_x) and TableY (instead of tb_y)

-- Make the A1's stg_014 schema the default for this session
SET search_path TO stg_014;

-- -------------------------------
-- 2) DROP TABLE before attempting to create OLTP snapshot tables
-- -------------------------------
DROP TABLE IF EXISTS tb_city_measurement_campaigns;
DROP TABLE IF EXISTS tb_measurementcampaign;

-- give a meaningful name and create Table X
CREATE TABLE tb_measurementcampaign (
    id SERIAL PRIMARY KEY ,
    campaignname VARCHAR(100),
    startdate DATE,
    enddate DATE,
    purpose TEXT,
    status VARCHAR(50)
);

-- give a meaningful name and create Table Y
CREATE TABLE tb_city_measurement_campaigns (
    id SERIAL NOT NULL PRIMARY KEY,
    city_id int NOT NULL REFERENCES tb_city(id),
    campaign_id int NOT NULL REFERENCES tb_measurementcampaign(id)
);


