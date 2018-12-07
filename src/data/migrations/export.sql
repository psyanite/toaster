--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: enum_post_reviews_ambience_score; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_post_reviews_ambience_score AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.enum_post_reviews_ambience_score OWNER TO postgres;

--
-- Name: enum_post_reviews_overall_score; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_post_reviews_overall_score AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.enum_post_reviews_overall_score OWNER TO postgres;

--
-- Name: enum_post_reviews_service_score; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_post_reviews_service_score AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.enum_post_reviews_service_score OWNER TO postgres;

--
-- Name: enum_post_reviews_taste_score; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_post_reviews_taste_score AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.enum_post_reviews_taste_score OWNER TO postgres;

--
-- Name: enum_post_reviews_value_score; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_post_reviews_value_score AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.enum_post_reviews_value_score OWNER TO postgres;

--
-- Name: enum_posts_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_posts_type AS ENUM (
    'review',
    'photo'
);


ALTER TYPE public.enum_posts_type OWNER TO postgres;

--
-- Name: enum_rewards_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_rewards_type AS ENUM (
    'one_time'
);


ALTER TYPE public.enum_rewards_type OWNER TO postgres;

--
-- Name: post_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.post_type AS ENUM (
    'photo',
    'review'
);


ALTER TYPE public.post_type OWNER TO postgres;

--
-- Name: reward_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reward_type AS ENUM (
    'one_time',
    'unlimited'
);


ALTER TYPE public.reward_type OWNER TO postgres;

--
-- Name: score_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.score_type AS ENUM (
    'bad',
    'okay',
    'good'
);


ALTER TYPE public.score_type OWNER TO postgres;

--
-- Name: user_reward_state; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_reward_state AS ENUM (
    'active',
    'redeemed',
    'expired'
);


ALTER TYPE public.user_reward_state OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    district_id integer NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_id_seq OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    alpha_2 character varying(2) NOT NULL,
    alpha_3 character varying(3) NOT NULL,
    country_code smallint NOT NULL,
    iso_3166_2 character varying(20) NOT NULL,
    region character varying(20),
    sub_region character varying(20),
    region_code smallint,
    sub_region_code smallint
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: cuisines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuisines (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.cuisines OWNER TO postgres;

--
-- Name: cuisines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuisines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuisines_id_seq OWNER TO postgres;

--
-- Name: cuisines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuisines_id_seq OWNED BY public.cuisines.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.districts_id_seq OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    suburb_id integer NOT NULL
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_id_seq OWNED BY public.locations.id;


--
-- Name: post_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_photos (
    id integer NOT NULL,
    post_id integer NOT NULL,
    photo text NOT NULL
);


ALTER TABLE public.post_photos OWNER TO postgres;

--
-- Name: post_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_photos_id_seq OWNER TO postgres;

--
-- Name: post_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_photos_id_seq OWNED BY public.post_photos.id;


--
-- Name: post_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_reviews (
    id integer NOT NULL,
    post_id integer NOT NULL,
    overall_score public.score_type NOT NULL,
    taste_score public.score_type NOT NULL,
    service_score public.score_type NOT NULL,
    value_score public.score_type NOT NULL,
    ambience_score public.score_type NOT NULL,
    body text
);


ALTER TABLE public.post_reviews OWNER TO postgres;

--
-- Name: post_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_reviews_id_seq OWNER TO postgres;

--
-- Name: post_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_reviews_id_seq OWNED BY public.post_reviews.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    type public.post_type NOT NULL,
    store_id integer NOT NULL,
    posted_by_id integer NOT NULL,
    posted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: rewards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rewards (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    description character varying,
    type public.reward_type,
    store_id integer,
    store_group_id integer,
    valid_from date NOT NULL,
    valid_until date,
    promo_image text,
    terms_and_conditions text,
    is_active boolean DEFAULT false NOT NULL,
    redeemlimit integer
);


ALTER TABLE public.rewards OWNER TO postgres;

--
-- Name: rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rewards_id_seq OWNER TO postgres;

--
-- Name: rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rewards_id_seq OWNED BY public.rewards.id;


--
-- Name: store_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_addresses (
    id integer NOT NULL,
    store_id integer NOT NULL,
    address_first_line character varying(100),
    address_second_line character varying(100),
    address_street_number character varying(20) NOT NULL,
    address_street_name character varying(50) NOT NULL,
    google_url character varying(255)
);


ALTER TABLE public.store_addresses OWNER TO postgres;

--
-- Name: store_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_addresses_id_seq OWNER TO postgres;

--
-- Name: store_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_addresses_id_seq OWNED BY public.store_addresses.id;


--
-- Name: store_cuisines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_cuisines (
    store_id integer NOT NULL,
    cuisine_id integer NOT NULL
);


ALTER TABLE public.store_cuisines OWNER TO postgres;

--
-- Name: store_group_stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_group_stores (
    group_id integer NOT NULL,
    store_id integer NOT NULL
);


ALTER TABLE public.store_group_stores OWNER TO postgres;

--
-- Name: store_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.store_groups OWNER TO postgres;

--
-- Name: store_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_groups_id_seq OWNER TO postgres;

--
-- Name: store_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_groups_id_seq OWNED BY public.store_groups.id;


--
-- Name: store_ratings_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_ratings_cache (
    store_id integer NOT NULL,
    heart_ratings integer DEFAULT 0 NOT NULL,
    okay_ratings integer DEFAULT 0 NOT NULL,
    burnt_ratings integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.store_ratings_cache OWNER TO postgres;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    id integer NOT NULL,
    name character varying(50),
    phone_country character varying(20),
    phone_number character varying(20),
    location_id integer,
    suburb_id integer,
    city_id integer,
    cover_image text
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stores_id_seq OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: suburbs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suburbs (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    city_id integer NOT NULL
);


ALTER TABLE public.suburbs OWNER TO postgres;

--
-- Name: suburbs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suburbs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suburbs_id_seq OWNER TO postgres;

--
-- Name: suburbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suburbs_id_seq OWNED BY public.suburbs.id;


--
-- Name: user_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_accounts (
    id integer NOT NULL,
    email character varying(255),
    email_confirmed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.user_accounts OWNER TO postgres;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_accounts_id_seq OWNER TO postgres;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_accounts_id_seq OWNED BY public.user_accounts.id;


--
-- Name: user_claims; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_claims (
    user_id integer NOT NULL,
    type character varying(255),
    value character varying(255)
);


ALTER TABLE public.user_claims OWNER TO postgres;

--
-- Name: user_favorite_rewards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_rewards (
    user_id integer NOT NULL,
    reward_id integer NOT NULL
);


ALTER TABLE public.user_favorite_rewards OWNER TO postgres;

--
-- Name: user_favorite_stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_stores (
    user_id integer NOT NULL,
    store_id integer NOT NULL
);


ALTER TABLE public.user_favorite_stores OWNER TO postgres;

--
-- Name: user_logins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_logins (
    social_type character varying(50) NOT NULL,
    social_id character varying(100) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_logins OWNER TO postgres;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profiles (
    user_id integer NOT NULL,
    username character varying(64),
    display_name character varying(64),
    profile_picture text,
    gender character varying(50)
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: cuisines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisines ALTER COLUMN id SET DEFAULT nextval('public.cuisines_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.location_id_seq'::regclass);


--
-- Name: post_photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_photos ALTER COLUMN id SET DEFAULT nextval('public.post_photos_id_seq'::regclass);


--
-- Name: post_reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reviews ALTER COLUMN id SET DEFAULT nextval('public.post_reviews_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: rewards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards ALTER COLUMN id SET DEFAULT nextval('public.rewards_id_seq'::regclass);


--
-- Name: store_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_addresses ALTER COLUMN id SET DEFAULT nextval('public.store_addresses_id_seq'::regclass);


--
-- Name: store_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_groups ALTER COLUMN id SET DEFAULT nextval('public.store_groups_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: suburbs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suburbs ALTER COLUMN id SET DEFAULT nextval('public.suburbs_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, name, district_id) FROM stdin;
1	Sydney	1
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, alpha_2, alpha_3, country_code, iso_3166_2, region, sub_region, region_code, sub_region_code) FROM stdin;
1	Afghanistan	AF	AFG	4	ISO 3166-2:AF	Asia	Southern Asia	142	34
2	Ã…land Islands	AX	ALA	248	ISO 3166-2:AX	Europe	Northern Europe	150	154
3	Albania	AL	ALB	8	ISO 3166-2:AL	Europe	Southern Europe	150	39
4	Algeria	DZ	DZA	12	ISO 3166-2:DZ	Africa	Northern Africa	2	15
5	American Samoa	AS	ASM	16	ISO 3166-2:AS	Oceania	Polynesia	9	61
6	Andorra	AD	AND	20	ISO 3166-2:AD	Europe	Southern Europe	150	39
7	Angola	AO	AGO	24	ISO 3166-2:AO	Africa	Middle Africa	2	17
8	Anguilla	AI	AIA	660	ISO 3166-2:AI	Americas	Caribbean	19	29
9	Antigua and Barbuda	AG	ATG	28	ISO 3166-2:AG	Americas	Caribbean	19	29
10	Argentina	AR	ARG	32	ISO 3166-2:AR	Americas	South America	19	5
11	Armenia	AM	ARM	51	ISO 3166-2:AM	Asia	Western Asia	142	145
12	Aruba	AW	ABW	533	ISO 3166-2:AW	Americas	Caribbean	19	29
13	Australia	AU	AUS	36	ISO 3166-2:AU	Oceania	Australia and New Ze	9	53
14	Austria	AT	AUT	40	ISO 3166-2:AT	Europe	Western Europe	150	155
15	Azerbaijan	AZ	AZE	31	ISO 3166-2:AZ	Asia	Western Asia	142	145
16	Bahamas	BS	BHS	44	ISO 3166-2:BS	Americas	Caribbean	19	29
17	Bahrain	BH	BHR	48	ISO 3166-2:BH	Asia	Western Asia	142	145
18	Bangladesh	BD	BGD	50	ISO 3166-2:BD	Asia	Southern Asia	142	34
19	Barbados	BB	BRB	52	ISO 3166-2:BB	Americas	Caribbean	19	29
20	Belarus	BY	BLR	112	ISO 3166-2:BY	Europe	Eastern Europe	150	151
21	Belgium	BE	BEL	56	ISO 3166-2:BE	Europe	Western Europe	150	155
22	Belize	BZ	BLZ	84	ISO 3166-2:BZ	Americas	Central America	19	13
23	Benin	BJ	BEN	204	ISO 3166-2:BJ	Africa	Western Africa	2	11
24	Bermuda	BM	BMU	60	ISO 3166-2:BM	Americas	Northern America	19	21
25	Bhutan	BT	BTN	64	ISO 3166-2:BT	Asia	Southern Asia	142	34
26	Bolivia (Plurinational State of)	BO	BOL	68	ISO 3166-2:BO	Americas	South America	19	5
27	Bonaire, Sint Eustatius and Saba	BQ	BES	535	ISO 3166-2:BQ	Americas	Caribbean	19	29
28	Bosnia and Herzegovina	BA	BIH	70	ISO 3166-2:BA	Europe	Southern Europe	150	39
29	Botswana	BW	BWA	72	ISO 3166-2:BW	Africa	Southern Africa	2	18
30	Brazil	BR	BRA	76	ISO 3166-2:BR	Americas	South America	19	5
31	Brunei Darussalam	BN	BRN	96	ISO 3166-2:BN	Asia	South-Eastern Asia	142	35
32	Bulgaria	BG	BGR	100	ISO 3166-2:BG	Europe	Eastern Europe	150	151
33	Burkina Faso	BF	BFA	854	ISO 3166-2:BF	Africa	Western Africa	2	11
34	Burundi	BI	BDI	108	ISO 3166-2:BI	Africa	Eastern Africa	2	14
35	Cambodia	KH	KHM	116	ISO 3166-2:KH	Asia	South-Eastern Asia	142	35
36	Cameroon	CM	CMR	120	ISO 3166-2:CM	Africa	Middle Africa	2	17
37	Canada	CA	CAN	124	ISO 3166-2:CA	Americas	Northern America	19	21
38	Cabo Verde	CV	CPV	132	ISO 3166-2:CV	Africa	Western Africa	2	11
39	Cayman Islands	KY	CYM	136	ISO 3166-2:KY	Americas	Caribbean	19	29
40	Central African Republic	CF	CAF	140	ISO 3166-2:CF	Africa	Middle Africa	2	17
41	Chad	TD	TCD	148	ISO 3166-2:TD	Africa	Middle Africa	2	17
42	Chile	CL	CHL	152	ISO 3166-2:CL	Americas	South America	19	5
43	China	CN	CHN	156	ISO 3166-2:CN	Asia	Eastern Asia	142	30
44	Colombia	CO	COL	170	ISO 3166-2:CO	Americas	South America	19	5
45	Comoros	KM	COM	174	ISO 3166-2:KM	Africa	Eastern Africa	2	14
46	Congo	CG	COG	178	ISO 3166-2:CG	Africa	Middle Africa	2	17
47	Congo (Democratic Republic of the)	CD	COD	180	ISO 3166-2:CD	Africa	Middle Africa	2	17
48	Cook Islands	CK	COK	184	ISO 3166-2:CK	Oceania	Polynesia	9	61
49	Costa Rica	CR	CRI	188	ISO 3166-2:CR	Americas	Central America	19	13
50	CÃ´te d'Ivoire	CI	CIV	384	ISO 3166-2:CI	Africa	Western Africa	2	11
51	Croatia	HR	HRV	191	ISO 3166-2:HR	Europe	Southern Europe	150	39
52	Cuba	CU	CUB	192	ISO 3166-2:CU	Americas	Caribbean	19	29
53	CuraÃ§ao	CW	CUW	531	ISO 3166-2:CW	Americas	Caribbean	19	29
54	Cyprus	CY	CYP	196	ISO 3166-2:CY	Asia	Western Asia	142	145
55	Czech Republic	CZ	CZE	203	ISO 3166-2:CZ	Europe	Eastern Europe	150	151
56	Denmark	DK	DNK	208	ISO 3166-2:DK	Europe	Northern Europe	150	154
57	Djibouti	DJ	DJI	262	ISO 3166-2:DJ	Africa	Eastern Africa	2	14
58	Dominica	DM	DMA	212	ISO 3166-2:DM	Americas	Caribbean	19	29
59	Dominican Republic	DO	DOM	214	ISO 3166-2:DO	Americas	Caribbean	19	29
60	Ecuador	EC	ECU	218	ISO 3166-2:EC	Americas	South America	19	5
61	Egypt	EG	EGY	818	ISO 3166-2:EG	Africa	Northern Africa	2	15
62	El Salvador	SV	SLV	222	ISO 3166-2:SV	Americas	Central America	19	13
63	Equatorial Guinea	GQ	GNQ	226	ISO 3166-2:GQ	Africa	Middle Africa	2	17
64	Eritrea	ER	ERI	232	ISO 3166-2:ER	Africa	Eastern Africa	2	14
65	Estonia	EE	EST	233	ISO 3166-2:EE	Europe	Northern Europe	150	154
66	Ethiopia	ET	ETH	231	ISO 3166-2:ET	Africa	Eastern Africa	2	14
67	Falkland Islands (Malvinas)	FK	FLK	238	ISO 3166-2:FK	Americas	South America	19	5
68	Faroe Islands	FO	FRO	234	ISO 3166-2:FO	Europe	Northern Europe	150	154
69	Fiji	FJ	FJI	242	ISO 3166-2:FJ	Oceania	Melanesia	9	54
70	Finland	FI	FIN	246	ISO 3166-2:FI	Europe	Northern Europe	150	154
71	France	FR	FRA	250	ISO 3166-2:FR	Europe	Western Europe	150	155
72	French Guiana	GF	GUF	254	ISO 3166-2:GF	Americas	South America	19	5
73	French Polynesia	PF	PYF	258	ISO 3166-2:PF	Oceania	Polynesia	9	61
74	Gabon	GA	GAB	266	ISO 3166-2:GA	Africa	Middle Africa	2	17
75	Gambia	GM	GMB	270	ISO 3166-2:GM	Africa	Western Africa	2	11
76	Georgia	GE	GEO	268	ISO 3166-2:GE	Asia	Western Asia	142	145
77	Germany	DE	DEU	276	ISO 3166-2:DE	Europe	Western Europe	150	155
78	Ghana	GH	GHA	288	ISO 3166-2:GH	Africa	Western Africa	2	11
79	Gibraltar	GI	GIB	292	ISO 3166-2:GI	Europe	Southern Europe	150	39
80	Greece	GR	GRC	300	ISO 3166-2:GR	Europe	Southern Europe	150	39
81	Greenland	GL	GRL	304	ISO 3166-2:GL	Americas	Northern America	19	21
82	Grenada	GD	GRD	308	ISO 3166-2:GD	Americas	Caribbean	19	29
83	Guadeloupe	GP	GLP	312	ISO 3166-2:GP	Americas	Caribbean	19	29
84	Guam	GU	GUM	316	ISO 3166-2:GU	Oceania	Micronesia	9	57
85	Guatemala	GT	GTM	320	ISO 3166-2:GT	Americas	Central America	19	13
86	Guernsey	GG	GGY	831	ISO 3166-2:GG	Europe	Northern Europe	150	154
87	Guinea	GN	GIN	324	ISO 3166-2:GN	Africa	Western Africa	2	11
88	Guinea-Bissau	GW	GNB	624	ISO 3166-2:GW	Africa	Western Africa	2	11
89	Guyana	GY	GUY	328	ISO 3166-2:GY	Americas	South America	19	5
90	Haiti	HT	HTI	332	ISO 3166-2:HT	Americas	Caribbean	19	29
91	Holy See	VA	VAT	336	ISO 3166-2:VA	Europe	Southern Europe	150	39
92	Honduras	HN	HND	340	ISO 3166-2:HN	Americas	Central America	19	13
93	Hong Kong	HK	HKG	344	ISO 3166-2:HK	Asia	Eastern Asia	142	30
94	Hungary	HU	HUN	348	ISO 3166-2:HU	Europe	Eastern Europe	150	151
95	Iceland	IS	ISL	352	ISO 3166-2:IS	Europe	Northern Europe	150	154
96	India	IN	IND	356	ISO 3166-2:IN	Asia	Southern Asia	142	34
97	Indonesia	ID	IDN	360	ISO 3166-2:ID	Asia	South-Eastern Asia	142	35
98	Iran (Islamic Republic of)	IR	IRN	364	ISO 3166-2:IR	Asia	Southern Asia	142	34
99	Iraq	IQ	IRQ	368	ISO 3166-2:IQ	Asia	Western Asia	142	145
100	Ireland	IE	IRL	372	ISO 3166-2:IE	Europe	Northern Europe	150	154
101	Isle of Man	IM	IMN	833	ISO 3166-2:IM	Europe	Northern Europe	150	154
102	Israel	IL	ISR	376	ISO 3166-2:IL	Asia	Western Asia	142	145
103	Italy	IT	ITA	380	ISO 3166-2:IT	Europe	Southern Europe	150	39
104	Jamaica	JM	JAM	388	ISO 3166-2:JM	Americas	Caribbean	19	29
105	Japan	JP	JPN	392	ISO 3166-2:JP	Asia	Eastern Asia	142	30
106	Jersey	JE	JEY	832	ISO 3166-2:JE	Europe	Northern Europe	150	154
107	Jordan	JO	JOR	400	ISO 3166-2:JO	Asia	Western Asia	142	145
108	Kazakhstan	KZ	KAZ	398	ISO 3166-2:KZ	Asia	Central Asia	142	143
109	Kenya	KE	KEN	404	ISO 3166-2:KE	Africa	Eastern Africa	2	14
110	Kiribati	KI	KIR	296	ISO 3166-2:KI	Oceania	Micronesia	9	57
111	Korea (Democratic People's Republic of)	KP	PRK	408	ISO 3166-2:KP	Asia	Eastern Asia	142	30
112	Korea (Republic of)	KR	KOR	410	ISO 3166-2:KR	Asia	Eastern Asia	142	30
113	Kuwait	KW	KWT	414	ISO 3166-2:KW	Asia	Western Asia	142	145
114	Kyrgyzstan	KG	KGZ	417	ISO 3166-2:KG	Asia	Central Asia	142	143
115	Lao People's Democratic Republic	LA	LAO	418	ISO 3166-2:LA	Asia	South-Eastern Asia	142	35
116	Latvia	LV	LVA	428	ISO 3166-2:LV	Europe	Northern Europe	150	154
117	Lebanon	LB	LBN	422	ISO 3166-2:LB	Asia	Western Asia	142	145
118	Lesotho	LS	LSO	426	ISO 3166-2:LS	Africa	Southern Africa	2	18
119	Liberia	LR	LBR	430	ISO 3166-2:LR	Africa	Western Africa	2	11
120	Libya	LY	LBY	434	ISO 3166-2:LY	Africa	Northern Africa	2	15
121	Liechtenstein	LI	LIE	438	ISO 3166-2:LI	Europe	Western Europe	150	155
122	Lithuania	LT	LTU	440	ISO 3166-2:LT	Europe	Northern Europe	150	154
123	Luxembourg	LU	LUX	442	ISO 3166-2:LU	Europe	Western Europe	150	155
124	Macao	MO	MAC	446	ISO 3166-2:MO	Asia	Eastern Asia	142	30
125	Macedonia (the former Yugoslav Republic of)	MK	MKD	807	ISO 3166-2:MK	Europe	Southern Europe	150	39
126	Madagascar	MG	MDG	450	ISO 3166-2:MG	Africa	Eastern Africa	2	14
127	Malawi	MW	MWI	454	ISO 3166-2:MW	Africa	Eastern Africa	2	14
128	Malaysia	MY	MYS	458	ISO 3166-2:MY	Asia	South-Eastern Asia	142	35
129	Maldives	MV	MDV	462	ISO 3166-2:MV	Asia	Southern Asia	142	34
130	Mali	ML	MLI	466	ISO 3166-2:ML	Africa	Western Africa	2	11
131	Malta	MT	MLT	470	ISO 3166-2:MT	Europe	Southern Europe	150	39
132	Marshall Islands	MH	MHL	584	ISO 3166-2:MH	Oceania	Micronesia	9	57
133	Martinique	MQ	MTQ	474	ISO 3166-2:MQ	Americas	Caribbean	19	29
134	Mauritania	MR	MRT	478	ISO 3166-2:MR	Africa	Western Africa	2	11
135	Mauritius	MU	MUS	480	ISO 3166-2:MU	Africa	Eastern Africa	2	14
136	Mayotte	YT	MYT	175	ISO 3166-2:YT	Africa	Eastern Africa	2	14
137	Mexico	MX	MEX	484	ISO 3166-2:MX	Americas	Central America	19	13
138	Micronesia (Federated States of)	FM	FSM	583	ISO 3166-2:FM	Oceania	Micronesia	9	57
139	Moldova (Republic of)	MD	MDA	498	ISO 3166-2:MD	Europe	Eastern Europe	150	151
140	Monaco	MC	MCO	492	ISO 3166-2:MC	Europe	Western Europe	150	155
141	Mongolia	MN	MNG	496	ISO 3166-2:MN	Asia	Eastern Asia	142	30
142	Montenegro	ME	MNE	499	ISO 3166-2:ME	Europe	Southern Europe	150	39
143	Montserrat	MS	MSR	500	ISO 3166-2:MS	Americas	Caribbean	19	29
144	Morocco	MA	MAR	504	ISO 3166-2:MA	Africa	Northern Africa	2	15
145	Mozambique	MZ	MOZ	508	ISO 3166-2:MZ	Africa	Eastern Africa	2	14
146	Myanmar	MM	MMR	104	ISO 3166-2:MM	Asia	South-Eastern Asia	142	35
147	Namibia	NA	NAM	516	ISO 3166-2:NA	Africa	Southern Africa	2	18
148	Nauru	NR	NRU	520	ISO 3166-2:NR	Oceania	Micronesia	9	57
149	Nepal	NP	NPL	524	ISO 3166-2:NP	Asia	Southern Asia	142	34
150	Netherlands	NL	NLD	528	ISO 3166-2:NL	Europe	Western Europe	150	155
151	New Caledonia	NC	NCL	540	ISO 3166-2:NC	Oceania	Melanesia	9	54
152	New Zealand	NZ	NZL	554	ISO 3166-2:NZ	Oceania	Australia and New Ze	9	53
153	Nicaragua	NI	NIC	558	ISO 3166-2:NI	Americas	Central America	19	13
154	Niger	NE	NER	562	ISO 3166-2:NE	Africa	Western Africa	2	11
155	Nigeria	NG	NGA	566	ISO 3166-2:NG	Africa	Western Africa	2	11
156	Niue	NU	NIU	570	ISO 3166-2:NU	Oceania	Polynesia	9	61
157	Norfolk Island	NF	NFK	574	ISO 3166-2:NF	Oceania	Australia and New Ze	9	53
158	Northern Mariana Islands	MP	MNP	580	ISO 3166-2:MP	Oceania	Micronesia	9	57
159	Norway	NO	NOR	578	ISO 3166-2:NO	Europe	Northern Europe	150	154
160	Oman	OM	OMN	512	ISO 3166-2:OM	Asia	Western Asia	142	145
161	Pakistan	PK	PAK	586	ISO 3166-2:PK	Asia	Southern Asia	142	34
162	Palau	PW	PLW	585	ISO 3166-2:PW	Oceania	Micronesia	9	57
163	Palestine, State of	PS	PSE	275	ISO 3166-2:PS	Asia	Western Asia	142	145
164	Panama	PA	PAN	591	ISO 3166-2:PA	Americas	Central America	19	13
165	Papua New Guinea	PG	PNG	598	ISO 3166-2:PG	Oceania	Melanesia	9	54
166	Paraguay	PY	PRY	600	ISO 3166-2:PY	Americas	South America	19	5
167	Peru	PE	PER	604	ISO 3166-2:PE	Americas	South America	19	5
168	Philippines	PH	PHL	608	ISO 3166-2:PH	Asia	South-Eastern Asia	142	35
169	Pitcairn	PN	PCN	612	ISO 3166-2:PN	Oceania	Polynesia	9	61
170	Poland	PL	POL	616	ISO 3166-2:PL	Europe	Eastern Europe	150	151
171	Portugal	PT	PRT	620	ISO 3166-2:PT	Europe	Southern Europe	150	39
172	Puerto Rico	PR	PRI	630	ISO 3166-2:PR	Americas	Caribbean	19	29
173	Qatar	QA	QAT	634	ISO 3166-2:QA	Asia	Western Asia	142	145
174	RÃ©union	RE	REU	638	ISO 3166-2:RE	Africa	Eastern Africa	2	14
175	Romania	RO	ROU	642	ISO 3166-2:RO	Europe	Eastern Europe	150	151
176	Russian Federation	RU	RUS	643	ISO 3166-2:RU	Europe	Eastern Europe	150	151
177	Rwanda	RW	RWA	646	ISO 3166-2:RW	Africa	Eastern Africa	2	14
178	Saint BarthÃ©lemy	BL	BLM	652	ISO 3166-2:BL	Americas	Caribbean	19	29
179	Saint Helena, Ascension and Tristan da Cunha	SH	SHN	654	ISO 3166-2:SH	Africa	Western Africa	2	11
180	Saint Kitts and Nevis	KN	KNA	659	ISO 3166-2:KN	Americas	Caribbean	19	29
181	Saint Lucia	LC	LCA	662	ISO 3166-2:LC	Americas	Caribbean	19	29
182	Saint Martin (French part)	MF	MAF	663	ISO 3166-2:MF	Americas	Caribbean	19	29
183	Saint Pierre and Miquelon	PM	SPM	666	ISO 3166-2:PM	Americas	Northern America	19	21
184	Saint Vincent and the Grenadines	VC	VCT	670	ISO 3166-2:VC	Americas	Caribbean	19	29
185	Samoa	WS	WSM	882	ISO 3166-2:WS	Oceania	Polynesia	9	61
186	San Marino	SM	SMR	674	ISO 3166-2:SM	Europe	Southern Europe	150	39
187	Sao Tome and Principe	ST	STP	678	ISO 3166-2:ST	Africa	Middle Africa	2	17
188	Saudi Arabia	SA	SAU	682	ISO 3166-2:SA	Asia	Western Asia	142	145
189	Senegal	SN	SEN	686	ISO 3166-2:SN	Africa	Western Africa	2	11
190	Serbia	RS	SRB	688	ISO 3166-2:RS	Europe	Southern Europe	150	39
191	Seychelles	SC	SYC	690	ISO 3166-2:SC	Africa	Eastern Africa	2	14
192	Sierra Leone	SL	SLE	694	ISO 3166-2:SL	Africa	Western Africa	2	11
193	Singapore	SG	SGP	702	ISO 3166-2:SG	Asia	South-Eastern Asia	142	35
194	Sint Maarten (Dutch part)	SX	SXM	534	ISO 3166-2:SX	Americas	Caribbean	19	29
195	Slovakia	SK	SVK	703	ISO 3166-2:SK	Europe	Eastern Europe	150	151
196	Slovenia	SI	SVN	705	ISO 3166-2:SI	Europe	Southern Europe	150	39
197	Solomon Islands	SB	SLB	90	ISO 3166-2:SB	Oceania	Melanesia	9	54
198	Somalia	SO	SOM	706	ISO 3166-2:SO	Africa	Eastern Africa	2	14
199	South Africa	ZA	ZAF	710	ISO 3166-2:ZA	Africa	Southern Africa	2	18
200	South Sudan	SS	SSD	728	ISO 3166-2:SS	Africa	Eastern Africa	2	14
201	Spain	ES	ESP	724	ISO 3166-2:ES	Europe	Southern Europe	150	39
202	Sri Lanka	LK	LKA	144	ISO 3166-2:LK	Asia	Southern Asia	142	34
203	Sudan	SD	SDN	729	ISO 3166-2:SD	Africa	Northern Africa	2	15
204	Suriname	SR	SUR	740	ISO 3166-2:SR	Americas	South America	19	5
205	Svalbard and Jan Mayen	SJ	SJM	744	ISO 3166-2:SJ	Europe	Northern Europe	150	154
206	Swaziland	SZ	SWZ	748	ISO 3166-2:SZ	Africa	Southern Africa	2	18
207	Sweden	SE	SWE	752	ISO 3166-2:SE	Europe	Northern Europe	150	154
208	Switzerland	CH	CHE	756	ISO 3166-2:CH	Europe	Western Europe	150	155
209	Syrian Arab Republic	SY	SYR	760	ISO 3166-2:SY	Asia	Western Asia	142	145
210	Taiwan, Province of China	TW	TWN	158	ISO 3166-2:TW	Asia	Eastern Asia	142	30
211	Tajikistan	TJ	TJK	762	ISO 3166-2:TJ	Asia	Central Asia	142	143
212	Tanzania, United Republic of	TZ	TZA	834	ISO 3166-2:TZ	Africa	Eastern Africa	2	14
213	Thailand	TH	THA	764	ISO 3166-2:TH	Asia	South-Eastern Asia	142	35
214	Timor-Leste	TL	TLS	626	ISO 3166-2:TL	Asia	South-Eastern Asia	142	35
215	Togo	TG	TGO	768	ISO 3166-2:TG	Africa	Western Africa	2	11
216	Tokelau	TK	TKL	772	ISO 3166-2:TK	Oceania	Polynesia	9	61
217	Tonga	TO	TON	776	ISO 3166-2:TO	Oceania	Polynesia	9	61
218	Trinidad and Tobago	TT	TTO	780	ISO 3166-2:TT	Americas	Caribbean	19	29
219	Tunisia	TN	TUN	788	ISO 3166-2:TN	Africa	Northern Africa	2	15
220	Turkey	TR	TUR	792	ISO 3166-2:TR	Asia	Western Asia	142	145
221	Turkmenistan	TM	TKM	795	ISO 3166-2:TM	Asia	Central Asia	142	143
222	Turks and Caicos Islands	TC	TCA	796	ISO 3166-2:TC	Americas	Caribbean	19	29
223	Tuvalu	TV	TUV	798	ISO 3166-2:TV	Oceania	Polynesia	9	61
224	Uganda	UG	UGA	800	ISO 3166-2:UG	Africa	Eastern Africa	2	14
225	Ukraine	UA	UKR	804	ISO 3166-2:UA	Europe	Eastern Europe	150	151
226	United Arab Emirates	AE	ARE	784	ISO 3166-2:AE	Asia	Western Asia	142	145
227	United Kingdom of Great Britain and Northern Ireland	GB	GBR	826	ISO 3166-2:GB	Europe	Northern Europe	150	154
228	United States of America	US	USA	840	ISO 3166-2:US	Americas	Northern America	19	21
229	Uruguay	UY	URY	858	ISO 3166-2:UY	Americas	South America	19	5
230	Uzbekistan	UZ	UZB	860	ISO 3166-2:UZ	Asia	Central Asia	142	143
231	Vanuatu	VU	VUT	548	ISO 3166-2:VU	Oceania	Melanesia	9	54
232	Venezuela (Bolivarian Republic of)	VE	VEN	862	ISO 3166-2:VE	Americas	South America	19	5
233	Viet Nam	VN	VNM	704	ISO 3166-2:VN	Asia	South-Eastern Asia	142	35
234	Virgin Islands (British)	VG	VGB	92	ISO 3166-2:VG	Americas	Caribbean	19	29
235	Virgin Islands (U.S.)	VI	VIR	850	ISO 3166-2:VI	Americas	Caribbean	19	29
236	Wallis and Futuna	WF	WLF	876	ISO 3166-2:WF	Oceania	Polynesia	9	61
237	Western Sahara	EH	ESH	732	ISO 3166-2:EH	Africa	Northern Africa	2	15
238	Yemen	YE	YEM	887	ISO 3166-2:YE	Asia	Western Asia	142	145
239	Zambia	ZM	ZMB	894	ISO 3166-2:ZM	Africa	Eastern Africa	2	14
240	Zimbabwe	ZW	ZWE	716	ISO 3166-2:ZW	Africa	Eastern Africa	2	14
\.


--
-- Data for Name: cuisines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuisines (id, name) FROM stdin;
1	Café
2	Modern Australian
3	Italian
4	Brunch
5	French
6	Pizza
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts (id, name, country_id) FROM stdin;
1	New South Wales	13
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, name, suburb_id) FROM stdin;
4	The Galleries	1
5	Chatswood Westfield	2
6	Darling Square	5
7	Goulburn Street	1
8	George Street	1
9	Broadway	9
10	Regent Place	1
11	Chatswood Station	2
12	Pitt Street Mall	1
13	Harbourside	12
14	Central Station	11
15	Chatswood Chase	2
\.


--
-- Data for Name: post_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_photos (id, post_id, photo) FROM stdin;
1	1	https://b.zmtcdn.com/data/reviews_photos/4e2/768396f0d2f2240303be0853341a84e2_1459007636.jpg
2	1	https://b.zmtcdn.com/data/reviews_photos/fd5/56b36df276a188e5ee74c617d24aefd5_1502800424.jpg
3	3	https://b.zmtcdn.com/data/pictures/chains/0/18347530/62820c277b3ffaa51767bc0049cbc3af.jpg
4	5	https://b.zmtcdn.com/data/pictures/chains/5/16564875/3c87693a4c32ce2fefb1c857829bc2fd.jpg
5	6	https://b.zmtcdn.com/data/pictures/chains/6/17743836/d8686af57a0418c0cd2a872ed40787d4.jpg
7	8	https://b.zmtcdn.com/data/reviews_photos/a96/f53dd28bdad35e606d482d0960aeda96_1514353691.jpg
9	8	https://b.zmtcdn.com/data/reviews_photos/2ed/b36055b55461ef9585027f3ba10e32ed_1505181523.jpg
10	8	https://b.zmtcdn.com/data/reviews_photos/8e6/9b664fd51279080febe34860481f48e6_1504497922.jpg
11	8	https://b.zmtcdn.com/data/reviews_photos/138/1fe35c8b80841cc1f2d410fcdb109138_1508660297.jpg
6	7	https://b.zmtcdn.com/data/reviews_photos/838/aa6d872963a952253080a923669f8838_1500286873.jpg
8	8	https://b.zmtcdn.com/data/pictures/chains/9/15544559/70d596499a7550ca5ac625369abd78bc.png
\.


--
-- Data for Name: post_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_reviews (id, post_id, overall_score, taste_score, service_score, value_score, ambience_score, body) FROM stdin;
3	4	good	okay	good	okay	good	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
1	1	bad	bad	bad	okay	okay	We came for the xialongbao (Shanghai soup dumplings) and weren't disappointed. These are some of the best I've ever had in my life. Fill in the order form and in a few, short moments the steamers will begin to arrive, carrying delicate dumplings, full of the tasty minced pork filling and that delicious soup. The rest of the menu is also fantastic. The only thing stopping me giving 5/5 is the price. It's pretty expensive, but certainly worth it for a special occasion. I doubt you will find better value in Sydney.
2	2	okay	good	bad	okay	good	This is the first time I had Dumplings and Co, it was a really good experience. I was shocked to see the number of options available for vegetarians. The menu was easy to understand the food was very tasty. We reached here at 5:20 and the restaurant re-opened on time, which showcased good hospitality. We ordered for vegetarian wonton soup and a vegetarian fried rice with mushroom and truffle oil, our order was served very fast and both the dishes were really tasty. We paid $24 for both, which was a good deal as the portions were good in size.
4	8	good	okay	okay	good	good	Lovely service breakfast open 7-4, nice area and food was alright, only thing have to say is it's a bit overpriced. It's better to go on the weekend, a lot of fun and nice location.
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, type, store_id, posted_by_id, posted_at) FROM stdin;
7	photo	2	4	2017-07-12 12:12:23.453
1	review	1	1	2017-01-19 15:04:20
3	photo	2	1	2017-02-07 12:54:38.249
8	review	3	4	2017-08-08 02:33:21.072
5	photo	3	1	2017-05-06 07:58:09.777
2	review	1	2	2017-01-25 09:10:55
4	review	3	2	2017-02-17 22:22:02.385
6	photo	2	3	2017-06-06 20:40:00.804
\.


--
-- Data for Name: rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rewards (id, name, description, type, store_id, store_group_id, valid_from, valid_until, promo_image, terms_and_conditions, is_active, redeemlimit) FROM stdin;
2	Free Toppings! 🍮	Come enjoy our mouth-watering tasty teas, enjoy a free topping of your choice when you purchase any large drink.	one_time	\N	3	2018-11-01	2018-12-31	https://imgur.com/KMzxoYx.jpg	\N	f	\N
3	Free Loaded Fries 🍟	8bit is all about the good times, with its wickedly delicious take on classic burgers, hotdogs, epic loaded fries and shakes. Come try one of our delicious burgers or hotdogs and get an epic loaded fries for free.	one_time	9	\N	2018-11-01	2018-12-31	https://imgur.com/3woCfTC.jpg	\N	f	\N
5	Half Price Soup Dumplings 🥟	To celebrate our grand opening, order our signature soup dumplings for only half price when you spend over $25. Available both lunch and dinner.	one_time	21	\N	2018-12-25	2018-12-25	https://imgur.com/bjJ3S72.jpg	\N	f	\N
6	$20 off $40 spend 💸	Enjoy our delicious wood-fired authentic Italian pizzas and hand-crafted pastas. Get $20 off when you spend over $40.	one_time	22	\N	2018-12-02	2018-12-02	https://imgur.com/tSE2cXf.jpg	\N	f	\N
1	Double Mex Tuesday 🌯	Buy two regular or naked burritos and get the cheaper one for free. Add two drinks for only $2! Hurry, only available this Tuesday.	one_time	\N	4	2018-11-01	2018-12-31	https://imgur.com/tR1bD1v.jpg	\N	f	\N
7	Free Coffee ☕	Purchase one of our finest authentic Kurtosh and receive any large coffee for free.	one_time	20	\N	2019-01-01	2019-12-01	https://imgur.com/9ydUqpJ.jpg	\N	f	\N
\.


--
-- Data for Name: store_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_addresses (id, store_id, address_first_line, address_second_line, address_street_number, address_street_name, google_url) FROM stdin;
3	1	Level 2, Hawker Lane	Chatswood Westfield	1	Anderson Street	https://goo.gl/maps/GZxSRicabTu
2	2	Level 1, Shop 11.04	Regent Place Arcade	487	George Street	https://goo.gl/maps/Ds7vagBoTu42
1	3	Basement Level	\N	500	George Street	https://goo.gl/maps/njQmnE8NFi52
4	4	\N	\N	22	Prince Street	https://goo.gl/maps/GZxSRicabTu
5	5	\N	\N	67	Mitchell Street	https://goo.gl/maps/GZxSRicabTu
6	6	\N	\N	36	Queen Street	https://goo.gl/maps/GZxSRicabTu
7	7	\N	\N	71	Pyrmont Street	https://goo.gl/maps/GZxSRicabTu
8	8	\N	\N	405	Victoria Street	https://goo.gl/maps/GZxSRicabTu
\.


--
-- Data for Name: store_cuisines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_cuisines (store_id, cuisine_id) FROM stdin;
1	1
1	4
2	2
3	1
3	4
4	1
7	1
8	1
5	6
6	5
\.


--
-- Data for Name: store_group_stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_group_stores (group_id, store_id) FROM stdin;
3	10
3	11
3	12
3	13
3	14
3	15
3	16
4	17
4	18
4	19
\.


--
-- Data for Name: store_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_groups (id, name) FROM stdin;
3	Coco Fresh Tea & Juice
4	Mad Mex
\.


--
-- Data for Name: store_ratings_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_ratings_cache (store_id, heart_ratings, okay_ratings, burnt_ratings) FROM stdin;
1	61	4	5
2	165	29	16
8	109	50	9
4	22	2	2
3	3	0	3
7	67	88	4
5	2	6	17
6	1	1	0
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (id, name, phone_country, phone_number, location_id, suburb_id, city_id, cover_image) FROM stdin;
4	Burn's Cafe	+61	289910090	\N	3	1	https://imgur.com/rxOxA57.jpg
5	Red Sparrow Pizza	+61	298810099	\N	3	1	https://imgur.com/q9978qK.jpg
6	Cie Lest	+61	291111089	\N	4	1	https://imgur.com/euQ3uUf.jpg
7	The Hungry Cartel	+61	281898789	\N	4	1	https://imgur.com/H7hHQe6.jpg
8	Higher Ground	+61	281565555	4	1	1	https://imgur.com/B3NiiYR.jpg
15	CoCo Fresh Tea & Juice	+61	295511312	\N	8	1	https://imgur.com/KMzxoYx.jpg
16	CoCo Fresh Tea & Juice	+61	295511312	\N	10	1	https://imgur.com/KMzxoYx.jpg
10	CoCo Fresh Tea & Juice	+61	295511312	7	1	1	https://imgur.com/KMzxoYx.jpg
11	CoCo Fresh Tea & Juice	+61	295511312	9	9	1	https://imgur.com/KMzxoYx.jpg
12	CoCo Fresh Tea & Juice	+61	295511312	10	1	1	https://imgur.com/KMzxoYx.jpg
13	CoCo Fresh Tea & Juice	+61	295511312	11	2	1	https://imgur.com/KMzxoYx.jpg
14	CoCo Fresh Tea & Juice	+61	295511312	\N	7	1	https://imgur.com/KMzxoYx.jpg
3	Workshop Meowpresso	+61	288819222	4	1	1	https://imgur.com/sLPotj2.jpg
9	8bit	+61	295511312	6	5	1	https://imgur.com/bmvua2K.jpg
2	Sokyo	+61	295258017	\N	1	1	https://imgur.com/9zJ9GvA.jpg
1	Dumplings & Co.	+61	296992235	5	2	1	https://imgur.com/9aGBDLY.jpg
17	Mad Mex	+61	295511312	12	1	1	https://imgur.com/tR1bD1v.jpg
18	Mad Mex	+61	295511312	13	12	1	https://imgur.com/tR1bD1v.jpg
19	Mad Mex	+61	295511312	14	11	1	https://imgur.com/tR1bD1v.jpg
20	Kurtosh House	+61	93562436	\N	12	1	http://insatiablemunchies.com/wp-content/uploads/2014/12/SAM_1062.jpg
21	New Shanghai	+61	926761888	15	2	1	http://s3-ap-southeast-2.amazonaws.com/newshanghai2016/pages_bgs/items/000/000/052/original/NS2017_PIC_04.jpg
22	Vapiano	+61	965511555	\N	1	1	https://res.cloudinary.com/scentre-group-au/image/fetch/c_fill,q_auto,g_faces:auto,w_2500,h_1071,f_auto/https://cam.scentregroup.io/m/5f0ea3430363225f
\.


--
-- Data for Name: suburbs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suburbs (id, name, city_id) FROM stdin;
1	CBD	1
2	Chatswood	1
3	Broken Hill	1
4	Bathurst	1
5	Haymarket	1
6	Town Hall	1
7	Chinatown	1
8	Ultimo	1
9	Glebe	1
10	Burwood	1
11	Central	1
12	Darlinghurst	1
\.


--
-- Data for Name: user_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_accounts (id, email, email_confirmed) FROM stdin;
1	psyneia@gmail.com	f
36	Kurt14242@kurt.com	f
38	Kurt14aa242@kurt.com	f
39	Kurt14aa233342@kurt.com	f
42	Kurt14aa233a342@kurt.com	f
50	psyneiaaa@gmail.com	f
45	151452@424.com	f
2745	psyneidda@gmail.com	f
43	psyneiaazza@gmail.com	f
2751	aafefeze@fefe.com	f
49	151aa4ss52@424.com	f
51	fefee@fefe.com	f
52	fefeze@fefe.com	f
2752	aafefeze@fefe.com	f
2753	psyneia@gmail.com	f
2754	psyneia@gmail.com	f
2755	psyneia@gmail.com	f
2756	psyneia@gmail.com	f
2757	psyneia@gmail.com	f
2758	fefeze@fefe.com	f
2759	psyanite@gmail.com	f
2763	psyanite@gmail.com	f
4	leia-the-slayer@gmail.com	f
2	c.c.chloe@gmail.com	f
3	annika_b@gmail.com	f
37	moefinef@gmail.com	f
\.


--
-- Data for Name: user_claims; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_claims (user_id, type, value) FROM stdin;
\.


--
-- Data for Name: user_favorite_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_rewards (user_id, reward_id) FROM stdin;
1	3
1	1
2	2
2	6
2	5
\.


--
-- Data for Name: user_favorite_stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_stores (user_id, store_id) FROM stdin;
1	2
1	3
1	1
\.


--
-- Data for Name: user_logins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_logins (social_type, social_id, user_id) FROM stdin;
facebook	134766764092722	37
facebook	985872859375	36
facebook	985872859ea375	38
facebook	98587285922ea375	39
facebook	985872859a22ea375	42
facebook	1905457aaa732907903	43
facebook	f3r32r32r3	45
facebook	f3rs32rfsfs32r3	49
facebook	124142100	51
facebook	190545773efeefef2907903	50
facebook	1241a42100	52
facebook	1905457732907903z	2745
facebook	zf2rf2	2751
facebook	1241a4210z0	2752
facebook	19aaaa07903	2753
facebook	1csc07903	2754
facebook	1905zz3	2755
facebook	1asdsd	2756
facebook	167203229291sddsds	2757
google	1164677640327081754	2759
facebook	1241a4aa2100	2758
google	116467743640327081754	1
facebook	1905457732907903	2
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (user_id, username, display_name, profile_picture, gender) FROM stdin;
1	nyatella	Luna	https://imgur.com/DAdLVwp.jpg	\N
2	curious_chloe	Curious Chloe	https://imgur.com/AwS5vPC.jpg	\N
3	annika_b	Annika	https://imgur.com/RMEkwS7.jpg	\N
4	leia	Leia	https://imgur.com/CUVkwzY.jpg	\N
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 1, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 240, true);


--
-- Name: cuisines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuisines_id_seq', 4, true);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 1, true);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_id_seq', 15, true);


--
-- Name: post_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_photos_id_seq', 5, true);


--
-- Name: post_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_reviews_id_seq', 1, false);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rewards_id_seq', 7, true);


--
-- Name: store_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_addresses_id_seq', 8, true);


--
-- Name: store_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_groups_id_seq', 4, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stores_id_seq', 22, true);


--
-- Name: suburbs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suburbs_id_seq', 12, true);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_accounts_id_seq', 2763, true);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: cuisines cuisines_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisines
    ADD CONSTRAINT cuisines_id_pk PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: post_photos post_photos_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_photos
    ADD CONSTRAINT post_photos_id_pk PRIMARY KEY (id);


--
-- Name: post_reviews post_reviews_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reviews
    ADD CONSTRAINT post_reviews_id_pk PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: rewards rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_pkey PRIMARY KEY (id);


--
-- Name: store_addresses store_addresses_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_addresses
    ADD CONSTRAINT store_addresses_id_pk PRIMARY KEY (id);


--
-- Name: store_cuisines store_cuisines_store_id_cuisine_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_store_id_cuisine_id_pk UNIQUE (store_id, cuisine_id);


--
-- Name: store_group_stores store_group_stores_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_group_stores
    ADD CONSTRAINT store_group_stores_unique UNIQUE (group_id, store_id);


--
-- Name: store_groups store_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_groups
    ADD CONSTRAINT store_groups_pkey PRIMARY KEY (id);


--
-- Name: stores stores_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_id_pk PRIMARY KEY (id);


--
-- Name: suburbs suburbs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suburbs
    ADD CONSTRAINT suburbs_pkey PRIMARY KEY (id);


--
-- Name: user_accounts user_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT user_accounts_pkey PRIMARY KEY (id);


--
-- Name: user_claims user_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_claims
    ADD CONSTRAINT user_claims_pkey PRIMARY KEY (user_id);


--
-- Name: user_favorite_stores user_favorite_stores_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_pk PRIMARY KEY (user_id, store_id);


--
-- Name: user_logins user_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_logins
    ADD CONSTRAINT user_logins_pkey PRIMARY KEY (social_type, social_id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: user_favorite_rewards user_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_pkey PRIMARY KEY (user_id, reward_id);


--
-- Name: cities_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX cities_id_uindex ON public.cities USING btree (id);


--
-- Name: cities_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cities_name ON public.cities USING btree (name);


--
-- Name: countries_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX countries_id_uindex ON public.countries USING btree (id);


--
-- Name: countries_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX countries_name ON public.countries USING btree (name);


--
-- Name: districts_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX districts_id_uindex ON public.districts USING btree (id);


--
-- Name: districts_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX districts_name ON public.districts USING btree (name);


--
-- Name: locations_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX locations_name ON public.locations USING btree (name);


--
-- Name: post_photos_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX post_photos_id_uindex ON public.post_photos USING btree (id);


--
-- Name: post_photos_photo_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_photos_photo_index ON public.post_photos USING btree (photo);


--
-- Name: post_photos_post_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_photos_post_id_index ON public.post_photos USING btree (post_id);


--
-- Name: posts_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX posts_id_uindex ON public.posts USING btree (id);


--
-- Name: rewards_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rewards_id_uindex ON public.rewards USING btree (id);


--
-- Name: store_addresses_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_addresses_id_uindex ON public.store_addresses USING btree (id);


--
-- Name: store_groups_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_groups_id_uindex ON public.store_groups USING btree (id);


--
-- Name: store_ratings_cache_store_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_ratings_cache_store_id_uindex ON public.store_ratings_cache USING btree (store_id);


--
-- Name: stores_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stores_name ON public.stores USING btree (name);


--
-- Name: suburbs_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX suburbs_name ON public.suburbs USING btree (name);


--
-- Name: user_accounts_email_confirmed_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_accounts_email_confirmed_index ON public.user_accounts USING btree (email_confirmed);


--
-- Name: user_accounts_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_accounts_email_index ON public.user_accounts USING btree (email);


--
-- Name: cities cities_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: districts districts_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: locations locations_suburb_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_suburb_id_fkey FOREIGN KEY (suburb_id) REFERENCES public.suburbs(id);


--
-- Name: post_photos post_photos_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_photos
    ADD CONSTRAINT post_photos_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: post_reviews post_reviews_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reviews
    ADD CONSTRAINT post_reviews_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: posts posts_posted_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_posted_by_id_fkey FOREIGN KEY (posted_by_id) REFERENCES public.user_accounts(id);


--
-- Name: posts posts_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: rewards rewards_store_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_store_group_id_fkey FOREIGN KEY (store_group_id) REFERENCES public.store_groups(id);


--
-- Name: rewards rewards_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: store_addresses store_addresses_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_addresses
    ADD CONSTRAINT store_addresses_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: store_cuisines store_cuisines_cuisines_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_cuisines_id_fk FOREIGN KEY (cuisine_id) REFERENCES public.cuisines(id);


--
-- Name: store_cuisines store_cuisines_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: store_group_stores store_group_stores_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_group_stores
    ADD CONSTRAINT store_group_stores_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.store_groups(id);


--
-- Name: store_group_stores store_group_stores_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_group_stores
    ADD CONSTRAINT store_group_stores_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: store_ratings_cache store_ratings_cache_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_ratings_cache
    ADD CONSTRAINT store_ratings_cache_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: suburbs suburbs_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suburbs
    ADD CONSTRAINT suburbs_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: user_claims user_claims_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_claims
    ADD CONSTRAINT user_claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_favorite_stores user_favorite_stores_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: user_favorite_stores user_favorite_stores_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_logins user_logins_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_logins
    ADD CONSTRAINT user_logins_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: user_favorite_rewards user_rewards_reward_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_reward_id_fkey FOREIGN KEY (reward_id) REFERENCES public.rewards(id);


--
-- Name: user_favorite_rewards user_rewards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- PostgreSQL database dump complete
--

