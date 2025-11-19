--
-- PostgreSQL database dump
--

\restrict P7naoHbEMI6lOKBCKJGZlr7NH1ws3seF8VgqOzf5YIIeYyJgK7iug5cdks9LwEn

-- Dumped from database version 17.6 (Debian 17.6-2.pgdg13+1)
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dwh_014; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dwh_014;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_city; Type: TABLE; Schema: dwh_014; Owner: -
--

CREATE TABLE dwh_014.dim_city (
    sk_city bigint NOT NULL,
    tb_city_id integer,
    city_name character varying(255) NOT NULL,
    city_population integer NOT NULL,
    city_latitude numeric(10,4) NOT NULL,
    city_longitude numeric(10,4) NOT NULL,
    country_name character varying(255) NOT NULL,
    country_population integer NOT NULL,
    etl_load_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: dim_city_sk_city_seq; Type: SEQUENCE; Schema: dwh_014; Owner: -
--

CREATE SEQUENCE dwh_014.dim_city_sk_city_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_city_sk_city_seq; Type: SEQUENCE OWNED BY; Schema: dwh_014; Owner: -
--

ALTER SEQUENCE dwh_014.dim_city_sk_city_seq OWNED BY dwh_014.dim_city.sk_city;


--
-- Name: dim_city sk_city; Type: DEFAULT; Schema: dwh_014; Owner: -
--

ALTER TABLE ONLY dwh_014.dim_city ALTER COLUMN sk_city SET DEFAULT nextval('dwh_014.dim_city_sk_city_seq'::regclass);


--
-- Data for Name: dim_city; Type: TABLE DATA; Schema: dwh_014; Owner: -
--

COPY dwh_014.dim_city (sk_city, tb_city_id, city_name, city_population, city_latitude, city_longitude, country_name, country_population, etl_load_timestamp) FROM stdin;
1	1001	Amsterdam	905	52.3676	4.9041	Netherlands	17500	2025-11-01 11:03:57.135158
2	1002	Ankara	5600	39.9208	32.8541	Turkey	85300	2025-11-01 11:03:57.135158
3	1003	Athens	3100	37.9838	23.7275	Greece	10400	2025-11-01 11:03:57.135158
4	1004	Barcelona	1650	41.3851	2.1734	Spain	47300	2025-11-01 11:03:57.135158
5	1005	Belgrade	1370	44.7866	20.4489	Serbia	6900	2025-11-01 11:03:57.135158
6	1006	Berlin	3700	52.5200	13.4050	Germany	83100	2025-11-01 11:03:57.135158
7	1007	Brno	380	49.1951	16.6068	Czech Republic	10800	2025-11-01 11:03:57.135158
8	1008	Brussels	1200	50.8503	4.3517	Belgium	11500	2025-11-01 11:03:57.135158
9	1009	Budapest	1750	47.4979	19.0402	Hungary	9700	2025-11-01 11:03:57.135158
10	1010	Copenhagen	800	55.6761	12.5683	Denmark	5900	2025-11-01 11:03:57.135158
11	1011	Edinburgh	540	55.9533	-3.1883	United Kingdom	67200	2025-11-01 11:03:57.135158
12	1012	Gothenburg	580	57.7089	11.9746	Sweden	10500	2025-11-01 11:03:57.135158
13	1013	Graz	330	47.0707	15.4395	Austria	9000	2025-11-01 11:03:57.135158
14	1014	Hamburg	1850	53.5511	9.9937	Germany	83100	2025-11-01 11:03:57.135158
15	1015	Helsinki	655	60.1695	24.9354	Finland	5550	2025-11-01 11:03:57.135158
16	1016	Istanbul	15500	41.0082	28.9784	Turkey	85300	2025-11-01 11:03:57.135158
17	1017	Kazan	1250	55.8304	49.0661	Russia	146000	2025-11-01 11:03:57.135158
18	1018	Leipzig	625	51.3397	12.3731	Germany	83100	2025-11-01 11:03:57.135158
19	1019	London	8900	51.5074	-0.1278	United Kingdom	67200	2025-11-01 11:03:57.135158
20	1020	Lyon	520	45.7640	4.8357	France	68000	2025-11-01 11:03:57.135158
21	1021	Marseille	870	43.2965	5.3698	France	68000	2025-11-01 11:03:57.135158
22	1022	Milan	1380	45.4642	9.1900	Italy	59000	2025-11-01 11:03:57.135158
23	1023	Minsk	2000	53.9006	27.5590	Belarus	9400	2025-11-01 11:03:57.135158
24	1024	Moscow	12600	55.7558	37.6173	Russia	146000	2025-11-01 11:03:57.135158
25	1025	Munich	1550	48.1351	11.5820	Germany	83100	2025-11-01 11:03:57.135158
26	1026	Paris	2160	48.8566	2.3522	France	68000	2025-11-01 11:03:57.135158
27	1027	Prague	1300	50.0755	14.4378	Czech Republic	10800	2025-11-01 11:03:57.135158
28	1028	Rome	2870	41.9028	12.4964	Italy	59000	2025-11-01 11:03:57.135158
29	1029	Salzburg	155	47.8095	13.0550	Austria	9000	2025-11-01 11:03:57.135158
30	1030	St. Petersburg	5400	59.9311	30.3609	Russia	146000	2025-11-01 11:03:57.135158
31	1031	Stockholm	975	59.3293	18.0686	Sweden	10500	2025-11-01 11:03:57.135158
32	1032	Stuttgart	635	48.7758	9.1829	Germany	83100	2025-11-01 11:03:57.135158
33	1033	Ufa	1150	54.7388	55.9721	Russia	146000	2025-11-01 11:03:57.135158
34	1034	Vienna	1920	48.2082	16.3738	Austria	9000	2025-11-01 11:03:57.135158
35	1035	Warsaw	1790	52.2297	21.0122	Poland	37900	2025-11-01 11:03:57.135158
36	1036	Zagreb	770	45.8150	15.9819	Croatia	3900	2025-11-01 11:03:57.135158
\.


--
-- Name: dim_city_sk_city_seq; Type: SEQUENCE SET; Schema: dwh_014; Owner: -
--

SELECT pg_catalog.setval('dwh_014.dim_city_sk_city_seq', 36, true);


--
-- Name: dim_city dim_city_pkey; Type: CONSTRAINT; Schema: dwh_014; Owner: -
--

ALTER TABLE ONLY dwh_014.dim_city
    ADD CONSTRAINT dim_city_pkey PRIMARY KEY (sk_city);


--
-- Name: dim_city dim_city_tb_city_id_key; Type: CONSTRAINT; Schema: dwh_014; Owner: -
--

ALTER TABLE ONLY dwh_014.dim_city
    ADD CONSTRAINT dim_city_tb_city_id_key UNIQUE (tb_city_id);


--
-- PostgreSQL database dump complete
--

\unrestrict P7naoHbEMI6lOKBCKJGZlr7NH1ws3seF8VgqOzf5YIIeYyJgK7iug5cdks9LwEn

