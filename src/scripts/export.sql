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
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


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

--
-- Name: f_unaccent(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT public.unaccent('public.unaccent', $1)  -- schema-qualify function and dictionary
$_$;


ALTER FUNCTION public.f_unaccent(text) OWNER TO postgres;

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
-- Name: comment_replies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_replies (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    body text,
    replied_by integer NOT NULL,
    replied_at timestamp with time zone NOT NULL
);


ALTER TABLE public.comment_replies OWNER TO postgres;

--
-- Name: comment_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_replies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_replies_id_seq OWNER TO postgres;

--
-- Name: comment_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_replies_id_seq OWNED BY public.comment_replies.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    body text NOT NULL,
    commented_by integer NOT NULL,
    commented_at timestamp with time zone
);


ALTER TABLE public.comments OWNER TO postgres;

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
-- Name: cuisine_search; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.cuisine_search AS
 SELECT cuisines.name,
    to_tsvector('english'::regconfig, public.unaccent((cuisines.name)::text)) AS document
   FROM public.cuisines
  WITH NO DATA;


ALTER TABLE public.cuisine_search OWNER TO postgres;

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
-- Name: cuisines_search; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuisines_search (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.cuisines_search OWNER TO postgres;

--
-- Name: cuisines_search_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuisines_search_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuisines_search_id_seq OWNER TO postgres;

--
-- Name: cuisines_search_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuisines_search_id_seq OWNED BY public.cuisines_search.id;


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
-- Name: suburbs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suburbs (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    city_id integer NOT NULL
);


ALTER TABLE public.suburbs OWNER TO postgres;

--
-- Name: location_search; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.location_search AS
 SELECT view.name,
    view.description,
    to_tsvector('english'::regconfig, public.unaccent((view.name)::text)) AS document
   FROM ( SELECT c.name,
            d.name AS description
           FROM (public.cities c
             LEFT JOIN public.districts d ON ((c.district_id = d.id)))
        UNION
         SELECT s.name,
            c.name AS description
           FROM (public.suburbs s
             LEFT JOIN public.cities c ON ((s.city_id = c.id)))
        UNION
         SELECT l.name,
            concat_ws(', '::text, s.name, c.name) AS description
           FROM ((public.locations l
             LEFT JOIN public.suburbs s ON ((l.suburb_id = s.id)))
             LEFT JOIN public.cities c ON ((s.city_id = c.id)))) view
  WITH NO DATA;


ALTER TABLE public.location_search OWNER TO postgres;

--
-- Name: post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_comments_id_seq OWNER TO postgres;

--
-- Name: post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_comments_id_seq OWNED BY public.comments.id;


--
-- Name: post_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_photos (
    id integer NOT NULL,
    post_id integer NOT NULL,
    url text NOT NULL
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
    posted_by integer,
    like_count integer DEFAULT 0 NOT NULL,
    comment_count integer DEFAULT 0 NOT NULL,
    hidden boolean DEFAULT true NOT NULL,
    posted_at timestamp with time zone
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
-- Name: reward_rankings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward_rankings (
    reward_id integer NOT NULL,
    rank integer NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL
);


ALTER TABLE public.reward_rankings OWNER TO postgres;

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
    active boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT true NOT NULL,
    redeem_limit integer,
    code character varying(12) NOT NULL,
    rank integer DEFAULT 99 NOT NULL
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
    address_street_number character varying(20),
    address_street_name character varying(50),
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
-- Name: store_follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_follows (
    store_id integer NOT NULL,
    follower_id integer NOT NULL
);


ALTER TABLE public.store_follows OWNER TO postgres;

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
-- Name: store_hours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_hours (
    store_id integer NOT NULL,
    "order" integer NOT NULL,
    dotw character varying(3) NOT NULL,
    hours character varying(50) NOT NULL
);


ALTER TABLE public.store_hours OWNER TO postgres;

--
-- Name: store_rankings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_rankings (
    store_id integer NOT NULL,
    rank integer NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL
);


ALTER TABLE public.store_rankings OWNER TO postgres;

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
-- Name: store_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_tags (
    store_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.store_tags OWNER TO postgres;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    id integer NOT NULL,
    name character varying(50),
    phone_country character varying(20),
    phone_number character varying(20),
    location_id integer,
    suburb_id integer NOT NULL,
    city_id integer NOT NULL,
    cover_image text,
    "order" integer DEFAULT 1 NOT NULL,
    rank integer DEFAULT 99 NOT NULL,
    follower_count integer DEFAULT 0 NOT NULL,
    review_count integer DEFAULT 0 NOT NULL,
    store_count integer DEFAULT 0 NOT NULL,
    z_id character varying(100),
    z_url character varying(255),
    more_info character varying(255),
    avg_cost integer
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
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


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
-- Name: user_favorite_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_comments (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.user_favorite_comments OWNER TO postgres;

--
-- Name: user_favorite_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.user_favorite_posts OWNER TO postgres;

--
-- Name: user_favorite_replies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_replies (
    user_id integer NOT NULL,
    reply_id integer NOT NULL
);


ALTER TABLE public.user_favorite_replies OWNER TO postgres;

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
-- Name: user_follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_follows (
    user_id integer NOT NULL,
    follower_id integer NOT NULL
);


ALTER TABLE public.user_follows OWNER TO postgres;

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
    preferred_name character varying(64),
    profile_picture text,
    gender character varying(50),
    firstname character varying(64),
    surname character varying(64),
    tagline character varying(140) DEFAULT NULL::character varying,
    follower_count integer DEFAULT 0 NOT NULL,
    store_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- Name: user_rewards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_rewards (
    user_id integer NOT NULL,
    reward_id integer NOT NULL,
    unique_code character varying(64) NOT NULL,
    redeemed_at timestamp with time zone
);


ALTER TABLE public.user_rewards OWNER TO postgres;

--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: comment_replies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies ALTER COLUMN id SET DEFAULT nextval('public.comment_replies_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.post_comments_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: cuisines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisines ALTER COLUMN id SET DEFAULT nextval('public.cuisines_id_seq'::regclass);


--
-- Name: cuisines_search id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisines_search ALTER COLUMN id SET DEFAULT nextval('public.cuisines_search_id_seq'::regclass);


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
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, name, district_id) FROM stdin;
1	Sydney	1
2	meow	1
\.


--
-- Data for Name: comment_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_replies (id, comment_id, body, replied_by, replied_at) FROM stdin;
1	1	This is lit!!!	3	2019-07-10 07:25:47.16+10
2	1	Totally.	1	2019-07-10 07:26:41.436+10
7	1	meow meow	2	2019-07-20 16:48:18.956+10
10	1	meow	2	2019-07-20 17:01:33.864+10
11	1	Unilever	2	2019-07-20 17:04:02.375+10
19	1	@curious_chloe that's so true	2	2019-07-21 16:16:10.225+10
20	1	@curious_chloe so true	2	2019-07-21 16:36:43.647+10
21	1	@curious_chloe hello kitty	2	2019-07-21 16:37:27.432+10
24	53	@curious_chloe super meow meow	2	2019-07-28 15:36:16.436+10
45	58	@curious_chloe a	2	2019-07-28 17:22:07.529+10
46	58	@curious_chloe b	2	2019-07-28 17:22:15.68+10
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, body, commented_by, commented_at) FROM stdin;
4	133	that's one cute melon	2	2019-07-14 04:22:52.803+10
1	1	this is brill, we are totally coming here next week, how about we go together after our seminar at the beach where we will have a fantastic time? I can't wait for the seminar it's going to be interactive and so full-on, I think I'm going to be knackered afterwards.	3	2019-07-11 06:31:33.937+10
3	1	how much did this all cost???	1	2019-07-14 06:31:44.507+10
2	1	omg this looks amaze	2	2019-07-15 05:31:21.677+10
5	1	hello	2	2019-07-20 13:38:27.893+10
7	1	meow meow 	2	2019-07-20 13:39:08.21+10
8	1	super	2	2019-07-20 14:29:54.154+10
9	1	hello	2	2019-07-20 14:32:07.247+10
10	1	hello	2	2019-07-20 14:44:38.498+10
11	1	kitty	2	2019-07-20 14:45:06.082+10
12	1	kitty	2	2019-07-20 14:47:26.688+10
13	1	kitty katw	2	2019-07-20 14:48:34.264+10
14	1	hello meow meow	2	2019-07-20 14:48:52.294+10
15	1	hello meow meow	2	2019-07-20 14:53:32.182+10
16	1	super duper	2	2019-07-20 14:53:40.964+10
17	1	pork bun	2	2019-07-20 15:27:25.675+10
18	1	boiiii	2	2019-07-20 15:29:17.278+10
19	1	hhh	2	2019-07-20 15:51:43.249+10
20	1	super	2	2019-07-20 15:51:55.931+10
21	1	hhhhhh	2	2019-07-20 15:52:48.822+10
22	1	jello	2	2019-07-20 15:58:29.606+10
24	1	cake	2	2019-07-20 16:00:46.821+10
25	1	pizza	2	2019-07-20 16:00:50.511+10
26	1	Mona Lisa	2	2019-07-20 16:02:39.831+10
28	1	Cheesecake	2	2019-07-20 16:03:44.592+10
29	1	Cheesey	2	2019-07-20 16:03:50.858+10
30	1	super	2	2019-07-20 16:03:57.596+10
36	1	super duper!	2	2019-07-20 20:02:50.236+10
37	1	test	2	2019-07-21 15:56:38.581+10
38	1	super	2	2019-07-21 15:58:39.51+10
39	1	. Hello	2	2019-07-21 16:00:59.515+10
40	1	hehe	2	2019-07-21 16:01:37.143+10
41	1	Vaseline	2	2019-07-21 16:05:31.905+10
42	1	rosy	2	2019-07-21 16:05:41.395+10
43	1	lip therapy	2	2019-07-21 16:07:26.228+10
44	1	a moment ago	2	2019-07-21 16:07:32.083+10
46	1	super	2	2019-07-21 16:08:46.043+10
47	1	mafia 	2	2019-07-21 16:29:28.469+10
48	1	robert	2	2019-07-21 16:30:43.893+10
49	1	the list	2	2019-07-21 16:32:03.093+10
50	134	meow meow	1	2019-07-21 19:47:43.955+10
52	134	ccc meow	1	2019-07-21 19:52:03.98+10
53	133	hello kitty	2	2019-07-28 15:36:11.085+10
57	2	hello kitty	2	2019-07-28 16:31:14.732+10
58	2	a	2	2019-07-28 17:20:58.86+10
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
8	Cafe
\.


--
-- Data for Name: cuisines_search; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuisines_search (id, name) FROM stdin;
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
17	Super Hill	13
\.


--
-- Data for Name: post_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_photos (id, post_id, url) FROM stdin;
1	1	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1.jpg?alt=media&token=b4579999-e2c9-4ce9-8f62-4d57dc875bbf
3	3	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F3.jpg?alt=media&token=200098a6-c78c-46a0-87d8-34aca27eb05f
6	7	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F6.jpg?alt=media&token=034983dd-3220-41f4-80a2-97a7f373d1d1
8	8	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F8.png?alt=media&token=056470e3-ba68-48c3-8af7-8436a57de31f
5	6	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F5.jpg?alt=media&token=03e7c7f2-f778-4c12-b77a-95e5d98d8a5f
7	8	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F7.jpg?alt=media&token=2cc4f40f-b96e-4c88-9b9f-e02f9fdbbe9e
11	8	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F11.jpg?alt=media&token=73080047-07f6-497d-a0c5-d56dad81178e
2	1	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F2.jpg?alt=media&token=7b9afbb8-e6d0-4d96-9865-3a14b96c52a0
9	8	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F9.jpg?alt=media&token=97849536-1a97-42a8-afd6-e53ce3f606a7
10	8	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F10.jpg?alt=media&token=80b65a35-2a15-45fd-a06c-81d3cbe432fa
4	5	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F4.jpg?alt=media&token=78b0181c-42f9-44c2-b434-2e47aaaf6ce9
313	133	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1562479459447-2319.jpg?alt=media&token=1acb258e-fd33-4e0c-893e-8926bca37064
314	133	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1562479459447-4805.jpg?alt=media&token=18573a40-4338-4af3-98b2-ff5dc2b498fa
315	133	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1562479459447-5771.jpg?alt=media&token=74ada1e9-efdb-4ed4-8f21-02beb8a8ef3b
317	136	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961603928-930.jpg?alt=media&token=839e90ec-a946-4e2b-970e-2360fd9b4509
318	136	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961603928-2529.jpg?alt=media&token=be550656-ddb3-40fd-aea4-dffb6b04c9c0
319	136	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961603928-4572.jpg?alt=media&token=01c3fe9e-49bc-45b3-b226-024d2b77f498
320	136	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961603928-3184.jpg?alt=media&token=d48e55e6-c90c-4a9f-bc74-47b029598b33
321	136	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961603928-528.jpg?alt=media&token=939ca1dc-af92-4734-9ba7-ec0adc3f37a8
322	137	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1563961689546-2766.jpg?alt=media&token=0d9fa64f-4888-4dd5-82db-9fa3eb280bc9
323	139	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564290835860-213.jpg?alt=media&token=544867e4-e56d-4f80-b903-03e0783bd391
324	139	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564290835860-5932.jpg?alt=media&token=7756f735-3470-48f2-bbe5-0c8969da9c50
325	142	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564901418449-1008.jpg?alt=media&token=b9126e6d-5e6d-410f-9067-296779e27fc9
326	143	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
328	147	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
329	148	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
330	149	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
331	150	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
332	151	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
333	152	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
334	153	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
335	154	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
336	155	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
337	156	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
338	157	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
339	158	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
340	159	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
341	160	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
342	161	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
343	162	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
344	163	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
345	164	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
346	165	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
347	166	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
348	167	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
349	168	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
350	169	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
351	170	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
352	171	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
353	172	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
354	173	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
355	174	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
356	175	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
357	176	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
358	177	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
359	178	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
360	179	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
361	180	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
362	181	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
363	182	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
364	183	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
365	184	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
366	185	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
367	186	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
368	187	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
369	188	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
370	189	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
371	190	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
372	191	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
373	192	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
374	193	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
375	194	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
376	195	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
377	196	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
378	197	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
379	198	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
380	199	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
381	210	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1564903094251-5258.jpg?alt=media&token=6350e510-cd74-4c3b-a46e-1b073432940f
\.


--
-- Data for Name: post_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_reviews (id, post_id, overall_score, taste_score, service_score, value_score, ambience_score, body) FROM stdin;
3	4	good	okay	good	okay	good	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
1	1	bad	bad	bad	okay	okay	We came for the xialongbao (Shanghai soup dumplings) and weren't disappointed. These are some of the best I've ever had in my life. Fill in the order form and in a few, short moments the steamers will begin to arrive, carrying delicate dumplings, full of the tasty minced pork filling and that delicious soup. The rest of the menu is also fantastic. The only thing stopping me giving 5/5 is the price. It's pretty expensive, but certainly worth it for a special occasion. I doubt you will find better value in Sydney.
2	2	okay	good	bad	okay	good	This is the first time I had Dumplings and Co, it was a really good experience. I was shocked to see the number of options available for vegetarians. The menu was easy to understand the food was very tasty. We reached here at 5:20 and the restaurant re-opened on time, which showcased good hospitality. We ordered for vegetarian wonton soup and a vegetarian fried rice with mushroom and truffle oil, our order was served very fast and both the dishes were really tasty. We paid $24 for both, which was a good deal as the portions were good in size.
4	8	good	okay	okay	good	good	Lovely service breakfast open 7-4, nice area and food was alright, only thing have to say is it's a bit overpriced. It's better to go on the weekend, a lot of fun and nice location.
122	133	okay	bad	bad	okay	okay	So tasty, highly recommend.
123	134	good	okay	bad	bad	bad	This was a pretty good experience, the staff was very attentive and friendly but not overly friendly. Would definitely go again 🌹
125	136	good	okay	okay	good	good	\N
126	137	bad	bad	bad	okay	okay	It was an interesting experience. I came here to chat with my girlfriend and we shared a bing soo. I love the flavours but it's not a lot of food. Pretty pricey but I think it's worth the money. It was really busy and we had to wait 30 minutes for a table for two on a Thursday night.
128	139	good	good	okay	okay	good	\N
131	143	okay	bad	okay	okay	good	Summer's finally here, thank goodness 🙏🙏🙏
130	142	good	okay	okay	good	good	Come try our new menu item matcha and red bean bing soo 😋 Available for a limited time only, get in quick!
134	146	okay	okay	bad	okay	okay	Buy One Get One Free!\r\nWe're doing an Anzac Day special. Buy any small or medium drink including coffee and get another one for FREE. Only available until the end of the day. For full terms and conditions see in store. Shout out your coworker or best friend and brighten up their day now! ☀️☀️☀️
135	147	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
136	148	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
137	149	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
138	150	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
139	151	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
140	152	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
141	153	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
142	154	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
143	155	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
144	156	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
145	157	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
146	158	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
147	159	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
148	160	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
149	161	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
150	162	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
151	163	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
152	164	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
153	165	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
154	166	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
155	167	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
156	168	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
157	169	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
158	170	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
159	171	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
160	172	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
161	173	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
162	174	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
163	175	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
164	176	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
165	177	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
166	178	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
167	179	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
168	180	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
169	181	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
170	182	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
171	183	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
172	184	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
173	185	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
174	186	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
175	187	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
176	188	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
177	189	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
178	190	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
179	191	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
180	191	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
181	192	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
182	193	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
183	194	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
184	195	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
185	194	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
186	195	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
187	196	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
188	197	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
189	198	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
190	199	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
191	200	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
192	201	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
193	202	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
194	203	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
195	204	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
196	205	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
197	206	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
198	207	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
199	208	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
200	209	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
201	210	okay	bad	okay	okay	okay	Consistent as always! Coffee was really good, chicken burger was juicy and saucy, and the wicked chips! Matcha cake was so light and sauce was highlight to cake, but I found it very pricey for its taste. I wouldn’t order matcha cake again, that I know for sure! Other dishes though another story :)
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, type, store_id, posted_by, like_count, comment_count, hidden, posted_at) FROM stdin;
5	photo	3	1	0	0	f	2018-05-06 17:58:09.777+10
4	review	3	2	0	0	f	2018-02-18 09:22:02.385+11
6	photo	2	3	0	0	f	2018-06-07 06:40:00.804+10
8	review	3	4	0	0	f	2018-08-08 12:33:21.072+10
7	photo	2	4	0	0	f	2018-07-12 22:12:23.453+10
1	review	1	1	0	39	f	2019-01-20 02:04:20+11
3	photo	2	1	1	0	f	2019-02-07 23:54:38.249+11
137	review	3	5	0	0	f	2019-07-24 19:48:06.909+10
136	review	3	3	0	0	f	2019-07-24 19:46:49.818+10
133	review	23	2	0	2	f	2019-07-07 16:03:48.854+10
2	review	1	2	0	2	f	2018-01-25 20:10:55+11
142	review	4	\N	0	0	f	2019-08-04 16:50:14.116+10
143	review	4	\N	0	0	f	2019-08-04 17:18:08.668+10
139	review	4	2	1	0	f	2019-07-28 15:13:56.516+10
146	review	3	\N	0	0	f	2019-08-18 15:53:54.409+10
147	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
148	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
149	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
150	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
151	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
134	review	4	2	0	2	f	2019-07-07 21:39:08.342+10
152	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
153	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
154	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
155	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
156	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
157	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
158	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
159	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
160	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
161	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
162	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
163	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
164	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
165	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
166	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
167	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
168	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
169	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
170	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
171	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
172	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
173	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
174	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
175	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
176	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
177	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
178	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
179	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
180	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
181	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
182	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
183	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
184	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
185	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
186	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
187	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
188	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
189	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
190	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
191	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
192	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
193	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
194	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
195	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
196	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
197	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
198	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
199	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
200	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
201	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
202	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
203	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
204	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
205	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
206	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
207	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
208	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
209	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
210	review	3	2	0	0	f	2019-08-18 15:53:54.409+10
\.


--
-- Data for Name: reward_rankings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reward_rankings (reward_id, rank, valid_from, valid_to) FROM stdin;
3	1	2019-08-01 00:00:00+10	2020-12-11 00:59:59+11
2	1	2019-08-01 00:00:00+10	2020-08-01 23:59:59+10
1	1	2019-08-01 00:00:00+10	2020-08-01 23:59:59+10
6	1	2019-08-01 00:00:00+10	2020-08-01 23:59:59+10
7	1	2019-08-01 00:00:00+10	2020-08-01 23:59:59+10
\.


--
-- Data for Name: rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rewards (id, name, description, type, store_id, store_group_id, valid_from, valid_until, promo_image, terms_and_conditions, active, hidden, redeem_limit, code, rank) FROM stdin;
7	Free Coffee ☕	Purchase one of our finest authentic Kurtosh and receive any large coffee for free.	one_time	20	\N	2019-01-01	2019-12-01	https://imgur.com/9ydUqpJ.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	c9VXr	1
1	Double Mex Tuesday 🌯	Buy two regular or naked burritos and get the cheaper one for free. Add two drinks for only $2! Hurry, only available this Tuesday.	one_time	\N	4	2018-11-01	2020-05-05	https://imgur.com/tR1bD1v.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	W6JVB	1
6	$20 off $40 spend 💸	Enjoy our delicious wood-fired authentic Italian pizzas and hand-crafted pastas. Get $20 off when you spend over $40.	one_time	22	\N	2018-12-02	2020-05-05	https://imgur.com/tSE2cXf.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	9WRjf	1
5	Half Price Soup Dumplings 🥟	To celebrate our grand opening, order our signature soup dumplings for only half price when you spend over $25. Available both lunch and dinner.	one_time	21	\N	2018-12-25	2020-07-09	https://imgur.com/bjJ3S72.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	JbgQP	99
8	Tea Latte Tuesday ☕	Get together for Tea Latte Tuesday. Buy a Teavana Tea Latte & score another one for FREE to share!	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/o4bRN3i.jpg	Every Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend!\r\n\r\nFree beverage must be of equal or lesser value.\r\n\r\nFrappuccino® blended beverages are excluded.\r\n\r\nEnds 26 August 2019.	t	t	\N	4pPfr	99
2	Free Toppings! 🍮	Come enjoy our mouth-watering tasty teas, enjoy a free topping of your choice when you purchase any large drink.	one_time	\N	3	2018-11-01	2020-08-23	https://imgur.com/KMzxoYx.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	WhCDD	1
3	Free Loaded Fries 🍟	8bit is all about the good times, with its wickedly delicious take on classic burgers, hotdogs, epic loaded fries and shakes. Come try one of our delicious burgers or hotdogs and get an epic loaded fries for free.	one_time	9	\N	2018-11-01	2018-05-05	https://imgur.com/3woCfTC.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	RRW2h	1
9	$3 Bagel 🥯	Nothing's better than a delicious bagel for a brighter start to the day, top it off with your favourite spread.	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/yYaJYSI.jpg	Offer only available before 10am. \r\n\r\nEvery Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend! \r\n\r\nFree beverage must be of equal or lesser value. \r\n\r\nFrappuccino® blended beverages are excluded. \r\n\r\nOffer ends 26 August 2019.\r\n	t	t	\N	BKKWL	99
\.


--
-- Data for Name: store_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_addresses (id, store_id, address_first_line, address_second_line, address_street_number, address_street_name, google_url) FROM stdin;
7	7	\N	\N	161	Castleraugh St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
27	20	Darling Square	\N	18	Nicole Walk	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
29	22	\N	\N	158	Burns Bay Rd	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
31	23	\N	\N	405	Victoria St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
28	21	B38	Chatswood Chase Sydney	345	Victoria Ave	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
26	19	Level 1 Food Court	MetCentre	273	George St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
24	17	\N	\N	88-89	Queen St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
25	18	Level 3, Shop 406a	Macquarie Centre	1	Waterloo Rd	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
22	15	\N	\N	22	Chapel Rd	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
21	14	\N	\N	1	Victoria Ave	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
23	16	\N	\N	24	Help St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
6	6	\N	\N	36	Queen St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
30	9	\N	\N	51	Tumbalong Boulevard	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
17	10	\N	\N	861	George St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
18	11	\N	\N	605	George St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
19	12	\N	\N	65-71	Grote St	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
20	13	Shop 2	\N	59	John Street	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
50	60	\N	\N	83	Foveaux Street	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
3	1	Level 1, Hawkers Lane Food	Chatswood Westfield	1	Anderson St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
2	2	Level G, The Darling	The Star	80	Pyrmont St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
1	3	Basement Level	The Star	500	George St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
5	5	\N	\N	50	Hunter St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
4	4	Shop 1	\N	276	Pitt St	https://www.google.com/maps/search/?api=1&query=crisp+cbd+the+passage+cbd+320+340+pitt+street+sydney
8	8	NO. 1, Ground Floor	Sydney GPO Building	\N	Martin Pl	https://www.google.com/maps/search/?api=1&query=taste+of+shanghai+world+square+cbd
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
23	1
60	2
60	8
\.


--
-- Data for Name: store_follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_follows (store_id, follower_id) FROM stdin;
5	2
1	2
2	2
3	2
4	2
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
-- Data for Name: store_hours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_hours (store_id, "order", dotw, hours) FROM stdin;
60	1	Mon	Closed
60	2	Tue	5:30pm - 10pm
60	3	Wed	5:30pm - 10pm
60	4	Thu	5:30pm - 10pm
60	5	Fri	11am-2pm, 5:30pm - 10pm
60	6	Sat	Closed
60	7	Sun	Closed
\.


--
-- Data for Name: store_rankings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_rankings (store_id, rank, valid_from, valid_to) FROM stdin;
1	1	2019-08-02 06:19:51.174+10	2020-08-04 06:20:01.083+10
2	1	2019-08-02 06:19:51.174+10	2020-08-04 06:20:01.083+10
3	1	2019-08-02 06:19:51.174+10	2020-08-04 06:20:01.083+10
4	1	2019-08-02 06:19:51.174+10	2020-08-04 06:20:01.083+10
5	1	2019-08-02 06:19:51.174+10	2020-08-04 06:20:01.083+10
\.


--
-- Data for Name: store_ratings_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_ratings_cache (store_id, heart_ratings, okay_ratings, burnt_ratings) FROM stdin;
8	0	0	0
11	0	0	0
19	0	0	0
4	3	1	2
21	0	0	0
14	0	0	0
3	2	0	0
17	0	0	0
22	0	0	0
20	0	0	0
7	0	0	0
9	0	0	0
13	0	0	0
10	0	0	0
1	0	1	1
5	0	0	0
18	0	0	0
2	0	0	0
16	0	0	0
15	0	0	0
6	0	0	0
12	0	0	0
23	0	0	0
\.


--
-- Data for Name: store_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_tags (store_id, tag_id) FROM stdin;
1	4
2	4
6	4
7	4
22	4
29	2
10	2
4	3
5	3
9	3
17	3
20	3
21	3
10	1
23	1
25	1
26	1
27	1
29	1
3	5
4	5
8	5
23	5
30	5
3	6
23	6
25	6
26	6
27	6
30	6
8	6
31	2
32	2
33	2
34	2
36	2
37	1
38	1
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (id, name, phone_country, phone_number, location_id, suburb_id, city_id, cover_image, "order", rank, follower_count, review_count, store_count, z_id, z_url, more_info, avg_cost) FROM stdin;
16	CoCo Fresh Tea & Juice	+61	295511312	\N	10	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
9	8bit	+61	295511312	6	5	1	https://imgur.com/bmvua2K.jpg	9	99	0	0	0	\N	\N	\N	\N
14	CoCo Fresh Tea & Juice	+61	295511312	\N	7	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
21	New Shanghai	+61	926761888	15	2	1	https://imgur.com/RVrwxN7.jpg	11	99	0	0	0	\N	\N	\N	\N
17	Mad Mex	+61	295511312	12	1	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N
13	CoCo Fresh Tea & Juice	+61	295511312	11	2	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
15	CoCo Fresh Tea & Juice	+61	295511312	\N	8	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
18	Mad Mex	+61	295511312	13	12	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N
19	Mad Mex	+61	295511312	14	11	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N
10	CoCo Fresh Tea & Juice	+61	295511312	7	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
12	CoCo Fresh Tea & Juice	+61	295511312	10	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
11	CoCo Fresh Tea & Juice	+61	295511312	9	9	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N
6	Cié Lest	+61	291111089	\N	4	1	https://imgur.com/euQ3uUf.jpg	5	99	0	0	0	\N	\N	\N	\N
2	Sokyo	+61	295258017	\N	1	1	https://imgur.com/9zJ9GvA.jpg	2	1	0	3	0	\N	\N	\N	\N
23	Anastasia Café and Eatery	+61	281565511	4	1	1	https://imgur.com/7xdUPm4.jpg	13	99	0	1	0	\N	\N	\N	\N
3	Workshop Meowpresso	+61	288819222	4	1	1	https://imgur.com/sLPotj2.jpg	3	1	0	5	0	\N	\N	\N	\N
1	Dumplings & Co.	+61	296992235	5	2	1	https://imgur.com/9aGBDLY.jpg	1	1	1	2	0	\N	\N	\N	\N
25	Bills	+61	998997123	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/c28/5af30180b449cff001d2d41eb5cd2c28_1544341757.jpg	1	99	0	0	0	\N	\N	\N	\N
26	Lorraine's Patisserie	+61	977551355	\N	13	1	https://b.zmtcdn.com/data/pictures/5/16566535/6f55afcd0e5c7b30645c4edae6303efc.jpg	1	99	0	0	0	\N	\N	\N	\N
27	Flour & Stone	+61	291191111	\N	12	1	https://b.zmtcdn.com/data/pictures/6/16564656/4ded590717ab792f34cff33c9fde11e3.jpg	1	99	0	0	0	\N	\N	\N	\N
29	Aqua S	+61	298897771	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/dd9/6e036069be9cb6f5f230c17f0cfcadd9_1552339233.jpg	1	99	0	0	0	\N	\N	\N	\N
30	Mecca Coffee Specialists	+61	298897771	\N	9	1	https://b.zmtcdn.com/data/reviews_photos/885/9275c0ec1e2ef00f4b0cd92852abc885_1477301450.jpg	1	99	0	0	0	\N	\N	\N	\N
31	Bubble Nini	+61	295258017	4	1	1	https://b.zmtcdn.com/data/pictures/3/17745593/2a0d941a5c71cc9e6b1a67b336dfe2a6.jpg	1	99	0	0	0	\N	\N	\N	\N
32	The Moment	+61	281898789	14	11	1	http://b.zmtcdn.com/data/reviews_photos/45e/9909395d1ccafe5e637890950810645e_1521863198.jpg	1	99	0	0	0	\N	\N	\N	\N
33	Mr. Tea	+61	93562436	\N	12	1	https://b.zmtcdn.com/data/pictures/4/15547454/1a52ca1626e3070bfebb32d9ca568e2d.jpg	1	99	0	0	0	\N	\N	\N	\N
34	Bean Code	+61	281898789	\N	4	1	https://b.zmtcdn.com/data/pictures/6/17742416/677976c7ecb967c9632e5e9005912994_featured_v2.jpg	1	99	0	0	0	\N	\N	\N	\N
36	Koomi	+61	291111089	\N	7	1	https://b.zmtcdn.com/data/pictures/chains/6/17747176/a5738e150615432b80bcfbdb9e83f0f5.jpg	1	99	0	0	0	\N	\N	\N	\N
37	Chapayum	+61	288819222	\N	13	1	https://b.zmtcdn.com/data/pictures/7/19018017/7c2119e91ec0f4e8c8bbb7302fa23e27.jpg	1	99	0	0	0	\N	\N	\N	\N
38	Choux Love	+61	93562436	\N	1	1	https://b.zmtcdn.com/data/reviews_photos/372/13299ecd4b16d6b896a09836b1628372_1522897753.jpg	1	99	0	0	0	\N	\N	\N	\N
60	Le Meow	+61	(02) 9211 3568	17	13	1	https://b.zmtcdn.com/data/reviews_photos/21e/cc0377b2af177b44aade56e1ed7eb21e_1542718407.jpg	1	99	0	0	0	sydney/le-meow-surry-hills	https://www.zomato.com/sydney/le-meow-surry-hills	Breakfast,Takeaway Available,No Alcohol Available	40
4	The Walrus Cafe	+61	289910090	\N	3	1	https://imgur.com/rxOxA57.jpg	4	1	0	4	0	\N	\N	\N	\N
5	Frankie's Pizza	+61	298810099	\N	3	1	https://imgur.com/q9978qK.jpg	6	1	1	0	0	\N	\N	\N	\N
20	Kürtősh	+61	93562436	\N	12	1	https://imgur.com/q6gqaXm.jpg	10	99	0	0	0	\N	\N	\N	\N
7	Pablo & Rusty's Sydney CBD	+61	281898789	\N	4	1	https://imgur.com/H7hHQe6.jpg	7	99	0	0	0	\N	\N	\N	\N
8	Maximus Cafe	+61	281565555	4	1	1	https://imgur.com/B3NiiYR.jpg	8	99	0	0	0	\N	\N	\N	\N
22	Zapparellis Pizza	+61	965511555	\N	1	1	https://imgur.com/mCuCc8p.jpg	12	99	0	0	0	\N	\N	\N	\N
\.


--
-- Data for Name: suburbs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suburbs (id, name, city_id) FROM stdin;
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
1	Sydney CBD	1
13	Surry Hills	1
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name) FROM stdin;
1	sweet
2	bubble
3	cheap
4	fancy
5	coffee
6	brunch
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
2764	eddie-huang@gmail.com	f
5	hello-meow-meow@gmail.com	f
2765	sophia_king@gmail.com	f
2766	psyanite@gmail.com	f
2767	psyanite@gmail.com	f
2768	psyanite@gmail.com	f
2769	pzyneia@gmail.com	f
\.


--
-- Data for Name: user_claims; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_claims (user_id, type, value) FROM stdin;
\.


--
-- Data for Name: user_favorite_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_comments (user_id, comment_id) FROM stdin;
2	2
2	3
2	1
2	29
2	47
\.


--
-- Data for Name: user_favorite_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_posts (user_id, post_id) FROM stdin;
2	118
2	132
2	3
2	139
\.


--
-- Data for Name: user_favorite_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_replies (user_id, reply_id) FROM stdin;
2	2
\.


--
-- Data for Name: user_favorite_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_rewards (user_id, reward_id) FROM stdin;
1	3
1	1
2	3
2	5
2	7
2	2
2	8
\.


--
-- Data for Name: user_favorite_stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_stores (user_id, store_id) FROM stdin;
1	2
1	3
1	1
2	2
2	4
2	1
2	8
2	22
2	21
2	6
2	7
2	5
\.


--
-- Data for Name: user_follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_follows (user_id, follower_id) FROM stdin;
2	1
3	1
1	2
3	2
4	2
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
facebook	1905457732907903	2
facebook	111999111999	2764
google	sophia123	2765
google	116467743640327081754	1
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (user_id, username, preferred_name, profile_picture, gender, firstname, surname, tagline, follower_count, store_count) FROM stdin;
2764	eddie_chae	Eddie	https://imgur.com/CUVkwzY.jpg	male	Edward	Perry	\N	0	0
2765	goldcoast.sophia	Sophia	https://imgur.com/ejg9ziF.jpg	female	Sophia	King	When a poet digs himself into a hole, he doesn't climb out. He digs deeper, enjoys the scenery, and comes out the other side enlightened.	0	0
1	nyatella	Luna	https://imgur.com/DAdLVwp.jpg	female	Luna	Lytele	Avid traveller, big foodie. Ramen or die! 🍜	0	3
3	annika_b	Annika	https://imgur.com/18N6fV3.jpg	female	Annika	McIntyre	🏹 Sagittarius\r\n🍜 Big Foodie\r\n📍 Tokyo, Amsterdam, Brooklyn	0	2
2	curious_chloe	Chloe	https://imgur.com/AwS5vPC.jpg	female	Chloe	Lee	🏹 Saggitarius\n✈ Tokyo, Amsterdam, and Brooklyn\n🏠 Living in Sydney\n🍜 Ramen, Pad Thai, and Boba is Lyf	0	4
4	miss.leia	Leia	https://imgur.com/CUVkwzY.jpg	female	Leia	Rochford	When a poet digs himself into a hole, he doesn't climb out. He digs deeper, enjoys the scenery, and comes out the other side enlightened.	0	2
5	evalicious	Eva	https://imgur.com/fFa9R1o.jpg	female	Eva	Seacrest	\N	0	1
\.


--
-- Data for Name: user_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_rewards (user_id, reward_id, unique_code, redeemed_at) FROM stdin;
2	7	N4CE	\N
1	1	CX1P	\N
2	9	0MYD	\N
2	8	OK1O	\N
2	3	IODE	\N
2765	2	Y8Z2	\N
2	1	5GVY	\N
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 2, true);


--
-- Name: comment_replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_replies_id_seq', 46, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 240, true);


--
-- Name: cuisines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuisines_id_seq', 8, true);


--
-- Name: cuisines_search_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuisines_search_id_seq', 1, false);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 1, true);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_id_seq', 17, true);


--
-- Name: post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_comments_id_seq', 58, true);


--
-- Name: post_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_photos_id_seq', 381, true);


--
-- Name: post_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_reviews_id_seq', 201, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 210, true);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rewards_id_seq', 9, true);


--
-- Name: store_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_addresses_id_seq', 50, true);


--
-- Name: store_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_groups_id_seq', 4, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stores_id_seq', 60, true);


--
-- Name: suburbs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suburbs_id_seq', 13, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 6, true);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_accounts_id_seq', 2769, true);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: city_locations; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.city_locations AS
 SELECT view.id,
    view.name,
    array_append(array_cat(view.suburbs, view.locations), view.name) AS locations
   FROM ( SELECT c.id,
            c.name,
            array_agg(DISTINCT s.name) AS suburbs,
            array_agg(DISTINCT l.name) AS locations
           FROM ((public.cities c
             JOIN public.suburbs s ON ((c.id = s.city_id)))
             JOIN public.locations l ON ((s.id = l.suburb_id)))
          GROUP BY c.id) view
  WITH NO DATA;


ALTER TABLE public.city_locations OWNER TO postgres;

--
-- Name: stores stores_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_id_pk PRIMARY KEY (id);


--
-- Name: store_search; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.store_search AS
 SELECT stores.id,
    stores.name,
    stores.phone_country,
    stores.phone_number,
    stores.location_id,
    stores.suburb_id,
    stores.city_id,
    stores.cover_image,
    ((((((((setweight(to_tsvector('english'::regconfig, public.unaccent((stores.name)::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(locations.name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_first_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_second_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, public.unaccent(COALESCE(string_agg((cuisines.name)::text, ' '::text), ''::text))), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_number, ''::character varying))::text), 'C'::"char")) AS document
   FROM ((((((public.stores
     LEFT JOIN public.locations ON ((stores.location_id = locations.id)))
     JOIN public.suburbs ON ((stores.suburb_id = suburbs.id)))
     JOIN public.cities ON ((stores.city_id = cities.id)))
     LEFT JOIN public.store_cuisines ON ((store_cuisines.store_id = stores.id)))
     LEFT JOIN public.cuisines ON ((store_cuisines.cuisine_id = cuisines.id)))
     JOIN public.store_addresses ON ((store_addresses.store_id = stores.id)))
  GROUP BY stores.id, locations.name, suburbs.name, cities.name, stores.cover_image, store_addresses.address_first_line, store_addresses.address_second_line, store_addresses.address_street_name, store_addresses.address_street_number
  WITH NO DATA;


ALTER TABLE public.store_search OWNER TO postgres;

--
-- Name: comment_replies comment_replies_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_pk PRIMARY KEY (id);


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
-- Name: cuisines_search cuisines_search_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisines_search
    ADD CONSTRAINT cuisines_search_pkey PRIMARY KEY (id);


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
-- Name: comments post_comments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT post_comments_pk PRIMARY KEY (id);


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
-- Name: posts posts_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pk PRIMARY KEY (id);


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
-- Name: store_tags store_tags_store_id_tag_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_tags
    ADD CONSTRAINT store_tags_store_id_tag_id_pk UNIQUE (store_id, tag_id);


--
-- Name: suburbs suburbs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suburbs
    ADD CONSTRAINT suburbs_pkey PRIMARY KEY (id);


--
-- Name: tags tags_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_id_pk PRIMARY KEY (id);


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
-- Name: user_favorite_comments user_favorite_comments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_comments
    ADD CONSTRAINT user_favorite_comments_pk PRIMARY KEY (user_id, comment_id);


--
-- Name: user_favorite_posts user_favorite_posts_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_pk PRIMARY KEY (user_id, post_id);


--
-- Name: user_favorite_replies user_favorite_replies_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_replies
    ADD CONSTRAINT user_favorite_replies_pk PRIMARY KEY (user_id, reply_id);


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
-- Name: user_rewards user_rewards_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rewards
    ADD CONSTRAINT user_rewards_pk PRIMARY KEY (user_id, reward_id);


--
-- Name: user_favorite_rewards user_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_pkey PRIMARY KEY (user_id, reward_id);


--
-- Name: cities_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cities_name ON public.cities USING btree (name);


--
-- Name: comment_replies_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX comment_replies_id_uindex ON public.comment_replies USING btree (id);


--
-- Name: comment_replies_replied_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comment_replies_replied_at_index ON public.comment_replies USING btree (replied_at);


--
-- Name: countries_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX countries_name ON public.countries USING btree (name);


--
-- Name: cuisine_search_document_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cuisine_search_document_idx ON public.cuisine_search USING btree (document);


--
-- Name: districts_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX districts_name ON public.districts USING btree (name);


--
-- Name: location_search_document_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX location_search_document_idx ON public.location_search USING btree (document);


--
-- Name: locations_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX locations_name ON public.locations USING btree (name);


--
-- Name: post_comments_commented_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_comments_commented_at_index ON public.comments USING btree (commented_at);


--
-- Name: post_comments_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX post_comments_id_uindex ON public.comments USING btree (id);


--
-- Name: post_photos_photo_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_photos_photo_index ON public.post_photos USING btree (url);


--
-- Name: post_photos_post_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_photos_post_id_index ON public.post_photos USING btree (post_id);


--
-- Name: post_reviews_post_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_reviews_post_id_index ON public.post_reviews USING btree (post_id);


--
-- Name: posts_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX posts_id_uindex ON public.posts USING btree (id);


--
-- Name: posts_posted_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_posted_at_index ON public.posts USING btree (posted_at);


--
-- Name: posts_posted_by_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_posted_by_id_index ON public.posts USING btree (posted_by);


--
-- Name: posts_secret_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_secret_index ON public.posts USING btree (hidden);


--
-- Name: posts_store_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_store_id_index ON public.posts USING btree (store_id);


--
-- Name: posts_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_type_index ON public.posts USING btree (type);


--
-- Name: reward_rankings_reward_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX reward_rankings_reward_id_uindex ON public.reward_rankings USING btree (reward_id);


--
-- Name: rewards_code_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rewards_code_uindex ON public.rewards USING btree (code);


--
-- Name: store_follows_store_id_follower_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_follows_store_id_follower_uindex ON public.store_follows USING btree (store_id, follower_id);


--
-- Name: store_rankings_store_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_rankings_store_id_uindex ON public.store_rankings USING btree (store_id);


--
-- Name: store_ratings_cache_store_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX store_ratings_cache_store_id_uindex ON public.store_ratings_cache USING btree (store_id);


--
-- Name: stores_city_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stores_city_id_index ON public.stores USING btree (city_id);


--
-- Name: stores_location_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stores_location_id_index ON public.stores USING btree (location_id);


--
-- Name: stores_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stores_name ON public.stores USING btree (name);


--
-- Name: stores_suburb_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stores_suburb_id_index ON public.stores USING btree (suburb_id);


--
-- Name: stores_z_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX stores_z_id_uindex ON public.stores USING btree (z_id);


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
-- Name: user_follows_user_id_follower_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_follows_user_id_follower_uindex ON public.user_follows USING btree (user_id, follower_id);


--
-- Name: user_rewards_redeemed_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_rewards_redeemed_at_index ON public.user_rewards USING btree (redeemed_at);


--
-- Name: user_rewards_unique_code_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_rewards_unique_code_uindex ON public.user_rewards USING btree (unique_code);


--
-- Name: cities cities_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: comment_replies comment_replies_comments_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_comments_id_fk FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_user_profiles_user_id_fk FOREIGN KEY (replied_by) REFERENCES public.user_profiles(user_id);


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
-- Name: comments post_comments_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT post_comments_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: comments post_comments_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT post_comments_user_accounts_id_fk FOREIGN KEY (commented_by) REFERENCES public.user_profiles(user_id);


--
-- Name: post_photos post_photos_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_photos
    ADD CONSTRAINT post_photos_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_reviews post_reviews_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reviews
    ADD CONSTRAINT post_reviews_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: posts posts_posted_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_posted_by_id_fkey FOREIGN KEY (posted_by) REFERENCES public.user_profiles(user_id);


--
-- Name: posts posts_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: reward_rankings reward_rankings_rewards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_rankings
    ADD CONSTRAINT reward_rankings_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES public.rewards(id);


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
    ADD CONSTRAINT store_addresses_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_cuisines store_cuisines_cuisines_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_cuisines_id_fk FOREIGN KEY (cuisine_id) REFERENCES public.cuisines(id);


--
-- Name: store_cuisines store_cuisines_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_follows store_follows_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_follows
    ADD CONSTRAINT store_follows_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_follows store_follows_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_follows
    ADD CONSTRAINT store_follows_user_profiles_user_id_fk FOREIGN KEY (follower_id) REFERENCES public.user_profiles(user_id);


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
-- Name: store_hours store_hours_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_hours
    ADD CONSTRAINT store_hours_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_rankings store_rankings_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_rankings
    ADD CONSTRAINT store_rankings_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_ratings_cache store_ratings_cache_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_ratings_cache
    ADD CONSTRAINT store_ratings_cache_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_tags store_tags_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_tags
    ADD CONSTRAINT store_tags_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_tags store_tags_tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_tags
    ADD CONSTRAINT store_tags_tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(id);


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
-- Name: user_favorite_comments user_favorite_comments_comments_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_comments
    ADD CONSTRAINT user_favorite_comments_comments_id_fk FOREIGN KEY (user_id) REFERENCES public.comments(id);


--
-- Name: user_favorite_comments user_favorite_comments_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_comments
    ADD CONSTRAINT user_favorite_comments_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_favorite_posts user_favorite_posts_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_favorite_replies user_favorite_replies_replies_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_replies
    ADD CONSTRAINT user_favorite_replies_replies_id_fk FOREIGN KEY (user_id) REFERENCES public.comment_replies(id);


--
-- Name: user_favorite_replies user_favorite_replies_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_replies
    ADD CONSTRAINT user_favorite_replies_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_favorite_stores user_favorite_stores_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: user_favorite_stores user_favorite_stores_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_follows user_follows_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id);


--
-- Name: user_follows user_follows_user_profiles_user_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk_2 FOREIGN KEY (follower_id) REFERENCES public.user_profiles(user_id);


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
-- Name: user_rewards user_rewards_rewards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rewards
    ADD CONSTRAINT user_rewards_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES public.rewards(id);


--
-- Name: user_rewards user_rewards_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rewards
    ADD CONSTRAINT user_rewards_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id);


--
-- Name: user_favorite_rewards user_rewards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id);


--
-- Name: city_locations; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.city_locations;


--
-- Name: cuisine_search; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.cuisine_search;


--
-- Name: location_search; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.location_search;


--
-- Name: store_search; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.store_search;


--
-- PostgreSQL database dump complete
--

