--
-- PostgreSQL database dump
--

-- Dumped from database version 11.6
-- Dumped by pg_dump version 11.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: croissant; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA croissant;


--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: enum_post_reviews_ambience_score; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_post_reviews_ambience_score AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: enum_post_reviews_overall_score; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_post_reviews_overall_score AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: enum_post_reviews_service_score; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_post_reviews_service_score AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: enum_post_reviews_taste_score; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_post_reviews_taste_score AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: enum_post_reviews_value_score; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_post_reviews_value_score AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: enum_posts_type; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_posts_type AS ENUM (
    'review',
    'photo'
);


--
-- Name: enum_rewards_type; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.enum_rewards_type AS ENUM (
    'one_time'
);


--
-- Name: post_type; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.post_type AS ENUM (
    'photo',
    'review'
);


--
-- Name: reward_type; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.reward_type AS ENUM (
    'one_time',
    'unlimited',
    'loyalty'
);


--
-- Name: score_type; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.score_type AS ENUM (
    'bad',
    'okay',
    'good'
);


--
-- Name: user_reward_state; Type: TYPE; Schema: croissant; Owner: -
--

CREATE TYPE croissant.user_reward_state AS ENUM (
    'active',
    'redeemed',
    'expired'
);


--
-- Name: f_unaccent(text); Type: FUNCTION; Schema: croissant; Owner: -
--

CREATE FUNCTION croissant.f_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT public.unaccent('public.unaccent', $1)  -- schema-qualify function and dictionary
$_$;


--
-- Name: hashpoint(point); Type: FUNCTION; Schema: croissant; Owner: -
--

CREATE FUNCTION croissant.hashpoint(point) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT hashfloat8($1[0]) # hashfloat8($1[1])$_$;


--
-- Name: mini(anyarray); Type: FUNCTION; Schema: croissant; Owner: -
--

CREATE FUNCTION croissant.mini(anyarray) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select min($1[i]) from generate_series(array_lower($1,1),
array_upper($1,1)) g(i);
$_$;


--
-- Name: hashpoint(point); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.hashpoint(point) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT hashfloat8($1[0]) # hashfloat8($1[1])$_$;


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.admins (
    id integer DEFAULT nextval('croissant.admins_id_seq'::regclass) NOT NULL,
    store_id integer,
    created_at timestamp with time zone NOT NULL,
    hash character varying(255) NOT NULL
);


--
-- Name: cities; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.cities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    district_id integer NOT NULL,
    coords point
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.cities_id_seq OWNED BY croissant.cities.id;


--
-- Name: comment_likes; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.comment_likes (
    user_id integer,
    comment_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


--
-- Name: comment_likes_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.comment_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.comment_likes_id_seq OWNED BY croissant.comment_likes.id;


--
-- Name: comment_replies; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.comment_replies (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    body text,
    replied_by integer,
    replied_at timestamp with time zone NOT NULL,
    replied_by_store integer,
    reply_to integer NOT NULL
);


--
-- Name: comment_replies_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.comment_replies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.comment_replies_id_seq OWNED BY croissant.comment_replies.id;


--
-- Name: comment_reply_likes; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.comment_reply_likes (
    user_id integer,
    reply_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.comment_reply_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.comment_reply_likes_id_seq OWNED BY croissant.comment_reply_likes.id;


--
-- Name: comments; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    body text NOT NULL,
    commented_by integer,
    commented_at timestamp with time zone NOT NULL,
    commented_by_store integer
);


--
-- Name: countries; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.countries (
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


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.countries_id_seq OWNED BY croissant.countries.id;


--
-- Name: cuisines; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.cuisines (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: cuisine_search; Type: MATERIALIZED VIEW; Schema: croissant; Owner: -
--

CREATE MATERIALIZED VIEW croissant.cuisine_search AS
 SELECT cuisines.name,
    to_tsvector('english'::regconfig, public.unaccent((cuisines.name)::text)) AS document
   FROM croissant.cuisines
  WITH NO DATA;


--
-- Name: cuisines_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.cuisines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cuisines_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.cuisines_id_seq OWNED BY croissant.cuisines.id;


--
-- Name: cuisines_search; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.cuisines_search (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: cuisines_search_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.cuisines_search_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cuisines_search_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.cuisines_search_id_seq OWNED BY croissant.cuisines_search.id;


--
-- Name: districts; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.districts (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    country_id integer NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.districts_id_seq OWNED BY croissant.districts.id;


--
-- Name: locations; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.locations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    suburb_id integer NOT NULL
);


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.location_id_seq OWNED BY croissant.locations.id;


--
-- Name: suburbs; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.suburbs (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    city_id integer DEFAULT 1 NOT NULL,
    postcode integer DEFAULT 1 NOT NULL,
    document tsvector,
    coords point
);


--
-- Name: location_search; Type: MATERIALIZED VIEW; Schema: croissant; Owner: -
--

CREATE MATERIALIZED VIEW croissant.location_search AS
 SELECT DISTINCT ON (view.name) view.name,
    view.description,
    view.coords,
    (setweight(to_tsvector('english'::regconfig, public.unaccent((view.name)::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, public.unaccent((view.description)::text)), 'B'::"char")) AS document
   FROM ( SELECT c.name,
            d.name AS description,
            c.coords
           FROM (croissant.cities c
             LEFT JOIN croissant.districts d ON ((c.district_id = d.id)))
        UNION ALL
         SELECT s.name,
            c.name AS description,
            s.coords
           FROM (croissant.suburbs s
             LEFT JOIN croissant.cities c ON ((s.city_id = c.id)))
        UNION ALL
         SELECT l.name,
            concat_ws(', '::text, s.name, c.name) AS description,
            s.coords
           FROM ((croissant.locations l
             LEFT JOIN croissant.suburbs s ON ((l.suburb_id = s.id)))
             LEFT JOIN croissant.cities c ON ((s.city_id = c.id)))) view
  WHERE (view.coords IS NOT NULL)
  WITH NO DATA;


--
-- Name: post_comments_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.post_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.post_comments_id_seq OWNED BY croissant.comments.id;


--
-- Name: post_likes; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.post_likes (
    user_id integer,
    post_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


--
-- Name: post_likes_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.post_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.post_likes_id_seq OWNED BY croissant.post_likes.id;


--
-- Name: post_photos; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.post_photos (
    id integer NOT NULL,
    post_id integer NOT NULL,
    url text NOT NULL
);


--
-- Name: post_photos1; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.post_photos1 (
    id integer,
    post_id integer,
    url text
);


--
-- Name: post_photos_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.post_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.post_photos_id_seq OWNED BY croissant.post_photos.id;


--
-- Name: post_reviews; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.post_reviews (
    id integer NOT NULL,
    post_id integer NOT NULL,
    overall_score croissant.score_type,
    taste_score croissant.score_type,
    service_score croissant.score_type,
    value_score croissant.score_type,
    ambience_score croissant.score_type,
    body text
);


--
-- Name: post_reviews_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.post_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.post_reviews_id_seq OWNED BY croissant.post_reviews.id;


--
-- Name: posts; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.posts (
    id integer NOT NULL,
    type croissant.post_type NOT NULL,
    store_id integer NOT NULL,
    posted_by integer NOT NULL,
    like_count integer DEFAULT 0 NOT NULL,
    comment_count integer DEFAULT 0 NOT NULL,
    hidden boolean DEFAULT true NOT NULL,
    posted_at timestamp with time zone,
    official boolean NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.posts_id_seq OWNED BY croissant.posts.id;


--
-- Name: reward_rankings; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.reward_rankings (
    reward_id integer NOT NULL,
    rank integer NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL
);


--
-- Name: rewards; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.rewards (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    description character varying,
    type croissant.reward_type,
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
    rank integer DEFAULT 99 NOT NULL,
    tags character varying(255),
    coords point[]
);


--
-- Name: store_groups; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: stores; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.stores (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
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
    more_info text,
    avg_cost integer,
    coords point
);


--
-- Name: reward_search; Type: MATERIALIZED VIEW; Schema: croissant; Owner: -
--

CREATE MATERIALIZED VIEW croissant.reward_search AS
 SELECT rewards.id,
    (((setweight(to_tsvector('english'::regconfig, public.unaccent((rewards.name)::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(rewards.tags, ''::character varying))::text), 'A'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(s.name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(sg.name, ''::character varying))::text), 'B'::"char")) AS document
   FROM ((croissant.rewards
     LEFT JOIN croissant.stores s ON ((rewards.store_id = s.id)))
     LEFT JOIN croissant.store_groups sg ON ((rewards.store_group_id = sg.id)))
  WITH NO DATA;


--
-- Name: rewards_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.rewards_id_seq OWNED BY croissant.rewards.id;


--
-- Name: store_addresses; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_addresses (
    id integer NOT NULL,
    store_id integer NOT NULL,
    address_first_line character varying(100),
    address_second_line character varying(100),
    address_street_number character varying(20),
    address_street_name character varying(50),
    google_url character varying(255)
);


--
-- Name: store_addresses_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.store_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: store_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.store_addresses_id_seq OWNED BY croissant.store_addresses.id;


--
-- Name: store_cuisines; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_cuisines (
    store_id integer NOT NULL,
    cuisine_id integer NOT NULL
);


--
-- Name: store_follows; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_follows (
    store_id integer NOT NULL,
    follower_id integer NOT NULL
);


--
-- Name: store_group_stores; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_group_stores (
    group_id integer NOT NULL,
    store_id integer NOT NULL
);


--
-- Name: store_groups_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.store_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: store_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.store_groups_id_seq OWNED BY croissant.store_groups.id;


--
-- Name: store_hours; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_hours (
    store_id integer NOT NULL,
    "order" integer NOT NULL,
    dotw character varying(3) NOT NULL,
    hours character varying(100) NOT NULL
);


--
-- Name: store_rankings; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_rankings (
    store_id integer NOT NULL,
    rank integer NOT NULL,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL
);


--
-- Name: store_ratings_cache; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_ratings_cache (
    store_id integer NOT NULL,
    heart_ratings integer DEFAULT 0 NOT NULL,
    okay_ratings integer DEFAULT 0 NOT NULL,
    burnt_ratings integer DEFAULT 0 NOT NULL
);


--
-- Name: store_tags; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.store_tags (
    store_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.stores_id_seq OWNED BY croissant.stores.id;


--
-- Name: suburbs_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.suburbs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suburbs_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.suburbs_id_seq OWNED BY croissant.suburbs.id;


--
-- Name: system_errors; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.system_errors (
    id integer NOT NULL,
    error_type character varying(64) NOT NULL,
    description character varying(255) NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: system_errors_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.system_errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.system_errors_id_seq OWNED BY croissant.system_errors.id;


--
-- Name: tags; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.tags (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.tags_id_seq OWNED BY croissant.tags.id;


--
-- Name: user_accounts; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_accounts (
    id integer NOT NULL,
    email character varying(255)
);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: croissant; Owner: -
--

CREATE SEQUENCE croissant.user_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: croissant; Owner: -
--

ALTER SEQUENCE croissant.user_accounts_id_seq OWNED BY croissant.user_accounts.id;


--
-- Name: user_claims; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_claims (
    user_id integer NOT NULL,
    type character varying(255),
    value character varying(255)
);


--
-- Name: user_favorite_posts; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_favorite_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


--
-- Name: user_favorite_rewards; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_favorite_rewards (
    user_id integer NOT NULL,
    reward_id integer NOT NULL
);


--
-- Name: user_favorite_stores; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_favorite_stores (
    user_id integer NOT NULL,
    store_id integer NOT NULL
);


--
-- Name: user_follows; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_follows (
    user_id integer NOT NULL,
    follower_id integer NOT NULL
);


--
-- Name: user_logins; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_logins (
    social_type character varying(50) NOT NULL,
    social_id character varying(100) NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: user_profiles; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_profiles (
    user_id integer NOT NULL,
    username character varying(64) NOT NULL,
    preferred_name character varying(64),
    profile_picture text,
    gender character varying(50),
    first_name character varying(64),
    last_name character varying(64),
    tagline character varying(140) DEFAULT NULL::character varying,
    follower_count integer DEFAULT 0 NOT NULL,
    store_count integer DEFAULT 0 NOT NULL,
    fcm_token character varying(255),
    admin_id integer
);


--
-- Name: user_rewards; Type: TABLE; Schema: croissant; Owner: -
--

CREATE TABLE croissant.user_rewards (
    user_id integer NOT NULL,
    reward_id integer NOT NULL,
    unique_code character varying(64) NOT NULL,
    last_redeemed_at timestamp with time zone,
    redeemed_count integer DEFAULT 0 NOT NULL
);


--
-- Name: cities id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cities ALTER COLUMN id SET DEFAULT nextval('croissant.cities_id_seq'::regclass);


--
-- Name: comment_likes id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_likes ALTER COLUMN id SET DEFAULT nextval('croissant.comment_likes_id_seq'::regclass);


--
-- Name: comment_replies id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies ALTER COLUMN id SET DEFAULT nextval('croissant.comment_replies_id_seq'::regclass);


--
-- Name: comment_reply_likes id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_reply_likes ALTER COLUMN id SET DEFAULT nextval('croissant.comment_reply_likes_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comments ALTER COLUMN id SET DEFAULT nextval('croissant.post_comments_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.countries ALTER COLUMN id SET DEFAULT nextval('croissant.countries_id_seq'::regclass);


--
-- Name: cuisines id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cuisines ALTER COLUMN id SET DEFAULT nextval('croissant.cuisines_id_seq'::regclass);


--
-- Name: cuisines_search id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cuisines_search ALTER COLUMN id SET DEFAULT nextval('croissant.cuisines_search_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.districts ALTER COLUMN id SET DEFAULT nextval('croissant.districts_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.locations ALTER COLUMN id SET DEFAULT nextval('croissant.location_id_seq'::regclass);


--
-- Name: post_likes id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_likes ALTER COLUMN id SET DEFAULT nextval('croissant.post_likes_id_seq'::regclass);


--
-- Name: post_photos id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_photos ALTER COLUMN id SET DEFAULT nextval('croissant.post_photos_id_seq'::regclass);


--
-- Name: post_reviews id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_reviews ALTER COLUMN id SET DEFAULT nextval('croissant.post_reviews_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.posts ALTER COLUMN id SET DEFAULT nextval('croissant.posts_id_seq'::regclass);


--
-- Name: rewards id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.rewards ALTER COLUMN id SET DEFAULT nextval('croissant.rewards_id_seq'::regclass);


--
-- Name: store_addresses id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_addresses ALTER COLUMN id SET DEFAULT nextval('croissant.store_addresses_id_seq'::regclass);


--
-- Name: store_groups id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_groups ALTER COLUMN id SET DEFAULT nextval('croissant.store_groups_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.stores ALTER COLUMN id SET DEFAULT nextval('croissant.stores_id_seq'::regclass);


--
-- Name: suburbs id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.suburbs ALTER COLUMN id SET DEFAULT nextval('croissant.suburbs_id_seq'::regclass);


--
-- Name: system_errors id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.system_errors ALTER COLUMN id SET DEFAULT nextval('croissant.system_errors_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.tags ALTER COLUMN id SET DEFAULT nextval('croissant.tags_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_accounts ALTER COLUMN id SET DEFAULT nextval('croissant.user_accounts_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.admins (id, store_id, created_at, hash) FROM stdin;
1	3	2019-09-15 08:43:32.443+00	$2b$10$96c0pL7AwM6H51wP5XJodOBa2VM32jFN5xhtdP3tED6GBYg4c2Pw6
3	\N	2019-10-02 10:11:32.012+00	$2b$10$GNkNdIcO132ajWMeBgTbyOhTNrp2T1ijm4KnjCOTgPzZUer7u..qK
2	8	2019-09-24 10:50:21.47+00	$2b$10$GNkNdIcO132ajWMeBgTbyOhTNrp2T1ijm4KnjCOTgPzZUer7u..qK
9	\N	2020-01-20 09:26:12.631+00	$2b$10$4WzWTj.zEPgR6xsQFcgGdOtnJZ/wuwgJkJd4zWGbVk.saVfCi3QhG
10	\N	2020-01-20 09:26:14.204+00	$2b$10$gXO69aULJYKcfy/b.gOEv.rwPAxsOsQQN.drtN40/KwQZ20pjoZty
8	8	2020-01-20 09:03:00.997+00	$2b$10$B3kjtGqyT4tc6XKrGlB.e.N.Uu/tRlK5w92Rex3mqovPrVm6A5q2W
11	\N	2020-02-01 07:09:53.178+00	$2b$10$E6/ydH8IbhF49hNdJW2wgukFORgArzIuY2nozj.l0CK.kCobl3fGG
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.cities (id, name, district_id, coords) FROM stdin;
1	Sydney	1	(-33.7948829999999987,151.268070999999992)
\.


--
-- Data for Name: comment_likes; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.comment_likes (user_id, comment_id, id, store_id) FROM stdin;
2	2	1	\N
2	3	2	\N
2	1	3	\N
\.


--
-- Data for Name: comment_replies; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.comment_replies (id, comment_id, body, replied_by, replied_at, replied_by_store, reply_to) FROM stdin;
20	1	@curious_chloe so true	2	2019-07-21 06:36:43.647+00	\N	2
21	1	@curious_chloe hello kitty	2	2019-07-21 06:37:27.432+00	\N	2
19	1	@curious_chloe that's so true	2	2019-07-21 06:16:10.225+00	\N	2
302	231	awesome	2780	2020-02-28 02:18:36.496+00	8	2
\.


--
-- Data for Name: comment_reply_likes; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.comment_reply_likes (user_id, reply_id, id, store_id) FROM stdin;
2	302	43	\N
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.comments (id, post_id, body, commented_by, commented_at, commented_by_store) FROM stdin;
4	133	that's one cute melon	2	2019-07-13 18:22:52.803+00	\N
1	1	this is brill, we are totally coming here next week, how about we go together after our seminar at the beach where we will have a fantastic time? I can't wait for the seminar it's going to be interactive and so full-on, I think I'm going to be knackered afterwards.	3	2019-07-10 20:31:33.937+00	\N
3	1	how much did this all cost???	1	2019-07-13 20:31:44.507+00	\N
2	1	omg this looks amaze	2	2019-07-14 19:31:21.677+00	\N
81	219	that's amazing ❤️❤️❤️	2	2020-01-21 08:57:05.123+00	\N
94	148	wow!	2780	2020-02-02 02:14:34.721+00	8
231	223	that's really cool 	2	2020-02-28 02:18:11.185+00	\N
232	222	Ggggg	2765	2020-02-29 06:09:11.128+00	\N
233	222	Vjvvznzbx	2765	2020-02-29 06:09:32.329+00	\N
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.countries (id, name, alpha_2, alpha_3, country_code, iso_3166_2, region, sub_region, region_code, sub_region_code) FROM stdin;
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
40	Central African Recroissant	CF	CAF	140	ISO 3166-2:CF	Africa	Middle Africa	2	17
41	Chad	TD	TCD	148	ISO 3166-2:TD	Africa	Middle Africa	2	17
42	Chile	CL	CHL	152	ISO 3166-2:CL	Americas	South America	19	5
43	China	CN	CHN	156	ISO 3166-2:CN	Asia	Eastern Asia	142	30
44	Colombia	CO	COL	170	ISO 3166-2:CO	Americas	South America	19	5
45	Comoros	KM	COM	174	ISO 3166-2:KM	Africa	Eastern Africa	2	14
46	Congo	CG	COG	178	ISO 3166-2:CG	Africa	Middle Africa	2	17
47	Congo (Democratic Recroissant of the)	CD	COD	180	ISO 3166-2:CD	Africa	Middle Africa	2	17
48	Cook Islands	CK	COK	184	ISO 3166-2:CK	Oceania	Polynesia	9	61
49	Costa Rica	CR	CRI	188	ISO 3166-2:CR	Americas	Central America	19	13
50	CÃ´te d'Ivoire	CI	CIV	384	ISO 3166-2:CI	Africa	Western Africa	2	11
51	Croatia	HR	HRV	191	ISO 3166-2:HR	Europe	Southern Europe	150	39
52	Cuba	CU	CUB	192	ISO 3166-2:CU	Americas	Caribbean	19	29
53	CuraÃ§ao	CW	CUW	531	ISO 3166-2:CW	Americas	Caribbean	19	29
54	Cyprus	CY	CYP	196	ISO 3166-2:CY	Asia	Western Asia	142	145
55	Czech Recroissant	CZ	CZE	203	ISO 3166-2:CZ	Europe	Eastern Europe	150	151
56	Denmark	DK	DNK	208	ISO 3166-2:DK	Europe	Northern Europe	150	154
57	Djibouti	DJ	DJI	262	ISO 3166-2:DJ	Africa	Eastern Africa	2	14
58	Dominica	DM	DMA	212	ISO 3166-2:DM	Americas	Caribbean	19	29
59	Dominican Recroissant	DO	DOM	214	ISO 3166-2:DO	Americas	Caribbean	19	29
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
98	Iran (Islamic Recroissant of)	IR	IRN	364	ISO 3166-2:IR	Asia	Southern Asia	142	34
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
111	Korea (Democratic People's Recroissant of)	KP	PRK	408	ISO 3166-2:KP	Asia	Eastern Asia	142	30
112	Korea (Recroissant of)	KR	KOR	410	ISO 3166-2:KR	Asia	Eastern Asia	142	30
113	Kuwait	KW	KWT	414	ISO 3166-2:KW	Asia	Western Asia	142	145
114	Kyrgyzstan	KG	KGZ	417	ISO 3166-2:KG	Asia	Central Asia	142	143
115	Lao People's Democratic Recroissant	LA	LAO	418	ISO 3166-2:LA	Asia	South-Eastern Asia	142	35
116	Latvia	LV	LVA	428	ISO 3166-2:LV	Europe	Northern Europe	150	154
117	Lebanon	LB	LBN	422	ISO 3166-2:LB	Asia	Western Asia	142	145
118	Lesotho	LS	LSO	426	ISO 3166-2:LS	Africa	Southern Africa	2	18
119	Liberia	LR	LBR	430	ISO 3166-2:LR	Africa	Western Africa	2	11
120	Libya	LY	LBY	434	ISO 3166-2:LY	Africa	Northern Africa	2	15
121	Liechtenstein	LI	LIE	438	ISO 3166-2:LI	Europe	Western Europe	150	155
122	Lithuania	LT	LTU	440	ISO 3166-2:LT	Europe	Northern Europe	150	154
123	Luxembourg	LU	LUX	442	ISO 3166-2:LU	Europe	Western Europe	150	155
124	Macao	MO	MAC	446	ISO 3166-2:MO	Asia	Eastern Asia	142	30
125	Macedonia (the former Yugoslav Recroissant of)	MK	MKD	807	ISO 3166-2:MK	Europe	Southern Europe	150	39
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
139	Moldova (Recroissant of)	MD	MDA	498	ISO 3166-2:MD	Europe	Eastern Europe	150	151
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
209	Syrian Arab Recroissant	SY	SYR	760	ISO 3166-2:SY	Asia	Western Asia	142	145
210	Taiwan, Province of China	TW	TWN	158	ISO 3166-2:TW	Asia	Eastern Asia	142	30
211	Tajikistan	TJ	TJK	762	ISO 3166-2:TJ	Asia	Central Asia	142	143
212	Tanzania, United Recroissant of	TZ	TZA	834	ISO 3166-2:TZ	Africa	Eastern Africa	2	14
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
232	Venezuela (Bolivarian Recroissant of)	VE	VEN	862	ISO 3166-2:VE	Americas	South America	19	5
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
-- Data for Name: cuisines; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.cuisines (id, name) FROM stdin;
1	Café
2	Modern Australian
3	Italian
4	Brunch
5	French
6	Pizza
8	Cafe
9	Yum Cha
10	Seafood
11	Asian
12	Chinese
13	Cantonese
14	Fusion
15	Korean
16	Fried Chicken
17	Vietnamese
18	Salad
19	Thai
20	Japanese
21	Ramen
22	Hot Pot
23	Cafe Food
24	Coffee and Tea
25	Dumplings
26	Shanghai
27	Malaysian
28	Korean BBQ
29	Sushi
30	Sichuan
31	Bar Food
32	Vegan
33	Vegetarian
34	Grill
35	Asian Fusion
36	Pho
37	Teriyaki
38	Tapas
39	BBQ
40	Malatang
41	Taiwanese
42	Bubble Tea
43	Uyghur
44	Oriental
45	Pub Food
46	Sandwich
47	Juices
48	Laotian
49	Japanese BBQ
50	Beverages
51	Tea
52	Healthy Food
53	Steak
54	Singaporean
55	Poké
56	Contemporary
57	Australian
58	Bakery
59	Indonesian
60	Indian
61	Pakistani
62	Desserts
63	Ice Cream
64	Satay
65	Street Food
66	African
67	Caribbean
68	Sri Lankan
69	International
70	Bangladeshi
71	Nepalese
72	Fast Food
73	Mexican
74	American
75	Burger
76	Fish and Chips
77	Cambodian
78	Filipino
79	Patisserie
80	Continental
81	European
82	Burmese
83	Tibetan
84	Hawaiian
85	Teppanyaki
86	Pan Asian
87	Spanish
88	Afghan
89	Brazilian
90	Charcoal Chicken
91	Middle Eastern
92	Latin American
93	Portuguese
94	Austrian
95	Falafel
96	Mongolian
97	North Indian
98	South Indian
99	Greek
100	Finger Food
101	Drinks Only
102	Diner
103	Mediterranean
104	Turkish
105	Deli
106	Lebanese
107	German
108	Moroccan
109	Arabian
110	Belgian
111	Hungarian
112	Swiss
113	Meat Pie
114	Crepes
115	Swedish
116	Kebab
117	Polish
118	Eastern European
119	Argentine
120	Soul Food
121	Brasserie
122	Modern European
123	Iranian
124	Irish
125	Peruvian
126	Ethiopian
127	Egyptian
128	Roast
129	Pastry
130	Colombian
131	Dutch
132	Israeli
133	British
134	Danish
135	Venezuelan
136	Tex-Mex
137	Creole
138	Frozen Yogurt
139	Uruguayan
140	Iraqi
141	Croatian
142	Basque
143	Fijian
144	Czech
145	Cuban
146	Turkish Pizza
\.


--
-- Data for Name: cuisines_search; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.cuisines_search (id, name) FROM stdin;
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.districts (id, name, country_id) FROM stdin;
1	New South Wales	13
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.locations (id, name, suburb_id) FROM stdin;
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
-- Data for Name: post_likes; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.post_likes (user_id, post_id, id, store_id) FROM stdin;
2	3	3	\N
2	139	4	\N
\.


--
-- Data for Name: post_photos; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.post_photos (id, post_id, url) FROM stdin;
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
388	223	https://firebasestorage.googleapis.com/v0/b/burntbutter-fix.appspot.com/o/reviews%2Fpost-photos%2F1579590677124-6907.jpg?alt=media&token=b310113f-1e13-44a6-815f-8fc817fad0c5
401	246	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1582946199522-379.jpg?alt=media&token=7b1848ba-ac7b-4bbc-ab81-fb369d56d1b4
405	252	https://firebasestorage.googleapis.com/v0/b/burntoast.appspot.com/o/reviews%2Fpost-photos%2F1587899945241-4801.jpg?alt=media&token=282f5ccb-8a14-47ab-a46d-832131b7f471
\.


--
-- Data for Name: post_photos1; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.post_photos1 (id, post_id, url) FROM stdin;
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
388	223	https://firebasestorage.googleapis.com/v0/b/burntbutter-fix.appspot.com/o/reviews%2Fpost-photos%2F1579590677124-6907.jpg?alt=media&token=b310113f-1e13-44a6-815f-8fc817fad0c5
401	246	https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/reviews%2Fpost-photos%2F1582946199522-379.jpg?alt=media&token=7b1848ba-ac7b-4bbc-ab81-fb369d56d1b4
405	252	https://firebasestorage.googleapis.com/v0/b/burntoast.appspot.com/o/reviews%2Fpost-photos%2F1587899945241-4801.jpg?alt=media&token=282f5ccb-8a14-47ab-a46d-832131b7f471
\.


--
-- Data for Name: post_reviews; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.post_reviews (id, post_id, overall_score, taste_score, service_score, value_score, ambience_score, body) FROM stdin;
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
136	148	okay	bad	okay	okay	okay	Lovely
214	223	\N	\N	\N	\N	\N	Come on down and try our new Moroccan Lamb sliders 🍔 Special introductory offer starts today ends Monday. Don't forget happy hour specials start at 4pm EVERYDAY.
210	219	good	good	okay	okay	okay	Beautiful ambience, service and food. The food is of such a high standard and there is so much variety. My favourites would have to be their sashimi, crispy tuna sushi and the beef tataki! I would definitely go again. It is the perfect spot to go to celebrate a special occasion or a wonderful date night.  There is also an amazing drink menu full of delicious cocktails.
211	220	bad	okay	okay	bad	bad	We loved Kiyomi in Gold Coast but not Sokyo. Poor service and staff quality, super loud atmosphere, food was all not as good as Kiyomi while the prices all the same or similar, overseasoning, food came so slow and got cold. We left with disappointment and will never come back.
212	221	bad	bad	okay	bad	okay	I had that potato rosti dish which was pretty small.\r\nThe staff looked completely lost, they were standing near the coffee machine doing nothing, I had to ask twice before someone took my order..\r\nThe only good thing is the coffee that's why I'm giving 2 stars and not 1.
213	222	good	good	good	good	good	Toffee vanilla choux pastry, Paris Brest (hazelnut cream) and pearidiso (?). The choux pastry and Paris brest were both absolutely delightful. Perfect sweetness level, beautiful to look at and great textural components with cream, dough and toffee caramel flavours. I personally didn’t like the yellow one as much with its chocolate coating and lemon cream filling as it lacked a wow factor for me.
237	246	good	okay	okay	good	good	I love these pancakes. Friday MUST HAVE. it's not a true Friday until I've had these pancakes. 
243	252	good	good	good	good	good	mlem
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.posts (id, type, store_id, posted_by, like_count, comment_count, hidden, posted_at, official) FROM stdin;
5	photo	3	1	0	0	f	2018-05-06 07:58:09.777+00	f
4	review	3	2	0	0	f	2018-02-17 22:22:02.385+00	f
6	photo	2	3	0	0	f	2018-06-06 20:40:00.804+00	f
8	review	3	4	0	0	f	2018-08-08 02:33:21.072+00	f
7	photo	2	4	0	0	f	2018-07-12 12:12:23.453+00	f
137	review	3	5	0	0	f	2019-07-24 09:48:06.909+00	f
136	review	3	3	0	0	f	2019-07-24 09:46:49.818+00	f
3	photo	2	1	1	0	f	2019-02-07 12:54:38.249+00	f
139	review	4	2	1	0	f	2019-07-28 05:13:56.516+00	f
134	review	4	2	0	2	f	2019-07-07 11:39:08.342+00	f
1	review	1	1	0	39	f	2019-01-19 15:04:20+00	f
133	review	23	2	0	2	f	2019-07-07 06:03:48.854+00	f
2	review	1	2	0	2	f	2018-01-25 09:10:55+00	f
221	review	23	2764	0	0	f	2020-01-16 05:53:17.911+00	f
220	review	2	5	1	0	f	2020-01-16 05:52:21.066+00	f
143	review	4	2772	0	0	f	2019-08-04 07:18:08.668+00	t
142	review	4	2771	0	0	f	2019-08-04 06:50:14.116+00	t
146	review	3	2771	0	0	f	2019-08-18 05:53:54.409+00	t
148	review	3	2	0	2	f	2019-08-18 05:53:54.409+00	f
219	review	2	3	0	1	f	2020-01-16 05:51:46.349+00	f
147	review	3	2	0	0	f	2019-08-18 05:53:54.409+00	f
223	review	8	2780	1	30	f	2020-01-21 07:09:52.977+00	t
246	review	59358	2	0	0	f	2020-02-29 03:16:47.345+00	f
222	review	26	2765	1	3	f	2020-01-16 05:53:54.244+00	f
252	review	25	2	0	0	f	2020-04-26 11:19:07.32+00	f
\.


--
-- Data for Name: reward_rankings; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.reward_rankings (reward_id, rank, valid_from, valid_to) FROM stdin;
3	1	2019-07-31 14:00:00+00	2020-12-10 13:59:59+00
2	1	2019-07-31 14:00:00+00	2020-08-01 13:59:59+00
1	1	2019-07-31 14:00:00+00	2020-08-01 13:59:59+00
6	1	2019-07-31 14:00:00+00	2020-08-01 13:59:59+00
7	1	2019-07-31 14:00:00+00	2020-08-01 13:59:59+00
\.


--
-- Data for Name: rewards; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.rewards (id, name, description, type, store_id, store_group_id, valid_from, valid_until, promo_image, terms_and_conditions, active, hidden, redeem_limit, code, rank, tags, coords) FROM stdin;
14	$1 off Mondays ☕	Pick me up Monday, get $1 off for any large drink, smoothie, and ice drinks.	one_time	25	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/9/16567979/91f31c5f267624ef8cf2ec31916fcefb.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	Jjjk2	99	coffe,cafe	{"(151.214503000000008,-33.8827220000000011)"}
12	Bring Your Own Cup Discount ☕	Take 50c off your coffee whenever you come to Mecca and bring your own cup or mug.	one_time	30	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/reviews_photos/cbb/9405cae7439688208e7028157cffccbb_1541840677.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	QQ9WR	99	coffee,cafe	{"(151.267565999999988,-33.7828960000000009)"}
13	Free Upsize 🍵	Feelin' chilly this winter? Visit Bean Code and pick up a limited edition hot taro bean milk. Free upsize available on any drink on the menu from medium to large.	one_time	34	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/6/17742416/42bdf07396559691b7c687382fa8b2cb.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	QQjk2	99	bean,drink,milk tea,bubble tea	{"(151.183624000000009,-33.7969280000000012)"}
15	$20 Pizza 🍕	Come in on Wednesday night and pick up any medium pizza for $20 from our classic range.	one_time	22	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/reviews_photos/28b/dc5c64e51622552c5312ded510ad028b_1556783562.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	jk92z	99	coffe,cafe	{"(151.146235999999988,-33.8282570000000007)"}
6	$20 off $40 spend 💸	Enjoy our delicious wood-fired authentic Italian pizzas and hand-crafted pastas. Get $20 off when you spend over $40.	one_time	22	\N	2018-12-02	2020-05-05	https://imgur.com/tSE2cXf.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	9WRjf	1	italian,pizza,pasta	{"(151.146235999999988,-33.8282570000000007)"}
7	Free Coffee ☕	Purchase one of our finest authentic Kurtosh and receive any large coffee for free.	one_time	20	\N	2019-01-01	2019-12-01	https://imgur.com/9ydUqpJ.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	c9VXr	1	coffee,cafe	{"(151.200677000000013,-33.8745380000000011)"}
11	Free Size Upgrade 🍦	Free size upgrade whenever you purchase a soft serve. All our products are a work of art.	one_time	29	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/4/16570514/ee9842022e181961c1f1b909b63ae303.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	PP9WR	99	ice cream,soft serve,dessert,sweet	{"(151.206509000000011,-33.8746709999999993)"}
2	Free Toppings! 🍮	Come enjoy our mouth-watering tasty teas, enjoy a free topping of your choice when you purchase any large drink.	one_time	\N	3	2018-11-01	2020-08-23	https://imgur.com/KMzxoYx.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	WhCDD	1	milk tea,bubble tea	{"(151.185439000000002,-33.7955789999999965)","(151.204746,-33.8810929999999999)","(151.205637999999993,-33.8738310000000027)","(151.205459999999988,-33.8775789999999972)","(151.195296000000013,-33.8843740000000011)","(151.185958999999997,-33.7944790000000026)","(151.208150999999987,-33.8590769999999992)"}
8	Tea Latte Tuesday ☕	Get together for Tea Latte Tuesday. Buy a Teavana Tea Latte & score another one for FREE to share!	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/o4bRN3i.jpg	Every Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend!\r\n\r\nFree beverage must be of equal or lesser value.\r\n\r\nFrappuccino® blended beverages are excluded.\r\n\r\nEnds 26 August 2019.	t	t	1	4pPfr	99	tea,latte,coffee,cafe	{"(151.209465999999992,-33.8394010000000023)"}
5	Half Price Soup Dumplings 🥟	To celebrate our grand opening, order our signature soup dumplings for only half price when you spend over $25. Available both lunch and dinner.	one_time	21	\N	2018-12-25	2020-07-09	https://imgur.com/bjJ3S72.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	JbgQP	99	chinese,dumplings	{"(151.208922999999999,-33.870510000000003)"}
9	$3 Bagel 🥯	Nothing's better than a delicious bagel for a brighter start to the day, top it off with your favourite spread.	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/yYaJYSI.jpg	Offer only available before 10am. \r\n\r\nEvery Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend! \r\n\r\nFree beverage must be of equal or lesser value. \r\n\r\nFrappuccino® blended beverages are excluded. \r\n\r\nOffer ends 26 August 2019.\r\n	t	t	1	BKKWL	99	cafe,bagel,coffee	{"(151.209465999999992,-33.8394010000000023)"}
17	Buy 3 get 1 free 🍵	It's simple, buy a coffee, get a star, collect 3 stars and get a free medium coffee on the house! Come talk to our friendly staff for more info. A loyalty card you can't lose.	loyalty	8	\N	2018-11-01	2020-11-05	https://b.zmtcdn.com/data/reviews_photos/d2c/a40be30a1b16c34457b2eab1490aed2c_1526978870.jpg	Offer only applies medium or large drinks.\r\nNot to be used in conjunction with any other offer.	t	f	3	9J99Q	99	coffee,cafe	{"(151.206751999999994,-33.8806530000000024)"}
16	Bingsoo Tuesday 🍦	Bingsoo Bingtwo, buy two for the price of one every Tuesday. Come into any of our participating stores, offer ends when summer is over!	unlimited	36	\N	2018-11-01	2020-11-05	https://b.zmtcdn.com/data/reviews_photos/741/b77fbeea14a19205042456a45e037741_1536399624.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	PL9Zz	99	bingsoo,sweet,ice cream,dessert, soft serve	{"(151.204940999999991,-33.8780819999999991)"}
18	$3 Bagel 🥯	Pay $1 for a bagel when you purchase a coffee. Offer applies one per person.	unlimited	8	\N	2018-11-01	2020-11-05	https://i.imgur.com/hVS4Sb1.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	9J9KM	99	cafe,bagel,coffee	{"(151.206751999999994,-33.8806530000000024)"}
19	Get $5 off Macarons 🎂	Get $5 off your purchase when you purchase a 12 or 18 box of Macarons of assorted flavours. Offer applies one per person.	one_time	8	\N	2018-11-01	2020-11-05	https://i.imgur.com/b4FTcEP.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	ZJ6JJ	99	cafe,bagel,coffee,sweets,macarons	{"(151.206751999999994,-33.8806530000000024)"}
3	Free Loaded Fries 🍟	8bit is all about the good times, with its wickedly delicious take on classic burgers, hotdogs, epic loaded fries and shakes. Come try one of our delicious burgers or hotdogs and get an epic loaded fries for free.	one_time	9	\N	2018-11-01	2018-05-05	https://imgur.com/3woCfTC.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	RRW2h	1	fries,burger,fast-food	{"(151.205338000000012,-33.872760999999997)"}
1	Double Mex Tuesday 🌯	Buy two regular or naked burritos and get the cheaper one for free. Add two drinks for only $2! Hurry, only available this Tuesday.	unlimited	\N	4	2018-11-01	2020-05-05	https://imgur.com/tR1bD1v.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	W6JVB	1	burrito,mexican	{"(151.19897499999999,-33.8717309999999969)","(151.208216999999991,-33.8659630000000007)","(151.209875000000011,-33.8620269999999977)"}
\.


--
-- Data for Name: store_addresses; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_addresses (id, store_id, address_first_line, address_second_line, address_street_number, address_street_name, google_url) FROM stdin;
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
68893	69072	Shop 8	\N	197	Military Road	\N
68913	69092	\N	\N	231	Burwood Road	\N
62948	63123	\N	\N	208	Pittwater Road	\N
68985	69165	\N	\N	23	Oaks Avenue	\N
68987	69167	\N	\N	49-52	Beecroft Road	\N
63081	63256	\N	\N	307	Military Road	\N
71612	71792	Shop 8	\N	72-80	Allison Crescent	\N
68855	69034	Shop 7	Eddy Avenue Exit	\N	Central Station	\N
68917	69096	\N	\N	729	Darling Street	\N
68937	69116	\N	\N	1,2/8	Waters Lane	\N
66178	66355	Food Court	Level 2	61-65	Albert Avenue	\N
68993	69173	\N	\N	\N	Food Court	\N
66208	66385	\N	\N	29	Bay Street	\N
71736	71916	Shop 3	\N	69	Grandview Street	\N
66156	66333	\N	\N	3	Trafalgar Place	\N
66211	66388	Shop 1	\N	58/50	MacLeay Street	\N
71620	71800	Shop 8	Illawong Shopping Village	273	Fowler Road	\N
62908	63083	\N	\N	\N	Shop 1-3/1259 Pacific Highway	\N
66308	66485	\N	\N	6/611	Military Road	\N
66312	66489	\N	\N	67	Union Street	\N
56946	57118	9A 1183-1187	\N	\N	The Horsely Drive	\N
68890	69069	\N	\N	195	Burwood Road	\N
66177	66354	\N	\N	128	Campbell Parade	\N
66242	66419	Shop 1	\N	100B	Briens Road	\N
68946	69126	Shop 3	\N	157-171	Haldon Street	\N
68973	69153	\N	\N	115	Marrickville Road	\N
66164	66341	\N	\N	22	Woodriffe Street	\N
69064	69244	Shop B2	Basement Level	7-13	Hunter Street	\N
63012	63187	\N	\N	20	Station Street	\N
63028	63203	\N	\N	158	Burns Bay Road	\N
16738	16778	\N	\N	\N	Corner of Showgrounds Road & Dawn Fraser Road	\N
66247	66424	Mr B's Hotel Mezzanine	\N	396	Pitt Street	\N
54196	54366	\N	\N	594	Harris Street	\N
69039	69219	Shop 1	\N	1040	Old Princes Highway	\N
71748	71928	Shop 1097	Level 1	236	Pacific Highway	\N
66356	66533	\N	\N	11	Amy Street	\N
71799	71979	4/1003 Pacific Hwy	Berowra 2082	\N	Sydney	\N
71880	72060	\N	\N	665-699	Merrylands Road	\N
66305	66482	Food Court	Plaza Level	36	Blue Street	\N
71918	72098	Shop 1	\N	46	Old Barrenjoey Road	\N
71951	72131	Shop 1	\N	493	Hume Highway	\N
69114	69294	Shop 27	Moorebank Shopping Village	42	Stockton Avenue	\N
69147	69327	\N	\N	79	Grandview Street	\N
63257	63432	\N	\N	171A	Burwood Road	\N
72017	72197	Shop 2	\N	488	Bunnerong Road	\N
66405	66582	Ground Floor	Gateway Building	\N	Alfred Street & Loftus Street	\N
63275	63450	\N	\N	262	Great North Road	\N
66363	66540	Shop 3	\N	100	Queen Street	\N
66402	66579	\N	\N	224	Sydney Street	\N
72042	72222	\N	\N	11-13	Main Street	\N
63433	63608	Harbord Bowling Club	\N	\N	Bennet Street	\N
66546	66723	\N	\N	288	Crown Street	\N
72096	72276	Shop T6	Matthews Arcade Building	\N	UNSW	\N
54647	54818	\N	\N	243-247	North Strathfield Road	\N
72123	72303	\N	\N	21b	Aurelia Street	\N
72166	72346	\N	\N	608	Liverpool Road	\N
66554	66731	Shop 5	\N	25-31	Kyle Parade	\N
72190	72370	\N	\N	7	Howard Avenue	\N
72277	72457	\N	\N	1349	Princes Highway	\N
72361	72541	\N	\N	7	King Street	\N
72296	72476	\N	\N	1087	Barrenjoey Road	\N
72367	72547	\N	\N	\N	Level G2/136 S Parade	\N
66509	66686	\N	\N	311	Bay Street	\N
63386	63561	\N	\N	69	Howard Avenue	\N
66598	66775	\N	\N	33	Irrigation Road	\N
72259	72439	\N	\N	101	New South Head Road	\N
66651	66828	\N	\N	111	Parramatta Road	\N
72387	72567	\N	\N	8	Croft Avenue	\N
66601	66778	\N	\N	\N	Shop 2	\N
66629	66806	D'albora Marina	\N	138	Breakfast Point Road	\N
66716	66893	\N	\N	8/40	Third Avenue	\N
72269	72449	\N	\N	165	Forest Road	\N
72298	72478	Shop 2	\N	246-250	Pitt Street	\N
72334	72514	\N	\N	147	Ramsay Street	\N
66691	66868	\N	\N	32	Burton Street	\N
63527	63702	\N	\N	154	Brougham Street	\N
72288	72468	\N	\N	25	Rooty Hill Road North	\N
54936	55107	\N	\N	27	Albion Street	\N
66915	67092	\N	\N	161	Denman Avenue	\N
72386	72566	\N	\N	997	Victoria Road	\N
69257	69437	\N	\N	27	Railway Parade	\N
66742	66919	\N	\N	197	Cabramatta Road	\N
66774	66951	\N	\N	532	Anzac Parade	\N
66704	66881	71 Great Western Hwy	Emu Plains	\N	Penrith	\N
72504	72684	\N	\N	665-699	Merrylands Road	\N
66789	66966	\N	\N	223	Windsor Street	\N
66768	66945	\N	\N	162	St Johns Road	\N
66775	66952	\N	\N	56	Delhi Road	\N
72500	72680	Shop 4	\N	1012	Forest Road	\N
63648	63823	Shop 5021	Level 5	188	Pitt Street	\N
63705	63880	Level 1	\N	396	Pitt Street	\N
63803	63978	\N	\N	45	Glebe Point Road	\N
63686	63861	\N	\N	10	Bligh Street	\N
69283	69463	\N	\N	371A	Darling St	\N
63628	63803	\N	\N	3	Bridge Lane	\N
63662	63837	\N	\N	71	George Street	\N
63738	63913	\N	\N	65	Ocean Street	\N
69272	69452	\N	\N	\N	Corner Princess Street & The Grand Parade	\N
69338	69518	\N	\N	\N	Chapel Road South	\N
63698	63873	Shop 7	\N	345	Sussex Street	\N
63725	63900	\N	\N	90	Wentworth Avenue	\N
72713	72893	2	\N	560	High Street	\N
63985	64160	\N	\N	6	Defries Avenue	\N
64002	64177	Shop 4	Myahgah Mews	3-5	Myahgah Road	\N
64035	64210	\N	\N	2/8	Central Park Avenue	\N
63945	64120	Shop 1	\N	7-9	Gibbons Street	\N
63980	64155	\N	\N	60	Riley Street	\N
72649	72829	\N	\N	1/231	Whale Beach Road	\N
67160	67338	\N	\N	7	Whistler Street	\N
63956	64131	Food Court	Pavilion On George	580	George Street	\N
72559	72739	Ground Level	Westfield Penrith Plaza	585	High Street	\N
72681	72861	Shop 9	\N	1067	Princes Highway	\N
72721	72901	\N	\N	412	Pittwater Road	\N
64034	64209	\N	\N	98	New Canterbury Road	\N
69345	69525	\N	\N	9	Wilkes Avenue	\N
67098	67276	\N	\N	532	Princes Highway	\N
67109	67287	Shop 2	Myahgah Mews	563	Military Road	\N
72709	72889	\N	\N	99	Great Western Highway	\N
72715	72895	\N	\N	2/22	Blenheim Road	\N
63952	64127	\N	\N	531	King Street	\N
72816	72996	\N	\N	561	Box Road	\N
72729	72909	\N	\N	2	Willarong Road	\N
64009	64184	\N	\N	13	Wentworth Street	\N
69371	69551	Taronga Zoo	\N	\N	Bradleys Head Road	\N
69399	69579	\N	\N	570	Box Road	\N
64113	64288	\N	\N	89	King Street	\N
64192	64367	\N	\N	537	George Street	\N
67216	67394	\N	\N	3	Military Street	\N
64075	64250	\N	\N	73	Dalhousie Street	\N
72772	72952	\N	\N	\N	Shop 13 23/31 Norton Street	\N
64254	64429	\N	\N	123	Clarence Street	\N
72786	72966	\N	\N	55	Fox Hills Crescent	\N
72818	72998	Shop 21A	Dee Why Grand	15-19	Pacific Parade	\N
64088	64263	Shop 2a	The Esplanade	\N	Balmoral Beach	\N
64203	64378	\N	\N	118	Prince Albert Street	\N
72886	73066	\N	\N	9b/10	Feldspar Road	\N
69480	69660	\N	\N	146	Beamish Street	\N
72863	73043	\N	\N	33	East Parade	\N
69489	69669	\N	\N	\N	Bonnyrigg Plaza	\N
64260	64435	Shop 3	\N	460	Elizabeth Street	\N
64325	64501	\N	\N	336	Riley Street	\N
64346	64522	\N	\N	92	Abercrombie Street	\N
67318	67496	\N	\N	157	Merrylands Road	\N
72857	73037	\N	\N	171A	Tower Street	\N
72871	73051	\N	\N	29	Rocky Point Road	\N
72860	73040	Shop 1	Rockdale Train Station	\N	Rockdale	\N
55381	55552	\N	\N	58A	Flinder Street	\N
64342	64518	Level 6	Westfield Bondi Junction	500	Oxford Street	\N
67359	67537	\N	\N	64	Railway Street	\N
69668	69848	\N	\N	11/16	East Market Street	\N
69476	69656	\N	\N	4-6	Lynton Street	\N
69567	69747	\N	\N	12	Marion Street	\N
64378	64554	\N	\N	9-11	Crofts Avenue	\N
69738	69918	\N	\N	58	Balaclava Road	\N
67326	67504	\N	\N	61	Todman Avenue	\N
67376	67554	\N	\N	252	Coogee Bay Road	\N
67511	67689	Level 2	Westfield Parramatta	159-175	Church Street	\N
64310	64486	\N	\N	16	Lyons Street	\N
67389	67567	\N	\N	1	Lakeside Road	\N
69623	69803	\N	\N	399	Pacific Highway	\N
64319	64495	\N	\N	\N	Home Hub	\N
55397	55568	\N	\N	259	Rowe Street	\N
69561	69741	Food Court	Westfield Miranda	600	Kingsway	\N
64431	64607	4	\N	224	Hamilton Road	\N
64583	64759	\N	\N	1	Swanson Street	\N
64422	64598	\N	\N	2	Moonbie Street	\N
72978	73158	\N	\N	10	Lord Street	\N
73018	73198	\N	\N	56	Marion Street	\N
73030	73210	\N	\N	141	Glenayr Avenue	\N
73035	73215	\N	\N	9	Casuarina Road	\N
73044	73224	\N	\N	16	Bungan Street	\N
73110	73290	\N	\N	26	Spit Road	\N
64409	64585	\N	\N	443	Concord Road	\N
69658	69838	Shop 4	\N	54	Foveaux Street	\N
64509	64685	Shop3	\N	338	Hamilton Road	\N
69632	69812	\N	\N	1353	Princes Highway	\N
64420	64596	\N	\N	96-100	Hay Street	\N
69680	69860	\N	\N	3/16	East Market Street	\N
67446	67624	Shop G 6/8	Century Circuit	\N	Baulkham Hills	\N
64460	64636	\N	\N	1/126	Phillip Street	\N
73019	73199	\N	\N	1621	Botany Road	\N
69685	69865	\N	\N	904	Military Road	\N
64462	64638	\N	\N	29-31	Dutton Lane	\N
64513	64689	Level 4	MCA	140	George Street	\N
73077	73257	Shop 2	\N	282	Sailors Bay Road	\N
55705	55876	\N	\N	1	Ocean Grove Avenue	\N
64574	64750	Shop 1	\N	810	Elizabeth Street	\N
69740	69920	Level 4	Westpoint Shopping Centre	17	Patrick Street	\N
73156	73336	\N	\N	241	O'Riordan Street	\N
73179	73359	Shop 58	First Floor	\N	Roselands Drive	\N
64770	64946	\N	\N	2	Kingsway	\N
64777	64953	\N	\N	85	The Grand Parade	\N
64794	64970	\N	\N	198	King Street	\N
64701	64877	\N	\N	1/96	Bronte Road	\N
64846	65022	Shop 2	\N	4A	Hillview Road	\N
64874	65050	Suite 7	\N	7	Rider Boulevard	\N
73192	73372	Orient Hotel	\N	89	George Street	\N
64676	64852	Level 1	\N	275	Pitt Street	\N
13082	13121	\N	\N	315	Anzac Parade	\N
57829	58002	Food Court	Westfield Sydney Central Plaza	450	George Street	\N
64774	64950	\N	\N	302	Church Street	\N
60423	60598	Liverpool Hospital Zone 1	Casual Dining Precinct	\N	Elizabeth Street & Goulburn Street	\N
67550	67728	\N	\N	\N	Shop 6A/2 Elizabeth Plaza	\N
13087	13126	\N	\N	\N	Shop 3/380 Forest Road	\N
67632	67810	Shop 77	Shepherds Bay Shopping Centre	11	Bay Drive	\N
73189	73369	\N	\N	1/163	Meadows Road	\N
64825	65001	\N	\N	44	Wentworth Avenue	\N
67691	67869	\N	\N	665	Darling Street	\N
67701	67879	Unit G02	Norwest Business Park	8	Century Circuit	\N
64925	65101	\N	\N	270-274	Coogee Bay Road	\N
64936	65112	\N	\N	2	Addison Road	\N
64954	65130	\N	\N	207	Coogee Bay Road	\N
69749	69929	\N	\N	41	Canley Vale Road Canley Vale	\N
67551	67729	Shop 160	\N	806	Bourke Street	\N
73215	73395	Lobby	Pavilion On George	580	George Street	\N
67723	67901	\N	\N	\N	Food Court	\N
67765	67943	2	\N	35	Missenden Road	\N
64939	65115	\N	\N	44	Dargan Street	\N
69827	70007	\N	\N	\N	Gate 2 High Street	\N
67746	67924	\N	\N	327	Chapel Road South	\N
67806	67984	Shop 1	\N	7-15	Corner Spring and Newland Street	\N
73239	73419	Shop 8	\N	2	Surf Road	\N
73363	73543	\N	\N	109	Glebe Point Road	\N
69814	69994	\N	\N	235-257	Meurants Lane	\N
64996	65172	\N	\N	163	Crown Street	\N
73265	73445	Shop 10	Camden Arcade	166-172	Argyle Street	\N
65057	65233	\N	\N	\N	Shop 5 310-330 Oxford Street	\N
65016	65192	\N	\N	171	Forest Road	\N
65069	65245	\N	\N	2	Waterways Court	\N
67792	67970	\N	\N	1/5	Burns Bay Road	\N
67901	68079	Shop 12	Suncorp Centre	259	George Street	\N
65034	65210	\N	\N	94	Wigram Street	\N
73352	73532	Ground Level	Stockland Shopping Centre	375-383	Windsor Road	\N
73357	73537	\N	\N	56	Station Street	\N
67797	67975	T1 International Departures	Pier C near Gate 56	\N	Sydney Airport	\N
67816	67994	\N	\N	1-3	Mary Street	\N
67872	68050	\N	\N	133	Regent Street	\N
67929	68107	\N	\N	102	John Street	\N
67937	68115	\N	\N	32	Cricketers Arms Road	\N
73308	73488	Food Court	Level 1	7-13	Hunter Street	\N
73325	73505	\N	\N	251	Oxford Street	\N
69838	70018	\N	\N	12/122	Katoomba Street	\N
65134	65310	\N	\N	991	Victoria Road	\N
69933	70113	\N	\N	700	Victoria Road	\N
69945	70125	Penshurst RSL	\N	58	Penshurst Street	\N
65144	65320	Shop 4	\N	81-91	Military Road	\N
69793	69973	\N	\N	22	Norton Street	\N
69822	70002	Narellan Town Centre	Shop 200	\N	Camden Valley Way	\N
65122	65298	\N	\N	364	Kent Street	\N
65141	65317	1	\N	265	Crown Street	\N
73423	73603	\N	\N	198	Main Street	\N
69849	70029	\N	\N	51	Hall Street	\N
65135	65311	\N	\N	1220	Forest Road	\N
69931	70111	Food Court	Metro Level	101	Miller Street	\N
65214	65391	Level 5	\N	55	Campbell Street	\N
73521	73701	\N	\N	382	Darling Street	\N
73568	73748	\N	\N	28	Harris Street	\N
73606	73786	\N	\N	120	Pendle Way	\N
73620	73800	Shop 6	\N	1	Kalinya Street	\N
73628	73808	Shop 2	\N	6-8	Clarke Street	\N
65234	65411	\N	\N	34	Morley Ave	\N
73551	73731	\N	\N	\N	Wharf 2	\N
70085	70265	\N	\N	\N	Location Varies	\N
73493	73673	Campus Hub Food Court Level 1	Macquarie University	\N	Macquarie Park	\N
70083	70263	Ground Floor	Gordon Centre	\N	Gordon	\N
70215	70395	\N	\N	1	Railway Parade	\N
70272	70452	Shop 12	\N	2-4	Knox Street	\N
73546	73726	\N	\N	22	Rooty Hill Road South	\N
65163	65339	\N	\N	377	Crown Street	\N
73495	73675	\N	\N	515	Pittwater Road	\N
73680	73860	North Sydney Leagues Club	Ground Level	12	Abbott Street	\N
73870	74050	\N	\N	83	Monfarville Street	\N
70005	70185	\N	\N	92	Haldon Street	\N
70017	70197	\N	\N	190	Liverpool Road	\N
73599	73779	Shop 5	\N	20	Frenchs Forest Road	\N
73688	73868	Shop 2	\N	7	Rider Boulevard	\N
73721	73901	\N	\N	12	Kleins Road	\N
65311	65488	\N	\N	9	Barbara Street	\N
73827	74007	Shop 1	\N	176	Parraweena Road	\N
73712	73892	ibis Sydney World Square	\N	382	-384 Pitt Street	\N
70095	70275	\N	\N	357	King Street	\N
73705	73885	Minto Marketplace	\N	32/10	Brookfield Road	\N
73725	73905	Shop 19	\N	61-63	Watergum Drive	\N
65341	65518	\N	\N	169~171	Rowe Street	\N
73807	73987	\N	\N	20	Argyle Street	\N
73855	74035	\N	\N	13	Orchard Road	\N
73918	74098	Flannerys Crows Nest	\N	13	Willoughby Road	\N
65354	65531	Shop 10.10	World Square Shopping Centre	644-680	George Street	\N
56608	56779	Shop 1	\N	7	Glen Street	\N
73884	74064	\N	\N	183	Queen Street	\N
65374	65551	\N	\N	81	Carrington Road	\N
70169	70349	\N	\N	98	Wollongong Road	\N
70177	70357	\N	\N	517	Elizabeth Street	\N
65514	65691	\N	\N	85	Majors Bay Road	\N
65552	65729	\N	\N	379	Glebe Point Road	\N
56642	56813	Shop 2	\N	183	Maroubra Road	\N
65409	65586	\N	\N	1	Powerhouse Road	\N
70284	70464	Pacific Square	\N	737	Anzac Parade	\N
65498	65675	\N	\N	161	Beamish Street	\N
65589	65766	\N	\N	94	McEvoy Street	\N
65612	65789	\N	\N	800	George Street	\N
70145	70325	World Square Shopping Centre	\N	644	George Street	\N
65456	65633	\N	\N	105	Moore Street	\N
70271	70451	\N	\N	13	Rochester Street	\N
70382	70562	\N	\N	11/254	Pitt St	\N
70410	70590	\N	\N	75	Thompson Street	\N
70188	70368	\N	\N	4/346	Galston Road Galston	\N
70369	70549	Level 2	Mandarin Centre	61-65	Albert Avenue	\N
70391	70571	\N	\N	1	Victoria Street	\N
65557	65734	Windsor RSL	\N	36	Argyle Street	\N
70295	70475	\N	\N	40	Mitchell Street	\N
70340	70520	Shop 1054	Level 1	600	Kingsway	\N
70434	70614	Shop 1	\N	540	Sydney Road	\N
70334	70514	\N	\N	107	Denman Road	\N
70532	70712	Shop 1	\N	321	Kent Street	\N
70394	70574	Food Court	Level G	100	Burwood Road	\N
70588	70768	\N	\N	459	Forest Road	\N
70676	70856	\N	\N	1399	Botany Road	\N
65657	65834	Shop 1-2	\N	8-14	Broadway	\N
65713	65890	\N	\N	196	Miller Street	\N
65728	65905	Pier 8-9	\N	23	Hickson Road	\N
70456	70636	\N	\N	2B	Brett Street	\N
71670	71850	\N	\N	9	Olympic Boulevard	\N
16816	16856	\N	\N	31	Bankstown City Plaza	\N
70563	70743	\N	\N	138	Great Western Highway	\N
16800	16840	\N	\N	5-7	Faversham Road	\N
70500	70680	\N	\N	\N	Lot 243 10 Kowan Road	\N
70502	70682	\N	\N	1/24	Ocean Road	\N
58841	59015	\N	\N	4669	Jenolan Caves Road	\N
70632	70812	\N	\N	\N	High Street	\N
70686	70866	Shop 14B	\N	\N	Henry Deane Plaza	\N
65741	65918	Level 1	\N	370	Victoria Ave	\N
70722	70902	Shop 1	\N	6	Progress Avenue	\N
65699	65876	Spice Alley	\N	18-20	Kensington Street	\N
70764	70944	\N	\N	\N	Exchange Place,300 Barangaroo Avenue	\N
70857	71037	\N	\N	110B	Boundary Street	\N
65721	65898	Shop KI 02	Level 1	9-13	Hay Street	\N
70948	71128	Shop 1	\N	2-14	Bayswater Road	\N
65793	65970	\N	\N	131	Church Street	\N
65802	65979	\N	\N	\N	Shop 6/27 Phillip Street	\N
59114	59288	\N	\N	4	Roslyn Street	\N
59348	59523	Shop 1	48 East Esplanade	\N	Manly	\N
70858	71038	\N	\N	16C	Lawrence Street	\N
59184	59358	\N	\N	5	Spit Road	\N
70725	70905	Darling Park	\N	201	Sussex Street	\N
65827	66004	Shop 16	\N	425	Bourke Street	\N
65838	66015	Shop 18	Ground Level	644	George Street	\N
70928	71108	\N	\N	472	Oxford Street	\N
70932	71112	Shop 2	\N	125	Great North Road	\N
65803	65980	\N	\N	50	Dixon Street	\N
70810	70990	Shop 5A	\N	13	Mount Street	\N
65920	66097	\N	\N	1	Barrack Street	\N
70846	71026	\N	\N	10A	Hilltop Road	\N
70891	71071	\N	\N	46-50	John Street	\N
71003	71183	\N	\N	546	Liverpool Road	\N
70728	70908	\N	\N	34	Tooronga Terrace	\N
65881	66058	\N	\N	180a	The Mall	\N
70863	71043	Level 3	Westfield Hornsby	236	Pacific Highway	\N
68021	68199	Shop 4	\N	1	Robey Street	\N
68025	68203	\N	\N	258	King Street	\N
65964	66141	\N	\N	440-442	Railway Parade	\N
65990	66167	\N	\N	58	Cowper Street	\N
66048	66225	\N	\N	118	Percival Road	\N
68139	68317	\N	\N	72	Botany Road	\N
17032	17072	\N	\N	265	Bondi Road	\N
65958	66135	\N	\N	7	George Street	\N
68278	68457	\N	\N	6/180	George Street	\N
65900	66077	Shop 2018	Westfield Pitt Street Mall	100	Market Street	\N
65984	66161	\N	\N	315	Clovelly Road	\N
65995	66172	\N	\N	77	Wigram Street	\N
66031	66208	\N	\N	593	King Street	\N
61457	61632	\N	\N	13	Hardie Ave	\N
72427	72607	\N	\N	63	Gymea Bay Road	\N
61331	61506	\N	\N	112	Railway Parade	\N
61557	61732	Shop 6	\N	105	Alfred Street	\N
68053	68231	\N	\N	235	Jones Street	\N
68028	68206	\N	\N	\N	A6/ 24-32 Lexington Drive	\N
68203	68382	\N	\N	233/1	Katherine Street	\N
68230	68409	Shop 8A Pierside	\N	1	Burroway Road	\N
68332	68511	\N	\N	1/128	Darlinghurst Road	\N
68159	68337	\N	\N	\N	Shop 14/11 Herbert Street	\N
68200	68379	\N	\N	361	The Kingsway	\N
68212	68391	Shop 19	\N	52	Belmore Road	\N
68263	68442	Food Court	Level 6	19	Martin Place	\N
68421	68600	Shop 16	\N	123	Liverpool Street	\N
68118	68296	\N	\N	126	Phillip Street	\N
68221	68400	\N	\N	402	Church Street	\N
63834	64009	\N	\N	80	Pyrmont Street Pyrmont	\N
68325	68504	Food Court	F14	7-13	Hunter Street	\N
64153	64328	\N	\N	1/56	Connells Point Road	\N
68502	68681	\N	\N	110e	Boundary Street	\N
68622	68801	\N	\N	3/333	Anzac Parade	\N
68371	68550	\N	\N	466	Anzac Parade	\N
62116	62291	Shop 5	Casba	18	Danks Street	\N
68406	68585	\N	\N	275	Bunnerong Road	\N
68484	68663	\N	\N	9/7	Hillcrest Road	\N
62263	62438	\N	\N	3	Bridge Street	\N
68560	68739	\N	\N	35	Heeley Street	\N
62492	62667	\N	\N	50	McCauley Street	\N
68591	68770	Kiosk 2	Cronulla Mall	\N	Cronulla	\N
68609	68788	\N	\N	482	Princes Highway	\N
68681	68860	\N	\N	209	Marion Street	\N
68736	68915	\N	\N	241	Commonwealth Street	\N
62404	62579	\N	\N	1	Careel Head Road	\N
64354	64530	\N	\N	470	Crown Street	\N
68545	68724	\N	\N	67	Military Road	\N
71068	71248	\N	\N	150	Belmore Road	\N
71202	71382	Shop 33	Moorebank Shopping Village	42	Stockton Avenue	\N
71262	71442	Level 4	Royal Prince Alfred Hospital	50	Missenden Road	\N
68487	68666	Shop 17	\N	1714	Pittwater Road	\N
68546	68725	\N	\N	15	Meagher Street	\N
68606	68785	\N	\N	50	Katoomba Street	\N
68709	68888	Level 2	Janfoss Russel building	\N	Darlington	\N
68742	68921	\N	\N	411	King Georges Road	\N
68744	68923	\N	\N	\N	Shop 24/47 Park Road	\N
71225	71405	Forum Plaza	Leonards Train Station	201-205	Pacific Highway	\N
68620	68799	\N	\N	110	Main Street	\N
68645	68824	\N	\N	2B	Brett Street	\N
68755	68934	\N	\N	74	Henry Street	\N
71196	71376	Shop B17	Basement Level	7-13	Hunter Street	\N
62362	62537	\N	\N	82	Hall Street	\N
68706	68885	World Square Shopping Centre	\N	644	George Street	\N
68769	68948	The Occidental Hotel	\N	43	York Street	\N
71355	71535	\N	\N	142	Bungaree Road	\N
71409	71589	Westleigh Shopping Centre	\N	4-8	Eucalyptus Drive	\N
71467	71647	Shop 3	\N	73-79	John Street	\N
62536	62711	\N	\N	10E	Hilltop Road	\N
71408	71588	Food Court	Shop 22	427-441	Victoria Avenue	\N
71580	71760	7 Rouse Hill Village Centre	\N	\N	Corner Windsor Road & Aberdour Avenue	\N
68791	68970	\N	\N	27-29	Oxford Road	\N
62542	62717	\N	\N	91	Macquarie Street	\N
62550	62725	\N	\N	217	Homer Street	\N
71259	71439	\N	\N	18	Anglo Road	\N
71295	71475	\N	\N	40	Waltz Street	\N
71389	71569	Shop 7-9	\N	421	Sussex Street	\N
71411	71591	\N	\N	11	Cornell Street	\N
71303	71483	\N	\N	\N	Shop 15/450 Miller Street	\N
71349	71529	Pendle Inn Hotel	\N	223	Wentworth Avenue	\N
71547	71727	\N	\N	\N	Shop 1 28-34 Railway Street	\N
17717	17757	\N	\N	77	Ware Street	\N
62580	62755	\N	\N	1/27	Mars Road	\N
71452	71632	\N	\N	45-51	Main Street	\N
71566	71746	\N	\N	83	Old Bells Line Road	\N
71579	71759	\N	\N	114	Darlinghurst Road	\N
73984	74182	\N	\N	125	Belmore Road	\N
70459	70639	\N	\N	1319	Mulgoa Road	\N
70504	70684	\N	\N	23	The Strand	\N
70626	70806	\N	\N	\N	Shop 6 1216 Mulgoa Road	\N
71432	71612	\N	\N	\N	Lower Level H141/24-32 Lexington Drive	\N
73968	74160	\N	\N	23	Letitia Street	\N
66822	66999	\N	\N	60	Carrington Street	\N
72393	72573	\N	\N	\N	Hughenden Boutique Hotel	\N
68804	68983	\N	\N	\N	Shop 1	\N
64721	64897	\N	\N	7-8	The Strand	\N
64993	65169	\N	\N	6	Sloane Street	\N
16532	16572	\N	\N	117	Cronulla Street	\N
68246	68425	\N	\N	13	The Corso	\N
73982	74180	\N	\N	\N	Corner of Raw Square and Churchill Ave	\N
53509	53679	Shop 9	Level 1	27-31	Belmore Street	\N
53692	53862	\N	\N	\N	Level 3 Food Court	\N
53975	54145	\N	\N	\N	Shop G09 51 Waterloo Street	\N
53659	53829	\N	\N	46-50	John Street	\N
53837	54007	Shop 2	\N	9	Careel Head Road	\N
\.


--
-- Data for Name: store_cuisines; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_cuisines (store_id, cuisine_id) FROM stdin;
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
65391	2
65391	14
53679	12
53679	11
53679	30
65488	58
65488	62
70902	12
70902	39
62291	91
62291	24
70944	23
65633	3
70944	24
70908	23
70908	24
65531	23
65531	24
68206	23
68206	24
73675	23
73675	24
57118	23
57118	24
65411	2
65586	23
65339	75
65339	46
68199	23
68199	24
68203	20
68203	15
70905	23
70905	24
68203	29
65551	81
65551	2
70990	90
70990	116
65518	19
65691	23
65691	24
65729	23
65729	24
73673	91
73673	116
68231	17
68231	23
68231	24
71038	10
65675	20
65766	17
65766	36
71037	58
71037	23
71037	24
65789	12
71128	46
71128	52
71043	19
73701	23
73701	106
73701	57
71026	58
71071	15
65734	2
65834	17
65834	36
71183	6
65890	3
65890	6
65890	33
65876	11
65898	41
65970	12
65979	20
65979	29
71108	23
71108	24
65918	17
65918	11
71112	72
71112	90
65918	36
68337	23
73726	12
68337	24
68379	60
65905	23
65905	24
65980	12
65980	22
68317	19
68296	47
68296	52
68296	33
66004	5
66004	3
66004	81
66015	41
66077	23
66077	24
66077	58
66077	50
66077	134
66077	18
66077	75
66077	72
71248	73
71248	136
73731	76
73748	23
68457	24
68457	23
68457	75
66058	23
66058	24
71382	12
71442	23
71442	24
62438	3
68382	15
68382	22
66172	12
68409	11
66172	60
68409	12
68409	25
66208	19
66097	3
68400	104
68400	6
68425	113
68425	23
68425	24
62579	6
62579	3
68391	19
66135	2
71376	46
71376	23
71376	24
68442	23
68442	24
73779	24
73779	23
66141	3
66141	6
66167	45
66167	75
68504	19
66225	99
66225	2
73786	27
73786	60
73800	19
62537	91
62537	33
66161	23
66161	24
53829	11
71535	24
71535	23
62711	3
62711	6
71405	52
68511	24
68511	23
68550	54
71439	23
71439	24
68585	103
71475	23
71475	24
62667	23
62667	24
68663	17
68663	23
68663	24
71483	24
71483	23
68600	12
68600	22
71529	45
71529	34
71529	10
68724	20
68724	23
68724	24
71588	29
71612	19
66355	11
66355	12
73808	23
73808	24
71569	12
71569	22
62717	58
62717	62
62725	3
71591	11
62725	6
53862	11
53862	20
53862	29
66341	19
66385	3
66482	10
66482	76
66482	52
54007	11
54007	14
71632	6
71632	31
71589	2
71647	17
66333	10
66388	5
66485	23
66485	24
66489	105
66489	23
66489	24
73885	72
62755	46
62755	72
71727	60
71727	61
66354	10
68681	10
73892	31
66540	60
66540	33
73860	23
73860	24
68770	23
68666	11
68666	10
66424	19
68666	19
71746	23
71746	24
71759	31
71759	2
73868	12
73901	19
68725	23
68725	24
68785	11
68785	2
66419	19
73905	24
73905	62
71760	23
71760	24
66533	12
66533	10
68739	57
68739	23
73987	91
68739	24
74035	20
74035	24
68799	88
66582	99
74007	23
74007	24
66723	23
66723	24
66579	15
66579	23
66579	24
66579	11
66579	35
66579	52
66579	32
66579	33
71792	17
74050	6
74050	3
66686	19
66775	3
66775	6
66778	12
66778	9
66828	20
68770	24
54145	20
54145	29
54145	38
68788	23
68788	24
68860	27
68915	118
68915	23
68915	24
16572	63
16572	24
68801	23
68801	24
54366	27
54366	65
54366	11
71800	23
71800	24
66731	23
66731	24
68888	23
68888	24
68921	59
68923	19
66806	103
66806	10
66806	2
66893	60
66893	33
68970	3
68983	52
68983	23
68983	24
71850	24
71850	23
68824	17
74064	58
66881	52
66881	23
66881	24
66966	23
66966	24
66868	23
66868	24
71916	58
66999	23
66999	24
67092	46
67092	23
67092	24
66828	85
74098	24
68885	60
74098	23
66945	2
66952	3
66952	6
68934	24
68934	23
66919	11
66919	12
66951	31
71928	52
71928	47
68948	31
60598	24
60598	23
71979	6
72222	75
72222	90
74160	45
69034	75
69034	6
69096	23
69096	24
69116	23
69116	24
69173	12
69219	23
69219	24
63083	60
69072	52
69072	23
69072	24
69092	2
69165	23
58002	73
69165	24
69167	104
69294	12
69294	19
69327	76
69327	75
69327	57
72060	72
72060	90
72060	75
63123	3
63123	6
63123	52
72098	3
72098	99
72131	57
72131	72
72276	20
72276	29
69069	12
69069	13
69069	11
69069	26
69126	12
69126	11
69153	31
72197	17
72197	76
72197	23
72197	24
72197	93
72303	68
72303	98
72303	60
69244	17
69244	11
16856	58
16856	62
63187	3
63187	6
63203	3
63203	6
67276	17
16778	62
16778	63
67276	36
67276	11
67287	23
67287	24
54818	12
16840	62
16840	63
16840	138
16840	79
69525	19
63256	3
63256	6
67338	74
67338	11
67338	35
67338	65
72346	106
72346	91
72370	24
72370	23
69463	28
69463	15
69463	11
69551	72
69579	23
69579	24
72457	75
72457	23
72457	24
72457	16
72541	71
69437	20
69437	29
69452	3
69518	58
69518	46
69518	17
72439	105
72439	34
72468	116
72468	6
69656	19
69656	17
69747	91
69747	116
69747	6
72449	12
72449	11
72449	30
72449	22
72449	10
72478	12
72514	19
74180	28
74182	17
17072	58
55107	17
69741	20
72476	45
67394	19
72439	75
13121	50
13121	42
13121	47
69848	23
69848	24
69920	75
69660	72
69660	90
69669	76
13126	42
13126	50
69803	23
69803	24
69865	75
69865	10
69838	23
69838	24
69838	17
69860	19
72547	12
69812	76
69812	10
72547	9
72547	10
72607	46
72607	23
72607	24
63432	41
63432	42
63432	50
67567	11
69929	101
72566	23
72566	24
72573	23
72573	24
63608	3
63608	6
72567	12
69918	12
69918	22
72680	18
72680	75
67504	23
67504	24
63450	12
67496	91
67496	116
72684	10
72684	76
70018	2
70018	75
67537	23
67537	24
67728	11
67728	74
63561	10
63561	3
63561	6
70007	24
70007	23
55568	39
55568	12
70029	38
67554	25
67554	12
67689	62
67689	58
67729	12
67729	23
67729	24
69973	20
72739	29
70002	23
70002	24
67624	2
69994	23
69994	24
70018	62
55552	20
55552	24
55552	23
72829	24
72829	23
72952	24
72952	23
72966	2
70029	57
61506	58
72889	45
72895	19
72996	58
70111	29
70111	20
72893	60
73040	23
73040	24
70113	19
70125	58
70125	23
70125	24
72861	23
72861	24
63702	6
63702	75
72901	76
72901	72
72998	20
73066	19
70185	72
70185	116
70185	90
70197	11
70197	12
70197	43
72909	23
72909	24
67810	12
67810	33
55876	19
73043	58
73158	23
73158	24
73198	60
73210	18
73037	104
73037	116
73051	6
61632	62
70265	73
70325	12
70325	25
70368	23
70368	24
73040	50
73040	47
70263	23
70263	24
67869	76
67869	10
67879	88
61732	58
61732	24
67975	3
67994	23
67994	24
73199	19
73199	57
63803	13
63803	12
63803	9
67901	60
70275	24
63873	20
70275	23
63873	29
63900	19
70349	58
70357	29
70357	20
73210	75
73215	23
73215	24
73224	58
73290	57
73290	23
73290	24
73257	23
73257	24
17757	58
73336	24
73336	23
73359	46
73369	75
73419	19
67924	17
63861	12
63861	14
63861	9
63823	20
63823	21
67970	12
67943	24
67943	99
67943	23
63837	27
63837	54
63913	2
70395	76
70452	6
63880	28
67984	46
67984	52
67984	47
67984	18
67984	23
67984	24
73372	45
73372	2
73372	50
73395	23
73395	24
70475	58
70475	132
68050	11
68050	23
68050	24
63978	92
63978	73
70451	58
70451	46
73445	58
73445	46
64009	11
64009	3
64009	10
64009	60
68079	52
68079	23
68079	24
70464	90
70464	93
70514	11
70514	12
73488	19
73505	23
73505	24
73505	52
73505	18
64120	11
64120	23
64120	24
64155	17
64155	11
68107	15
68107	28
68115	2
70520	104
70520	116
64160	10
64160	55
56813	12
64177	23
64177	24
73543	24
73543	23
64210	23
64210	24
64210	62
64210	52
64210	18
64210	46
64131	27
64131	64
64131	65
64131	62
70574	57
70574	23
70574	24
64127	23
64127	24
64127	62
64184	24
64184	23
70712	24
70712	3
70712	23
56779	12
70549	35
70549	27
64209	93
64209	90
70571	2
64250	3
64250	6
70680	10
70682	23
70682	24
73603	45
70562	123
59015	2
70590	23
70590	24
73532	46
73537	101
64263	2
64378	23
64378	24
64210	33
64210	32
70614	23
70614	24
70639	23
70639	24
70684	19
70636	23
70636	24
64328	58
64328	62
64328	106
64328	23
64328	24
64367	72
64367	75
64367	32
64367	33
70768	23
70768	24
59288	58
59288	105
59288	46
70812	23
70812	24
64288	19
59358	23
59358	24
70743	58
70743	23
70743	24
70806	19
64429	3
64435	59
64486	28
64486	22
64495	75
70856	34
70856	90
64530	2
64530	6
64554	12
64554	10
64554	9
70866	11
70866	12
70866	25
64501	3
64501	6
64522	81
64522	23
64522	24
64518	12
64518	9
64518	11
64518	13
64518	25
64518	10
59523	24
59523	23
64596	12
64596	10
64636	81
64852	3
64852	31
64852	50
64598	2
64607	23
64607	24
64759	45
64585	3
64585	6
64685	3
64685	6
64750	23
64750	24
64897	24
64897	23
64638	11
64638	10
64638	76
64638	72
64638	17
64689	23
64689	24
64877	3
64946	10
64946	2
64953	99
64953	33
64970	60
65172	78
65320	49
65320	29
65192	11
65192	12
65233	20
65233	18
65245	57
65311	10
65311	2
64950	89
64950	92
65115	23
65115	24
65169	23
65169	24
65210	60
65210	33
65022	11
65022	20
65050	57
65050	5
65050	3
65050	23
65050	24
65298	20
65298	23
65298	24
65317	106
65001	35
65001	75
65001	92
65001	45
65001	65
65001	33
65101	2
65101	23
65101	24
65112	45
65130	24
65130	75
65130	23
65310	19
\.


--
-- Data for Name: store_follows; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_follows (store_id, follower_id) FROM stdin;
5	2
1	2
2	2
3	2
4	2
\.


--
-- Data for Name: store_group_stores; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_group_stores (group_id, store_id) FROM stdin;
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
-- Data for Name: store_groups; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_groups (id, name) FROM stdin;
3	Coco Fresh Tea & Juice
4	Mad Mex
\.


--
-- Data for Name: store_hours; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_hours (store_id, "order", dotw, hours) FROM stdin;
60	1	Mon	Closed
60	2	Tue	5:30pm - 10pm
60	3	Wed	5:30pm - 10pm
60	4	Thu	5:30pm - 10pm
60	5	Fri	11am-2pm, 5:30pm - 10pm
60	6	Sat	Closed
60	7	Sun	Closed
71760	1	Mon	7am – 4pm
71760	2	Tue	7am – 4pm
71760	3	Wed	7am – 4pm
71760	4	Thu	7am – 4pm
71760	5	Fri	7am – 4pm
71760	6	Sat	7am – 3pm
71760	7	Sun	7:30am – 3pm
71727	1	Mon	9am – 9pm
71727	2	Tue	9am – 9pm
71727	3	Wed	9am – 9pm
71727	4	Thu	9am – 9pm
71727	5	Fri	9am – 9pm
71727	6	Sat	9am – 9pm
71727	7	Sun	9am – 9pm
71792	1	Mon	5pm – 10pm
71792	2	Tue	5pm – 10pm
71792	3	Wed	5pm – 10pm
71792	4	Thu	5pm – 10pm
71792	5	Fri	5pm – 10pm
71792	6	Sat	5pm – 10pm
71792	7	Sun	5pm – 10pm
71800	1	Mon	6am – 4pm
71800	2	Tue	6am – 4pm
71800	3	Wed	6am – 4pm
71800	4	Thu	6am – 4pm
71800	5	Fri	6am – 4pm
71800	6	Sat	6am – 2pm
71800	7	Sun	7am – 1pm
57118	1	Mon	6am – 10pm
57118	2	Tue	6am – 10pm
57118	3	Wed	6am – 10pm
57118	4	Thu	6am – 10pm
57118	5	Fri	6am – 10pm
57118	6	Sat	7am – 10pm
57118	7	Sun	7am – 10pm
69072	1	Mon	7am – 5pm
69072	2	Tue	7am – 5pm
69072	3	Wed	7am – 5pm
69072	4	Thu	7am – 5pm
69072	5	Fri	7am – 5pm
69072	6	Sat	8am – 3pm
69072	7	Sun	9am – 4pm
66333	1	Mon	12noon – 3pm, 6pm – 10pm
66333	2	Tue	12noon – 3pm, 6pm – 10pm
66333	3	Wed	12noon – 3pm, 6pm – 10pm
66333	4	Thu	12noon – 3pm, 6pm – 10pm
66333	5	Fri	12noon – 3pm, 6pm – 10pm
66333	6	Sat	12noon – 3pm, 6pm – 10pm
66333	7	Sun	Closed
71746	1	Mon	Closed
71746	2	Tue	8am – 3pm
71746	3	Wed	8am – 3pm
71746	4	Thu	8am – 3pm
71746	5	Fri	8am – 3pm, 6pm – 9pm
71746	6	Sat	8am – 3pm, 6pm – 9pm
71746	7	Sun	8am – 3pm
69069	1	Mon	11am – 9:30pm
69069	2	Tue	11am – 9:30pm
69069	3	Wed	11am – 9:30pm
69069	4	Thu	11am – 9:30pm
69069	5	Fri	11am – 9:30pm
69069	6	Sat	11am – 9:30pm
69069	7	Sun	11am – 9:30pm
66341	1	Mon	11am – 2:30pm, 5pm – 9:30pm
66341	2	Tue	11am – 2:30pm, 5pm – 9:30pm
66341	3	Wed	11am – 2:30pm, 5pm – 9:30pm
66341	4	Thu	11am – 2:30pm, 5pm – 9:30pm
66341	5	Fri	11am – 2:30pm, 5pm – 9:30pm
66341	6	Sat	11am – 2:30pm, 5pm – 9:30pm
66341	7	Sun	5pm – 9:30pm
66354	1	Mon	9am – 9pm
66354	2	Tue	9am – 9pm
66354	3	Wed	9am – 9pm
66354	4	Thu	9am – 9pm
66354	5	Fri	9am – 9pm
66354	6	Sat	9am – 9pm
66354	7	Sun	9am – 9pm
66355	1	Mon	11am – 8pm
66355	2	Tue	11am – 8pm
66355	3	Wed	11am – 8pm
66355	4	Thu	11am – 8:30pm
66355	5	Fri	11am – 8pm
66355	6	Sat	11am – 4pm
66355	7	Sun	11am – 4pm
69126	1	Mon	4pm – 10:30pm
69126	2	Tue	4pm – 10:30pm
69126	3	Wed	4pm – 10:30pm
69126	4	Thu	4pm – 10:30pm
69126	5	Fri	4pm – 10:30pm
69092	1	Mon	11am – 9pm
69092	2	Tue	11am – 9pm
69092	3	Wed	11am – 9pm
69092	4	Thu	11am – 9pm
69092	5	Fri	11am – 9pm
69092	6	Sat	11am – 9pm
66385	1	Mon	5pm – 12midnight
66385	2	Tue	5pm – 12midnight
66385	3	Wed	5pm – 12midnight
66385	4	Thu	5pm – 12midnight
66385	5	Fri	12noon – 12midnight
66385	6	Sat	12noon – 12midnight
66385	7	Sun	12noon – 10pm
69092	7	Sun	12noon – 8pm
16778	1	Mon	10:30am – 10pm
16778	2	Tue	10:30am – 10pm
16778	3	Wed	10:30am – 10pm
16778	4	Thu	10:30am – 10pm
16778	5	Fri	10:30am – 11pm
16778	6	Sat	10:30am – 11pm
16778	7	Sun	10:30am – 10pm
66388	1	Mon	12noon – 12midnight
66388	2	Tue	5pm – 11pm
66388	3	Wed	5pm – 11pm
66388	4	Thu	5pm – 11pm
66388	5	Fri	12noon – 12midnight
69096	1	Mon	6am – 4pm
66388	6	Sat	12noon – 12midnight
66388	7	Sun	12noon – 12midnight
69096	2	Tue	6am – 4pm
69096	3	Wed	6am – 4pm
69096	4	Thu	6am – 4pm
69096	5	Fri	6am – 4pm
69096	6	Sat	6am – 4pm
69096	7	Sun	6am – 4pm
69116	1	Mon	Closed
69116	2	Tue	7am – 4pm
69116	3	Wed	7am – 4pm
69116	4	Thu	7am – 4pm
69116	5	Fri	7am – 4pm
69116	6	Sat	7am – 4pm
69116	7	Sun	7:30am – 3:30pm
71850	1	Mon	6:30am – 8:30pm
71850	2	Tue	6:30am – 8:30pm
71850	3	Wed	6:30am – 8:30pm
71850	4	Thu	6:30am – 8:30pm
71850	5	Fri	6:30am – 8:30pm
71850	6	Sat	6:30am – 7:30pm
71850	7	Sun	6:30am – 7:30pm
69126	6	Sat	1pm – 10:30pm
69126	7	Sun	1pm – 10:30pm
16840	1	Mon	9am – 4pm
66419	1	Mon	11am – 10:30pm
66419	2	Tue	11am – 10:30pm
66419	3	Wed	11am – 10:30pm
66419	4	Thu	11am – 10:30pm
66419	5	Fri	11am – 10:30pm
66419	6	Sat	11am – 10:30pm
66419	7	Sun	11am – 10:30pm
66424	1	Mon	Closed
66424	2	Tue	Closed
66424	3	Wed	6pm – 12midnight
66424	4	Thu	11am – 3pm, 6pm – 12midnight
66424	5	Fri	11am – 3pm, 6pm – 12midnight
66424	6	Sat	6pm – 12midnight
66424	7	Sun	11am – 3pm, 6pm – 12midnight
69173	1	Mon	9am – 6pm
69173	2	Tue	9am – 6pm
69173	3	Wed	9am – 6pm
69173	4	Thu	9am – 9pm
69173	5	Fri	9am – 6pm
69173	6	Sat	9am – 6pm
69173	7	Sun	9am – 6pm
16840	2	Tue	9am – 4pm
16840	3	Wed	9am – 4pm
16840	4	Thu	9am – 4pm
16840	5	Fri	9am – 3pm
16840	6	Sat	9am – 12noon
16840	7	Sun	Closed
63083	1	Mon	5pm – 10pm
63083	2	Tue	5pm – 10pm
63083	3	Wed	5pm – 10pm
63083	4	Thu	5pm – 10pm
63083	5	Fri	5pm – 10pm
63083	6	Sat	5pm – 10pm
63083	7	Sun	5pm – 10pm
69153	1	Mon	Closed
69153	2	Tue	5pm – 11pm
69153	3	Wed	5pm – 11pm
69153	4	Thu	5pm – 11pm
69153	5	Fri	5pm – 11pm
69153	6	Sat	3pm – 11:30pm
69153	7	Sun	3pm – 9:30pm
16856	1	Mon	7am – 8pm
16856	2	Tue	7am – 8pm
16856	3	Wed	7am – 8pm
69165	1	Mon	5:30am – 4pm
69165	2	Tue	5:30am – 4pm
69165	3	Wed	5:30am – 4pm
69165	4	Thu	5:30am – 4pm
69165	5	Fri	5:30am – 4pm
69165	6	Sat	5:30am – 4pm
69165	7	Sun	7am – 4pm
69167	1	Mon	9am – 10pm
69167	2	Tue	9am – 10pm
69167	3	Wed	9am – 12midnight
69167	4	Thu	9am – 10pm
69167	5	Fri	9am – 12midnight
69167	6	Sat	9am – 12midnight
69167	7	Sun	9am – 10pm
71928	1	Mon	9am – 5:30pm
71928	2	Tue	9am – 5:30pm
71928	3	Wed	9am – 5:30pm
71928	4	Thu	9am – 9pm
71928	5	Fri	9am – 5:30pm
71928	6	Sat	9am – 5:30pm
71928	7	Sun	9am – 5:30pm
16856	4	Thu	7am – 8pm
16856	5	Fri	7am – 8pm
16856	6	Sat	7am – 8pm
16856	7	Sun	7am – 8pm
71916	1	Mon	6am – 3pm
71916	2	Tue	6am – 3pm
71916	3	Wed	6am – 3pm
71916	4	Thu	6am – 3pm
71916	5	Fri	6am – 3pm
71916	6	Sat	6am – 2pm
71916	7	Sun	Closed
63123	1	Mon	5pm – 11pm
63123	2	Tue	5pm – 11pm
63123	3	Wed	5pm – 11pm
63123	4	Thu	5pm – 11pm
63123	5	Fri	5pm – 11pm
63123	6	Sat	5pm – 11pm
63123	7	Sun	5pm – 11pm
66485	1	Mon	6:30am – 5pm
66485	2	Tue	6:30am – 5pm
66485	3	Wed	6:30am – 5pm
66485	4	Thu	6:30am – 5pm
66485	5	Fri	6:30am – 5pm
66485	6	Sat	7:30am – 5pm
66485	7	Sun	7:30am – 4:30pm
66489	1	Mon	9am – 2pm
66489	2	Tue	9am – 2pm
66489	3	Wed	9am – 2pm
66489	4	Thu	9am – 2pm
66482	1	Mon	9am – 3:30pm
66482	2	Tue	9am – 3:30pm
66482	3	Wed	9am – 3:30pm
66482	4	Thu	9am – 3:30pm
66482	5	Fri	9am – 3:30pm
66482	6	Sat	10am – 3:30pm
66482	7	Sun	Closed
66489	5	Fri	9am – 2pm
66489	6	Sat	Closed
66489	7	Sun	Closed
71979	1	Mon	4:30pm – 8:30pm
71979	2	Tue	4:30pm – 8:30pm
71979	3	Wed	4:30pm – 8:30pm
71979	4	Thu	4:30pm – 8:30pm
71979	5	Fri	4:30pm – 8:30pm
71979	6	Sat	4:30pm – 8:30pm
71979	7	Sun	4:30pm – 8:30pm
66540	1	Mon	5pm – 10pm
66540	2	Tue	5pm – 10pm
66540	3	Wed	5pm – 10pm
66540	4	Thu	5pm – 10:30pm
66540	5	Fri	5pm – 10:30pm
66540	6	Sat	5pm – 10:30pm
66540	7	Sun	5pm – 10pm
69219	1	Mon	6:30am – 5pm
69219	2	Tue	6:30am – 5pm
69219	3	Wed	6:30am – 5pm
69219	4	Thu	6:30am – 5pm
69219	5	Fri	6:30am – 5pm
69219	6	Sat	8am – 3:30pm
69219	7	Sun	8am – 2pm
66533	1	Mon	11am – 10pm
66533	2	Tue	11am – 10pm
66533	3	Wed	11am – 10pm
66533	4	Thu	11am – 10pm
66533	5	Fri	11am – 10pm
66533	6	Sat	11am – 10pm
66533	7	Sun	11am – 10pm
69244	1	Mon	10am – 3:30pm
69244	2	Tue	10am – 3:30pm
69244	3	Wed	10am – 3:30pm
69244	4	Thu	10am – 3:30pm
69244	5	Fri	10am – 3:30pm
69244	6	Sat	Closed
69244	7	Sun	Closed
66579	1	Mon	7am – 3pm
66579	2	Tue	7am – 3pm
66579	3	Wed	7am – 3pm
66579	4	Thu	7am – 3pm
66579	5	Fri	7am – 3pm, 5:30pm – 8:30pm
66579	6	Sat	7am – 3pm, 5:30pm – 8:30pm
66579	7	Sun	7am – 3pm
66582	1	Mon	8am – 10pm
66582	2	Tue	8am – 10pm
66582	3	Wed	8am – 10pm
66582	4	Thu	8am – 10pm
66582	5	Fri	8am – 10pm
66582	6	Sat	8am – 10pm
66582	7	Sun	8am – 10pm
54818	1	Mon	12noon – 3pm, 5pm – 10pm
54818	2	Tue	12noon – 3pm, 5pm – 10pm
54818	3	Wed	12noon – 3pm, 5pm – 10pm
54818	4	Thu	12noon – 3pm, 5pm – 10pm
69294	1	Mon	11:30am – 2:30pm, 4:30pm – 9pm
69294	2	Tue	11:30am – 2:30pm, 4:30pm – 9pm
69294	3	Wed	11:30am – 2:30pm, 4:30pm – 9pm
69294	4	Thu	11:30am – 2:30pm, 4:30pm – 9pm
63187	1	Mon	5pm – 9pm
63187	2	Tue	5pm – 9pm
63187	3	Wed	5pm – 9pm
63187	4	Thu	5pm – 10pm
63187	5	Fri	5pm – 10pm
63187	6	Sat	5pm – 10pm
63187	7	Sun	Closed
63203	1	Mon	5pm – 10pm
63203	2	Tue	5pm – 10pm
63203	3	Wed	5pm – 10pm
54818	5	Fri	12noon – 3pm, 5pm – 11pm
54818	6	Sat	12noon – 3pm, 5pm – 11pm
54818	7	Sun	12noon – 3pm, 5pm – 10pm
63203	4	Thu	5pm – 10pm
63203	5	Fri	5pm – 10pm
63203	6	Sat	5pm – 10pm
63203	7	Sun	5pm – 10pm
72060	1	Mon	8am – 8pm
17072	1	Mon	8am – 7pm
17072	2	Tue	8am – 7pm
17072	3	Wed	8am – 7pm
17072	4	Thu	8am – 7pm
17072	5	Fri	8am – 7pm
17072	6	Sat	8am – 6pm
17072	7	Sun	8am – 6pm
72060	2	Tue	8am – 8pm
72060	3	Wed	8am – 8pm
72060	4	Thu	8am – 8pm
72060	5	Fri	8am – 8pm
72060	6	Sat	8am – 8pm
72060	7	Sun	8am – 8pm
69294	5	Fri	11:30am – 2:30pm, 4:30pm – 10pm
69294	6	Sat	4:30pm – 10pm
69294	7	Sun	4:30pm – 9pm
69327	1	Mon	7am – 5pm
69327	2	Tue	7am – 5pm
69327	3	Wed	7am – 5pm
69327	4	Thu	7am – 7:30pm
69327	5	Fri	7am – 7:30pm
69327	6	Sat	7am – 3pm
69327	7	Sun	Closed
63256	1	Mon	5pm – 10pm
63256	2	Tue	5pm – 10pm
63256	3	Wed	5pm – 10pm
63256	4	Thu	5pm – 10pm
63256	5	Fri	5pm – 10:30pm
63256	6	Sat	5pm – 10pm
63256	7	Sun	5pm – 9:30pm
72098	1	Mon	Closed
72098	2	Tue	5pm – 10pm
72098	3	Wed	5pm – 10pm
72098	4	Thu	5pm – 10pm
72098	5	Fri	5pm – 10pm
72098	6	Sat	5pm – 10pm
72098	7	Sun	5pm – 10pm
72131	1	Mon	9am – 8pm
72131	2	Tue	9am – 8pm
72131	3	Wed	9am – 8pm
72131	4	Thu	9am – 8pm
72131	5	Fri	9am – 8pm
72131	6	Sat	9am – 8pm
66686	1	Mon	11am – 10:30pm
66686	2	Tue	11am – 10:30pm
66686	3	Wed	11am – 10:30pm
66686	4	Thu	11am – 10:30pm
66686	5	Fri	11am – 10:30pm
66686	6	Sat	11am – 10:30pm
66686	7	Sun	11am – 10:30pm
66723	1	Mon	7:30am – 6pm
66723	2	Tue	7:30am – 6pm
66723	3	Wed	7:30am – 6pm
66723	4	Thu	7:30am – 6pm
66723	5	Fri	7:30am – 6pm
66723	6	Sat	8am – 6pm
66723	7	Sun	8am – 6pm
72131	7	Sun	9am – 8pm
66731	1	Mon	7am – 4am
66731	2	Tue	7am – 4am
66731	3	Wed	7am – 4am
66731	4	Thu	7am – 4am
66731	5	Fri	7am – 4am
66731	6	Sat	7am – 4am
66731	7	Sun	7am – 4am
66775	1	Mon	Closed
66775	2	Tue	12noon – 3pm, 5pm – 9:30pm
66775	3	Wed	12noon – 3pm, 5pm – 9:30pm
66775	4	Thu	12noon – 3pm, 5pm – 9:30pm
66775	5	Fri	12noon – 3pm, 5pm – 9:30pm
66775	6	Sat	12noon – 3pm, 5pm – 9:30pm
66775	7	Sun	12noon – 3pm, 5pm – 9:30pm
66778	1	Mon	6am – 8pm
66778	2	Tue	6am – 8pm
66778	3	Wed	6am – 8pm
66778	4	Thu	6am – 8pm
66778	5	Fri	6am – 8pm
66778	6	Sat	6am – 8pm
66778	7	Sun	6am – 8pm
72197	1	Mon	8am – 7pm
72197	2	Tue	8am – 7pm
72197	3	Wed	8am – 7pm
72197	4	Thu	8am – 7pm
72197	5	Fri	8am – 7pm
72197	6	Sat	8am – 7pm
72197	7	Sun	8am – 7pm
66806	1	Mon	7:30am – 10pm
66806	2	Tue	7:30am – 10pm
66806	3	Wed	7:30am – 10pm
66806	4	Thu	7:30am – 10pm
66806	5	Fri	7:30am – 10pm
72222	1	Mon	9am – 6pm
72222	2	Tue	9am – 6pm
72222	3	Wed	9am – 6pm
72222	4	Thu	9am – 6pm
72222	5	Fri	9am – 6pm
72222	6	Sat	9am – 6pm
72222	7	Sun	9am – 6pm
72276	1	Mon	9am – 6pm
72276	2	Tue	9am – 6pm
72276	3	Wed	9am – 6pm
72276	4	Thu	9am – 6pm
72276	5	Fri	9am – 6pm
72276	6	Sat	Closed
72276	7	Sun	Closed
63432	1	Mon	10am – 11pm
63432	2	Tue	10am – 11pm
63432	3	Wed	10am – 11pm
66806	6	Sat	7:30am – 10pm
66806	7	Sun	7:30am – 10pm
66828	1	Mon	12noon – 2:30pm, 5:30pm – 10pm
66828	2	Tue	12noon – 2:30pm, 5:30pm – 10pm
66828	3	Wed	12noon – 2:30pm, 5:30pm – 10pm
66828	4	Thu	12noon – 2:30pm, 5:30pm – 10pm
66828	5	Fri	12noon – 2:30pm, 5:30pm – 10pm
66828	6	Sat	12noon – 2:30pm, 5:30pm – 10pm
66828	7	Sun	12noon – 2:30pm, 5:30pm – 10pm
72303	1	Mon	11am – 9pm
72303	2	Tue	11am – 9pm
72303	3	Wed	11am – 9pm
72303	4	Thu	11am – 9pm
72303	5	Fri	11am – 9pm
72303	6	Sat	11am – 9pm
72303	7	Sun	11am – 9pm
72346	1	Mon	11am – 11pm
72346	2	Tue	11am – 11pm
72346	3	Wed	11am – 11pm
72346	4	Thu	11am – 11pm
72346	5	Fri	11am – 12midnight
72346	6	Sat	11am – 12midnight
72346	7	Sun	11am – 11pm
72370	1	Mon	6:30am – 4pm
72370	2	Tue	6:30am – 4pm
72370	3	Wed	6:30am – 4pm
72370	4	Thu	6:30am – 4pm
72370	5	Fri	6:30am – 4pm
72370	6	Sat	6:30am – 4pm
72370	7	Sun	7am – 4pm
66868	1	Mon	8am – 4:30pm
66868	2	Tue	8am – 4:30pm
66868	3	Wed	8am – 4:30pm
66868	4	Thu	8am – 4:30pm
66868	5	Fri	8am – 4:30pm
66868	6	Sat	8am – 4:30pm
66868	7	Sun	8am – 4:30pm
66881	1	Mon	7am – 5pm
66881	2	Tue	7am – 5pm
66881	3	Wed	7am – 5pm
66881	4	Thu	7am – 5pm
66881	5	Fri	7am – 5pm
66881	6	Sat	8am – 4pm
66881	7	Sun	8am – 3pm
63432	4	Thu	10am – 11pm
63432	5	Fri	10am – 11pm
63432	6	Sat	10am – 11pm
63432	7	Sun	10am – 11pm
66919	1	Mon	9am – 9pm
66919	2	Tue	9am – 9pm
66893	1	Mon	5pm – 10pm
66893	2	Tue	10am – 10pm
66893	3	Wed	10am – 10pm
66893	4	Thu	10am – 10pm
66893	5	Fri	10am – 10pm
66893	6	Sat	9am – 10pm
66893	7	Sun	9am – 10pm
63450	1	Mon	5pm – 10pm
63450	2	Tue	5pm – 10pm
63450	3	Wed	5pm – 10pm
63450	4	Thu	5pm – 10pm
63450	5	Fri	5pm – 10pm
63450	6	Sat	5pm – 10pm
63450	7	Sun	5pm – 10pm
66919	3	Wed	9am – 9pm
66919	4	Thu	9am – 9pm
66919	5	Fri	9am – 9pm
66919	6	Sat	9am – 9pm
66919	7	Sun	9am – 9pm
72439	1	Mon	11am – 9pm
72439	2	Tue	11am – 9pm
72439	3	Wed	11am – 9pm
72439	4	Thu	11am – 9pm
72439	5	Fri	11am – 9pm
72439	6	Sat	11am – 9pm
72439	7	Sun	11am – 9pm
66951	1	Mon	11am – 3:30pm, 5pm – 10pm
66951	2	Tue	11am – 3:30pm, 5pm – 10pm
66951	3	Wed	11am – 3:30pm, 5pm – 10pm
66951	4	Thu	11am – 3:30pm, 5pm – 10pm
66951	5	Fri	11am – 3:30pm, 5pm – 10pm
66951	6	Sat	8:30am – 10pm
66951	7	Sun	8:30am – 10pm
72449	1	Mon	5pm – 10pm
72449	2	Tue	11am – 3pm, 5pm – 10pm
72449	3	Wed	11am – 3pm, 5pm – 10pm
72449	4	Thu	11am – 3pm, 5pm – 10pm
72449	5	Fri	11am – 3pm, 5pm – 10pm
72449	6	Sat	11am – 3pm, 5pm – 10pm
72449	7	Sun	11am – 3pm, 5pm – 10pm
72478	1	Mon	5pm – 9pm
72478	2	Tue	5pm – 9pm, 11am – 2:30pm
72478	3	Wed	5pm – 9pm, 11am – 2:30pm
72478	4	Thu	5pm – 9pm, 11am – 2:30pm
72478	5	Fri	5pm – 9pm, 11am – 2:30pm
72478	6	Sat	5pm – 9pm, 11am – 2:30pm
72478	7	Sun	5pm – 9pm, 11am – 2:30pm
72457	1	Mon	5:30am – 5:30pm
72457	2	Tue	5:30am – 5:30pm
72457	3	Wed	5:30am – 5:30pm
72457	4	Thu	5:30am – 5:30pm
72457	5	Fri	5:30am – 5:30pm
72457	6	Sat	5am – 4pm
72457	7	Sun	6am – 3pm
72468	1	Mon	10am – 9pm
72468	2	Tue	10am – 9pm
72468	3	Wed	10am – 9pm
72468	4	Thu	10am – 9pm
72468	5	Fri	10am – 9pm
72468	6	Sat	10am – 9pm
72468	7	Sun	Closed
72476	1	Mon	11:30am – 2:30pm, 6pm – 8:30pm
72476	2	Tue	11:30am – 2:30pm, 6pm – 8:30pm
72476	3	Wed	11:30am – 2:30pm, 6pm – 8:30pm
72476	4	Thu	11:30am – 2:30pm, 6pm – 8:30pm
72476	5	Fri	11:30am – 2:30pm, 6pm – 8:30pm
72476	6	Sat	11:30am – 2:30pm, 6pm – 8:30pm
72476	7	Sun	11:30am – 2:30pm, 6pm – 8:30pm
66945	1	Mon	12noon – 3pm, 6pm – 9:30pm
66945	2	Tue	12noon – 3pm, 6pm – 9:30pm
66945	3	Wed	12noon – 3pm, 6pm – 9:30pm
66945	4	Thu	12noon – 3pm, 6pm – 9:30pm
66945	5	Fri	12noon – 10pm
66945	6	Sat	12noon – 10pm
66945	7	Sun	12noon – 9pm
66952	1	Mon	8am – 9pm
66952	2	Tue	8am – 9pm
66952	3	Wed	8am – 9pm
66952	4	Thu	8am – 9pm
66952	5	Fri	8am – 9pm
66952	6	Sat	5pm – 9pm
66952	7	Sun	Closed
72514	1	Mon	11am – 3:30pm, 5pm – 10pm
72514	2	Tue	11am – 3:30pm, 5pm – 10pm
72514	3	Wed	11am – 3:30pm, 5pm – 10pm
72514	4	Thu	11am – 3:30pm, 5pm – 10pm
72514	5	Fri	11am – 3:30pm, 5pm – 10pm
72514	6	Sat	11am – 3:30pm, 5pm – 10pm
72514	7	Sun	5pm – 10pm
66966	1	Mon	5am – 4pm
66966	2	Tue	5am – 4pm
66966	3	Wed	5am – 4pm
66966	4	Thu	5am – 4pm
66966	5	Fri	5am – 4pm
66966	6	Sat	5am – 4pm
66966	7	Sun	5am – 4pm
72541	1	Mon	11am – 9pm
72541	2	Tue	11am – 9pm
72541	3	Wed	11am – 9pm
72541	4	Thu	11am – 9pm
72541	5	Fri	11am – 9pm
72541	6	Sat	11am – 9pm
72541	7	Sun	4pm – 9pm
72547	1	Mon	10:30am – 3pm, 5:30pm – 10pm
72547	2	Tue	10:30am – 3pm, 5:30pm – 10pm
72547	3	Wed	10:30am – 3pm, 5:30pm – 10pm
72547	4	Thu	10:30am – 3pm, 5:30pm – 10pm
72547	5	Fri	10:30am – 3pm, 5:30pm – 10pm
72547	6	Sat	10:30am – 3pm, 5:30pm – 10pm
72547	7	Sun	10:30am – 3pm, 5:30pm – 10pm
72566	1	Mon	8am – 4pm
72566	2	Tue	8am – 4pm
72566	3	Wed	8am – 4pm
72566	4	Thu	8am – 4pm
72566	5	Fri	8am – 4pm
72566	6	Sat	9am – 3pm
72566	7	Sun	Closed
72573	1	Mon	6:30am – 10:30pm
72573	2	Tue	6:30am – 10:30pm
72573	3	Wed	6:30am – 10:30pm
72573	4	Thu	6:30am – 10:30pm
72573	5	Fri	6:30am – 10:30pm
72573	6	Sat	6:30am – 10:30pm
72573	7	Sun	6:30am – 10:30pm
66999	1	Mon	7am – 4pm
66999	2	Tue	7am – 4pm
66999	3	Wed	7am – 4pm
66999	4	Thu	7am – 4pm
66999	5	Fri	7am – 4pm
72567	1	Mon	7am – 7pm
72567	2	Tue	7am – 7pm
72567	3	Wed	7am – 7pm
72567	4	Thu	7am – 7pm
72567	5	Fri	7am – 7pm
72567	6	Sat	8am – 6pm
72567	7	Sun	8am – 6pm
72607	1	Mon	5am – 3pm
72607	2	Tue	5am – 3pm
72607	3	Wed	5am – 3pm
72607	4	Thu	5am – 3pm
72607	5	Fri	5am – 3pm
72607	6	Sat	5am – 9pm
66999	6	Sat	Closed
66999	7	Sun	Closed
55107	1	Mon	Closed
55107	2	Tue	5:30pm – 10pm
55107	3	Wed	5:30pm – 10pm
55107	4	Thu	5:30pm – 10pm
55107	5	Fri	5:30pm – 10pm
55107	6	Sat	5:30pm – 10pm
55107	7	Sun	Closed
72607	7	Sun	Closed
63561	1	Mon	7am – 11pm
63561	2	Tue	7am – 11pm
63561	3	Wed	7am – 11pm
63561	4	Thu	7am – 11pm
63561	5	Fri	7am – 12midnight
63561	6	Sat	7am – 12midnight
63561	7	Sun	7am – 11pm
72680	1	Mon	Closed
72680	2	Tue	12noon – 10pm
72680	3	Wed	12noon – 10pm
72680	4	Thu	12noon – 10pm
72680	5	Fri	12noon – 10pm
72680	6	Sat	12noon – 10pm
72680	7	Sun	12noon – 10pm
72684	1	Mon	9am – 7:30pm
72684	2	Tue	9am – 8pm
72684	3	Wed	9am – 8pm
72684	4	Thu	9am – 8pm
72684	5	Fri	9am – 8pm
72684	6	Sat	9am – 8pm
72684	7	Sun	10am – 7pm
67092	1	Mon	6:30am – 8:30pm
67092	2	Tue	6:30am – 8:30pm
67092	3	Wed	6:30am – 8:30pm
67092	4	Thu	6:30am – 8:30pm
67092	5	Fri	6:30am – 8:30pm
67092	6	Sat	7am – 8:30pm
67092	7	Sun	7am – 8:30pm
69437	1	Mon	8am – 8pm
69437	2	Tue	8am – 8pm
69437	3	Wed	8am – 8pm
69437	4	Thu	8am – 8pm
69437	5	Fri	8am – 8pm
69437	6	Sat	9am – 4pm
69437	7	Sun	Closed
63608	1	Mon	4:30pm – 10pm
63608	2	Tue	4:30pm – 10pm
63608	3	Wed	4:30pm – 10pm
63608	4	Thu	4:30pm – 10pm
63608	5	Fri	4:30pm – 10pm
63608	6	Sat	4:30pm – 10pm
63608	7	Sun	4:30pm – 10pm
69452	1	Mon	6pm – 11pm
69452	2	Tue	6pm – 11pm
69452	3	Wed	6pm – 11pm
69452	4	Thu	12noon – 3pm, 6pm – 11pm
69452	5	Fri	12noon – 3pm, 6pm – 11pm
69452	6	Sat	5:30pm – 11pm
69452	7	Sun	Closed
72739	1	Mon	9am – 5pm
72739	2	Tue	9am – 5pm
72739	3	Wed	9am – 5pm
72739	4	Thu	9am – 9pm
72739	5	Fri	9am – 5pm
72739	6	Sat	9am – 4pm
72739	7	Sun	9am – 4pm
69463	1	Mon	5:30pm – 10:30pm
69463	2	Tue	5:30pm – 10:30pm
69463	3	Wed	11:30am – 10:30pm
69463	4	Thu	11:30am – 10:30pm
69463	5	Fri	11:30am – 10:30pm
69463	6	Sat	11:30am – 10:30pm
69463	7	Sun	5:30pm – 10:30pm
72829	1	Mon	7am – 3pm
72829	2	Tue	7am – 3pm
72829	3	Wed	7am – 3pm
72829	4	Thu	7am – 3pm
72829	5	Fri	7am – 3pm
72829	6	Sat	7am – 3pm
72829	7	Sun	7am – 3pm
72893	1	Mon	11am – 3pm, 5pm – 10pm
72893	2	Tue	Closed
72893	3	Wed	11am – 3pm, 5pm – 10pm
72893	4	Thu	11am – 3pm, 5pm – 10pm
72893	5	Fri	11am – 3pm, 5pm – 10pm
72893	6	Sat	11am – 3pm, 5pm – 10pm
72893	7	Sun	11am – 3pm, 5pm – 10pm
63702	1	Mon	5pm – 3am
63702	2	Tue	5pm – 3am
63702	3	Wed	5pm – 3am
63702	4	Thu	5pm – 3am
63702	5	Fri	5pm – 3am
63702	6	Sat	5pm – 3am
63702	7	Sun	Closed
72861	1	Mon	7am – 3pm
72861	2	Tue	7am – 3pm
72861	3	Wed	7am – 3pm
72861	4	Thu	7am – 3pm
72861	5	Fri	7am – 3pm
72861	6	Sat	8am – 3pm
72861	7	Sun	8am – 3pm
72901	1	Mon	6am – 4pm
72901	2	Tue	6am – 4pm
72901	3	Wed	6am – 4pm
72901	4	Thu	6am – 4pm
72901	5	Fri	6am – 4pm
72901	6	Sat	6am – 4pm
72901	7	Sun	6am – 2pm
72889	1	Mon	9am – 12midnight
72889	2	Tue	9am – 12midnight
72889	3	Wed	9am – 12midnight
72889	4	Thu	9am – 12midnight
72889	5	Fri	9am – 1am
72889	6	Sat	9am – 1am
72889	7	Sun	10am – 10pm
72895	1	Mon	11am – 3pm, 5pm – 9:30pm
72895	2	Tue	11am – 3pm, 5pm – 9:30pm
72895	3	Wed	11am – 3pm, 5pm – 9:30pm
72895	4	Thu	11am – 3pm, 5pm – 9:30pm
72895	5	Fri	11am – 3pm, 5pm – 9:30pm
72895	6	Sat	11am – 3pm, 5pm – 9:30pm
72895	7	Sun	11am – 3pm, 5pm – 9:30pm
72909	1	Mon	5:30am – 2:30pm
72909	2	Tue	5:30am – 2:30pm
72909	3	Wed	5:30am – 2:30pm
72909	4	Thu	5:30am – 2:30pm
72909	5	Fri	5:30am – 2:30pm
72909	6	Sat	6:30am – 2:30pm
72909	7	Sun	Closed
69551	1	Mon	9am – 5pm
69551	2	Tue	9am – 5pm
69551	3	Wed	9am – 5pm
69551	4	Thu	9am – 5pm
69551	5	Fri	9am – 5pm
69551	6	Sat	9am – 5pm
69551	7	Sun	9am – 5pm
69579	1	Mon	6am – 5pm
69579	2	Tue	6am – 5pm
69579	3	Wed	6am – 5pm
69579	4	Thu	6am – 5pm
69579	5	Fri	6am – 5pm
69518	1	Mon	6:30am – 6pm
69518	2	Tue	6:30am – 6pm
69518	3	Wed	6:30am – 6pm
69518	4	Thu	6:30am – 6pm
69518	5	Fri	6:30am – 6pm
69518	6	Sat	6:30am – 6pm
69518	7	Sun	6:30am – 6pm
69525	1	Mon	11am – 10pm
69525	2	Tue	11am – 10pm
69525	3	Wed	11am – 10pm
69525	4	Thu	11am – 10pm
69525	5	Fri	11am – 10pm
69525	6	Sat	11am – 10pm
69525	7	Sun	11am – 10pm
72952	1	Mon	7am – 4pm
72952	2	Tue	7am – 4pm
72952	3	Wed	7am – 4pm
72952	4	Thu	7am – 4pm
72952	5	Fri	7am – 4pm
67276	1	Mon	11am – 10pm
67276	2	Tue	11am – 10pm
67276	3	Wed	11am – 10pm
67276	4	Thu	11am – 10pm
67276	5	Fri	11am – 10pm
67276	6	Sat	11am – 10pm
67276	7	Sun	5pm – 10pm
67287	1	Mon	6am – 3pm
67287	2	Tue	6am – 3pm
67287	3	Wed	6am – 3pm
67287	4	Thu	6am – 3pm
67287	5	Fri	6am – 3pm
67287	6	Sat	7am – 3pm
67287	7	Sun	Closed
63803	1	Mon	12noon – 3pm, 5:30pm – 11pm
63803	2	Tue	12noon – 3pm, 5:30pm – 11pm
63803	3	Wed	12noon – 3pm, 5:30pm – 11pm
63803	4	Thu	12noon – 3pm, 5:30pm – 12midnight
63803	5	Fri	12noon – 3pm, 5:30pm – 12midnight
63803	6	Sat	10:30am – 3pm, 5:30pm – 12midnight
63803	7	Sun	10:30am – 3pm, 5:30pm – 10pm
72952	6	Sat	Closed
72952	7	Sun	Closed
72966	1	Mon	11:30am – 2pm
72966	2	Tue	11:30am – 2pm
72966	3	Wed	11:30am – 2pm, 5:30pm – 8pm
72966	4	Thu	11:30am – 2pm, 5:30pm – 8pm
72966	5	Fri	11:30am – 2pm, 5:30pm – 9pm
72966	6	Sat	11:30am – 2pm, 5:30pm – 9pm
72966	7	Sun	11:30am – 2pm, 5:30pm – 8pm
72998	1	Mon	9am – 5:30pm
72998	2	Tue	9am – 5:30pm
72998	3	Wed	9am – 5:30pm
72998	4	Thu	9am – 8pm
72998	5	Fri	9am – 5:30pm
72998	6	Sat	9am – 5pm
72998	7	Sun	10am – 5pm
63823	1	Mon	11am – 10pm
63823	2	Tue	11am – 10pm
63823	3	Wed	11am – 10pm
63823	4	Thu	11am – 11pm
63823	5	Fri	11am – 11pm
63823	6	Sat	11am – 11pm
63823	7	Sun	11am – 9pm
63837	1	Mon	Closed
63837	2	Tue	11:30am – 2:30pm, 5:30pm – 10pm
63837	3	Wed	11:30am – 2:30pm, 5:30pm – 10pm
63837	4	Thu	11:30am – 2:30pm, 5:30pm – 10pm
63837	5	Fri	11:30am – 2:30pm, 5:30pm – 10pm
63837	6	Sat	11:30am – 2:30pm, 5:30pm – 10pm
63837	7	Sun	11:30am – 2:30pm, 5:30pm – 10pm
72996	1	Mon	6am – 5pm
72996	2	Tue	6am – 5pm
72996	3	Wed	6am – 5pm
72996	4	Thu	6am – 5pm
72996	5	Fri	6am – 5pm
72996	6	Sat	6am – 5pm
72996	7	Sun	6am – 5pm
63861	1	Mon	12noon – 3pm, 6pm – 10:30pm
63861	2	Tue	12noon – 3pm, 6pm – 10:30pm
63861	3	Wed	12noon – 3pm, 6pm – 10:30pm
63861	4	Thu	12noon – 3pm, 6pm – 11pm
63861	5	Fri	12noon – 3pm, 6pm – 11pm
63861	6	Sat	5:30pm – 11pm
63861	7	Sun	6pm – 10pm
63873	1	Mon	12noon – 10pm
63873	2	Tue	12noon – 10pm
63873	3	Wed	12noon – 10pm
63873	4	Thu	12noon – 10pm
63873	5	Fri	12noon – 11pm
63873	6	Sat	12noon – 11pm
63873	7	Sun	12noon – 10pm
67338	1	Mon	12noon – 10:30pm
67338	2	Tue	12noon – 10:30pm
67338	3	Wed	12noon – 10:30pm
67338	4	Thu	12noon – 10:30pm
67338	5	Fri	12noon – 11:30pm
67338	6	Sat	9am – 11:30pm
67338	7	Sun	9am – 10pm
63900	1	Mon	11:30am – 3:30pm, 5pm – 10pm
63900	2	Tue	11:30am – 3:30pm, 5pm – 10pm
63900	3	Wed	11:30am – 3:30pm, 5pm – 10pm
63900	4	Thu	11:30am – 3:30pm, 5pm – 10pm
63900	5	Fri	11:30am – 3:30pm, 5pm – 10pm
63900	6	Sat	11:30am – 3:30pm, 5pm – 10pm
63900	7	Sun	11:30am – 3:30pm, 5pm – 10pm
73040	1	Mon	6am – 6pm
73040	2	Tue	6am – 6pm
73040	3	Wed	6am – 6pm
73040	4	Thu	6am – 6pm
73040	5	Fri	6am – 6pm
63880	1	Mon	11am – 12midnight
63880	2	Tue	11am – 12midnight
63880	3	Wed	11am – 12midnight
73043	1	Mon	7am – 8pm
73043	2	Tue	7am – 8pm
73043	3	Wed	7am – 8pm
73043	4	Thu	7am – 8pm
73043	5	Fri	7am – 7pm
73043	6	Sat	7am – 4pm
73043	7	Sun	8am – 2pm
63880	4	Thu	11am – 12midnight
63880	5	Fri	11am – 12midnight
69579	6	Sat	6am – 4pm
69579	7	Sun	Closed
63880	6	Sat	11am – 12midnight
63880	7	Sun	11am – 12midnight
73037	1	Mon	Closed
73037	2	Tue	Closed
73037	3	Wed	10:30am – 9pm
73037	4	Thu	10:30am – 9pm
73037	5	Fri	10:30am – 9pm
73037	6	Sat	10:30am – 9pm
73037	7	Sun	10:30am – 9pm
73040	6	Sat	Closed
73040	7	Sun	Closed
63913	1	Mon	12noon – 2:30pm, 6pm – 10pm
73051	1	Mon	5pm – 10pm
73051	2	Tue	5pm – 10pm
73051	3	Wed	5pm – 10pm
63913	2	Tue	12noon – 2:30pm, 6pm – 10pm
63913	3	Wed	12noon – 2:30pm, 6pm – 10pm
63913	4	Thu	12noon – 2:30pm, 6pm – 10pm
63913	5	Fri	12noon – 3pm, 5:30pm – 10pm
73051	4	Thu	5pm – 10pm
73051	5	Fri	5pm – 10pm
73051	6	Sat	5pm – 10pm
73051	7	Sun	5pm – 10pm
63913	6	Sat	12noon – 3pm, 5:30pm – 10pm
63913	7	Sun	12noon – 3pm, 6pm – 9pm
73066	1	Mon	11am – 9pm
73066	2	Tue	11am – 9pm
73066	3	Wed	11am – 9pm
73066	4	Thu	11am – 9pm
73066	5	Fri	11am – 9pm
73066	6	Sat	11am – 9pm
73066	7	Sun	11am – 9pm
63978	1	Mon	6pm – 11pm
63978	2	Tue	6pm – 11pm
63978	3	Wed	6pm – 11pm
63978	4	Thu	6pm – 11pm
63978	5	Fri	12noon – 12midnight
63978	6	Sat	12noon – 12midnight
63978	7	Sun	12noon – 12midnight
67394	1	Mon	12noon – 3pm, 5pm – 9:30pm
67394	2	Tue	12noon – 3pm, 5pm – 9:30pm
64009	1	Mon	7am – 10am, 11:30am – 3:30pm, 5pm – 9:30pm
64009	2	Tue	7am – 10am, 11:30am – 3:30pm, 5pm – 9:30pm
64009	3	Wed	7am – 10am, 11:30am – 3:30pm, 5pm – 9:30pm
64009	4	Thu	7am – 10am, 11:30am – 3:30pm, 5pm – 9:30pm
64009	5	Fri	7am – 10am, 5pm – 10pm, 11:30am – 3:30pm
64009	6	Sat	7am – 10:30am, 5pm – 10pm, 11:30am – 3:30pm
64009	7	Sun	7:30am – 10:30am, 5pm – 9:30pm, 11:30am – 3:30pm
69660	1	Mon	10am – 8pm
69660	2	Tue	10am – 8pm
69660	3	Wed	10am – 8pm
69660	4	Thu	10am – 8pm
69660	5	Fri	10am – 8pm
69660	6	Sat	10am – 8pm
69660	7	Sun	Closed
67394	3	Wed	12noon – 3pm, 5pm – 9:30pm
67394	4	Thu	12noon – 3pm, 5pm – 9:30pm
67394	5	Fri	12noon – 3pm, 5pm – 9:30pm
67394	6	Sat	12noon – 3pm, 5pm – 9:30pm
67394	7	Sun	12noon – 3pm, 5pm – 9:30pm
69656	1	Mon	11am – 3pm, 4:30pm – 9pm
69656	2	Tue	11am – 3pm, 4:30pm – 9pm
69656	3	Wed	11am – 3pm, 4:30pm – 9pm
69656	4	Thu	11am – 3pm, 4:30pm – 9pm
69656	5	Fri	11am – 3pm, 4:30pm – 9pm
69656	6	Sat	11am – 3pm, 4:30pm – 9pm
69656	7	Sun	11am – 3pm, 4:30pm – 9pm
73158	1	Mon	6:30am – 2:30pm
73158	2	Tue	6:30am – 2:30pm
73158	3	Wed	6:30am – 2:30pm
73158	4	Thu	6:30am – 2:30pm
73158	5	Fri	6:30am – 2:30pm
73158	6	Sat	Closed
73158	7	Sun	Closed
69669	1	Mon	10:30am – 8pm
69669	2	Tue	10:30am – 8pm
69669	3	Wed	10:30am – 8:30pm
69669	4	Thu	10:30am – 9pm
69669	5	Fri	10:30am – 9pm
69669	6	Sat	10:30am – 9pm
69669	7	Sun	10:30am – 8pm
64120	1	Mon	6:30am – 4pm
64120	2	Tue	6:30am – 4pm
64120	3	Wed	6:30am – 4pm
64120	4	Thu	6:30am – 4pm
64120	5	Fri	6:30am – 4pm
64120	6	Sat	6:30am – 4pm
64120	7	Sun	7am – 4pm
55552	1	Mon	12noon – 3pm, 6pm – 9pm
55552	2	Tue	12noon – 3pm, 6pm – 9pm
55552	3	Wed	12noon – 3pm, 6pm – 9pm
55552	4	Thu	12noon – 3pm, 6pm – 9pm
55552	5	Fri	12noon – 3pm, 6pm – 9pm
55552	6	Sat	12noon – 3pm
55552	7	Sun	Closed
73199	1	Mon	6am – 3pm
73199	2	Tue	6am – 3pm
73199	3	Wed	6am – 3pm
73199	4	Thu	6am – 3pm
73199	5	Fri	6am – 3pm
73199	6	Sat	6:30am – 3pm
73199	7	Sun	7am – 1pm
64127	1	Mon	8am – 3pm
64127	2	Tue	8am – 3pm
64127	3	Wed	Closed
64127	4	Thu	8am – 3pm, 6pm – 10pm
64127	5	Fri	8am – 3pm, 6pm – 10pm
64127	6	Sat	8am – 4pm, 6pm – 11pm
64127	7	Sun	8am – 4pm
73198	1	Mon	11am – 11pm
73198	2	Tue	11am – 11pm
73198	3	Wed	11am – 11pm
73198	4	Thu	11am – 11pm
73198	5	Fri	11am – 11pm
73198	6	Sat	11am – 11pm
73198	7	Sun	11am – 11pm
73210	1	Mon	7am – 9pm
73210	2	Tue	7am – 9pm
73210	3	Wed	7am – 9pm
73210	4	Thu	7am – 9pm
73210	5	Fri	7am – 9pm
73210	6	Sat	7am – 9pm
73210	7	Sun	7am – 9pm
73215	1	Mon	7am – 4pm
73215	2	Tue	7am – 4pm
73215	3	Wed	7am – 4pm
73215	4	Thu	7am – 4pm
64160	1	Mon	12noon – 3pm, 5:30pm – 10pm
64160	2	Tue	12noon – 3pm, 5:30pm – 10pm
64160	3	Wed	12noon – 3pm, 5:30pm – 10pm
64160	4	Thu	12noon – 3pm, 5:30pm – 10pm
64160	5	Fri	12noon – 3pm, 5:30pm – 10pm
64160	6	Sat	12noon – 3pm, 5:30pm – 10pm
64160	7	Sun	12noon – 3pm, 5:30pm – 10pm
73215	5	Fri	7am – 4pm
73215	6	Sat	7am – 2:30pm
73215	7	Sun	8am – 2:30pm
73224	1	Mon	7am – 5pm
73224	2	Tue	7am – 5pm
73224	3	Wed	7am – 5pm
64131	1	Mon	9:30am – 5pm
64131	2	Tue	9:30am – 5pm
64131	3	Wed	9:30am – 5pm
64131	4	Thu	9:30am – 5pm
64131	5	Fri	9:30am – 5pm
64131	6	Sat	Closed
64131	7	Sun	Closed
55568	1	Mon	5pm – 1am
55568	2	Tue	5pm – 1am
55568	3	Wed	5pm – 1am
55568	4	Thu	5pm – 1am
55568	5	Fri	5pm – 1am
55568	6	Sat	5pm – 1am
55568	7	Sun	5pm – 1am
64155	1	Mon	Closed
64155	2	Tue	6pm – 10pm
64155	3	Wed	6pm – 10pm
64155	4	Thu	6pm – 10pm
64155	5	Fri	12noon – 3pm, 6pm – 10pm
64155	6	Sat	6pm – 10pm
64155	7	Sun	6pm – 10pm
64184	1	Mon	7am – 3:30pm
64184	2	Tue	7am – 3:30pm
64184	3	Wed	7am – 3:30pm
64184	4	Thu	7am – 3:30pm
64184	5	Fri	7am – 3:30pm
64184	6	Sat	8am – 3pm
64184	7	Sun	8am – 3pm
73224	4	Thu	7am – 5pm
73224	5	Fri	7am – 5pm
73224	6	Sat	7am – 5pm
73224	7	Sun	Closed
69741	1	Mon	9am – 5:30pm
69741	2	Tue	9am – 5:30pm
69741	3	Wed	9am – 5:30pm
69741	4	Thu	9am – 9pm
69741	5	Fri	9am – 5:30pm
69741	6	Sat	9am – 5:30pm
69741	7	Sun	9am – 5:30pm
64177	1	Mon	6am – 3pm
64177	2	Tue	6am – 3pm
64177	3	Wed	6am – 3pm
64177	4	Thu	6am – 3pm
64177	5	Fri	6am – 3pm
64177	6	Sat	7am – 3pm
64177	7	Sun	7am – 3pm
64209	1	Mon	10am – 9pm
64209	2	Tue	10am – 9pm
64209	3	Wed	10am – 9pm
64209	4	Thu	10am – 9pm
64209	5	Fri	10am – 9pm
64209	6	Sat	10am – 9pm
64209	7	Sun	10am – 8pm
64250	1	Mon	5:30pm – 10pm
64250	2	Tue	5:30pm – 10pm
64250	3	Wed	5:30pm – 10pm
64250	4	Thu	5:30pm – 10pm
64250	5	Fri	12noon – 3pm, 5:30pm – 11pm
64250	6	Sat	12noon – 3pm, 5:30pm – 11pm
64250	7	Sun	12noon – 3pm, 5:30pm – 9:30pm
64210	1	Mon	8am – 4pm
64210	2	Tue	8am – 4pm
73257	1	Mon	6am – 3:30pm
64210	3	Wed	8am – 4pm
64210	4	Thu	8am – 4pm
64210	5	Fri	8am – 4pm
64210	6	Sat	8am – 4pm
64210	7	Sun	8am – 4pm
73257	2	Tue	6am – 3:30pm
73257	3	Wed	6am – 3:30pm
73257	4	Thu	6am – 3:30pm
73257	5	Fri	6am – 3:30pm
73257	6	Sat	6:30am – 12noon
73257	7	Sun	7am – 12noon
67496	1	Mon	10am – 11:30pm
67496	2	Tue	10am – 11:30pm
67496	3	Wed	10am – 11:30pm
67496	4	Thu	10am – 11:30pm
17757	1	Mon	6:30am – 6pm
17757	2	Tue	6:30am – 6pm
17757	3	Wed	6:30am – 6pm
17757	4	Thu	6:30am – 6pm
17757	5	Fri	6:30am – 6pm
17757	6	Sat	6:30am – 6pm
17757	7	Sun	6:30am – 6pm
69747	1	Mon	9am – 11:30pm
69747	2	Tue	9am – 11:30pm
69747	3	Wed	9am – 11:30pm
69747	4	Thu	9am – 11:30pm, 12midnight – 2am
69747	5	Fri	9am – 11:30pm, 12midnight – 2am
69747	6	Sat	9am – 11:30pm, 12midnight – 2am
67496	5	Fri	10am – 11:30pm, 12midnight – 1am
67496	6	Sat	10am – 11:30pm, 12midnight – 1am
67496	7	Sun	10am – 11:30pm
69747	7	Sun	9am – 11:30pm
64263	1	Mon	12noon – 3pm, 6pm – 10pm
64263	2	Tue	12noon – 3pm, 6pm – 10pm
64288	1	Mon	11:30am – 10pm
64288	2	Tue	11:30am – 10pm
64288	3	Wed	11:30am – 10pm
64288	4	Thu	11:30am – 10pm
64288	5	Fri	11:30am – 10pm
64288	6	Sat	11:30am – 10pm
64288	7	Sun	11:30am – 10pm
64263	3	Wed	12noon – 3pm, 6pm – 10pm
64263	4	Thu	12noon – 3pm, 6pm – 10pm
64263	5	Fri	12noon – 3pm, 6pm – 10pm
64263	6	Sat	8am – 10:30am, 12noon – 10pm
64263	7	Sun	8am – 10:30am, 12noon – 10pm
67504	1	Mon	6:30am – 2pm
67504	2	Tue	6:30am – 2pm
67504	3	Wed	6:30am – 2pm
67504	4	Thu	6:30am – 2pm
67504	5	Fri	6:30am – 2pm
67504	6	Sat	8am – 1pm
67504	7	Sun	8am – 1pm
60598	1	Mon	6am – 9pm
60598	2	Tue	6am – 9pm
60598	3	Wed	6am – 9pm
60598	4	Thu	6am – 9pm
60598	5	Fri	6am – 9pm
60598	6	Sat	6am – 9pm
60598	7	Sun	6am – 9pm
73290	1	Mon	8am – 4pm
73290	2	Tue	7am – 4pm
73290	3	Wed	7am – 4pm
73290	4	Thu	7am – 4pm
73290	5	Fri	7am – 4pm
73290	6	Sat	7am – 4pm
73290	7	Sun	8am – 3pm
64328	1	Mon	Closed
64328	2	Tue	7am – 4pm
64328	3	Wed	7am – 4pm
64328	4	Thu	7am – 4pm
64328	5	Fri	7am – 4pm
64328	6	Sat	7am – 4pm
64328	7	Sun	7am – 12noon
64367	1	Mon	11am – 11pm
64367	2	Tue	11am – 11pm
64367	3	Wed	11am – 11pm
64367	4	Thu	11am – 11:30pm, 12midnight – 1am
64367	5	Fri	11am – 11:30pm, 12midnight – 4am
64367	6	Sat	11am – 11:30pm, 12midnight – 4am
64367	7	Sun	11am – 11pm
69803	1	Mon	7am – 3pm
69803	2	Tue	7am – 3pm
69803	3	Wed	7am – 3pm
69803	4	Thu	7am – 3pm
69803	5	Fri	7am – 3pm
69803	6	Sat	7am – 3pm
69803	7	Sun	7am – 3pm
69812	1	Mon	Closed
69812	2	Tue	11:30am – 7:30pm
69812	3	Wed	11:30am – 7:30pm
69812	4	Thu	11:30am – 7:30pm
69812	5	Fri	11:30am – 8pm
69812	6	Sat	11:30am – 7:30pm
69812	7	Sun	11:30am – 7:30pm
73336	1	Mon	6am – 3:30pm
73336	2	Tue	6am – 3:30pm
73336	3	Wed	6am – 3:30pm
73336	4	Thu	6am – 3:30pm
73336	5	Fri	6am – 3:30pm
73336	6	Sat	Closed
73336	7	Sun	Closed
67554	1	Mon	12noon – 12midnight
67554	2	Tue	12noon – 12midnight
67554	3	Wed	12noon – 12midnight
67554	4	Thu	12noon – 12midnight
67554	5	Fri	12noon – 12midnight
67554	6	Sat	12noon – 12midnight
67554	7	Sun	12noon – 12midnight
69838	1	Mon	7am – 5pm
69838	2	Tue	7am – 5pm
69838	3	Wed	7am – 5pm
69838	4	Thu	7am – 5pm
69838	5	Fri	7am – 5pm
69838	6	Sat	Closed
69838	7	Sun	Closed
69865	1	Mon	8am – 8pm
69865	2	Tue	8am – 8pm
69865	3	Wed	8am – 8pm
69865	4	Thu	8am – 8pm
69865	5	Fri	8am – 9pm
69865	6	Sat	8am – 8pm
69865	7	Sun	9am – 8pm
64378	1	Mon	6:30am – 4:30pm
64378	2	Tue	6:30am – 4:30pm
64378	3	Wed	6:30am – 4:30pm
64378	4	Thu	6:30am – 4:30pm
64378	5	Fri	6:30am – 4:30pm
64378	6	Sat	6:30am – 4:30pm
64378	7	Sun	6:30am – 4:30pm
69848	1	Mon	5am – 4pm
69848	2	Tue	5am – 4pm
69848	3	Wed	5am – 4pm
69848	4	Thu	5am – 4pm
69848	5	Fri	5am – 4pm
69848	6	Sat	6am – 2pm
69848	7	Sun	7am – 2pm
73359	1	Mon	9am – 5:30pm
73359	2	Tue	9am – 5:30pm
73359	3	Wed	9am – 5:30pm
73359	4	Thu	9am – 5:30pm
73359	5	Fri	9am – 5:30pm
73359	6	Sat	9am – 5:30pm
73359	7	Sun	9am – 5:30pm
73369	1	Mon	8am – 8pm
73369	2	Tue	8am – 8pm
73369	3	Wed	8am – 8pm
73369	4	Thu	8am – 8pm
73369	5	Fri	8am – 8pm
73369	6	Sat	8am – 8pm
73369	7	Sun	Closed
69860	1	Mon	Closed
69860	2	Tue	11:30am – 9pm
69860	3	Wed	11:30am – 9pm
69860	4	Thu	11:30am – 9pm
69860	5	Fri	11:30am – 9pm
69860	6	Sat	11:30am – 9pm
69860	7	Sun	4:30pm – 9pm
67537	1	Mon	5:30am – 10pm
67537	2	Tue	5:30am – 10pm
67537	3	Wed	5:30am – 10pm
73372	1	Mon	11:30am – 11pm
73372	2	Tue	11:30am – 11pm
73372	3	Wed	11:30am – 11pm
73372	4	Thu	11:30am – 11pm
73372	5	Fri	11:30am – 2am
73372	6	Sat	11:30am – 11pm, 12midnight – 2am
73372	7	Sun	11:30am – 10pm
73395	1	Mon	6am – 4pm
73395	2	Tue	6am – 4pm
73395	3	Wed	6am – 4pm
73395	4	Thu	6am – 4pm
73395	5	Fri	6am – 4pm
73395	6	Sat	Closed
73395	7	Sun	Closed
67537	4	Thu	5:30am – 10pm
67537	5	Fri	5:30am – 11pm
67537	6	Sat	5:30am – 11pm
67537	7	Sun	7am – 10pm
73419	1	Mon	5pm – 10pm
73419	2	Tue	11am – 10:30pm
73419	3	Wed	11am – 10:30pm
73419	4	Thu	11am – 10:30pm
73419	5	Fri	11am – 11pm
73419	6	Sat	11am – 11pm
73419	7	Sun	11am – 10:30pm
55876	1	Mon	5:30pm – 10:30pm
55876	2	Tue	5:30pm – 10:30pm
55876	3	Wed	5:30pm – 10:30pm
55876	4	Thu	5:30pm – 10:30pm
55876	5	Fri	5:30pm – 11pm
55876	6	Sat	5:30pm – 11pm
55876	7	Sun	5pm – 10pm
73445	1	Mon	6am – 6pm
73445	2	Tue	6am – 6pm
73445	3	Wed	6am – 6pm
73445	4	Thu	6am – 6pm
73445	5	Fri	6am – 6pm
73445	6	Sat	6am – 6pm
73445	7	Sun	6am – 6pm
69918	1	Mon	5pm – 10:30pm
69918	2	Tue	5pm – 10:30pm
69918	3	Wed	5pm – 10:30pm
69918	4	Thu	5pm – 10:30pm
69918	5	Fri	11:30am – 10:30pm
69918	6	Sat	11:30am – 10:30pm
69918	7	Sun	11:30am – 10:30pm
64429	1	Mon	12noon – 3pm, 6pm – 9:30pm
64429	2	Tue	12noon – 3pm, 6pm – 9:30pm
64429	3	Wed	12noon – 3pm, 6pm – 9:30pm
64429	4	Thu	12noon – 3pm, 6pm – 9:30pm
64429	5	Fri	12noon – 3pm, 6pm – 9:30pm
64429	6	Sat	6pm – 9:30pm
64429	7	Sun	Closed
69929	1	Mon	10am – 4am
69929	2	Tue	10am – 4am
69929	3	Wed	10am – 4am
69929	4	Thu	10am – 4am
69929	5	Fri	10am – 5am
69929	6	Sat	9am – 5am
69929	7	Sun	10am – 10pm
69920	1	Mon	10am – 7pm
69920	2	Tue	10am – 7pm
69920	3	Wed	10am – 7pm
69920	4	Thu	10am – 7pm
69920	5	Fri	10am – 7pm
69920	6	Sat	10am – 7pm
69920	7	Sun	10am – 7pm
67567	1	Mon	11am – 11pm
67567	2	Tue	11am – 11pm
67567	3	Wed	11am – 11pm
67567	4	Thu	11am – 11pm
67567	5	Fri	11am – 11pm
67567	6	Sat	11am – 11pm
67567	7	Sun	11am – 9pm
71759	1	Mon	12noon – 3pm, 5pm – 10:30pm
71759	2	Tue	12noon – 3pm, 5pm – 10:30pm
71759	3	Wed	12noon – 3pm, 5pm – 10:30pm
71759	4	Thu	12noon – 3pm, 5pm – 10:30pm
71759	5	Fri	12noon – 3pm, 5pm – 10:30pm
71759	6	Sat	12noon – 3pm, 5pm – 10:30pm
64435	1	Mon	Closed
64435	2	Tue	11:30am – 3pm
64435	3	Wed	11:30am – 3pm
64435	4	Thu	11:30am – 3pm
64435	5	Fri	11:30am – 3pm
64435	6	Sat	11am – 9pm
64435	7	Sun	11am – 9pm
71759	7	Sun	12noon – 3pm, 5pm – 10:30pm
73488	1	Mon	10am – 4pm
73488	2	Tue	10am – 4pm
73488	3	Wed	10am – 4pm
73488	4	Thu	10am – 4pm
73488	5	Fri	10am – 4pm
73488	6	Sat	Closed
73488	7	Sun	Closed
73505	1	Mon	6:30am – 3pm
73505	2	Tue	6:30am – 3pm
73505	3	Wed	6:30am – 3pm
73505	4	Thu	6:30am – 3pm
73505	5	Fri	6:30am – 3pm
73505	6	Sat	Closed
73505	7	Sun	Closed
64501	1	Mon	12noon – 12midnight
64501	2	Tue	12noon – 12midnight
64501	3	Wed	12noon – 12midnight
64501	4	Thu	12noon – 12midnight
64501	5	Fri	12noon – 12midnight
64501	6	Sat	12noon – 1am
64501	7	Sun	12noon – 10pm
73532	1	Mon	7am – 9pm
73532	2	Tue	7am – 9pm
73532	3	Wed	7am – 9pm
73532	4	Thu	7am – 9pm
73532	5	Fri	7am – 9pm
64530	1	Mon	12noon – 3pm, 5pm – 10pm
64486	1	Mon	11am – 3pm, 5pm – 12midnight
64486	2	Tue	11am – 3pm, 5pm – 12midnight
64486	3	Wed	11am – 3pm, 5pm – 12midnight
64486	4	Thu	11am – 3pm, 5pm – 12midnight
64486	5	Fri	11am – 12midnight
64486	6	Sat	11am – 12midnight
64486	7	Sun	11am – 12midnight
64495	1	Mon	10am – 8:30pm
64495	2	Tue	10am – 8:30pm
64495	3	Wed	10am – 8:30pm
64495	4	Thu	10am – 8:30pm
64495	5	Fri	10am – 8:30pm
64495	6	Sat	10am – 8:30pm
64495	7	Sun	10am – 8:30pm
73532	6	Sat	7am – 5:30pm
73532	7	Sun	7am – 5pm
73537	1	Mon	9am – 11:30pm, 12midnight – 3am
73537	2	Tue	9am – 11:30pm, 12midnight – 3am
73537	3	Wed	9am – 11:30pm, 12midnight – 3am
73537	4	Thu	9am – 11:30pm, 12midnight – 3am
73537	5	Fri	9am – 11:30pm, 12midnight – 6am
73537	6	Sat	9am – 11:30pm, 12midnight – 6am
73537	7	Sun	10am – 10pm
64518	1	Mon	11am – 3pm, 5:30pm – 10pm
64518	2	Tue	11am – 3pm, 5:30pm – 10pm
64518	3	Wed	11am – 3pm, 5:30pm – 10pm
64518	4	Thu	11am – 3pm, 5:30pm – 10pm
64518	5	Fri	11am – 3pm, 5:30pm – 10pm
64518	6	Sat	10am – 4pm, 5:30pm – 10pm
64518	7	Sun	10am – 4pm, 5:30pm – 10pm
73543	1	Mon	8am – 4pm
73543	2	Tue	8am – 4pm
73543	3	Wed	8am – 4pm
73543	4	Thu	8am – 4pm
73543	5	Fri	8am – 4pm
73543	6	Sat	8am – 4pm
73543	7	Sun	8am – 4pm
64522	1	Mon	6:30am – 3:30pm
64522	2	Tue	6:30am – 3:30pm
64522	3	Wed	6:30am – 3:30pm
64522	4	Thu	6:30am – 3:30pm
64522	5	Fri	6:30am – 3:30pm
64522	6	Sat	Closed
64522	7	Sun	Closed
73603	1	Mon	10am – 12midnight
73603	2	Tue	10am – 12midnight
73603	3	Wed	10am – 12midnight
73603	4	Thu	10am – 12midnight
73603	5	Fri	10am – 3am
64530	2	Tue	12noon – 3pm, 5pm – 10pm
64530	3	Wed	12noon – 3pm, 5pm – 10pm
64530	4	Thu	12noon – 3pm, 5pm – 10pm
64530	5	Fri	12noon – 10pm
64530	6	Sat	12noon – 10pm
64530	7	Sun	12noon – 10pm
73603	6	Sat	10am – 3am
73603	7	Sun	10am – 12midnight
69973	1	Mon	11am – 10pm
69973	2	Tue	11am – 10pm
69973	3	Wed	11am – 10pm
69973	4	Thu	11am – 10pm
64554	1	Mon	10am – 3pm, 5:30pm – 11pm
69973	5	Fri	11am – 10pm
64554	2	Tue	10am – 3pm, 5:30pm – 11pm
64554	3	Wed	10am – 3pm, 5:30pm – 11pm
64554	4	Thu	10am – 3pm, 5:30pm – 11pm
64554	5	Fri	10am – 3pm, 5:30pm – 11pm
64554	6	Sat	10am – 4pm, 5:30pm – 11pm
64554	7	Sun	10am – 4pm, 5:30pm – 11pm
69973	6	Sat	11am – 10pm
69973	7	Sun	Closed
67624	1	Mon	Closed
67624	2	Tue	6pm – 10:30pm
67624	3	Wed	12noon – 3pm, 6pm – 10:30pm
67624	4	Thu	12noon – 3pm, 6pm – 10:30pm
67624	5	Fri	12noon – 3pm, 6pm – 10:30pm
67624	6	Sat	6pm – 11pm
67624	7	Sun	Closed
64585	1	Mon	12noon – 3pm, 6pm – 10pm
64585	2	Tue	12noon – 3pm, 6pm – 10pm
64585	3	Wed	12noon – 3pm, 6pm – 10pm
64585	4	Thu	12noon – 3pm, 6pm – 10pm
64585	5	Fri	12noon – 3pm, 6pm – 10pm
64585	6	Sat	12noon – 3pm, 6pm – 10pm
64585	7	Sun	12noon – 3pm, 6pm – 10pm
73675	1	Mon	6:30am – 3:30pm
73675	2	Tue	6:30am – 3:30pm
73675	3	Wed	6:30am – 3:30pm
73675	4	Thu	6:30am – 3:30pm
73675	5	Fri	6:30am – 3:30pm
73675	6	Sat	Closed
73675	7	Sun	Closed
73673	1	Mon	9am – 6pm
73673	2	Tue	9am – 6pm
73673	3	Wed	9am – 6pm
73673	4	Thu	9am – 6pm
73673	5	Fri	9am – 6pm
73673	6	Sat	Closed
73673	7	Sun	Closed
64638	1	Mon	11am – 6pm
64638	2	Tue	11am – 9pm
64638	3	Wed	11am – 9pm
64638	4	Thu	11am – 9pm
64638	5	Fri	11am – 9pm
64638	6	Sat	11am – 9pm
64638	7	Sun	11am – 9pm
73701	1	Mon	Closed
73701	2	Tue	7am – 4pm
73701	3	Wed	7am – 4pm
73701	4	Thu	7am – 4pm
73701	5	Fri	7am – 9:30pm
73701	6	Sat	7am – 9:30pm
73701	7	Sun	7am – 4pm
64596	1	Mon	7:30am – 12midnight
64596	2	Tue	7:30am – 12midnight
64596	3	Wed	7:30am – 12midnight
64596	4	Thu	7:30am – 12midnight
64596	5	Fri	7:30am – 12midnight
64596	6	Sat	7:30am – 12midnight
64596	7	Sun	7:30am – 12midnight
64598	1	Mon	5:30pm – 10:30pm
64598	2	Tue	4pm – 10:30pm
64598	3	Wed	12noon – 2pm, 4pm – 10:30pm
64598	4	Thu	12noon – 2pm
64598	5	Fri	12noon – 2pm, 4pm – 11:30pm
64598	6	Sat	12noon – 11:30pm
64598	7	Sun	12noon – 10pm
64607	1	Mon	7am – 1pm
64607	2	Tue	7am – 6pm
64607	3	Wed	7am – 6pm
64607	4	Thu	7am – 6pm
64607	5	Fri	7am – 10pm
64607	6	Sat	8am – 10pm
69994	1	Mon	8am – 4pm
69994	2	Tue	8am – 4pm
69994	3	Wed	8am – 4pm
69994	4	Thu	8am – 4pm
64607	7	Sun	8am – 5pm
64636	1	Mon	7:30am – 9:30pm
64636	2	Tue	7:30am – 9:30pm
64636	3	Wed	7:30am – 9:30pm
64636	4	Thu	7:30am – 10pm
64636	5	Fri	7:30am – 10pm
64636	6	Sat	Closed
64636	7	Sun	Closed
73731	1	Mon	6am – 7pm
69994	5	Fri	8am – 4pm
69994	6	Sat	8am – 3pm
69994	7	Sun	8am – 3pm
73726	1	Mon	4:30pm – 9pm
73726	2	Tue	4:30pm – 9pm
73726	3	Wed	11:30am – 3pm, 4:30pm – 10pm
73726	4	Thu	11:30am – 3pm, 4:30pm – 10pm
73726	5	Fri	11:30am – 3pm, 4:30pm – 10pm
73726	6	Sat	11:30am – 3pm, 4:30pm – 10pm
73726	7	Sun	12noon – 3pm, 4:30pm – 9pm
64685	1	Mon	5:30pm – 9pm
64685	2	Tue	Closed
64685	3	Wed	5:30pm – 10pm
64685	4	Thu	5:30pm – 10pm
64685	5	Fri	5:30pm – 10pm
64685	6	Sat	5:30pm – 10pm
64685	7	Sun	11:30am – 3pm, 5pm – 9pm
53679	1	Mon	11:30am – 9pm
53679	2	Tue	11:30am – 9pm
53679	3	Wed	11:30am – 9pm
53679	4	Thu	11:30am – 9:30pm
53679	5	Fri	11:30am – 9:30pm
53679	6	Sat	11am – 9:30pm
53679	7	Sun	11am – 9:30pm
73731	2	Tue	6am – 7pm
73731	3	Wed	6am – 7pm
73731	4	Thu	6am – 7pm
73731	5	Fri	6am – 7pm
73731	6	Sat	6am – 7pm
73731	7	Sun	6am – 7pm
73748	1	Mon	7am – 6pm
73748	2	Tue	7am – 6pm
73748	3	Wed	7am – 6pm
73748	4	Thu	7am – 6pm
73748	5	Fri	7am – 6pm
70007	1	Mon	6am – 5pm
70007	2	Tue	6am – 5pm
70007	3	Wed	6am – 5pm
70007	4	Thu	6am – 5pm
70007	5	Fri	6am – 5pm
73748	6	Sat	7am – 6pm
73748	7	Sun	Closed
67689	1	Mon	9:30am – 6pm
67689	2	Tue	9:30am – 6pm
67689	3	Wed	9:30am – 7pm
70007	6	Sat	8am – 4:30pm
70007	7	Sun	8am – 4:30pm
67689	4	Thu	9am – 9pm
67689	5	Fri	9:30am – 7pm
67689	6	Sat	8am – 7pm
67689	7	Sun	9am – 6pm
70002	1	Mon	8am – 5:30pm
70002	2	Tue	8am – 5:30pm
70002	3	Wed	8am – 5:30pm
70002	4	Thu	8am – 9pm
70002	5	Fri	8am – 5:30pm
70002	6	Sat	8am – 4pm
70002	7	Sun	8am – 4pm
73786	1	Mon	10am – 7pm
73786	2	Tue	10am – 7pm
73786	3	Wed	10am – 7pm
73786	4	Thu	10am – 7pm
73786	5	Fri	10am – 7pm
73786	6	Sat	10am – 7pm
64689	1	Mon	10am – 5pm
64689	2	Tue	10am – 5pm
64689	3	Wed	10am – 9pm
64689	4	Thu	10am – 5pm
64689	5	Fri	10am – 5pm
64689	6	Sat	10am – 5pm
64689	7	Sun	10am – 5pm
67728	1	Mon	10am – 3:30pm
67728	2	Tue	10am – 3:30pm
67728	3	Wed	10am – 3:30pm
67728	4	Thu	10am – 3:30pm
67728	5	Fri	10am – 3:30pm
67728	6	Sat	Closed
67728	7	Sun	Closed
67729	1	Mon	12noon – 8pm
67729	2	Tue	12noon – 8pm
67729	3	Wed	12noon – 8pm
67729	4	Thu	12noon – 8pm
67729	5	Fri	12noon – 8pm
67729	6	Sat	11am – 8pm
67729	7	Sun	11am – 8pm
70018	1	Mon	Closed
73779	1	Mon	5:30am – 3pm
73779	2	Tue	5:30am – 3pm
73779	3	Wed	5:30am – 3pm
73779	4	Thu	5:30am – 3pm
73779	5	Fri	5:30am – 3pm
73779	6	Sat	6:30am – 1pm
73779	7	Sun	Closed
73786	7	Sun	10am – 7pm
73800	1	Mon	5pm – 9:30pm
73800	2	Tue	5pm – 9:30pm
73800	3	Wed	11am – 3:30pm, 5pm – 9:30pm
73800	4	Thu	11am – 3:30pm, 5pm – 9:30pm
73800	5	Fri	11am – 3:30pm, 5pm – 9:30pm
73800	6	Sat	11am – 3:30pm, 5pm – 9:30pm
73800	7	Sun	11am – 3:30pm, 5pm – 9:30pm
70018	2	Tue	Closed
70018	3	Wed	12noon – 8:30pm
70018	4	Thu	12noon – 8:30pm
70018	5	Fri	12noon – 8:30pm
70018	6	Sat	12noon – 8:30pm
70018	7	Sun	12noon – 4pm
73808	1	Mon	7am – 3pm
73808	2	Tue	7am – 3pm
73808	3	Wed	7am – 3pm
73808	4	Thu	7am – 3pm
73808	5	Fri	7am – 3pm
73808	6	Sat	Closed
73808	7	Sun	Closed
64750	1	Mon	7am – 3pm
64750	2	Tue	7am – 3pm
64750	3	Wed	7am – 3pm, 5pm – 10pm
64750	4	Thu	7am – 3pm, 5pm – 10pm
64750	5	Fri	7am – 3pm, 5pm – 10pm
64750	6	Sat	7am – 3pm, 5pm – 10pm
64750	7	Sun	7am – 3pm
67810	1	Mon	11am – 2:30pm, 5pm – 9pm
67810	2	Tue	11am – 2:30pm, 5pm – 9pm
67810	3	Wed	11am – 2:30pm, 5pm – 9pm
67810	4	Thu	11am – 2:30pm, 5pm – 9pm
67810	5	Fri	11am – 2:30pm, 5pm – 9:30pm
73868	1	Mon	11:30am – 9:30pm
73868	2	Tue	11:30am – 9:30pm
73868	3	Wed	11:30am – 9:30pm
73868	4	Thu	11:30am – 9:30pm
73868	5	Fri	11:30am – 9:30pm
73868	6	Sat	11:30am – 12midnight
73868	7	Sun	11:30am – 9:30pm
73885	1	Mon	9am – 5pm
73885	2	Tue	9am – 5pm
73885	3	Wed	9am – 5pm
73885	4	Thu	9am – 9pm
73885	5	Fri	9am – 5pm
73885	6	Sat	9am – 5pm
73885	7	Sun	10am – 4pm
67810	6	Sat	11am – 2:30pm, 5pm – 9:30pm
67810	7	Sun	5pm – 9pm
64759	1	Mon	10am – 11pm
64759	2	Tue	10am – 11:30pm
64759	3	Wed	10am – 11:30pm
64759	4	Thu	10am – 11:30pm
64759	5	Fri	10am – 11:30pm
64759	6	Sat	10am – 11:30pm
64759	7	Sun	10am – 11pm
53829	1	Mon	5pm – 12midnight
53829	2	Tue	5pm – 12midnight
53829	3	Wed	5pm – 12midnight
53829	4	Thu	5pm – 12midnight
53829	5	Fri	5pm – 12midnight
53829	6	Sat	5pm – 12midnight
53829	7	Sun	4pm – 11pm
58002	1	Mon	10am – 7pm
58002	2	Tue	10am – 7pm
58002	3	Wed	10am – 7pm
58002	4	Thu	10am – 9pm
58002	5	Fri	10am – 7pm
58002	6	Sat	10:30am – 6:30pm
58002	7	Sun	10:30am – 6pm
13121	1	Mon	11:30am – 9:30pm
13121	2	Tue	11:30am – 9:30pm
13121	3	Wed	11:30am – 9:30pm
13121	4	Thu	11:30am – 9:30pm
13121	5	Fri	11:30am – 9:30pm
13121	6	Sat	11:30am – 9:30pm
13121	7	Sun	11:30am – 9:30pm
67869	1	Mon	11am – 10pm
67869	2	Tue	11am – 10pm
67869	3	Wed	11am – 10pm
67869	4	Thu	11am – 10pm
67869	5	Fri	11am – 10pm
67869	6	Sat	11am – 10pm
67869	7	Sun	11am – 10pm
13126	1	Mon	11:30am – 9:45pm
13126	2	Tue	11:30am – 9:45pm
13126	3	Wed	11:30am – 9:45pm
13126	4	Thu	11:30am – 9:45pm
13126	5	Fri	11:30am – 9:45pm
13126	6	Sat	11:30am – 9:45pm
13126	7	Sun	11:30am – 9:45pm
73860	1	Mon	10am – 10:59pm, 12midnight – 2am
73860	2	Tue	10am – 10:59pm, 12midnight – 2am
73860	3	Wed	10am – 10:59pm, 12midnight – 2am
73860	4	Thu	10am – 10:59pm, 12midnight – 2am
73860	5	Fri	10am – 10:59pm, 12midnight – 3:30am
73860	6	Sat	10am – 10:59pm, 12midnight – 3:30am
73860	7	Sun	10am – 10:59pm, 12midnight – 2am
53862	1	Mon	10am – 5pm
53862	2	Tue	10am – 5pm
53862	3	Wed	10am – 5pm
53862	4	Thu	10am – 9pm
53862	5	Fri	10am – 5pm
53862	6	Sat	10am – 5pm
53862	7	Sun	10am – 5pm
70029	1	Mon	12noon – 10pm
70029	2	Tue	12noon – 10pm
73892	1	Mon	8:30am – 10pm
73892	2	Tue	8:30am – 10pm
73892	3	Wed	8:30am – 10pm
73892	4	Thu	8:30am – 10pm
73892	5	Fri	8:30am – 10pm
73892	6	Sat	8:30am – 10pm
73892	7	Sun	8:30am – 10pm
70029	3	Wed	12noon – 10pm
70029	4	Thu	12noon – 10pm
70029	5	Fri	12noon – 10pm
70029	6	Sat	11am – 10pm
70029	7	Sun	11am – 10pm
67901	1	Mon	9:30am – 7:30pm
67901	2	Tue	9:30am – 7:30pm
67901	3	Wed	9:30am – 7:30pm
67901	4	Thu	9:30am – 9pm
67901	5	Fri	9:30am – 7:30pm
67879	1	Mon	12noon – 3pm, 5pm – 10pm
67879	2	Tue	12noon – 3pm, 5pm – 10pm
67879	3	Wed	12noon – 3pm, 5pm – 10pm
67879	4	Thu	12noon – 3pm, 5pm – 10pm
67879	5	Fri	12noon – 3pm, 5pm – 10pm
67879	6	Sat	12noon – 3pm, 5pm – 10pm
67879	7	Sun	12noon – 3pm, 5pm – 9pm
64852	1	Mon	12noon – 2:30pm, 5pm – 9:30pm
64852	2	Tue	12noon – 2:30pm, 5pm – 9:30pm
64852	3	Wed	12noon – 2:30pm, 5pm – 9:30pm
64852	4	Thu	12noon – 2:30pm, 5pm – 9:30pm
64852	5	Fri	12noon – 2:30pm, 5pm – 9:30pm
64852	6	Sat	5pm – 9:30pm
64852	7	Sun	Closed
73901	1	Mon	10am – 3pm, 4pm – 10pm
73901	2	Tue	10am – 3pm, 4pm – 10pm
73901	3	Wed	10am – 3pm, 4pm – 10pm
73901	4	Thu	10am – 3pm, 4pm – 10pm
73901	5	Fri	10am – 3pm, 4pm – 10pm
73901	6	Sat	10am – 3pm, 4pm – 10pm
73901	7	Sun	10am – 3pm, 4pm – 10pm
67901	6	Sat	9:30am – 7:30pm
67901	7	Sun	9:30am – 7:30pm
64877	1	Mon	6pm – 10:30pm
64877	2	Tue	6pm – 10:30pm
64877	3	Wed	6pm – 10:30pm
64877	4	Thu	6pm – 10:30pm
64877	5	Fri	12noon – 10:30pm
64877	6	Sat	12noon – 10:30pm
64877	7	Sun	12noon – 10pm
73905	1	Mon	5:30am – 6pm
73905	2	Tue	5:30am – 6pm
73905	3	Wed	5:30am – 9pm
73905	4	Thu	5:30am – 9pm
73905	5	Fri	5:30am – 9pm
73905	6	Sat	6:30am – 9pm
73905	7	Sun	6:30am – 9pm
67924	1	Mon	8am – 7pm
67924	2	Tue	8am – 7pm
67924	3	Wed	8am – 7pm
67924	4	Thu	8am – 7pm
67924	5	Fri	8am – 7pm
67924	6	Sat	8am – 7pm
67924	7	Sun	8am – 7pm
64897	1	Mon	6:30am – 4:30pm
64897	2	Tue	6:30am – 4:30pm
64897	3	Wed	6:30am – 4:30pm
64897	4	Thu	6:30am – 4:30pm
64897	5	Fri	6:30am – 4:30pm
64897	6	Sat	7am – 4:30pm
64897	7	Sun	7am – 4:30pm
67943	1	Mon	7am – 4pm
67943	2	Tue	7am – 4pm
67943	3	Wed	7am – 4pm
67943	4	Thu	7am – 4pm
67943	5	Fri	7am – 4pm
67943	6	Sat	7am – 4pm
67943	7	Sun	Closed
64946	1	Mon	12noon – 3pm, 5:30pm – 9:30pm
64946	2	Tue	12noon – 3pm, 5:30pm – 9:30pm
64946	3	Wed	12noon – 3pm, 5:30pm – 9:30pm
64946	4	Thu	12noon – 3pm, 5:30pm – 9:30pm
64946	5	Fri	12noon – 3pm, 5:30pm – 10pm
64946	6	Sat	8am – 11am, 5:30pm – 10pm, 12noon – 3pm
64946	7	Sun	8am – 11am, 5:30pm – 9:30pm, 12noon – 3pm
64953	1	Mon	5pm – 11pm
64953	2	Tue	5pm – 11pm
74007	1	Mon	5:30am – 4pm
74007	2	Tue	5:30am – 4pm
74007	3	Wed	5:30am – 4pm
74007	4	Thu	5:30am – 4pm
74007	5	Fri	5:30am – 4pm
67970	1	Mon	12noon – 3pm, 6pm – 10pm
67970	2	Tue	12noon – 3pm, 6pm – 10pm
67970	3	Wed	12noon – 3pm, 6pm – 10pm
67970	4	Thu	12noon – 3pm, 6pm – 10pm
67970	5	Fri	12noon – 3pm, 6pm – 10pm
67970	6	Sat	6pm – 10pm
67970	7	Sun	6pm – 10pm
64950	1	Mon	11:30am – 2:30pm, 5:30pm – 10pm
64950	2	Tue	11:30am – 2:30pm, 5:30pm – 10pm
64950	3	Wed	11:30am – 2:30pm, 5:30pm – 10pm
64950	4	Thu	11:30am – 2:30pm, 5:30pm – 10pm
64950	5	Fri	11:30am – 2:30pm, 5:30pm – 10pm
64950	6	Sat	11:30am – 2:30pm, 5:30pm – 10pm
73987	1	Mon	11am – 8:30pm
73987	2	Tue	11am – 8:30pm
73987	3	Wed	11am – 8:30pm
73987	4	Thu	11am – 8:30pm
73987	5	Fri	11am – 8:30pm
73987	6	Sat	11am – 8:30pm
73987	7	Sun	11am – 8:30pm
74035	1	Mon	6am – 6pm
74035	2	Tue	6am – 6pm
74035	3	Wed	6am – 6pm
74035	4	Thu	6am – 6pm
74035	5	Fri	6am – 6pm
74035	6	Sat	Closed
74035	7	Sun	Closed
74007	6	Sat	6:30am – 3pm
74007	7	Sun	Closed
54007	1	Mon	Closed
54007	2	Tue	5pm – 8:30pm
54007	3	Wed	5pm – 8:30pm
54007	4	Thu	5pm – 8:30pm
54007	5	Fri	5pm – 8:30pm
54007	6	Sat	5pm – 8:30pm
54007	7	Sun	5pm – 8:30pm
64950	7	Sun	11:30am – 2:30pm, 5:30pm – 10pm
64953	3	Wed	5pm – 11pm
64953	4	Thu	5pm – 11pm
64953	5	Fri	5pm – 11pm
64953	6	Sat	5pm – 11pm
64953	7	Sun	12noon – 11pm
67975	1	Mon	8am – 11pm
67975	2	Tue	8am – 11pm
67975	3	Wed	8am – 11pm
67975	4	Thu	8am – 11pm
67975	5	Fri	8am – 11pm
67975	6	Sat	8am – 11pm
67975	7	Sun	8am – 11pm
64970	1	Mon	12noon – 10pm
64970	2	Tue	12noon – 10pm
64970	3	Wed	12noon – 10pm
64970	4	Thu	12noon – 10pm
64970	5	Fri	12noon – 10:30pm
64970	6	Sat	12noon – 10:30pm
64970	7	Sun	12noon – 10pm
70111	1	Mon	7am – 3pm
70111	2	Tue	7am – 3pm
70111	3	Wed	7am – 3pm
70111	4	Thu	7am – 3pm
70111	5	Fri	7am – 3pm
70111	6	Sat	8am – 2pm
70111	7	Sun	Closed
65022	1	Mon	11:30am – 3pm, 4:30pm – 9pm
65022	2	Tue	11:30am – 3pm, 4:30pm – 9pm
65022	3	Wed	11:30am – 3pm, 4:30pm – 9pm
65022	4	Thu	11:30am – 3pm, 4:30pm – 9pm
65022	5	Fri	11:30am – 3pm, 4:30pm – 9pm
65022	6	Sat	11:30am – 3pm, 4:30pm – 9pm
65022	7	Sun	11:30am – 3pm, 4:30pm – 9pm
65001	1	Mon	11:30am – 10pm
65001	2	Tue	11:30am – 10pm
65001	3	Wed	11:30am – 10pm
65001	4	Thu	11:30am – 10pm
65001	5	Fri	11:30am – 11pm
65001	6	Sat	11:30am – 11pm
65001	7	Sun	11:30am – 10pm
74064	1	Mon	7am – 3pm
74064	2	Tue	7am – 3pm
74064	3	Wed	7am – 3pm
74064	4	Thu	7am – 3pm
74064	5	Fri	7am – 3pm
74064	6	Sat	7am – 3pm
74064	7	Sun	7am – 3pm
70113	1	Mon	Closed
70113	2	Tue	11am – 9:30pm
70113	3	Wed	11am – 9:30pm
70113	4	Thu	11am – 9:30pm
70113	5	Fri	11am – 9:30pm
70113	6	Sat	5pm – 9:30pm
70113	7	Sun	5pm – 9:30pm
74050	1	Mon	5pm – 9:30pm
74050	2	Tue	5pm – 9:30pm
74050	3	Wed	5pm – 10pm
74050	4	Thu	5pm – 10pm
74050	5	Fri	5pm – 10:30pm
70125	1	Mon	12noon – 2pm, 5:30pm – 8:30pm
70125	2	Tue	12noon – 2pm, 5:30pm – 8:30pm
70125	3	Wed	12noon – 2pm, 5:30pm – 8:30pm
70125	4	Thu	12noon – 2pm, 5:30pm – 8:30pm
70125	5	Fri	12noon – 2pm, 5pm – 9:30pm
74050	6	Sat	5pm – 10:30pm
74050	7	Sun	5pm – 9:30pm
74098	1	Mon	7am – 4pm
74098	2	Tue	7am – 4pm
74098	3	Wed	7am – 4pm
74098	4	Thu	7am – 4pm
74098	5	Fri	7am – 4pm
74098	6	Sat	7am – 5pm
74098	7	Sun	7am – 5pm
70125	6	Sat	12noon – 2pm, 5pm – 9:30pm
70125	7	Sun	12noon – 2pm, 5:30pm – 8:30pm
65050	1	Mon	6am – 10pm
65050	2	Tue	6am – 10pm
65050	3	Wed	6am – 10pm
65050	4	Thu	6am – 10pm
65050	5	Fri	6am – 10pm
65050	6	Sat	7am – 10pm
65050	7	Sun	7am – 10pm
67984	1	Mon	6:30am – 5pm
67984	2	Tue	6:30am – 5pm
67984	3	Wed	6:30am – 5pm
67984	4	Thu	6:30am – 5pm
67984	5	Fri	6:30am – 5pm
67984	6	Sat	6:30am – 3pm
67984	7	Sun	Closed
74160	1	Mon	Closed
74160	2	Tue	12noon – 2:30pm, 5:30pm – 9pm
74160	3	Wed	12noon – 2:30pm, 5:30pm – 9pm
74160	4	Thu	12noon – 2:30pm, 5:30pm – 9pm
74160	5	Fri	12noon – 2:30pm, 5:30pm – 9pm
74160	6	Sat	12noon – 2:30pm, 5:30pm – 9pm
74160	7	Sun	12noon – 2:30pm, 5:30pm – 9pm
70185	1	Mon	9am – 1am
70185	2	Tue	9am – 1am
70185	3	Wed	9am – 1am
70185	4	Thu	9am – 1am
70185	5	Fri	9am – 1am
70185	6	Sat	9am – 1am
70185	7	Sun	9am – 1am
70197	1	Mon	Closed
70197	2	Tue	11am – 9:30pm
70197	3	Wed	11am – 9:30pm
67994	1	Mon	6:30am – 7pm
67994	2	Tue	6:30am – 7pm
67994	3	Wed	6:30am – 7pm
67994	4	Thu	6:30am – 7pm
67994	5	Fri	6:30am – 7pm
67994	6	Sat	7am – 7pm
67994	7	Sun	8am – 8pm
68050	1	Mon	6am – 3pm
68050	2	Tue	6am – 3pm
68050	3	Wed	6am – 3pm
68050	4	Thu	6am – 3pm
68050	5	Fri	6am – 3pm
68050	6	Sat	6am – 3pm
68050	7	Sun	Closed
65101	1	Mon	7am – 11:30pm
65101	2	Tue	7am – 11:30pm
65101	3	Wed	7am – 11:30pm
65101	4	Thu	7am – 11:30pm
65101	5	Fri	7am – 11:30pm
65101	6	Sat	7am – 11:30pm
65101	7	Sun	7am – 11:30pm
65112	1	Mon	10am – 1am
65112	2	Tue	10am – 1am
65112	3	Wed	10am – 3am
65112	4	Thu	10am – 3am
65112	5	Fri	10am – 3am
65112	6	Sat	10am – 3am
65112	7	Sun	11am – 10pm
65130	1	Mon	6am – 9pm
65130	2	Tue	6am – 9pm
65130	3	Wed	6am – 9pm
65130	4	Thu	6am – 9pm
65130	5	Fri	6am – 9pm
65130	6	Sat	7am – 9pm
65130	7	Sun	7am – 9pm
65115	1	Mon	6am – 4pm
65115	2	Tue	6am – 4pm, 5pm – 10pm
65115	3	Wed	6am – 4pm, 5pm – 10pm
65115	4	Thu	6am – 4pm, 5pm – 10pm
65115	5	Fri	6am – 4pm, 5pm – 10pm
65115	6	Sat	6am – 4pm, 5pm – 10pm
65115	7	Sun	6am – 4pm
70197	4	Thu	11am – 9:30pm
70197	5	Fri	11am – 10pm
70197	6	Sat	11am – 10pm
70197	7	Sun	11am – 9:30pm
54145	1	Mon	6pm – 10pm
54145	2	Tue	6pm – 10pm
54145	3	Wed	6pm – 10pm
54145	4	Thu	6pm – 11pm
54145	5	Fri	6pm – 11pm
54145	6	Sat	6pm – 11pm
54145	7	Sun	Closed
74180	1	Mon	10:30am – 10pm
74180	2	Tue	10:30am – 10pm
74180	3	Wed	10:30am – 10pm
74180	4	Thu	10:30am – 10pm
74180	5	Fri	10:30am – 11pm
65169	1	Mon	6:30am – 3pm
65169	2	Tue	6:30am – 3pm
65169	3	Wed	6:30am – 3pm
65169	4	Thu	6:30am – 3pm
65169	5	Fri	6:30am – 3pm
65169	6	Sat	7:30am – 3pm
65169	7	Sun	7:30am – 3pm
74180	6	Sat	10:30am – 11pm
74180	7	Sun	10:30am – 11pm
74182	1	Mon	11am – 4pm, 4:30pm – 9:30pm
74182	2	Tue	11am – 4pm, 4:30pm – 9:30pm
74182	3	Wed	11am – 4pm, 4:30pm – 9:30pm
74182	4	Thu	11am – 4pm, 4:30pm – 9:30pm
74182	5	Fri	11am – 4pm, 4:30pm – 9:30pm
74182	6	Sat	11am – 4pm, 4:30pm – 9:30pm
74182	7	Sun	11am – 4pm, 4:30pm – 9:30pm
70265	1	Mon	9am – 5pm
70265	2	Tue	9am – 5pm
70265	3	Wed	9am – 5pm
70265	4	Thu	9am – 5pm
70265	5	Fri	9am – 5pm
70265	6	Sat	9am – 5pm
70265	7	Sun	9am – 5pm
65172	1	Mon	Closed
65172	2	Tue	6pm – 9pm
65172	3	Wed	6pm – 9pm
65172	4	Thu	6pm – 9pm
65172	5	Fri	12noon – 2pm, 6pm – 10pm
65172	6	Sat	6pm – 10pm
65172	7	Sun	Closed
70263	1	Mon	7am – 6pm
70263	2	Tue	7am – 6pm
70263	3	Wed	7am – 6pm
70263	4	Thu	7am – 6pm
70263	5	Fri	7am – 6pm
70263	6	Sat	7am – 6pm
70263	7	Sun	8am – 5pm
65192	1	Mon	10am – 10pm
65192	2	Tue	10am – 10pm
65192	3	Wed	10am – 10pm
65192	4	Thu	10am – 10pm
65192	5	Fri	10am – 10pm
65192	6	Sat	9am – 10pm
65192	7	Sun	9am – 10pm
70275	1	Mon	8am – 5pm
70275	2	Tue	8am – 5pm
70275	3	Wed	8am – 5pm
70275	4	Thu	8am – 12midnight
70275	5	Fri	8am – 12midnight
70275	6	Sat	8am – 12midnight
70275	7	Sun	8am – 9:30pm
65210	1	Mon	Closed
65210	2	Tue	11am – 3pm, 5pm – 10:30pm
65210	3	Wed	11am – 3pm, 5pm – 10:30pm
65210	4	Thu	11am – 3pm, 5pm – 10:30pm
65210	5	Fri	11am – 3pm, 5pm – 10:30pm
65210	6	Sat	11am – 10:30pm
65210	7	Sun	11am – 10:30pm
65233	1	Mon	Closed
65233	2	Tue	11am – 2:30pm, 5pm – 9:30pm
65233	3	Wed	11am – 2:30pm, 5pm – 9:30pm
65233	4	Thu	11am – 2:30pm, 5pm – 9:30pm
65233	5	Fri	11am – 2:30pm, 5pm – 9:30pm
65233	6	Sat	11am – 2:30pm, 5pm – 9:30pm
65233	7	Sun	5pm – 9:30pm
65245	1	Mon	7am – 2:30pm
65245	2	Tue	7am – 2:30pm
65245	3	Wed	7am – 2:30pm
65245	4	Thu	7am – 2:30pm
65245	5	Fri	7am – 2:30pm
65245	6	Sat	7:30am – 3pm
65245	7	Sun	7:30am – 3pm
61506	1	Mon	7am – 4:30pm
61506	2	Tue	7am – 4:30pm
61506	3	Wed	7am – 4:30pm
61506	4	Thu	7am – 4:30pm
61506	5	Fri	7am – 4:30pm
61506	6	Sat	7am – 2pm
61506	7	Sun	Closed
70325	1	Mon	7am – 9pm
70325	2	Tue	7am – 9pm
70325	3	Wed	7am – 9pm
70325	4	Thu	7am – 9pm
70325	5	Fri	7am – 9pm
70325	6	Sat	7am – 9pm
70325	7	Sun	7am – 9pm
65298	1	Mon	7am – 3:30pm
65298	2	Tue	7am – 3:30pm
65298	3	Wed	7am – 3:30pm
65298	4	Thu	7am – 3:30pm
65298	5	Fri	7am – 3:30pm
65298	6	Sat	Closed
65298	7	Sun	Closed
65317	1	Mon	12noon – 3pm, 5:30pm – 9pm
65317	2	Tue	12noon – 3pm, 5:30pm – 9pm
65317	3	Wed	12noon – 3pm, 5:30pm – 9pm
65317	4	Thu	12noon – 3pm, 5:30pm – 10pm
65317	5	Fri	12noon – 3pm, 5:30pm – 10pm
65317	6	Sat	12noon – 3pm, 5:30pm – 10pm
65317	7	Sun	Closed
65310	1	Mon	11:30am – 2:30pm, 5pm – 9:30pm
65310	2	Tue	11:30am – 2:30pm, 5pm – 9:30pm
65310	3	Wed	11:30am – 2:30pm, 5pm – 9:30pm
65310	4	Thu	11:30am – 2:30pm, 5pm – 9:30pm
65310	5	Fri	11:30am – 2:30pm, 5pm – 9:30pm
65310	6	Sat	11:30am – 9:30pm
65310	7	Sun	11:30am – 9:30pm
70349	1	Mon	5am – 3:30pm
70349	2	Tue	5am – 3:30pm
70349	3	Wed	5am – 3:30pm
70349	4	Thu	5am – 3:30pm
70349	5	Fri	5am – 3:30pm
70349	6	Sat	5am – 3:30pm
70349	7	Sun	5am – 3:30pm
70357	1	Mon	11am – 9pm
70357	2	Tue	11am – 9pm
70357	3	Wed	11am – 9pm
70357	4	Thu	11am – 9pm
70357	5	Fri	11am – 9pm
70357	6	Sat	11am – 9pm
70357	7	Sun	11am – 9pm
65339	1	Mon	8am – 6pm
65339	2	Tue	8am – 6pm
65339	3	Wed	8am – 6pm
65339	4	Thu	8am – 6pm
65339	5	Fri	8am – 6pm
65311	1	Mon	12noon – 12midnight
65311	2	Tue	12noon – 12midnight
65311	3	Wed	12noon – 12midnight
65311	4	Thu	12noon – 12midnight
65311	5	Fri	12noon – 12midnight
65311	6	Sat	12noon – 12midnight
65311	7	Sun	12noon – 12midnight
65320	1	Mon	12noon – 3pm, 5:30pm – 9:30pm
65320	2	Tue	12noon – 3pm, 5:30pm – 9:30pm
65320	3	Wed	12noon – 3pm, 5:30pm – 9:30pm
65320	4	Thu	12noon – 3pm, 5:30pm – 9:30pm
65320	5	Fri	12noon – 3pm, 5:30pm – 9:30pm
65320	6	Sat	12noon – 3pm, 5:30pm – 9:30pm
65320	7	Sun	12noon – 3pm, 5:30pm – 9:30pm
65339	6	Sat	9am – 6pm
65339	7	Sun	9am – 4pm
68079	1	Mon	7:30am – 4pm
68079	2	Tue	7:30am – 4pm
68079	3	Wed	7:30am – 4pm
68079	4	Thu	7:30am – 4pm
70368	1	Mon	6am – 4pm
70368	2	Tue	6am – 4pm
70368	3	Wed	6am – 4pm
70368	4	Thu	6am – 4pm
70368	5	Fri	6am – 4pm
70368	6	Sat	6am – 4pm
70368	7	Sun	6am – 4pm
61632	1	Mon	7am – 5pm
61632	2	Tue	7am – 5pm
61632	3	Wed	7am – 5pm
61632	4	Thu	7am – 5pm
61632	5	Fri	7am – 5pm
61632	6	Sat	7am – 5pm
61632	7	Sun	7am – 5pm
16572	1	Mon	9am – 10pm
16572	2	Tue	9am – 10pm
16572	3	Wed	9am – 10pm
16572	4	Thu	9am – 10pm
16572	5	Fri	9am – 11:30pm
16572	6	Sat	9am – 11:30pm
16572	7	Sun	9am – 10pm
68079	5	Fri	7:30am – 4pm
68079	6	Sat	Closed
68079	7	Sun	Closed
56779	1	Mon	10am – 10pm
56779	2	Tue	10am – 10pm
56779	3	Wed	10am – 10pm
56779	4	Thu	10am – 10pm
56779	5	Fri	10am – 10:30pm
56779	6	Sat	10am – 10:30pm
56779	7	Sun	10am – 10:30pm
68107	1	Mon	11:30am – 10:30pm
68107	2	Tue	11:30am – 10:30pm
68107	3	Wed	11:30am – 10:30pm
68107	4	Thu	11:30am – 10:30pm
68107	5	Fri	11:30am – 11:30pm
68107	6	Sat	11:30am – 11:30pm
68107	7	Sun	11:30am – 10:30pm
68115	1	Mon	12noon – 9pm
68115	2	Tue	12noon – 9pm
68115	3	Wed	12noon – 9pm
68115	4	Thu	12noon – 9pm
68115	5	Fri	12noon – 9pm
68115	6	Sat	12noon – 9pm
68115	7	Sun	12noon – 9pm
65391	1	Mon	12noon – 3pm, 5:30pm – 10pm
56813	1	Mon	7am – 9pm
56813	2	Tue	7am – 9pm
56813	3	Wed	7am – 9pm
56813	4	Thu	7am – 9pm
56813	5	Fri	7am – 9pm
56813	6	Sat	7am – 9pm
56813	7	Sun	7am – 9pm
70395	1	Mon	10am – 8pm
70395	2	Tue	10am – 8pm
70395	3	Wed	10am – 8pm
70395	4	Thu	10am – 8pm
70395	5	Fri	10am – 8pm
70395	6	Sat	10am – 8pm
70395	7	Sun	10am – 8pm
61732	1	Mon	6am – 6pm
61732	2	Tue	6am – 6pm
61732	3	Wed	6am – 6pm
61732	4	Thu	6am – 6pm
61732	5	Fri	6am – 6pm
61732	6	Sat	6am – 4pm
61732	7	Sun	6am – 3pm
65411	1	Mon	Closed
65411	2	Tue	Closed
65411	3	Wed	12noon – 11:30pm
65411	4	Thu	12noon – 11:30pm
65391	2	Tue	12noon – 3pm, 5:30pm – 10pm
65391	3	Wed	12noon – 3pm, 5:30pm – 10pm
65391	4	Thu	12noon – 3pm, 5:30pm – 10pm
65391	5	Fri	12noon – 3pm, 5:30pm – 10pm
65391	6	Sat	12noon – 3pm, 5:30pm – 10pm
65391	7	Sun	12noon – 3pm, 5:30pm – 10pm
65411	5	Fri	12noon – 11:30pm
65411	6	Sat	12noon – 11:30pm
65411	7	Sun	10am – 4pm
70451	1	Mon	6am – 6pm
70451	2	Tue	6am – 6pm
70451	3	Wed	6am – 6pm
70451	4	Thu	6am – 6pm
70451	5	Fri	6am – 6pm
70451	6	Sat	6am – 2:30pm
70451	7	Sun	6am – 2:30pm
70452	1	Mon	5am – 5pm
70452	2	Tue	5am – 5pm
70452	3	Wed	5am – 5pm
70452	4	Thu	5am – 5pm
70452	5	Fri	5am – 5pm
70452	6	Sat	5am – 3pm
70452	7	Sun	5am – 2pm
70464	1	Mon	11am – 10pm
70464	2	Tue	11am – 10pm
70464	3	Wed	11am – 10pm
70464	4	Thu	11am – 10pm
70464	5	Fri	11am – 10pm
70464	6	Sat	11am – 10pm
70464	7	Sun	11am – 10pm
65488	1	Mon	8:30am – 5:30pm
65488	2	Tue	8:30am – 5:30pm
65488	3	Wed	8:30am – 5:30pm
65488	4	Thu	8:30am – 5:30pm
65488	5	Fri	8:30am – 5:30pm
65488	6	Sat	8:30am – 5pm
65488	7	Sun	8:30am – 5:30pm
65531	1	Mon	6am – 5pm
65531	2	Tue	6am – 5pm
65531	3	Wed	6am – 5pm
65531	4	Thu	6am – 5pm
65531	5	Fri	6am – 5pm
65531	6	Sat	8am – 4pm
65531	7	Sun	8am – 4pm
65518	1	Mon	11:30am – 10:30pm
65518	2	Tue	11:30am – 10:30pm
65518	3	Wed	11:30am – 10:30pm
65518	4	Thu	11:30am – 10:30pm
65518	5	Fri	11:30am – 10:30pm
65518	6	Sat	11:30am – 10:30pm
65518	7	Sun	11:30am – 10:30pm
70475	1	Mon	7am – 3pm
70475	2	Tue	7am – 3pm
70475	3	Wed	7am – 3pm
70475	4	Thu	7am – 3pm
70475	5	Fri	7am – 3pm
70475	6	Sat	7am – 3pm
70475	7	Sun	7am – 3pm
65551	1	Mon	10am – 12midnight
65551	2	Tue	10am – 12midnight
65551	3	Wed	10am – 12midnight
65551	4	Thu	10am – 2am
65551	5	Fri	10am – 2am
65551	6	Sat	10am – 2am
65551	7	Sun	10am – 10pm
65586	1	Mon	9am – 2pm
65586	2	Tue	9am – 2pm
65586	3	Wed	9am – 2pm
65586	4	Thu	9am – 2pm
65586	5	Fri	9am – 2pm
65586	6	Sat	9am – 2pm
65586	7	Sun	9am – 2pm
70520	1	Mon	9:30am – 6pm
70520	2	Tue	9:30am – 6pm
70520	3	Wed	9:30am – 6pm
70520	4	Thu	9:30am – 9pm
70520	5	Fri	9:30am – 6pm
70520	6	Sat	9am – 6pm
70520	7	Sun	10am – 6pm
65633	1	Mon	Closed
65633	2	Tue	12noon – 3pm, 5:30pm – 10pm
65633	3	Wed	12noon – 3pm, 5:30pm – 10pm
65633	4	Thu	12noon – 3pm, 5:30pm – 10pm
65633	5	Fri	12noon – 3pm, 5:30pm – 10pm
65633	6	Sat	5:30pm – 10pm
65633	7	Sun	5:30pm – 10pm
54366	1	Mon	12noon – 3pm
54366	2	Tue	12noon – 3pm, 6pm – 9:30pm
54366	3	Wed	12noon – 3pm, 6pm – 9:30pm
54366	4	Thu	12noon – 3pm, 6pm – 9:30pm
54366	5	Fri	12noon – 3pm, 6pm – 9:30pm
54366	6	Sat	12noon – 3pm, 6pm – 9:30pm
54366	7	Sun	12noon – 3pm, 6pm – 9:30pm
70514	1	Mon	12noon – 2:30pm, 5pm – 9:30pm
70514	2	Tue	12noon – 2:30pm, 5pm – 9:30pm
70514	3	Wed	12noon – 2:30pm, 5pm – 9:30pm
65675	1	Mon	11:30am – 10pm
65675	2	Tue	11:30am – 10pm
65675	3	Wed	11:30am – 10pm
65675	4	Thu	11:30am – 10pm
65675	5	Fri	11:30am – 10pm
65675	6	Sat	11:30am – 10pm
65675	7	Sun	11:30am – 10pm
65766	1	Mon	8am – 4pm
65766	2	Tue	8am – 4pm
65766	3	Wed	8am – 4pm
65766	4	Thu	8am – 4pm, 5pm – 9pm
65766	5	Fri	8am – 4pm, 5pm – 9pm
65766	6	Sat	8am – 4pm, 5pm – 9pm
65766	7	Sun	8am – 4pm, 5pm – 9pm
70514	4	Thu	12noon – 2:30pm, 5pm – 9:30pm
70514	5	Fri	12noon – 2:30pm, 5pm – 10pm
70514	6	Sat	5pm – 10pm
70514	7	Sun	5pm – 9:30pm
65691	1	Mon	6am – 4pm
65691	2	Tue	6am – 4pm
65691	3	Wed	6am – 4pm
65691	4	Thu	6am – 4pm
65691	5	Fri	6am – 4pm
65691	6	Sat	7am – 4pm
65691	7	Sun	7am – 4pm
65729	1	Mon	7am – 3pm
65729	2	Tue	7am – 3pm
65729	3	Wed	7am – 3pm
65729	4	Thu	7am – 3pm
65729	5	Fri	7am – 3pm
65729	6	Sat	7am – 3pm
65729	7	Sun	8am – 3pm
70549	1	Mon	11am – 8pm
70549	2	Tue	11am – 8pm
70549	3	Wed	11am – 8pm
70549	4	Thu	11am – 9pm
70549	5	Fri	11am – 8pm
70549	6	Sat	11am – 8pm
70549	7	Sun	11am – 8pm
70562	1	Mon	11am – 10pm
70562	2	Tue	11am – 10pm
70562	3	Wed	11am – 10pm
70562	4	Thu	11am – 10pm
70562	5	Fri	11am – 10pm
70562	6	Sat	11am – 10pm
70562	7	Sun	11am – 10pm
65734	1	Mon	11:30am – 12midnight
65734	2	Tue	11:30am – 12midnight
65734	3	Wed	11:30am – 12midnight
65734	4	Thu	11:30am – 12midnight
65734	5	Fri	11:30am – 12midnight
65734	6	Sat	11:30am – 12midnight
65734	7	Sun	11:30am – 12midnight
70574	1	Mon	7am – 6pm
70574	2	Tue	7am – 6pm
70574	3	Wed	7am – 6pm
70574	4	Thu	7am – 6pm
70574	5	Fri	7am – 6pm
70574	6	Sat	7am – 6pm
70574	7	Sun	7am – 6pm
65789	1	Mon	8am – 10pm
65789	2	Tue	8am – 10pm
65789	3	Wed	8am – 10pm
65789	4	Thu	8am – 10pm
65789	5	Fri	8am – 10pm
65789	6	Sat	8am – 10pm
65789	7	Sun	8am – 10pm
70571	1	Mon	Closed
70571	2	Tue	4pm – 9:30pm
70571	3	Wed	4pm – 9:30pm
70571	4	Thu	12noon – 10pm
70571	5	Fri	12noon – 11:30pm
70571	6	Sat	12noon – 11:30pm
70571	7	Sun	12noon – 9:30pm
65834	1	Mon	9:30am – 10pm
65834	2	Tue	9:30am – 10pm
65834	3	Wed	9:30am – 10pm
65834	4	Thu	9:30am – 10pm
65834	5	Fri	9:30am – 10pm
65834	6	Sat	10am – 10pm
65834	7	Sun	10am – 10pm
68206	1	Mon	6am – 4pm
68206	2	Tue	6am – 4pm
68206	3	Wed	6am – 4pm
68206	4	Thu	6am – 4pm
68206	5	Fri	6am – 4pm
68206	6	Sat	7am – 2pm
68206	7	Sun	Closed
70614	1	Mon	7am – 3:30pm
70614	2	Tue	Closed
70614	3	Wed	7am – 3:30pm
70614	4	Thu	7am – 3:30pm
70614	5	Fri	7am – 3:30pm
70614	6	Sat	8am – 3pm
70614	7	Sun	8am – 3pm
70590	1	Mon	5am – 3pm
70590	2	Tue	5am – 3pm
70590	3	Wed	5am – 3pm
70590	4	Thu	5am – 3pm
70590	5	Fri	5am – 3pm
70590	6	Sat	5am – 2pm
70590	7	Sun	6am – 12noon
70636	1	Mon	9am – 10pm
70636	2	Tue	9am – 10pm
70636	3	Wed	9am – 10pm
70636	4	Thu	9am – 10pm
70636	5	Fri	9am – 11:30pm
70636	6	Sat	9am – 11:30pm
70636	7	Sun	9am – 10pm
68199	1	Mon	6am – 3pm
68199	2	Tue	6am – 3pm
68199	3	Wed	6am – 3pm
68199	4	Thu	6am – 3pm
68199	5	Fri	6am – 3pm
68199	6	Sat	7am – 1pm
68199	7	Sun	Closed
68203	1	Mon	9am – 10pm
68203	2	Tue	9am – 10pm
68203	3	Wed	9am – 10pm
68203	4	Thu	9am – 10pm
68203	5	Fri	9am – 11pm
68203	6	Sat	9am – 11pm
68203	7	Sun	9am – 10pm
70639	1	Mon	5am – 3pm
70639	2	Tue	5am – 3pm
70639	3	Wed	5am – 3pm
70639	4	Thu	5am – 3pm
70639	5	Fri	5am – 3pm
70639	6	Sat	8am – 3pm
70639	7	Sun	8am – 3pm
70684	1	Mon	11am – 3pm, 5pm – 10pm
70684	2	Tue	11am – 3pm, 5pm – 10pm
70684	3	Wed	11am – 3pm, 5pm – 10pm
70684	4	Thu	11am – 3pm, 5pm – 10pm
70684	5	Fri	11am – 3pm, 5pm – 10pm
70684	6	Sat	5pm – 10pm
70684	7	Sun	5pm – 10pm
70680	1	Mon	8am – 4pm
70680	2	Tue	8am – 4pm
70680	3	Wed	8am – 4pm
70680	4	Thu	8am – 4pm
70680	5	Fri	8am – 4pm
70680	6	Sat	8am – 4pm
70680	7	Sun	8am – 4pm
70682	1	Mon	7:30am – 5pm
70682	2	Tue	7:30am – 5pm
70682	3	Wed	7:30am – 5pm
70682	4	Thu	7:30am – 5pm
70682	5	Fri	7:30am – 5pm
70682	6	Sat	7:30am – 5pm
70682	7	Sun	7:30am – 5pm
68231	1	Mon	5am – 6pm
68231	2	Tue	5am – 6pm
68231	3	Wed	5am – 6pm
68231	4	Thu	5am – 6pm
68231	5	Fri	5am – 6pm
68231	6	Sat	6am – 2pm
68231	7	Sun	Closed
70712	1	Mon	6am – 5pm
70712	2	Tue	6am – 5pm
70712	3	Wed	6am – 5pm
70712	4	Thu	6am – 5pm
70712	5	Fri	6am – 5pm
70712	6	Sat	Closed
70712	7	Sun	Closed
65876	1	Mon	11am – 10pm
65876	2	Tue	11am – 10pm
65876	3	Wed	11am – 10pm
65876	4	Thu	11am – 10pm
65876	5	Fri	11am – 10pm
65876	6	Sat	11am – 10pm
65876	7	Sun	11am – 10pm
70743	1	Mon	5:30am – 6pm
70743	2	Tue	5:30am – 6pm
70743	3	Wed	5:30am – 6pm
70743	4	Thu	5:30am – 6pm
70743	5	Fri	5:30am – 6pm
70743	6	Sat	6am – 5pm
70743	7	Sun	6:30am – 4pm
65890	1	Mon	11:30am – 3pm, 5pm – 9:30pm
65890	2	Tue	11:30am – 3pm, 5pm – 9:30pm
65890	3	Wed	11:30am – 3pm, 5pm – 9:30pm
65890	4	Thu	11:30am – 3pm, 5pm – 9:30pm
65890	5	Fri	11:30am – 3pm, 5pm – 9:30pm
65890	6	Sat	5pm – 9:30pm
65890	7	Sun	Closed
65905	1	Mon	7am – 3pm
65905	2	Tue	7am – 3pm
65898	1	Mon	9am – 7pm
70768	1	Mon	5:30am – 3pm
70768	2	Tue	5:30am – 3pm
70768	3	Wed	5:30am – 3pm
70768	4	Thu	5:30am – 3pm
70768	5	Fri	5:30am – 3pm
70768	6	Sat	6am – 2pm
70768	7	Sun	6am – 2pm
65898	2	Tue	9am – 7pm
65898	3	Wed	9am – 7pm
70806	1	Mon	5pm – 9:30pm
70806	2	Tue	5pm – 9:30pm
70806	3	Wed	11:30am – 2:30pm, 5pm – 9:30pm
70806	4	Thu	11:30am – 2:30pm, 5pm – 9:30pm
70806	5	Fri	11:30am – 2:30pm, 5pm – 9:30pm
70806	6	Sat	11:30am – 2:30pm, 5pm – 9:30pm
70806	7	Sun	11:30am – 2:30pm, 5pm – 9:30pm
65898	4	Thu	9am – 7pm
65898	5	Fri	9am – 7pm
65898	6	Sat	9am – 7pm
65898	7	Sun	9am – 7pm
65918	1	Mon	11am – 10pm
65918	2	Tue	11am – 10pm
65918	3	Wed	11am – 10pm
65918	4	Thu	11am – 10pm
65918	5	Fri	11am – 10pm
65918	6	Sat	11am – 10pm
65918	7	Sun	11am – 10pm
70812	1	Mon	6:30am – 4pm
70812	2	Tue	6:30am – 4pm
70812	3	Wed	6:30am – 4pm
70812	4	Thu	6:30am – 4pm
70812	5	Fri	6:30am – 3pm
70812	6	Sat	6am – 4pm
70812	7	Sun	Closed
70866	1	Mon	7:30am – 6:30pm
70866	2	Tue	7:30am – 6:30pm
70866	3	Wed	7:30am – 6:30pm
70866	4	Thu	7:30am – 6:30pm
70866	5	Fri	7:30am – 6:30pm
70866	6	Sat	9:30am – 2:30pm
70866	7	Sun	Closed
70856	1	Mon	7:30am – 8:30pm
70856	2	Tue	7:30am – 8:30pm
70856	3	Wed	7:30am – 8:30pm
70856	4	Thu	7:30am – 8:30pm
70856	5	Fri	7:30am – 8:30pm
70856	6	Sat	7:30am – 8:30pm
70856	7	Sun	8am – 7pm
65905	3	Wed	7am – 3pm
65905	4	Thu	7am – 3pm
65905	5	Fri	7am – 3pm
65905	6	Sat	7am – 3pm
65905	7	Sun	7am – 3pm
68317	1	Mon	11am – 3pm, 4pm – 9pm
68317	2	Tue	11am – 3pm, 4pm – 9pm
68317	3	Wed	11am – 3pm, 4pm – 9pm
68317	4	Thu	11am – 3pm, 4pm – 9pm
68317	5	Fri	11am – 3pm, 4pm – 9pm
68317	6	Sat	11am – 3pm, 4pm – 9pm
68317	7	Sun	11am – 3pm, 4pm – 9pm
68296	1	Mon	8:30am – 3pm
68296	2	Tue	8:30am – 3pm
68296	3	Wed	8:30am – 3pm
68296	4	Thu	8:30am – 3pm
68296	5	Fri	8:30am – 3pm
68296	6	Sat	Closed
68296	7	Sun	Closed
68382	1	Mon	11:20am – 2:30pm, 5pm – 12:30am
68382	2	Tue	11:20am – 2:30pm, 5pm – 12:30am
68382	3	Wed	11:20am – 2:30pm, 5pm – 12:30am
68382	4	Thu	11:20am – 2:30pm, 5pm – 12:30am
68382	5	Fri	11:20am – 2:30pm, 5pm – 12:30am
68382	6	Sat	5pm – 12:30am
68382	7	Sun	5pm – 11pm
68337	1	Mon	6:30am – 3pm
68337	2	Tue	6:30am – 3pm
68337	3	Wed	6:30am – 3pm
68337	4	Thu	6:30am – 3pm
68337	5	Fri	6:30am – 3pm
68337	6	Sat	7:30am – 3pm
68337	7	Sun	7:30am – 3pm
68379	1	Mon	5:30pm – 10:30pm
68379	2	Tue	5:30pm – 10:30pm
68379	3	Wed	5:30pm – 10:30pm, 12noon – 2:30pm
68379	4	Thu	5:30pm – 10:30pm, 12noon – 2:30pm
68379	5	Fri	5:30pm – 10:30pm, 12noon – 2:30pm
68379	6	Sat	5:30pm – 10:30pm
68379	7	Sun	5:30pm – 10:30pm
68391	1	Mon	11am – 4pm, 5pm – 9:30pm
68391	2	Tue	11am – 4pm, 5pm – 9:30pm
68391	3	Wed	11am – 4pm, 5pm – 9:30pm
68391	4	Thu	11am – 4pm, 5pm – 9:30pm
68391	5	Fri	11am – 4pm, 5pm – 9:30pm
68391	6	Sat	11am – 4pm, 5pm – 9:30pm
68391	7	Sun	11am – 4pm, 5pm – 9:30pm
70902	1	Mon	9:30am – 8pm
70902	2	Tue	9:30am – 8pm
70902	3	Wed	9:30am – 8pm
70902	4	Thu	9:30am – 8pm
70902	5	Fri	9:30am – 8pm
70902	6	Sat	9:30am – 8pm
70902	7	Sun	9:30am – 8pm
65980	1	Mon	11am – 10pm
65980	2	Tue	11am – 10pm
65980	3	Wed	11am – 10pm
65980	4	Thu	11am – 10pm
65980	5	Fri	11am – 11pm
65980	6	Sat	11am – 11pm
70905	1	Mon	6am – 5pm
70905	2	Tue	6am – 5pm
70905	3	Wed	6am – 5pm
70905	4	Thu	6am – 5pm
70905	5	Fri	6am – 5pm
70905	6	Sat	Closed
70905	7	Sun	Closed
59015	1	Mon	7:30am – 9:30am, 6pm – 11pm
70990	1	Mon	10am – 10pm
70990	2	Tue	10am – 10pm
70990	3	Wed	10am – 10pm
70990	4	Thu	10am – 11pm
70990	5	Fri	10am – 11pm
70990	6	Sat	10am – 11pm
70990	7	Sun	10am – 9pm
59015	2	Tue	7:30am – 9:30am, 6pm – 11pm
59015	3	Wed	7:30am – 9:30am, 6pm – 11pm
59015	4	Thu	7:30am – 9:30am, 6pm – 11pm
59015	5	Fri	7:30am – 9:30am, 6pm – 11pm
59015	6	Sat	7:30am – 9:30am, 6pm – 11pm
59015	7	Sun	7:30am – 9:30am, 6pm – 11pm
70908	1	Mon	5am – 3:30pm
70908	2	Tue	5am – 3:30pm
70908	3	Wed	5am – 3:30pm
70908	4	Thu	5am – 3:30pm
70908	5	Fri	5am – 3:30pm
70908	6	Sat	6:30am – 2pm
70908	7	Sun	6:30am – 2pm
70944	1	Mon	7am – 5pm
70944	2	Tue	7am – 5pm
70944	3	Wed	7am – 5pm
70944	4	Thu	7am – 5pm
70944	5	Fri	7am – 5pm
70944	6	Sat	7am – 5pm
70944	7	Sun	10am – 4pm
65970	1	Mon	10am – 10pm
65970	2	Tue	10am – 10pm
65970	3	Wed	10am – 10pm
65970	4	Thu	10am – 10pm
65970	5	Fri	10am – 10pm
65970	6	Sat	10am – 10pm
65970	7	Sun	10am – 10pm
65979	1	Mon	11am – 8:30pm
65979	2	Tue	11am – 8:30pm
65979	3	Wed	11am – 8:30pm
65979	4	Thu	11am – 8:30pm
65979	5	Fri	11am – 8:30pm
68400	1	Mon	10am – 12midnight
68400	2	Tue	10am – 12midnight
68400	3	Wed	10am – 12midnight
68400	4	Thu	10am – 12midnight
68400	5	Fri	10am – 12midnight
68400	6	Sat	10am – 12midnight
68400	7	Sun	12noon – 12midnight
71038	1	Mon	9am – 8:30pm
71038	2	Tue	9am – 8:30pm
71038	3	Wed	9am – 8:30pm
71038	4	Thu	9am – 8:30pm
71038	5	Fri	9am – 8:30pm
71038	6	Sat	9am – 8:30pm
71038	7	Sun	9am – 8:30pm
65979	6	Sat	11:30am – 8:30pm
65979	7	Sun	Closed
71037	1	Mon	7am – 5pm
71037	2	Tue	7am – 5pm
71037	3	Wed	7am – 5pm
71037	4	Thu	7am – 5pm
71037	5	Fri	7am – 5pm
71037	6	Sat	7am – 5pm
71037	7	Sun	7am – 5pm
65980	7	Sun	11am – 10pm
71026	1	Mon	5:30am – 2pm
71026	2	Tue	5:30am – 2pm
71026	3	Wed	5:30am – 2pm
71026	4	Thu	5:30am – 2pm
71026	5	Fri	5:30am – 2pm
71026	6	Sat	5:30am – 2pm
71026	7	Sun	5:30am – 2pm
71071	1	Mon	11am – 4pm, 5pm – 12midnight
71071	2	Tue	11am – 4pm, 5pm – 12midnight
71071	3	Wed	11am – 4pm, 5pm – 12midnight
71071	4	Thu	11am – 4pm, 5pm – 12midnight
71071	5	Fri	11am – 4pm, 5pm – 12midnight
71071	6	Sat	11am – 4pm, 5pm – 12midnight
71071	7	Sun	11am – 4pm, 5pm – 12midnight
71043	1	Mon	9am – 5:30pm
71043	2	Tue	9am – 5:30pm
71043	3	Wed	9am – 5:30pm
71043	4	Thu	9am – 9pm
71043	5	Fri	9am – 5:30pm
71043	6	Sat	9am – 5:30pm
71043	7	Sun	9am – 5:30pm
66004	1	Mon	10am – 6pm
66004	2	Tue	10am – 6pm
66004	3	Wed	10am – 6pm
66004	4	Thu	10am – 6pm
66004	5	Fri	10am – 6pm
66004	6	Sat	9am – 6pm
66004	7	Sun	Closed
66015	1	Mon	10am – 10pm
66015	2	Tue	10am – 10pm
66015	3	Wed	10am – 10pm
66015	4	Thu	10am – 10pm
66015	5	Fri	10am – 10pm
66015	6	Sat	10am – 10pm
66015	7	Sun	10am – 10pm
71108	1	Mon	7am – 4:30pm
71108	2	Tue	7am – 4:30pm
71108	3	Wed	7am – 4:30pm
71108	4	Thu	7am – 4:30pm
71108	5	Fri	7am – 4:30pm
71108	6	Sat	7am – 4:30pm
71108	7	Sun	7am – 4:30pm
71112	1	Mon	9am – 8pm
71112	2	Tue	9am – 8pm
71112	3	Wed	9am – 8pm
71112	4	Thu	9am – 8pm
71112	5	Fri	9am – 8pm
71112	6	Sat	9am – 7pm
71112	7	Sun	9am – 3pm
71183	1	Mon	9am – 10pm
71183	2	Tue	9am – 10pm
71183	3	Wed	9am – 10pm
71183	4	Thu	9am – 10pm
71183	5	Fri	9am – 12midnight
71183	6	Sat	9am – 12midnight
71128	1	Mon	24 Hours
71128	2	Tue	24 Hours
71128	3	Wed	24 Hours
71128	4	Thu	24 Hours
71128	5	Fri	24 Hours
71128	6	Sat	24 Hours
71128	7	Sun	24 Hours
59288	1	Mon	Closed
59288	2	Tue	10am – 5pm
59288	3	Wed	10am – 5pm
59288	4	Thu	10am – 6pm
59288	5	Fri	10am – 6pm
59288	6	Sat	8:30am – 4pm
59288	7	Sun	Closed
66077	5	Fri	7am – 5pm
66077	1	Mon	7am – 5pm
66077	2	Tue	7am – 5pm
66077	3	Wed	7am – 5pm
66077	4	Thu	7am – 5pm
66077	6	Sat	8am – 5pm
66077	7	Sun	8:30am – 5pm
71183	7	Sun	9am – 10pm
59358	1	Mon	8:30am – 4pm
59358	2	Tue	8:30am – 4pm
59358	3	Wed	8:30am – 4pm
59358	4	Thu	8:30am – 4pm
59358	5	Fri	8:30am – 4pm
59358	6	Sat	9am – 3pm
59358	7	Sun	9am – 3pm
66058	1	Mon	7am – 5pm
66058	2	Tue	7am – 5pm
66058	3	Wed	7am – 5pm
66058	4	Thu	7am – 5pm
66058	5	Fri	7am – 5pm
66058	6	Sat	7am – 5pm
66058	7	Sun	7am – 5pm
71248	1	Mon	5:30pm – 9pm
71248	2	Tue	5:30pm – 9pm
71248	3	Wed	5:30pm – 9pm
71248	4	Thu	5:30pm – 9pm
71248	5	Fri	5:30pm – 9pm
71248	6	Sat	5:30pm – 9pm
71248	7	Sun	5:30pm – 9pm
66097	1	Mon	7am – 9pm
66097	2	Tue	7am – 9pm
66097	3	Wed	7am – 9pm
66097	4	Thu	7am – 9pm
66097	5	Fri	7am – 9pm
66097	6	Sat	Closed
66097	7	Sun	Closed
59523	1	Mon	7am – 2pm
59523	2	Tue	7am – 2pm
59523	3	Wed	7am – 2pm
59523	4	Thu	7am – 2pm
59523	5	Fri	7am – 2pm
59523	6	Sat	8am – 2pm
59523	7	Sun	Closed
68409	1	Mon	11am – 9pm
68409	2	Tue	11am – 9pm
68409	3	Wed	11am – 9pm
68409	4	Thu	11am – 9pm
68409	5	Fri	11am – 9pm
68409	6	Sat	11am – 9pm
68409	7	Sun	11am – 9pm
66141	1	Mon	Closed
66141	2	Tue	5:30pm – 10pm
66141	3	Wed	5:30pm – 10pm
66141	4	Thu	5:30pm – 10pm
66141	5	Fri	5:30pm – 10pm
66141	6	Sat	5:30pm – 10pm
66141	7	Sun	12noon – 9:30pm
66161	1	Mon	6:30am – 4pm
66161	2	Tue	6:30am – 4pm
66161	3	Wed	6:30am – 4pm
66161	4	Thu	6:30am – 4pm
66161	5	Fri	6:30am – 4pm
66135	1	Mon	11am – 11:30pm, 12midnight – 2am
66135	2	Tue	11am – 11:30pm, 12midnight – 2am
66135	3	Wed	11am – 11:30pm, 12midnight – 2am
66135	4	Thu	11am – 11:30pm, 12midnight – 2am
66135	5	Fri	11am – 11:30pm, 12midnight – 2am
66135	6	Sat	11am – 11:30pm, 12midnight – 2am
66135	7	Sun	11am – 10pm
66167	1	Mon	10am – 12midnight
66167	2	Tue	10am – 12midnight
66167	3	Wed	10am – 12midnight
66167	4	Thu	10am – 12midnight
66167	5	Fri	10am – 12midnight
66167	6	Sat	10am – 12midnight
66167	7	Sun	10am – 10pm
66172	1	Mon	5pm – 11pm
66172	2	Tue	5pm – 11pm
66172	3	Wed	5pm – 11pm
66172	4	Thu	5pm – 11pm
66172	5	Fri	5pm – 11pm
66172	6	Sat	12:30pm – 10:30pm
66172	7	Sun	12:30pm – 10:30pm
66208	1	Mon	11am – 10:30pm
66208	2	Tue	11am – 10:30pm
66208	3	Wed	11am – 10:30pm
66208	4	Thu	11am – 10:30pm
66208	5	Fri	11am – 10:30pm
66208	6	Sat	11am – 10:30pm
66208	7	Sun	4pm – 10:30pm
66161	6	Sat	7am – 4pm
66161	7	Sun	7am – 4pm
68425	1	Mon	7am – 7pm
68425	2	Tue	7am – 7pm
68425	3	Wed	7am – 7pm
68425	4	Thu	7am – 3am
68425	5	Fri	7am – 3am
68425	6	Sat	7am – 3am
68425	7	Sun	7am – 6pm
66225	1	Mon	10am – 12midnight
66225	2	Tue	10am – 12midnight
66225	3	Wed	10am – 12midnight
66225	4	Thu	10am – 12midnight
66225	5	Fri	10am – 12midnight
66225	6	Sat	10am – 12midnight
66225	7	Sun	10am – 10pm
68442	1	Mon	6am – 3pm
68442	2	Tue	6am – 3pm
68442	3	Wed	6am – 3pm
62291	1	Mon	12noon – 3pm, 6pm – 10pm
62291	2	Tue	12noon – 3pm, 6pm – 10pm
62291	3	Wed	12noon – 3pm, 6pm – 10pm
62291	4	Thu	12noon – 3pm, 6pm – 10pm
62291	5	Fri	12noon – 3pm, 6pm – 10pm
62291	6	Sat	9am – 11:30am, 6pm – 10pm, 12noon – 3pm
62291	7	Sun	9am – 11:30am, 6pm – 10pm, 12noon – 3pm
68457	1	Mon	6am – 6pm
68457	2	Tue	6am – 6pm
68457	3	Wed	6am – 6pm
68457	4	Thu	6am – 6pm
68457	5	Fri	6am – 6pm
68457	6	Sat	6am – 6pm
68457	7	Sun	7am – 6pm
68442	4	Thu	6am – 3pm
68442	5	Fri	6am – 3pm
68442	6	Sat	Closed
68442	7	Sun	Closed
68511	1	Mon	7am – 3:30pm
68511	2	Tue	7am – 3:30pm
68511	3	Wed	7am – 3:30pm
68511	4	Thu	7am – 3:30pm
68511	5	Fri	7am – 3:30pm
68511	6	Sat	8am – 2:30pm
68511	7	Sun	8am – 2:30pm
68504	1	Mon	8am – 3pm
68504	2	Tue	8am – 3pm
68504	3	Wed	8am – 3pm
68504	4	Thu	8am – 3pm
68504	5	Fri	8am – 3pm
68504	6	Sat	Closed
68504	7	Sun	Closed
68550	1	Mon	11am – 10pm
68550	2	Tue	11am – 10pm
68550	3	Wed	11am – 10pm
68550	4	Thu	11am – 10pm
68550	5	Fri	11am – 10pm
68550	6	Sat	11am – 10pm
68550	7	Sun	11am – 10pm
68585	1	Mon	Closed
68585	2	Tue	5:30pm – 10pm
68585	3	Wed	5:30pm – 10pm
68585	4	Thu	5:30pm – 10pm
68585	5	Fri	5:30pm – 11pm
68585	6	Sat	5:30pm – 11pm
68585	7	Sun	12:30pm – 10pm
62438	1	Mon	Closed
62438	2	Tue	5:30pm – 9:30pm
62438	3	Wed	5:30pm – 9:30pm
62438	4	Thu	5:30pm – 9:30pm
62438	5	Fri	5:30pm – 9:30pm
62438	6	Sat	5:30pm – 9:30pm
62438	7	Sun	5:30pm – 9:30pm
68600	1	Mon	10:30am – 3pm, 5pm – 10pm
68600	2	Tue	10:30am – 3pm, 5pm – 10pm
68600	3	Wed	10:30am – 3pm, 5pm – 10pm
68600	4	Thu	10:30am – 3pm, 5pm – 10pm
68600	5	Fri	10:30am – 3pm, 5pm – 10pm
68600	6	Sat	10:30am – 3pm, 5pm – 10pm
68600	7	Sun	10:30am – 3pm, 5pm – 10pm
68663	1	Mon	7am – 4pm
68663	2	Tue	7am – 4pm
68663	3	Wed	7am – 4pm
68663	4	Thu	7am – 4pm
68663	5	Fri	7am – 4pm
68663	6	Sat	8am – 3pm
68663	7	Sun	8am – 2pm
68666	1	Mon	12noon – 3:30pm, 5pm – 9:30pm
68666	2	Tue	12noon – 3:30pm, 5pm – 9:30pm
68666	3	Wed	12noon – 3:30pm, 5pm – 9:30pm
68666	4	Thu	12noon – 3:30pm, 5pm – 9:30pm
68666	5	Fri	12noon – 3:30pm, 5pm – 9:30pm
68666	6	Sat	12noon – 3:30pm, 5pm – 9:30pm
68666	7	Sun	12noon – 3:30pm, 5pm – 9:30pm
68681	1	Mon	5pm – 9pm
68681	2	Tue	5pm – 9pm
68681	3	Wed	5pm – 9pm
68681	4	Thu	5pm – 9pm
68681	5	Fri	5pm – 9pm
68681	6	Sat	5pm – 9pm
68681	7	Sun	12noon – 8pm
62537	1	Mon	11am – 10pm
62537	2	Tue	11am – 10pm
62537	3	Wed	11am – 10pm
62537	4	Thu	11am – 10pm
62537	5	Fri	11am – 10pm
62537	6	Sat	11am – 10pm
62537	7	Sun	11am – 10pm
68724	1	Mon	6:30am – 5pm
68724	2	Tue	6:30am – 5pm
68724	3	Wed	6:30am – 5pm
68724	4	Thu	6:30am – 5pm
68724	5	Fri	6:30am – 5pm
68724	6	Sat	7am – 4pm
68724	7	Sun	8am – 3pm
68725	1	Mon	7am – 4pm
68725	2	Tue	7am – 4pm
68725	3	Wed	7am – 4pm
68725	4	Thu	7am – 4pm
68725	5	Fri	7am – 4pm
68725	6	Sat	Closed
68725	7	Sun	Closed
68739	1	Mon	7am – 3pm
68739	2	Tue	7am – 3pm
68739	3	Wed	7am – 3pm
68739	4	Thu	7am – 3pm
68739	5	Fri	7am – 3pm
68739	6	Sat	7am – 3pm
68739	7	Sun	8am – 3pm
68801	1	Mon	6am – 4pm
62579	1	Mon	Closed
62579	2	Tue	Closed
62579	3	Wed	5:30pm – 9pm
62579	4	Thu	5:30pm – 9pm
62579	5	Fri	5:30pm – 9pm
62579	6	Sat	5:30pm – 9pm
62579	7	Sun	5:30pm – 9pm
68770	1	Mon	7:30am – 5pm
68770	2	Tue	7:30am – 5pm
68770	3	Wed	7:30am – 5pm
68770	4	Thu	7:30am – 5pm
68770	5	Fri	7:30am – 5pm
68770	6	Sat	7:30am – 5pm
68770	7	Sun	7:30am – 5pm
71382	1	Mon	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	2	Tue	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	3	Wed	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	4	Thu	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	5	Fri	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	6	Sat	11:30am – 2:30pm, 4:30pm – 9:30pm
71382	7	Sun	4:30pm – 9pm
71442	1	Mon	7am – 10pm
71442	2	Tue	7am – 10pm
71442	3	Wed	7am – 10pm
71442	4	Thu	7am – 10pm
71442	5	Fri	7am – 10pm
71376	1	Mon	6am – 6pm
71376	2	Tue	6am – 6pm
71376	3	Wed	6am – 6pm
71376	4	Thu	6am – 6pm
71376	5	Fri	6am – 6pm
71376	6	Sat	Closed
71376	7	Sun	Closed
62667	1	Mon	6am – 2pm
62667	2	Tue	6am – 2pm
62667	3	Wed	6am – 2pm
62667	4	Thu	6am – 2pm
62667	5	Fri	6am – 2pm
62667	6	Sat	Closed
62667	7	Sun	Closed
62717	1	Mon	7:30am – 5pm
62717	2	Tue	7:30am – 5pm
62717	3	Wed	7:30am – 5pm
62717	4	Thu	7:30am – 5pm
62717	5	Fri	7:30am – 5pm
62717	6	Sat	7:30am – 3pm
62717	7	Sun	Closed
62725	1	Mon	Closed
62725	2	Tue	4:30pm – 9:30pm
62725	3	Wed	4:30pm – 9:30pm
62725	4	Thu	4:30pm – 9:30pm
62725	5	Fri	4:30pm – 9:30pm
62725	6	Sat	4:30pm – 9:30pm
62725	7	Sun	4:30pm – 9:30pm
68788	1	Mon	6:30am – 4pm
68788	2	Tue	6:30am – 4pm
68788	3	Wed	6:30am – 4pm
68788	4	Thu	6:30am – 4pm
68788	5	Fri	6:30am – 4pm
68788	6	Sat	7am – 4pm
68785	1	Mon	10am – 4:30pm
68785	2	Tue	10am – 4:30pm
68785	3	Wed	10am – 4:30pm
68785	4	Thu	10am – 4:30pm
68785	5	Fri	10am – 4:30pm
68785	6	Sat	10am – 4:30pm
68785	7	Sun	10am – 4:30pm
62711	1	Mon	Closed
62711	2	Tue	5pm – 10pm
62711	3	Wed	5pm – 10pm
62711	4	Thu	5pm – 10pm
62711	5	Fri	5pm – 10pm
62711	6	Sat	5pm – 10pm
62711	7	Sun	5pm – 10pm
68799	1	Mon	12noon – 10pm
68799	2	Tue	12noon – 10pm
68799	3	Wed	12noon – 10pm
68799	4	Thu	12noon – 10pm
68799	5	Fri	12noon – 10pm
68799	6	Sat	12noon – 10pm
68799	7	Sun	12noon – 10pm
68824	1	Mon	11:30am – 9pm
68824	2	Tue	11:30am – 9pm
68824	3	Wed	11:30am – 9pm
68824	4	Thu	11:30am – 9pm
68788	7	Sun	7am – 4pm
62755	1	Mon	7am – 7pm
62755	2	Tue	7am – 7pm
62755	3	Wed	7am – 7pm
62755	4	Thu	7am – 7pm
62755	5	Fri	7am – 7pm
62755	6	Sat	9am – 5pm
62755	7	Sun	Closed
68801	2	Tue	6am – 4pm
68801	3	Wed	6am – 4pm
68801	4	Thu	6am – 4pm
68801	5	Fri	6am – 4pm
68801	6	Sat	6am – 3pm
68801	7	Sun	8am – 3pm
68860	1	Mon	11:30am – 3pm, 4:30pm – 9:30pm
68860	2	Tue	11:30am – 3pm, 4:30pm – 9:30pm
68860	3	Wed	11:30am – 3pm, 4:30pm – 9:30pm
68860	4	Thu	11:30am – 3pm, 4:30pm – 9:30pm
68860	5	Fri	11:30am – 3pm, 4:30pm – 9:30pm
68860	6	Sat	11:30am – 3pm, 4:30pm – 9:30pm
68860	7	Sun	4:30pm – 9:30pm
68824	5	Fri	11:30am – 11pm
68824	6	Sat	11:30am – 11pm
68824	7	Sun	11:30am – 9pm
68888	1	Mon	7am – 6pm
68888	2	Tue	7am – 6pm
68888	3	Wed	7am – 6pm
68888	4	Thu	7am – 6pm
68888	5	Fri	7am – 6pm
68888	6	Sat	Closed
68888	7	Sun	Closed
68885	1	Mon	10:30am – 8:30pm
68885	2	Tue	10:30am – 8:30pm
68885	3	Wed	10:30am – 8:30pm
68885	4	Thu	10:30am – 8:30pm
68885	5	Fri	10:30am – 8:30pm
68885	6	Sat	10:30am – 8:30pm
68885	7	Sun	10:30am – 8:30pm
68915	1	Mon	6:30am – 5:30pm
68915	2	Tue	6:30am – 5:30pm
68915	3	Wed	6:30am – 5:30pm
68915	4	Thu	6:30am – 5:30pm
68915	5	Fri	6:30am – 5:30pm
68915	6	Sat	8am – 3pm
68915	7	Sun	Closed
68934	1	Mon	7:30am – 3pm
68934	2	Tue	7:30am – 3pm
68934	3	Wed	7:30am – 3pm
68934	4	Thu	7:30am – 3pm
68934	5	Fri	7:30am – 3pm
68934	6	Sat	7am – 3pm
68934	7	Sun	7am – 3pm
68921	1	Mon	5pm – 9pm
68921	2	Tue	5pm – 9pm
68921	3	Wed	5pm – 9pm
68921	4	Thu	5pm – 9pm
68921	5	Fri	5pm – 9pm
68921	6	Sat	11:30am – 9pm
68921	7	Sun	11:30am – 9pm
68923	1	Mon	9am – 5:30pm
68923	2	Tue	9am – 5:30pm
68923	3	Wed	9am – 5:30pm
68923	4	Thu	9am – 5:30pm
68923	5	Fri	9am – 5:30pm
68923	6	Sat	9am – 5:30pm
68923	7	Sun	9am – 5:30pm
68948	1	Mon	12noon – 2:30pm
68948	2	Tue	12noon – 2:30pm, 5pm – 9pm
68948	3	Wed	12noon – 2:30pm, 5pm – 9pm
68948	4	Thu	12noon – 2:30pm, 5pm – 9pm
68948	5	Fri	12noon – 2:30pm, 5pm – 9pm
68948	6	Sat	Closed
68948	7	Sun	Closed
71405	1	Mon	9am – 7pm
71405	2	Tue	9am – 7pm
71405	3	Wed	9am – 7pm
71405	4	Thu	9am – 7pm
71405	5	Fri	9am – 7pm
71405	6	Sat	Closed
71405	7	Sun	Closed
71439	1	Mon	6am – 6pm
71439	2	Tue	6am – 6pm
71439	3	Wed	6am – 6pm
71439	4	Thu	6am – 6pm
71439	5	Fri	6am – 6pm
71439	6	Sat	6am – 6pm
71439	7	Sun	6am – 6pm
68970	1	Mon	5:30am – 9pm
68970	2	Tue	5:30am – 9pm
68970	3	Wed	5:30am – 9pm
68970	4	Thu	5:30am – 9pm
68970	5	Fri	5:30am – 9pm
68970	6	Sat	5:30am – 2pm
68970	7	Sun	7am – 2pm
68983	1	Mon	6am – 4pm
68983	2	Tue	6am – 4pm
68983	3	Wed	6am – 4pm
68983	4	Thu	6am – 4pm
68983	5	Fri	6am – 4pm
68983	6	Sat	Closed
68983	7	Sun	Closed
69034	1	Mon	24 Hours
69034	2	Tue	24 Hours
69034	3	Wed	24 Hours
69034	4	Thu	24 Hours
69034	5	Fri	24 Hours
69034	6	Sat	24 Hours
69034	7	Sun	24 Hours
71442	6	Sat	7am – 8pm
71442	7	Sun	7am – 8pm
71483	1	Mon	7am – 4:30pm
71483	2	Tue	7am – 4:30pm
71483	3	Wed	7am – 4:30pm
71483	4	Thu	7am – 4:30pm
71483	5	Fri	7am – 4:30pm
71483	6	Sat	7am – 4:30pm
71483	7	Sun	7:30am – 4:30pm
71475	1	Mon	5am – 5pm
71475	2	Tue	5am – 5pm
71475	3	Wed	5am – 5pm
71475	4	Thu	5am – 5pm
71475	5	Fri	5am – 5pm
71475	6	Sat	5am – 4pm
71475	7	Sun	6am – 2pm
71569	1	Mon	11am – 11pm
71569	2	Tue	11am – 11pm
71569	3	Wed	11am – 11pm
71535	1	Mon	6:30am – 5:30pm
71535	2	Tue	6:30am – 5:30pm
71535	3	Wed	6:30am – 5:30pm
71535	4	Thu	6:30am – 5:30pm
71535	5	Fri	6:30am – 5:30pm
71535	6	Sat	5:30am – 5:30pm
71535	7	Sun	Closed
71529	1	Mon	11am – 2:30pm, 5pm – 9pm
71529	2	Tue	11am – 2:30pm, 5pm – 9pm
71529	3	Wed	11am – 2:30pm, 5pm – 9pm
71529	4	Thu	11am – 2:30pm, 5pm – 9pm
71529	5	Fri	11am – 2:30pm, 5pm – 9pm
71529	6	Sat	11am – 2:30pm, 5pm – 9pm
71529	7	Sun	11am – 2:30pm, 5pm – 9pm
71588	1	Mon	8am – 7:30pm
71588	2	Tue	8am – 7:30pm
71588	3	Wed	8am – 7:30pm
71588	4	Thu	8am – 7:30pm
71588	5	Fri	8am – 7:30pm
71588	6	Sat	8am – 7:30pm
71588	7	Sun	Closed
71612	1	Mon	11am – 3pm, 5pm – 9pm
71612	2	Tue	11am – 3pm, 5pm – 9pm
71612	3	Wed	11am – 3pm, 5pm – 9pm
71612	4	Thu	11am – 3pm, 5pm – 9pm
71612	5	Fri	11am – 3pm, 5pm – 9pm
71612	6	Sat	5pm – 9pm
71612	7	Sun	5pm – 9pm
71569	4	Thu	11am – 11pm
71569	5	Fri	11am – 11pm
71569	6	Sat	11am – 11pm
71569	7	Sun	11am – 11pm
71591	1	Mon	9am – 5pm
71591	2	Tue	9am – 5pm
71591	3	Wed	9am – 5pm
71591	4	Thu	9am – 5pm
71591	5	Fri	9am – 5pm
71591	6	Sat	9am – 5pm
71591	7	Sun	9am – 5pm
71589	1	Mon	Closed
71589	2	Tue	7:30am – 3:30pm
71589	3	Wed	7:30am – 3:30pm
71589	4	Thu	7:30am – 3:30pm
71589	5	Fri	7:30am – 3pm, 6:30pm – 9:30pm
71589	6	Sat	8:30am – 2pm, 6:30pm – 10pm
71589	7	Sun	9am – 12:30pm
71647	1	Mon	8am – 8pm
71647	2	Tue	8am – 8pm
71647	3	Wed	8am – 8pm
71647	4	Thu	8am – 8pm
71647	5	Fri	8am – 8pm
71647	6	Sat	8am – 8pm
71647	7	Sun	8am – 8pm
71632	1	Mon	10am – 3pm
71632	2	Tue	10am – 3pm
71632	3	Wed	10am – 3pm
71632	4	Thu	10am – 3pm
71632	5	Fri	10am – 3pm
71632	6	Sat	10am – 3pm
71632	7	Sun	10am – 12midnight
\.


--
-- Data for Name: store_rankings; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_rankings (store_id, rank, valid_from, valid_to) FROM stdin;
1	1	2019-08-01 20:19:51.174+00	2020-08-03 20:20:01.083+00
2	1	2019-08-01 20:19:51.174+00	2020-08-03 20:20:01.083+00
3	1	2019-08-01 20:19:51.174+00	2020-08-03 20:20:01.083+00
4	1	2019-08-01 20:19:51.174+00	2020-08-03 20:20:01.083+00
5	1	2019-08-01 20:19:51.174+00	2020-08-03 20:20:01.083+00
\.


--
-- Data for Name: store_ratings_cache; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_ratings_cache (store_id, heart_ratings, okay_ratings, burnt_ratings) FROM stdin;
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
-- Data for Name: store_tags; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.store_tags (store_id, tag_id) FROM stdin;
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
-- Data for Name: stores; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.stores (id, name, phone_country, phone_number, location_id, suburb_id, city_id, cover_image, "order", rank, follower_count, review_count, store_count, z_id, z_url, more_info, avg_cost, coords) FROM stdin;
1	Dumplings & Co.	+61	(02) 9627 7282	5	2	1	https://imgur.com/9aGBDLY.jpg	1	1	1	2	0	\N	\N	\N	\N	(151.183624000000009,-33.7969280000000012)
60	Le Meow	+61	(02) 9211 3568	17	13	1	https://b.zmtcdn.com/data/reviews_photos/21e/cc0377b2af177b44aade56e1ed7eb21e_1542718407.jpg	1	99	0	0	0	sydney/le-meow-surry-hills	https://www.zomato.com/sydney/le-meow-surry-hills	Breakfast,Takeaway Available,No Alcohol Available	40	(151.208526000000006,-33.8597809999999981)
22	Zapparellis Pizza	+61	965511555	\N	120	1	https://imgur.com/mCuCc8p.jpg	12	99	0	0	0	\N	\N	\N	\N	(151.146235999999988,-33.8282570000000007)
16	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	\N	10	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.208150999999987,-33.8590769999999992)
17	Mad Mex	+61	(02) 9627 7282	12	1	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.19897499999999,-33.8717309999999969)
18	Mad Mex	+61	(02) 9627 7282	13	12	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.208216999999991,-33.8659630000000007)
19	Mad Mex	+61	(02) 9627 7282	14	11	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.209875000000011,-33.8620269999999977)
20	Kürtősh	+61	(02) 9627 7282	\N	12	1	https://imgur.com/q6gqaXm.jpg	10	99	0	0	0	\N	\N	\N	\N	(151.200677000000013,-33.8745380000000011)
71759	Two Doors	+61	0413 141 550	\N	12	1	https://b.zmtcdn.com/data/pictures/7/19220477/f726437cae48a38fb7656f157fede715.jpg?resize=1204%3A802&crop=1200%3A464%3B4%2C197	1	99	0	0	0	two-doors-darlinghurst	https://www.zomato.com/sydney/two-doors-darlinghurst	Full Bar Available,Table Reservation Not Required,Indoor Seating	85	(151.221371814599991,-33.8766563200000022)
71760	The Second Home Cafe Rouse Hill	+61	(02) 9836 1660	\N	325	1	https://b.zmtcdn.com/data/pictures/2/17745412/598d086f596d73dba7aabe5799e2245c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-second-home-cafe-rouse-hill-rouse-hill	https://www.zomato.com/sydney/the-second-home-cafe-rouse-hill-rouse-hill	Breakfast,Takeaway Available,Indoor Seating,Kid Friendly,Vegan Options	40	(150.916533730899999,-33.6822149305999972)
71792	Moonlight Vietnamese	+61	(02) 8544 0458	\N	512	1	https://b.zmtcdn.com/data/pictures/9/15543979/24a7221f75af174683df1d6fc31c939f.jpg?resize=1204%3A903&crop=1200%3A464%3B-1%2C2	1	99	0	0	0	moonlight-vietnamese-menai	https://www.zomato.com/sydney/moonlight-vietnamese-menai	Breakfast,Wheelchair Accessible,Outdoor Seating,Table Reservation Not Required,Indoor Seating,Vegetarian Friendly	85	(151.017382443000002,-34.0122911237000025)
66097	Mach 2	+61	(02) 9262 1075	\N	2475	1	https://b.zmtcdn.com/data/pictures/9/16568969/f9ef9536bb01ec5643a124b0ac7c0b39.jpg?resize=1204%3A802&crop=1200%3A464%3B-54%2C12	1	99	0	0	0	mach-2-cbd	https://www.zomato.com/sydney/mach-2-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Wifi,Vegetarian Friendly,Desserts and Bakes,Outdoor Seating,Gluten Free Options,Brunch,Parking available 156 metres away	60	(151.205260120300011,-33.8678121031000003)
71800	Espressa	+61	(02) 9541 2560	\N	510	1	https://b.zmtcdn.com/data/reviews_photos/0f3/96c221650fe6c12741f69514f65f80f3_1505016326.jpg?resize=1204%3A1204&crop=1200%3A464%3B1%2C405	1	99	0	0	0	espressa-illawong	https://www.zomato.com/sydney/espressa-illawong	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Kid Friendly,Pet Friendly,Vegan Options,Desserts and Bakes,Gluten Free Options,Vegetarian Friendly,Brunch	30	(151.042250543800009,-33.9972114370999989)
71928	Fresh Corp	+61	(02) 9482 3888	\N	154	1	https://b.zmtcdn.com/data/reviews_photos/094/2b5be2071faec56c9843498d7bf62094_1489535131.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	fresh-corp-hornsby	https://www.zomato.com/sydney/fresh-corp-hornsby	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available,Vegetarian Friendly	15	(151.10010143369999,-33.7051466943999998)
62537	Sabbaba	+61	(02) 9365 7500	\N	2451	1	https://b.zmtcdn.com/data/res_imagery/16559748_CHAIN_79bba84e726a4513c20c6cacb0b6e866.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sabbaba-bondi-beach	https://www.zomato.com/sydney/sabbaba-bondi-beach	Breakfast,Home Delivery,Takeaway Available,Full Bar Available,Pet Friendly,Gluten Free Options,Table Reservation Not Required,Outdoor Seating,Vegetarian Friendly,Kid Friendly,Indoor Seating,Parking available 128 metres away	40	(151.271017491799995,-33.8895561928000006)
16856	Bread Station	+61	\N	\N	420	1	https://b.zmtcdn.com/data/pictures/6/16715916/591649cbb2604e77442815b16265da05.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	bread-station-bankstown	https://www.zomato.com/sydney/bread-station-bankstown	Takeaway Available,Wheelchair Accessible,Serves Halal,No Alcohol Available,Desserts and Bakes,Vegetarian Friendly,Indoor Seating	20	(151.03327486660001,-33.9185060269999994)
57118	XS Espresso	+61	(02) 9757 4265	\N	348	1	https://b.zmtcdn.com/data/res_imagery/16566787_CHAIN_0c5e05af6f4a388bc72f8de8114a35bf_c.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	xs-espresso-wetherill-park	https://www.zomato.com/sydney/xs-espresso-wetherill-park	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Smoking Area,Vegetarian Friendly,Brunch,Outdoor Seating	45	(150.898489169800001,-33.8500624467000009)
69069	Homeway 咱家	+61	(02) 9715 7716	\N	10	1	https://b.zmtcdn.com/data/pictures/chains/2/17745782/a220fcf53a787af2831c7c9647c895a6.jpg?resize=1204%3A803&crop=1200%3A464%3B-2%2C234	1	99	0	0	0	homeway-burwood	https://www.zomato.com/sydney/homeway-burwood	Home Delivery,Takeaway Available,Beer,BYO,BYO Food,Kid Friendly,Indoor Seating,Group Bookings Available,Table booking recommended,Set Menu,Wifi,BYO Cake,Lunch Menu,Available for Functions	75	(151.103515215199991,-33.8807976517)
69072	Acai Brothers Superfood Bar	+61	\N	\N	174	1	https://b.zmtcdn.com/data/res_imagery/15546830_CHAIN_ba1c17891ef74981d6087dba6b855dd9.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	acai-brothers-superfood-bar-neutral-bay	https://www.zomato.com/sydney/acai-brothers-superfood-bar-neutral-bay	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Vegan Options,Table Reservation Not Required,Indoor Seating,Gluten Free Options,Vegetarian Friendly	25	(151.223871298099994,-33.8315122977000016)
66333	Basil's Seafood	+61	(02) 9876 6617	\N	252	1	https://b.zmtcdn.com/data/res_imagery/16560540_RESTAURANT_52f97fa6d13877662ed824cb78567f0b.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	basils-seafood-marsfield	https://www.zomato.com/sydney/basils-seafood-marsfield	Full Bar Available,Kid Friendly,Wifi,Vegan Options,Outdoor Seating,Gluten Free Options	120	(151.10813431439999,-33.767996455499997)
71850	Cafe Aqua	+61	(02) 9752 3666	\N	2452	1	\N	1	99	0	0	0	cafe-aqua-sydney-olympic-park	https://www.zomato.com/sydney/cafe-aqua-sydney-olympic-park	Breakfast,No Alcohol Available,Indoor Seating,Kid Friendly,Desserts and Bakes	30	(151.067049577799992,-33.8506658374000011)
66341	Bai Bua	+61	(02) 4722 8422	\N	2098	1	https://b.zmtcdn.com/data/res_imagery/16560669_RESTAURANT_d5a44bd8f4827001145ed2099977953b.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	bai-bua-penrith	https://www.zomato.com/sydney/bai-bua-penrith	Takeaway Available,No Alcohol Available,Gluten Free Options,Indoor Seating,Vegetarian Friendly,Table Reservation Not Required	50	(150.697368755899987,-33.7543158316999978)
66355	East West Gourmet	+61	(02) 9411 2811	\N	2	1	https://b.zmtcdn.com/data/reviews_photos/4ab/717d9024c5d2008f3d854fb17c6234ab_1478843123.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	east-west-gourmet-chatswood	https://www.zomato.com/sydney/east-west-gourmet-chatswood	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Wifi	30	(151.182646416099999,-33.7981092095999998)
69116	8@8 Cafe	+61	(02) 9908 8326	\N	174	1	https://b.zmtcdn.com/data/pictures/7/18686747/9a4fb929be7edb8a5dde20a86d2a165e.jpg?resize=1203%3A1203&crop=1200%3A464%3B1%2C558	1	99	0	0	0	8@8-cafe-neutral-bay	https://www.zomato.com/sydney/8@8-cafe-neutral-bay	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Pram Friendly,Outdoor Seating,Brunch,Lunch Menu,Available for Functions,Drive Thru,Table booking recommended,Free Parking,Gluten Free Options,Split Bills,Set Menu,Indoor Seating,All Day Breakfast,Desserts and Bakes,Kid Friendly,Pet Friendly,Wifi,Dairy Free,Vegan Options	50	(151.223071664600013,-33.8306283131000001)
66354	The Bondi Surf Seafoods	+61	(02) 9130 4554	\N	2451	1	https://b.zmtcdn.com/data/res_imagery/16564884_RESTAURANT_1fff5e277476e8d5758bc56e5e0c0dd2_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-bondi-surf-seafoods-bondi-beach	https://www.zomato.com/sydney/the-bondi-surf-seafoods-bondi-beach	Breakfast,Takeaway Available,Wheelchair Accessible,Table booking not available,No Alcohol Available,Indoor Seating,Kid Friendly,Parking available 272 metres away	35	(151.274578794799993,-33.8913053996000002)
16778	Cold Rock Ice Creamery	+61	(02) 9764 5002	\N	2452	1	https://b.zmtcdn.com/data/res_imagery/16714349_CHAIN_c0ecf5efb7e904d3097b0dc318cb6b75.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cold-rock-ice-creamery-sydney-olympic-park	https://www.zomato.com/sydney/cold-rock-ice-creamery-sydney-olympic-park	Takeaway Available,Wheelchair Accessible,Table booking not available,Gluten Free Options,Desserts and Bakes,Outdoor Seating,Vegetarian Friendly,Kid Friendly,Vegan Options	25	(151.068096645200001,-33.8479504063000007)
63450	Happy Dragon	+61	(02) 9712 5192	\N	97	1	https://b.zmtcdn.com/data/reviews_photos/aad/e0737d50c8438efc65c8fe28db8e2aad_1451807746.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C300	1	99	0	0	0	happy-dragon-wareemba	https://www.zomato.com/sydney/happy-dragon-wareemba	Home Delivery,Takeaway Available,Wheelchair Accessible,BYO,Indoor Seating	40	(151.131126545400008,-33.8578708344999981)
69126	Ekush Restaurant and Sweets	+61	(02) 9740 4340	\N	413	1	https://b.zmtcdn.com/data/res_imagery/16569001_CHAIN_433e0e1f0cf5539a2fa6af6f21104644.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	ekush-restaurant-and-sweets-lakemba	https://www.zomato.com/sydney/ekush-restaurant-and-sweets-lakemba	Takeaway Available,Serves Halal,No Alcohol Available,Kid Friendly,Indoor Seating,Table Reservation Not Required	60	(151.078913323600005,-33.922760505200003)
66385	Matteo Double Bay	+61	(02) 9327 8015	\N	53	1	https://b.zmtcdn.com/data/pictures/1/17742681/fc9dd0e20c5f0adc2c28e3f568892e61.jpg?resize=1204%3A803&crop=1200%3A464%3B-1%2C321	1	99	0	0	0	matteo-double-bay-double-bay	https://www.zomato.com/sydney/matteo-double-bay-double-bay	Takeaway Available,Full Bar Available,Table booking recommended,Vegetarian Friendly,Dairy Free,BYO Cake,Set Menu,Indoor Seating,Shared Plates,Craft Beer,Available for Functions,Gluten Free Options,Vegan Options,Split Bills,Outdoor Seating,Serves Cocktails,Kid Friendly	90	(151.241974532600011,-33.8780124765999986)
66388	Bistro Rex	+61	(02) 9332 2100	\N	25	1	https://b.zmtcdn.com/data/pictures/3/18487033/34ccb712ffaf97598ebf1d8dd79e4924.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C410	1	99	0	0	0	bistro-rex-elizabeth-bay	https://www.zomato.com/sydney/bistro-rex-elizabeth-bay	Wine,Table booking recommended,Indoor Seating,Parking available 202 metres away	100	(151.225398480899997,-33.8718461328999965)
69153	The Gasoline Pony	+61	(02) 9569 2668	\N	423	1	https://b.zmtcdn.com/data/res_imagery/16714247_RESTAURANT_f809a69e2afbd910a88e52aa16419808.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-gasoline-pony-marrickville	https://www.zomato.com/sydney/the-gasoline-pony-marrickville	Full Bar Available,Live Music,Nightlife,Outdoor Seating,Indoor Seating	60	(151.160895712700011,-33.912707386400001)
16840	Casa Del	+61	(02) 9550 5982	\N	423	1	https://b.zmtcdn.com/data/pictures/6/18310946/08df904b4a3fa374258700945bb7dc28.jpg?resize=1204%3A803&crop=1200%3A464%3B-2%2C144	1	99	0	0	0	casa-del-marrickville	https://www.zomato.com/sydney/casa-del-marrickville	Takeaway Only,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Desserts and Bakes,Vegan Options	25	(151.164340674899989,-33.9098762288000017)
69167	Epping Star Kebabs	+61	(02) 9868 2882	\N	250	1	https://b.zmtcdn.com/data/res_imagery/16715156_RESTAURANT_17cda91cc2cc591fcaf6a8c9aa29c3f0.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	epping-star-kebabs-epping	https://www.zomato.com/sydney/epping-star-kebabs-epping	Takeaway Available,No Alcohol Available,Indoor Seating	35	(151.081655546999997,-33.7730424128000024)
69165	Oaksccino	+61	0466 668 125	\N	190	1	https://b.zmtcdn.com/data/pictures/3/16715353/4c437f1b17235b6650cecbe54188b0cf.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	23-oaks-coffee-bar-dee-why	https://www.zomato.com/sydney/23-oaks-coffee-bar-dee-why	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Gluten Free Options,Wifi,Brunch,Kid Friendly,Vegetarian Friendly,Indoor Seating	50	(151.287271007899989,-33.7541064843000029)
66419	Bangkok Snap	+61	(02) 9890 8462	\N	317	1	https://b.zmtcdn.com/data/res_imagery/16566273_CHAIN_36128e55a377d91dc73557aea2976f84_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	bangkok-snap-northmead	https://www.zomato.com/sydney/bangkok-snap-northmead	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,Kid Friendly,Gluten Free Options,Indoor Seating,Vegetarian Friendly	65	(150.989150181399992,-33.7965848910999966)
63083	Spice Theory Indian Restaurant	+61	(02) 9988 4242	\N	143	1	https://b.zmtcdn.com/data/reviews_photos/d17/9d74690acf7c53a998147d8d1eec6d17_1532580485.JPG?resize=1204%3A1204&crop=1200%3A464%3B-1%2C222	1	99	0	0	0	spice-theory-indian-restaurant-turramurra	https://www.zomato.com/sydney/spice-theory-indian-restaurant-turramurra	Home Delivery,Takeaway Available,Wine,BYO,Indoor Seating,Kid Friendly	75	(151.13032992929999,-33.7330765903000014)
66424	MON Modern Thai & Cocktails - Mr B's Hotel	+61	(02) 8080 7777	\N	2449	1	https://b.zmtcdn.com/data/pictures/1/16562721/2453a9d875116cd751310fdd9a2848f3.jpg?resize=1204%3A722&crop=1200%3A464%3B16%2C103	1	99	0	0	0	mon-modern-thai-cocktails-mr-bs-hotel-cbd	https://www.zomato.com/sydney/mon-modern-thai-cocktails-mr-bs-hotel-cbd	Wheelchair Accessible,Full Bar Available,Serves Cocktails,Gluten Free Options,Nightlife,Outdoor Seating,Vegetarian Friendly,Indoor Seating,Parking available 162 metres away	140	(151.204844042699989,-33.8683223873999992)
69173	Orient Express	+61	(02) 8883 1680	\N	325	1	https://b.zmtcdn.com/data/res_imagery/16562447_CHAIN_eece2de429a21b4d62b43b3babbc986e_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	orient-express-rouse-hill	https://www.zomato.com/sydney/orient-express-rouse-hill	Takeaway Available,No Alcohol Available,Indoor Seating	30	(150.92725317930001,-33.6908504179000019)
62579	Cranzgots Pizza Cafe	+61	(02) 9918 5550	\N	212	1	https://b.zmtcdn.com/data/pictures/7/16566647/769021bdeae54cf3fce213fb24f192cd.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cranzgots-pizza-cafe-avalon	https://www.zomato.com/sydney/cranzgots-pizza-cafe-avalon	Home Delivery,Takeaway Available,No Alcohol Available,Outdoor Seating,Gluten Free Options,Vegetarian Friendly,Pet Friendly,Vegan Options	60	(151.333540454499996,-33.6217614995000034)
66951	Churchill's Sports Bar	+61	(02) 9663 3648	\N	61	1	https://b.zmtcdn.com/data/pictures/8/16557588/2dc3ace26ac92fb8e5744bc00ddc860f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	churchills-sports-bar-kingsford	https://www.zomato.com/sydney/churchills-sports-bar-kingsford	Breakfast,Wheelchair Accessible,Full Bar Available,Sports Bar,Outdoor Seating,Nightlife,Kid Friendly,Live Sports Screening,Smoking Area,Indoor Seating	60	(151.228567846099992,-33.924250857799997)
69518	Banh Mi Bay Ngo	+61	(02) 9709 8106	\N	420	1	https://b.zmtcdn.com/data/pictures/3/16715903/2297968f3f502ccfadc40698726da758.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	banh-mi-bay-ngo-bankstown	https://www.zomato.com/sydney/banh-mi-bay-ngo-bankstown	Breakfast,Takeaway Only,Seating Not Available,Vegetarian Friendly,Desserts and Bakes	15	(151.032240875100001,-33.9184743096000005)
71979	Berowra Pizza Restaurant	+61	(02) 9456 3710	\N	158	1	\N	1	99	0	0	0	berowra-pizza-restaurant-berowra	https://www.zomato.com/sydney/berowra-pizza-restaurant-berowra	Takeaway Available,BYO,No Alcohol Available,Indoor Seating,Table booking recommended,Kid Friendly	45	(151.152694999999994,-33.6229549999999975)
69219	Corner Brew	+61	(02) 9520 2042	\N	502	1	https://b.zmtcdn.com/data/res_imagery/15543863_RESTAURANT_ff474b7081b79ba0804095c1ef9d9e1d.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	corner-brew-engadine	https://www.zomato.com/sydney/corner-brew-engadine	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Outdoor Seating,Brunch,Desserts and Bakes,Gluten Free Options,Vegetarian Friendly,Indoor Seating	40	(151.014302596499988,-34.0653901429000001)
63123	Ironbark Woodfired Pizza Restaurant & Cafe	+61	(02) 9977 2255	\N	184	1	https://b.zmtcdn.com/data/res_imagery/16559566_RESTAURANT_a45525ba16ec9e1ec035971200fdd67c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ironbark-woodfired-pizza-restaurant-cafe-manly	https://www.zomato.com/sydney/ironbark-woodfired-pizza-restaurant-cafe-manly	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,BYO,Outdoor Seating,Wifi,Indoor Seating,Kid Friendly,Gluten Free Options,Vegetarian Friendly,Table booking recommended	85	(151.284781917900006,-33.7882877316000005)
69656	Lyton Noodle House	+61	(02) 8678 9812	\N	309	1	\N	1	99	0	0	0	lyton-noodle-house-1-blacktown	https://www.zomato.com/sydney/lyton-noodle-house-1-blacktown	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Table Reservation Not Required,Kid Friendly,Indoor Seating	55	(150.894014909899994,-33.7576463661999995)
66482	Costi's Fish & Chips	+61	(02) 9922 4265	\N	108	1	https://b.zmtcdn.com/data/reviews_photos/4b9/e2f3ff35593bd7bdb8b0518219b3b4b9.jpg?resize=1204%3A677&crop=1200%3A464%3B0%2C36	1	99	0	0	0	costis-fish-chips-north-sydney	https://www.zomato.com/sydney/costis-fish-chips-north-sydney	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Kid Friendly,Parking available 150 metres away	30	(151.20791047809999,-33.8405585499000026)
66485	Cafe Mosman	+61	(02) 9969 8729	\N	173	1	https://b.zmtcdn.com/data/res_imagery/16565504_RESTAURANT_ada9cab4f61c33780a3aca29a4485b73_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	cafe-mosman-mosman	https://www.zomato.com/sydney/cafe-mosman-mosman	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Pet Friendly,Brunch,Desserts and Bakes,Kid Friendly,Vegetarian Friendly,Outdoor Seating,Gluten Free Options	45	(151.24231450260001,-33.8253331263000021)
69525	Little Thai Place	+61	(02) 9411 3389	\N	17	1	https://b.zmtcdn.com/data/pictures/1/16561991/3265a0155244c3948ebbdcc8945dcc79.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	little-thai-place-artarmon	https://www.zomato.com/sydney/little-thai-place-artarmon	Home Delivery,Takeaway Available,Wheelchair Accessible,BYO,Outdoor Seating,Indoor Seating,Vegetarian Friendly	50	(151.18475630879999,-33.808211486700003)
66489	67 Union St Deli	+61	(02) 9955 3797	\N	2464	1	https://b.zmtcdn.com/data/reviews_photos/96f/0c90744c3ac0733d9a9dbdbc24a9396f_1507019472.jpg?resize=1204%3A675&crop=1200%3A464%3B-2%2C213	1	99	0	0	0	67-union-st-deli-mcmahons-point	https://www.zomato.com/sydney/67-union-st-deli-mcmahons-point	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Outdoor Seating,Vegan Options,Kid Friendly,Gluten Free Options,Brunch,Wifi,Desserts and Bakes	35	(151.202264763399995,-33.8416721728000027)
72098	Meltemi Pizzeria Restaurant	+61	(02) 9918 0640	\N	212	1	https://b.zmtcdn.com/data/res_imagery/16715399_RESTAURANT_a9e7001fa8275ea423b43c3f8211da93.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	meltemi-pizzeria-restaurant-avalon	https://www.zomato.com/sydney/meltemi-pizzeria-restaurant-avalon	Home Delivery,Takeaway Available,Wheelchair Accessible,Table Reservation Not Required,Vegetarian Friendly,Wifi,Outdoor Seating,Indoor Seating	50	(151.328771151599994,-33.6377153440000001)
66533	Hong Kong Seafood Cuisine	+61	(02) 9787 6168	\N	412	1	https://b.zmtcdn.com/data/res_imagery/15543434_RESTAURANT_5f12ac86185be8cbca6f3620b836e0c2.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	hong-kong-seafood-cuisine-campsie	https://www.zomato.com/sydney/hong-kong-seafood-cuisine-campsie	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Kid Friendly,Table Reservation Not Required	65	(151.103130318199987,-33.9122307567999997)
63187	P'Eatzza At Joes	+61	(02) 9638 6926	\N	241	1	https://b.zmtcdn.com/data/res_imagery/16562027_RESTAURANT_da92517d326ec07efe49d124abe450a7.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	peatzza-at-joes-rydalmere	https://www.zomato.com/sydney/peatzza-at-joes-rydalmere	Home Delivery,Takeaway Available,No Alcohol Available,Dairy Free,Vegetarian Friendly,Indoor Seating,Gluten Free Options	40	(151.03354811669999,-33.8044942793000018)
63203	Zapparelli's Pizza	+61	(02) 9420 3131	\N	119	1	https://b.zmtcdn.com/data/res_imagery/16562085_RESTAURANT_4299111ba959cc3d1b282dc6383f4117_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	zapparellis-pizza-lane-cove	https://www.zomato.com/sydney/zapparellis-pizza-lane-cove	Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Gluten Free Options,Vegetarian Friendly,Outdoor Seating	55	(151.157981492599987,-33.8149726959000034)
69294	Ka Wah Chinese Restaurant	+61	(02) 9602 4596	\N	374	1	\N	1	99	0	0	0	ka-wah-chinese-restaurant-moorebank	https://www.zomato.com/sydney/ka-wah-chinese-restaurant-moorebank	Home Delivery,Takeaway Available,Wheelchair Accessible,Indoor Seating,Gluten Free Options,Vegetarian Friendly	30	(150.949298590399991,-33.9326157670000015)
66540	Aalishaan Indian Cuisine	+61	(02) 4620 0853	\N	1681	1	https://b.zmtcdn.com/data/res_imagery/16561690_RESTAURANT_49fbb1bd17f8f7c01eb1c0429caf9b3a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	aalishaan-indian-cuisine-campbelltown	https://www.zomato.com/sydney/aalishaan-indian-cuisine-campbelltown	Home Delivery,Takeaway Available,Serves Halal,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Table Reservation Not Required	55	(150.816717334099991,-34.0642008418000017)
73369	J & P Take Away	+61	(02) 9711 4522	\N	375	1	https://b.zmtcdn.com/data/pictures/7/17747537/1a632d9256a7e59ec9697b1faa5007e0.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	j-p-take-away-mount-pritchard	https://www.zomato.com/sydney/j-p-take-away-mount-pritchard	Breakfast,Takeaway Available,Indoor Seating,Outdoor Seating	20	(150.89726608250001,-33.9018288281000011)
72131	Casula Chicks & Seafood	+61	(02) 9824 2323	\N	368	1	\N	1	99	0	0	0	casula-chicks-seafood-casula	https://www.zomato.com/sydney/casula-chicks-seafood-casula	Indoor Seating	\N	(150.910881981300008,-33.9433418674000009)
69327	Northside Burger/ Fish & Chips	+61	(02) 8084 8835	\N	141	1	https://b.zmtcdn.com/data/pictures/7/17743857/b89d3182f555ffcd13e7c0e989ca537d.jpg?resize=1204%3A903&crop=1200%3A464%3B-1%2C285	1	99	0	0	0	northside-burger-fish-chips-pymble	https://www.zomato.com/sydney/northside-burger-fish-chips-pymble	Breakfast,Home Delivery,Takeaway Available,Gluten Free Options,Indoor Seating,All Day Breakfast	45	(151.142454519900014,-33.7445615386999975)
72468	Rooty Hill Star Kebab and Pizza	+61	(02) 9677 9569	\N	2812	1	\N	1	99	0	0	0	rooty-hill-star-kebab-and-pizza-rooty-hill	https://www.zomato.com/sydney/rooty-hill-star-kebab-and-pizza-rooty-hill	Takeaway Only	\N	(150.843148492300003,-33.7708325959999982)
54818	Liu Rose	+61	(02) 9736 1042	\N	274	1	https://b.zmtcdn.com/data/pictures/1/16558351/2c028397e4ea586b90d253b890072235.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	liu-rose-north-strathfield	https://www.zomato.com/sydney/liu-rose-north-strathfield	Takeaway Available,No Alcohol Available,Table Reservation Not Required,Wifi,Indoor Seating	55	(151.091638393700009,-33.8558764834999977)
17072	The Health Emporium	+61	(02) 9365 6008	\N	49	1	https://b.zmtcdn.com/data/pictures/1/16569401/3b3a0a6f2a18ea15cc0dff242ed5f536.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-health-emporium-bondi	https://www.zomato.com/sydney/the-health-emporium-bondi	Takeaway Available,No Alcohol Available,Vegan Options,Gluten Free Options,Indoor Seating,Desserts and Bakes,Vegetarian Friendly	60	(151.267842091599988,-33.8946620506999992)
66579	Seoulmate	+61	(02) 9007 7743	\N	130	1	https://b.zmtcdn.com/data/reviews_photos/9e8/17e84bae07623c15551410ae0be249e8_1517717441.jpg?resize=1204%3A1605&crop=1200%3A464%3B0%2C809	1	99	0	0	0	seoulmate-north-willoughby	https://www.zomato.com/sydney/seoulmate-north-willoughby	Breakfast,Takeaway Available,Wheelchair Accessible,BYO,Brunch,Gluten Free Options,Kid Friendly,Pram Friendly,Corkage Fee Charged,Available for Functions,Indoor Seating,Vegan Options,All Day Breakfast,Pet Friendly,Split Bills,BYO Cake,Vegetarian Friendly	40	(151.195678599199994,-33.7932082242000007)
66582	Quay & Co	+61	(02) 8937 3220	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/18441408_RESTAURANT_c07ef1648ba72361c16922cd2c961503.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	quay-co-cbd	https://www.zomato.com/sydney/quay-co-cbd	Breakfast,Full Bar Available,Table Reservation Not Required,Indoor Seating,Vegetarian Friendly,Parking available 0 metres away	70	(151.209767572599986,-33.8618568910000022)
21	New Shanghai	+61	(02) 9627 7282	15	2	1	https://imgur.com/RVrwxN7.jpg	11	99	0	0	0	\N	\N	\N	\N	(151.208922999999999,-33.870510000000003)
2	Sokyo	+61	(02) 9627 7282	\N	1	1	https://imgur.com/9zJ9GvA.jpg	2	1	1	3	0	\N	\N	\N	\N	(151.195517999999993,-33.8695459999999997)
73673	Doner Diner	+61	\N	\N	2928	1	\N	1	99	0	0	0	doner-diner-macquarie-park	https://www.zomato.com/sydney/doner-diner-macquarie-park	Indoor Seating,Outdoor Seating,Vegetarian Friendly	25	(151.114177331299999,-33.7755110750999989)
69437	Tomo Sushi	+61	0424 355 175	\N	453	1	https://b.zmtcdn.com/data/pictures/8/16569588/39f97daf8a025da78d0b69e35b466ecc.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	tomo-sushi-kogarah	https://www.zomato.com/sydney/tomo-sushi-kogarah	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Vegetarian Friendly,Indoor Seating,Outdoor Seating,Parking available 293 metres away	45	(151.132507547699987,-33.9634255052)
72276	Tori by Sushi Hon	+61	(02) 9663 1888	\N	59	1	\N	1	99	0	0	0	tori-by-sushi-hon-kensington	https://www.zomato.com/sydney/tori-by-sushi-hon-kensington	Breakfast,Takeaway Available,Indoor Seating,Vegetarian Friendly	25	(151.234403327100011,-33.9173602974000019)
66686	Nakhon Thai Restaurant	+61	(02) 9599 8202	\N	2461	1	https://b.zmtcdn.com/data/res_imagery/16560814_RESTAURANT_4608a8406287d7e1b0ef57a22fca3186_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	nakhon-thai-restaurant-brighton-le-sands	https://www.zomato.com/sydney/nakhon-thai-restaurant-brighton-le-sands	Home Delivery,Takeaway Available,Serves Halal,No Alcohol Available,Outdoor Seating,Vegetarian Friendly,Indoor Seating,Table Reservation Not Required	50	(151.154192201799987,-33.9601650000999982)
72952	Adri's Cocina	+61	0403 991 124	\N	79	1	https://b.zmtcdn.com/data/pictures/6/17746936/9c54190eb946e1495f17a089547170c0.jpg?resize=1204%3A1204&crop=1200%3A464%3B-1%2C387	1	99	0	0	0	adris-cocina-leichhardt	https://www.zomato.com/sydney/adris-cocina-leichhardt	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Vegetarian Friendly,Desserts and Bakes	30	(151.158402599400006,-33.8872695064999974)
72861	Steam Brothers	+61	\N	\N	502	1	\N	1	99	0	0	0	steam-brothers-engadine	https://www.zomato.com/sydney/steam-brothers-engadine	Breakfast,No Alcohol Available,Indoor Seating,Kid Friendly	35	(151.012876331799987,-34.0656578860999986)
72346	Massaya Authentic Lebanese Restaurant	+61	1300 088 714	\N	266	1	https://b.zmtcdn.com/data/pictures/2/19045612/6d0fccc57b977ac7ce260cfdd3bb6327.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=903&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=195&cropgravity=NorthWest	1	99	0	0	0	massaya-authentic-lebanese-restaurant-strathfield	https://www.zomato.com/sydney/massaya-authentic-lebanese-restaurant-strathfield	Takeaway Available,Serves Alcohol,Indoor Seating,Table Reservation Not Required,Serves Cocktails	60	(151.073300130700005,-33.8876669535000019)
66723	Cafe Organism	+61	(02) 7901 2509	\N	12	1	https://b.zmtcdn.com/data/res_imagery/16569889_RESTAURANT_45dbe3b3f5a4487a45217c526ed0d9c0.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cafe-organism-darlinghurst	https://www.zomato.com/sydney/cafe-organism-darlinghurst	Breakfast,Takeaway Available,No Alcohol Available,Wifi,Gluten Free Options,Outdoor Seating,Brunch,Vegan Options,Vegetarian Friendly,Indoor Seating	55	(151.215194351999997,-33.8801042890999966)
69452	Bianco Restaurant	+61	(02) 9567 3345	\N	2461	1	https://b.zmtcdn.com/data/res_imagery/16716068_RESTAURANT_5879fe7b59630e51998114d9afd828d5.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	bianco-restaurant-brighton-le-sands	https://www.zomato.com/sydney/bianco-restaurant-brighton-le-sands	Wheelchair Accessible,Full Bar Available,Indoor Seating,Outdoor Seating,Table booking recommended,Vegetarian Friendly	75	(151.156513318399988,-33.9600760123000001)
72998	Kaori sushi	+61	0434 097 990	\N	190	1	https://b.zmtcdn.com/data/pictures/9/17745989/7eecdb67307f7697f3a2c179b0622ff8.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	kaori-sushi-dee-why	https://www.zomato.com/sydney/kaori-sushi-dee-why	Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Table Reservation Not Required,Kid Friendly	15	(151.284686364200013,-33.7553854189999996)
66731	Cup and Cook	+61	(02) 9547 1111	\N	465	1	https://b.zmtcdn.com/data/res_imagery/15548753_RESTAURANT_c8f46f6c3ad1d949ef0b83d5b56968f9.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cup-and-cook-kyle-bay	https://www.zomato.com/sydney/cup-and-cook-kyle-bay	Breakfast,No Alcohol Available,Outdoor Seating,Indoor Seating,Brunch	50	(151.100495383099997,-33.9877814857999994)
72449	Lucky Yummy 川越阁	+61	(02) 8317 4837	\N	463	1	https://b.zmtcdn.com/data/pictures/chains/8/17745028/408928fbc5280b1027fb10fa04debc53.jpg?resize=1204%3A802&crop=1200%3A464%3B0%2C99	1	99	0	0	0	lucky-yummy-hurstville	https://www.zomato.com/sydney/lucky-yummy-hurstville	Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Accepts Cryptocurrency,Lunch Menu,Indoor Seating,Catering Available,Pram Friendly,Group Bookings Available,Buffet,Free Parking,Available for Functions,BYO Cake,Kid Friendly	65	(151.105885282200006,-33.967497832600003)
69244	C&I Noodle Kitchen	+61	\N	\N	2449	1	https://b.zmtcdn.com/data/reviews_photos/245/41b6ee35afcd4b4d15b14566a966b245_1473682859.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	c-i-noodle-kitchen-cbd	https://www.zomato.com/sydney/c-i-noodle-kitchen-cbd	Takeaway Available,Indoor Seating,Vegetarian Friendly,Parking available 149 metres away	25	(151.208056658499999,-33.8657436529000009)
72439	Field To Fork- The Butcher's Grill	+61	(02) 9388 7172	\N	55	1	https://b.zmtcdn.com/data/pictures/9/19052269/2c73d32af56ba91a88416154d539cd40.jpg?resize=1204%3A1204&crop=1200%3A464%3B-1%2C526	1	99	0	0	0	field-to-fork-the-butchers-grill-vaucluse	https://www.zomato.com/sydney/field-to-fork-the-butchers-grill-vaucluse	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Pet Friendly,Outdoor Seating,Kid Friendly	30	(151.279116757200001,-33.8593829240999966)
72457	Hambaagaa	+61	(02) 9520 4087	\N	503	1	https://b.zmtcdn.com/data/pictures/5/15543715/f14aa2897d9885aafee18595a7688833.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	hambaagaa-heathcote	https://www.zomato.com/sydney/hambaagaa-heathcote	Breakfast,Takeaway Available,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Brunch	45	(151.008252538699992,-34.0876327187000001)
73066	Thai Cuisine	+61	(02) 9603 6263	\N	1681	1	\N	1	99	0	0	0	thai-cuisine-eastern-creek	https://www.zomato.com/sydney/thai-cuisine-eastern-creek	Takeaway Available,Indoor Seating	40	(150.816675424599993,-34.0322462239999979)
72476	Club Palm Beach	+61	(02) 9974 5566	\N	216	1	\N	1	99	0	0	0	club-palm-beach-palm-beach	https://www.zomato.com/sydney/club-palm-beach-palm-beach	Breakfast,Takeaway Available,Wine and Beer,Wifi,Indoor Seating	60	(151.319227777799995,-33.6003083332999992)
73779	Nero's Cafe and Espresso	+61	(02) 9451 5946	\N	170	1	\N	1	99	0	0	0	neros-cafe-and-espresso-frenchs-forest	https://www.zomato.com/sydney/neros-cafe-and-espresso-frenchs-forest	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes,Vegetarian Friendly,Kid Friendly	40	(151.243899352900002,-33.7511028082000024)
72478	Bistro Of Shanghai	+61	(02) 9897 3711	\N	336	1	https://b.zmtcdn.com/data/pictures/1/16715951/4b6e9f6b3e0c9e7120c6d023db8eb56e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	bistro-of-shanghai-merrylands	https://www.zomato.com/sydney/bistro-of-shanghai-merrylands	Takeaway Available,No Alcohol Available,Indoor Seating,Table booking recommended	40	(150.992329269700008,-33.8360122894000028)
69463	Purumiru	+61	(02) 8387 3727	\N	82	1	\N	1	99	0	0	0	purumiru-balmain	https://www.zomato.com/sydney/purumiru-balmain	Home Delivery,Wine,Table Reservation Not Required,Indoor Seating,Kid Friendly	40	(151.177833192099996,-33.8563921292000032)
72514	DishCovery Thai Restaurant	+61	0415 212 626	\N	90	1	https://b.zmtcdn.com/data/pictures/6/19093306/7b92b6cd832d9c8bbe91c214634f4070.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=6&cropoffsety=545&cropgravity=NorthWest	1	99	0	0	0	dishcovery-thai-restaurant-haberfield	https://www.zomato.com/sydney/dishcovery-thai-restaurant-haberfield	Takeaway Available,No Alcohol Available,Table Reservation Not Required,Indoor Seating,Kid Friendly	60	(151.139431670300013,-33.8802696277999971)
66775	Vincenzo's Pizzeria	+61	(02) 9896 7060	\N	300	1	\N	1	99	0	0	0	vincenzos-pizzeria-merrylands	https://www.zomato.com/sydney/vincenzos-pizzeria-merrylands	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Table booking recommended	30	(150.966002717599991,-33.8289892689000027)
66778	Po Po Hurstville	+61	(02) 9580 6218	\N	2523	1	https://b.zmtcdn.com/data/reviews_photos/07b/1c64caec89888b897df3db5a3a1c107b_1518310434.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1203&fith=678&cropw=1200&croph=464&cropoffsetx=-1&cropoffsety=27&cropgravity=NorthWest	1	99	0	0	0	po-po-hurstville-hurstville	https://www.zomato.com/sydney/po-po-hurstville-hurstville	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Indoor Seating	35	(151.104298420300012,-33.9675353710999985)
72541	Momo ME	+61	0431 436 283	\N	451	1	https://b.zmtcdn.com/data/pictures/5/17748155/4d6b97e59339b1cde5fc0dfe79a86ed9.jpg?resize=1204%3A903&crop=1200%3A464%3B1%2C251	1	99	0	0	0	momo-me-rockdale	https://www.zomato.com/sydney/momo-me-rockdale	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	\N	(151.138534806699994,-33.9525434122000007)
73868	Time @ Rhodes	+61	\N	\N	277	1	\N	1	99	0	0	0	time-@-rhodes-rhodes	https://www.zomato.com/sydney/time-@-rhodes-rhodes	Indoor Seating,Outdoor Seating	60	(151.086494587400011,-33.8315047780999976)
72573	14 Queen at The Hughenden	+61	(02) 9363 4863	\N	2726	1	https://b.zmtcdn.com/data/pictures/7/17745527/65e9165e8e99724bebeedb5667dd727e.jpg?resize=1204%3A803&crop=1200%3A464%3B1%2C208	1	99	0	0	0	14-queen-at-the-hughenden-woollahra	https://www.zomato.com/sydney/14-queen-at-the-hughenden-woollahra	Breakfast,Full Bar Available,Indoor Seating,Outdoor Seating,Brunch,High Tea	40	(151.234100237500002,-33.8895024775000024)
66806	Vela Dining & Bar	+61	(02) 8759 7604	\N	270	1	https://b.zmtcdn.com/data/res_imagery/16568020_RESTAURANT_8b00fe29da868becd7b01750b4be1629_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	vela-dining-bar-breakfast-point	https://www.zomato.com/sydney/vela-dining-bar-breakfast-point	Breakfast,Wheelchair Accessible,Wine,Outdoor Seating,Table booking recommended	60	(151.120021864800009,-33.8420843126000008)
73987	Skewers Middle Eastern BBQ House	+61	(02) 4655 9812	\N	1710	1	\N	1	99	0	0	0	skewers-middle-eastern-bbq-house-camden	https://www.zomato.com/sydney/skewers-middle-eastern-bbq-house-camden	Takeaway Available,Outdoor Seating,Indoor Seating	50	(150.698788000000008,-34.0538230000000013)
66828	Okori Teppan-Yaki	+61	(02) 9897 7790	\N	284	1	https://b.zmtcdn.com/data/res_imagery/16558612_RESTAURANT_479716aef0c45613981af2f15f699308.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	okori-teppan-yaki-granville	https://www.zomato.com/sydney/okori-teppan-yaki-granville	No Alcohol Available,Kid Friendly,Table booking recommended,Indoor Seating,Set Menu	80	(151.013007089500007,-33.8308951248000014)
72303	Raj Bhavan	+61	(02) 9688 2574	\N	303	1	\N	1	99	0	0	0	raj-bhavan-toongabbie	https://www.zomato.com/sydney/raj-bhavan-toongabbie	Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Table Reservation Not Required	30	(150.949911139899996,-33.7884646724999982)
66868	San Antonio Sourdough	+61	0413 630 430	\N	109	1	https://b.zmtcdn.com/data/reviews_photos/560/fe9a7e3041aa5170fc73014602476560_1446011446.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	san-antonio-sourdough-kirribilli	https://www.zomato.com/sydney/san-antonio-sourdough-kirribilli	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Pet Friendly,Outdoor Seating,Desserts and Bakes,Brunch,Indoor Seating	30	(151.212978176799993,-33.8461769203000031)
66893	Radhe Chatpata House	+61	(02) 8625 1936	\N	309	1	https://b.zmtcdn.com/data/reviews_photos/02f/9175f92de74e332e9cf4a5bcf4c9d02f_1515663505.jpg?resize=1204%3A903&crop=1200%3A464%3B-2%2C348	1	99	0	0	0	radhe-chatpata-house-1-blacktown	https://www.zomato.com/sydney/radhe-chatpata-house-1-blacktown	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	60	(150.908466651999987,-33.7655766315999983)
66881	Nu Healthy Cafe	+61	(02) 4735 2003	\N	2976	1	https://b.zmtcdn.com/data/res_imagery/16570460_RESTAURANT_e33038e3ff31d96e4428c77501ad4930.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	nu-healthy-cafe-emu-plains	https://www.zomato.com/sydney/nu-healthy-cafe-emu-plains	Breakfast,Takeaway Available,No Alcohol Available,Vegan Options,Brunch,Kid Friendly,Vegetarian Friendly,Outdoor Seating,Gluten Free Options	40	(150.674696713700001,-33.7465916605000018)
72739	Jin Sushi Bar	+61	0433 675 925	\N	2098	1	\N	1	99	0	0	0	jin-sushi-bar-penrith	https://www.zomato.com/sydney/jin-sushi-bar-penrith	Breakfast,Takeaway Only,Seating Not Available	10	(150.693503692799993,-33.7513676376999996)
55107	Uyen	+61	(02) 9389 5660	\N	47	1	https://b.zmtcdn.com/data/res_imagery/16559292_CHAIN_0d40298bff66b3f0f0f9b3d48730763d.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	uyen-waverley	https://www.zomato.com/sydney/uyen-waverley	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	40	(151.254835389600004,-33.9030593616000004)
66945	The Nag's Head Hotel	+61	(02) 9660 1591	\N	9	1	https://b.zmtcdn.com/data/pictures/chains/7/16558557/b9a6c163662bed73eb032ce64c87fc71.jpg?resize=1204%3A803&crop=1200%3A464%3B-1%2C260	1	99	0	0	0	the-nags-head-hotel-glebe	https://www.zomato.com/sydney/the-nags-head-hotel-glebe	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Kid Friendly,Gluten Free Options,Table Reservation Not Required,Pet Friendly,Wifi,Live Sports Screening,Live Music,Nightlife,Indoor Seating,Smoking Area,Vegetarian Friendly,Outdoor Seating	50	(151.184606105099988,-33.8826455705000029)
72829	Whale Beach Deli	+61	(02) 9974 5440	\N	211	1	https://b.zmtcdn.com/data/pictures/2/17744872/aa6fcaaa5050cd86a1a2752aea5b3676.jpg?resize=1204%3A803&crop=1200%3A464%3B2%2C268	1	99	0	0	0	whale-beach-deli-whale-beach	https://www.zomato.com/sydney/whale-beach-deli-whale-beach	Breakfast,No Alcohol Available,Indoor Seating,Gluten Free Options,Kid Friendly,Dairy Free,Vegan Options	50	(151.330149000000006,-33.6110720000000001)
66919	World Vegan	+61	(02) 9724 3886	\N	354	1	https://b.zmtcdn.com/data/reviews_photos/5e4/f85257a25c0b406d265bd166624c85e4_1474889861.jpg?resize=1204%3A677&crop=1200%3A464%3B0%2C36	1	99	0	0	0	world-vegan-cabramatta	https://www.zomato.com/sydney/world-vegan-cabramatta	Takeaway Available,No Alcohol Available,Vegetarian Friendly,Vegan Options,Indoor Seating,Outdoor Seating	30	(150.937946476000008,-33.8958943574000031)
72893	Cook's Castle	+61	(02) 4722 3995	\N	2098	1	https://b.zmtcdn.com/data/pictures/2/15547952/1664f1facab22971497dc67d40cef952.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cooks-castle-penrith	https://www.zomato.com/sydney/cooks-castle-penrith	Takeaway Available,No Alcohol Available,Indoor Seating	30	(150.693119131000003,-33.752755609700003)
63608	JC's Pizza	+61	(02) 9939 7744	\N	186	1	https://b.zmtcdn.com/data/res_imagery/16561966_RESTAURANT_8b72ca84a87e43c2402d4f2f5527b66c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	jcs-pizza-curl-curl	https://www.zomato.com/sydney/jcs-pizza-curl-curl	Home Delivery,Takeaway Available,Wheelchair Accessible,Wine,Live Sports Screening,Catering Available,Kid Friendly,Indoor Seating,Available for Functions	50	(151.284057050900003,-33.7681037600999971)
72901	Goody's Take Away	+61	(02) 9905 4808	\N	195	1	https://b.zmtcdn.com/data/pictures/9/16715259/babed6cdb23484b5c92328b4ed881cdb.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	goodys-take-away-north-manly	https://www.zomato.com/sydney/goodys-take-away-north-manly	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating	25	(151.276502609299996,-33.7800744850000001)
72889	O'Donoghue's	+61	(02) 4735 5509	\N	2098	1	\N	1	99	0	0	0	odonoghues-emu-plains	https://www.zomato.com/sydney/odonoghues-emu-plains	Wheelchair Accessible,Full Bar Available,Outdoor Seating,Table Reservation Not Required,Kid Friendly,Indoor Seating	80	(150.673201717399991,-33.7465860848000005)
66952	Fourno Cafe	+61	(02) 9889 4118	\N	231	1	https://b.zmtcdn.com/data/res_imagery/16559862_RESTAURANT_0c01aa1dc6b9805124685de4c0649a5d.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	fourno-cafe-macquarie-park	https://www.zomato.com/sydney/fourno-cafe-macquarie-park	Breakfast,Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegetarian Friendly,Outdoor Seating,Kid Friendly	60	(151.143422462100006,-33.7950594309999985)
72909	The Modern Cafeteria	+61	(02) 9531 2303	\N	484	1	https://b.zmtcdn.com/data/pictures/5/17745485/5421bfa448e586b9da5d2bba8f41ba31.jpg?resize=1204%3A1605&crop=1200%3A464%3B3%2C-2	1	99	0	0	0	the-modern-cafeteria-caringbah	https://www.zomato.com/sydney/the-modern-cafeteria-caringbah	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Indoor Seating,Kid Friendly,Desserts and Bakes	20	(151.123415194500012,-34.0265006276000008)
66966	Ugly Mug Coffee House	+61	(02) 4578 9795	\N	2106	1	https://b.zmtcdn.com/data/res_imagery/17848982_RESTAURANT_89ad0cc13aaae1adfc910462e8251382_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ugly-mug-coffee-house-richmond	https://www.zomato.com/sydney/ugly-mug-coffee-house-richmond	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Desserts and Bakes,Gluten Free Options,Indoor Seating	45	(150.75121200000001,-33.5965259999999972)
69551	Forage and Graze	+61	(02) 9969 2400	\N	173	1	https://b.zmtcdn.com/data/res_imagery/16567898_RESTAURANT_081a16053fd3a3acec82fe61175701aa.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	forage-and-graze-mosman	https://www.zomato.com/sydney/forage-and-graze-mosman	No Alcohol Available,Indoor Seating	20	(151.242697387899995,-33.8426072817999994)
69579	Cafe Jolie	+61	(02) 9528 7126	\N	479	1	\N	1	99	0	0	0	cafe-jolie-jannali	https://www.zomato.com/sydney/cafe-jolie-jannali	Breakfast,Takeaway Available,No Alcohol Available,Kid Friendly,Vegetarian Friendly,Brunch,Outdoor Seating,Gluten Free Options	30	(151.065779551899993,-34.0163908457000019)
73051	Supreme Gourmet Pizza	+61	(02) 9553 9555	\N	453	1	https://b.zmtcdn.com/data/pictures/9/17741939/f9c4258cdb8b21e16d35e803f5e3070f.png?resize=1204%3A805&crop=1200%3A464%3B2%2C154	1	99	0	0	0	supreme-gourmet-pizza-kogarah	https://www.zomato.com/sydney/supreme-gourmet-pizza-kogarah	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating	45	(151.136182509399987,-33.9717593166)
63702	Piazza Guru	+61	(02) 9360 4210	\N	26	1	\N	1	99	0	0	0	piazza-guru-potts-point	https://www.zomato.com/sydney/piazza-guru-potts-point	Home Delivery,Takeaway Available,BYO,No Alcohol Available,Indoor Seating,Table Reservation Not Required	35	(151.221569627500003,-33.8750164886999983)
73040	Expresso Cartel	+61	0413 600 390	\N	2954	1	https://b.zmtcdn.com/data/pictures/4/17747934/805f24e38e3b1695fed4ebc126c86c01.jpg?resize=1204%3A1149&crop=1200%3A464%3B-3%2C572	1	99	0	0	0	expresso-cartel-rockdale	https://www.zomato.com/sydney/expresso-cartel-rockdale	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating	\N	(151.136915758300006,-33.9524213210999974)
66999	Table Sixty	+61	0488 197 776	\N	2475	1	https://b.zmtcdn.com/data/pictures/chains/2/16568672/f35289bd5e693ee91a7fc208cfc0b847.jpg?resize=1204%3A801&crop=1200%3A464%3B-1%2C196	1	99	0	0	0	table-sixty-cbd	https://www.zomato.com/sydney/table-sixty-cbd	Breakfast,Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Brunch,Vegetarian Friendly,Gluten Free Options,Indoor Seating,Parking available 250 metres away	45	(151.206517405800014,-33.8667706461000009)
66141	Little Italy	+61	(02) 9553 1555	\N	463	1	https://b.zmtcdn.com/data/res_imagery/16558345_RESTAURANT_c5893af176a34ee85a5214606f5a9298.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	little-italy-allawah	https://www.zomato.com/sydney/little-italy-allawah	Home Delivery,Takeaway Available,Wheelchair Accessible,BYO,Kid Friendly,Vegetarian Friendly,Outdoor Seating,Indoor Seating,Gluten Free Options	70	(151.115782633399988,-33.970205009099999)
66135	Cookies Lounge Bar	+61	(02) 9746 2021	\N	274	1	https://b.zmtcdn.com/data/res_imagery/16565054_RESTAURANT_5dd719c6945383227d8c533d94a39099.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cookies-lounge-bar-north-strathfield	https://www.zomato.com/sydney/cookies-lounge-bar-north-strathfield	Wheelchair Accessible,Wine,Live Sports Screening,Outdoor Seating,Indoor Seating,Vegan Options,Nightlife,Kid Friendly,Vegetarian Friendly	60	(151.088317483699996,-33.8629387765999965)
66161	TopHat Coffee Merchants	+61	0424 878 792	\N	58	1	https://b.zmtcdn.com/data/res_imagery/16566135_RESTAURANT_4612b88a9d02c0d660cabde9b080f990.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	tophat-coffee-merchants-clovelly	https://www.zomato.com/sydney/tophat-coffee-merchants-clovelly	Breakfast,Takeaway Available,No Alcohol Available,Smoking Area,Pet Friendly,Vegan Options,Desserts and Bakes,Outdoor Seating,Vegetarian Friendly,Gluten Free Options,Brunch	35	(151.259318701900014,-33.9122978134999968)
66167	Friend in Hand Hotel	+61	(02) 9660 2326	\N	9	1	https://b.zmtcdn.com/data/reviews_photos/96a/298a1f716e9cd5320f53c1e0bfc9196a_1500781203.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	friend-in-hand-hotel-glebe	https://www.zomato.com/sydney/friend-in-hand-hotel-glebe	Breakfast,Wheelchair Accessible,Full Bar Available,Indoor Seating,Wifi,Live Sports Screening,Nightlife	70	(151.192575283400004,-33.881433948199998)
63803	Mr. Wong	+61	(02) 9114 7317	\N	2449	1	https://b.zmtcdn.com/data/pictures/chains/4/16565634/cd088619a921d44d7f9b8552ea33403d.jpg?resize=1204%3A903&crop=1200%3A464%3B1%2C361	1	99	0	0	0	mr-wong-cbd	https://www.zomato.com/sydney/mr-wong-cbd	Wheelchair Accessible,Wine,Wifi,Vegetarian Friendly,Table booking recommended,Indoor Seating,Gluten Free Options,Set Menu,Parking available 168 metres away	120	(151.208086162799987,-33.8640779990000027)
73158	Cafe Gusto	+61	0424 347 556	\N	38	1	https://b.zmtcdn.com/data/pictures/3/19176433/e002c12ef056f28ad923462a622433bd.jpg?resize=1204%3A1204&crop=1200%3A464%3B1%2C391	1	99	0	0	0	cafe-gusto-botany	https://www.zomato.com/sydney/cafe-gusto-botany	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Indoor Seating	50	(151.197638000000012,-33.9398630000000026)
63823	Ippudo	+61	(02) 8078 7020	\N	2449	1	https://b.zmtcdn.com/data/pictures/9/16566109/29c445eb9e79ae236141c68746928a8b.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=903&cropw=1200&croph=464&cropoffsetx=1&cropoffsety=184&cropgravity=NorthWest	1	99	0	0	0	ippudo-cbd	https://www.zomato.com/sydney/ippudo-cbd	Takeaway Available,Serves Alcohol,Wifi,Vegan Options,Serves Cocktails,Sake,Indoor Seating,Gluten Free Options,Vegetarian Friendly,Table booking recommended,Parking available 181 metres away	70	(151.208997443300007,-33.8698635220000028)
63837	Temasek	+61	(02) 9633 9926	\N	255	1	https://b.zmtcdn.com/data/reviews_photos/03e/63a3c757be3387488ff5d8f98982503e_1551581920.jpg?resize=1204%3A1605&crop=1200%3A464%3B-1%2C690	1	99	0	0	0	temasek-parramatta	https://www.zomato.com/sydney/temasek-parramatta	Takeaway Available,Wheelchair Accessible,BYO,Table booking recommended,Kid Friendly,Gluten Free Options,Outdoor Seating,Indoor Seating,Available for Functions,Vegetarian Friendly,Parking available 249 metres away	50	(151.005598828199993,-33.8144559646000005)
73210	Cafe Bondi Relish	+61	0490 917 112	\N	2451	1	https://b.zmtcdn.com/data/pictures/5/17746045/35ad2d0328064f80c9268e4407732d79.jpg?resize=1204%3A1605&crop=1200%3A464%3B0%2C500	1	99	0	0	0	cafe-bondi-relish-bondi-beach	https://www.zomato.com/sydney/cafe-bondi-relish-bondi-beach	Breakfast,Takeaway Available,Outdoor Seating,Indoor Seating,Kid Friendly	40	(151.27215709539999,-33.8877821793999985)
73215	Rock Paper Coffee	+61	0434 520 841	\N	481	1	https://b.zmtcdn.com/data/pictures/chains/9/18658079/80378d4e390fefa12c4640e51b2d8b46.jpg?resize=1204%3A903&crop=1200%3A464%3B-4%2C197	1	99	0	0	0	rock-paper-coffee-gymea-bay	https://www.zomato.com/sydney/rock-paper-coffee-gymea-bay	Breakfast,Takeaway Available,No Alcohol Available,Gluten Free Options,Indoor Seating,Desserts and Bakes,Outdoor Seating,Kid Friendly	25	(151.088689304899987,-34.0525316406000016)
63861	Spice Temple	+61	(02) 8078 1888	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16559582_RESTAURANT_129dc65c08b4a70bbf520896b3771a93.png?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	spice-temple-cbd	https://www.zomato.com/sydney/spice-temple-cbd	Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegan Options,Gluten Free Options,Set Menu,Table booking recommended,Vegetarian Friendly,Parking available 183 metres away	150	(151.210222542299988,-33.8660020031000002)
73199	Cafe Thai	+61	(02) 9316 6888	\N	2457	1	https://b.zmtcdn.com/data/pictures/1/17747281/a6563fcaa8047c6c6bd385ad70cfa00a.jpg?resize=1204%3A1605&crop=1200%3A464%3B2%2C55	1	99	0	0	0	cafe-thai-banksmeadow	https://www.zomato.com/sydney/cafe-thai-banksmeadow	Takeaway Available,Wheelchair Accessible,Full Bar Available,Table Reservation Not Required,Kid Friendly,Indoor Seating,Vegetarian Friendly	55	(151.204393431499994,-33.9542576755000027)
63873	Sushi Rio	+61	(02) 9261 2388	\N	2449	1	https://b.zmtcdn.com/data/reviews_photos/61b/c6117087edf10f0de412c4fd4364f61b_1538877680.jpg?resize=1204%3A1606&crop=1200%3A464%3B-1%2C507	1	99	0	0	0	sushi-rio-1-cbd	https://www.zomato.com/sydney/sushi-rio-1-cbd	Takeaway Available,BYO,Vegetarian Friendly,Sushi Train,Table Reservation Not Required,Indoor Seating,Kid Friendly	30	(151.204611696299992,-33.8761778188000022)
67092	Food Xchange	+61	(02) 9540 5501	\N	484	1	https://b.zmtcdn.com/data/res_imagery/16568995_RESTAURANT_e39a92270051ee58741a7385dbf59bda.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	food-xchange-caringbah	https://www.zomato.com/sydney/food-xchange-caringbah	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Brunch,Desserts and Bakes,Kid Friendly,Gluten Free Options,Indoor Seating,Vegan Options	40	(151.121845431600008,-34.0410855913000034)
63880	678 Korean BBQ	+61	(02) 9281 8997	\N	5	1	https://b.zmtcdn.com/data/res_imagery/16567853_RESTAURANT_45b70a6c60d7a8ea32742b78de1eb893.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	678-korean-bbq-haymarket	https://www.zomato.com/sydney/678-korean-bbq-haymarket	Takeaway Available,Wheelchair Accessible,Wine and Beer,Vegetarian Friendly,Indoor Seating,Vegan Options,Parking available 273 metres away	80	(151.207911483900006,-33.8783041921999981)
63900	Spice I Am	+61	(02) 9280 0928	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/143/78b4240ac269bdc4da435ed1e5eae143_1490069414.jpg?resize=1204%3A1605&crop=1200%3A464%3B-4%2C608	1	99	0	0	0	spice-i-am-surry-hills	https://www.zomato.com/sydney/spice-i-am-surry-hills	Takeaway Available,Wine and Beer,Indoor Seating,Table booking recommended,Vegetarian Friendly,Serves Cocktails,Parking available 263 metres away	60	(151.209546960900013,-33.8797031884000006)
63913	Chiswick	+61	(02) 8388 8688	\N	48	1	https://b.zmtcdn.com/data/res_imagery/16564904_RESTAURANT_57a4c0679f12027d67082736f090fee5_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	chiswick-woollahra	https://www.zomato.com/sydney/chiswick-woollahra	Wheelchair Accessible,Full Bar Available,Farm-to-Table,Table booking recommended,Vegetarian Friendly,Set Menu,Gluten Free Options,Gastro Pub,Indoor Seating,Outdoor Seating	110	(151.240383312099993,-33.8868258556000015)
73257	The Owls Cafe	+61	04 0294 1531	\N	112	1	https://b.zmtcdn.com/data/pictures/7/15545397/155c2fadb269def8b1f7e7460aef152a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-owls-cafe-northbridge	https://www.zomato.com/sydney/the-owls-cafe-northbridge	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Pet Friendly,Indoor Seating,Brunch,Outdoor Seating,Gluten Free Options,Kid Friendly,Vegetarian Friendly	25	(151.21812164779999,-33.8121647598999999)
73198	Shri Desi Dhabha	+61	\N	\N	313	1	\N	1	99	0	0	0	shri-desi-dhabha-harris-park	https://www.zomato.com/sydney/shri-desi-dhabha-harris-park	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	40	(151.009756587499993,-33.8224302711000036)
69660	Campsie Charcoal Chicken	+61	(02) 9789 3812	\N	412	1	https://b.zmtcdn.com/data/reviews_photos/840/8c19c494e1177de3ef23e788ee210840_1460021043.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	campsie-charcoal-chicken-campsie	https://www.zomato.com/sydney/campsie-charcoal-chicken-campsie	Takeaway Available,Indoor Seating	25	(151.10362786799999,-33.9094699812999991)
73290	The Dry Leaf Cafe	+61	(02) 8668 5022	\N	173	1	https://b.zmtcdn.com/data/pictures/9/17744569/1ea8a80e92607d3345d391ed2ab1f0f4.png?resize=1204%3A890&crop=1200%3A464%3B0%2C143	1	99	0	0	0	the-dry-leaf-cafe-mosman	https://www.zomato.com/sydney/the-dry-leaf-cafe-mosman	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Desserts and Bakes,Brunch	40	(151.2413519248,-33.8240273828999989)
72370	Made in DY	+61	\N	\N	190	1	https://b.zmtcdn.com/data/pictures/2/17746622/f6183891fa71bd777e362b682bbab030.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	made-in-dy-dee-why	https://www.zomato.com/sydney/made-in-dy-dee-why	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Outdoor Seating	50	(151.287292130299988,-33.7533454701000011)
69669	Sea Master Fish and Chips	+61	(02) 9753 0271	\N	397	1	\N	1	99	0	0	0	sea-master-fish-and-chips-bonnyrigg	https://www.zomato.com/sydney/sea-master-fish-and-chips-bonnyrigg	Takeaway Available,Indoor Seating,All Day Breakfast	30	(150.888212621200012,-33.8865753615000003)
73359	A&C Chicken Shop	+61	(02) 9759 0361	\N	416	1	\N	1	99	0	0	0	a-c-chicken-shop-roselands	https://www.zomato.com/sydney/a-c-chicken-shop-roselands	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available	30	(151.067726835600013,-33.9345293237999996)
63978	Baja Cantina	+61	(02) 9571 1199	\N	9	1	https://b.zmtcdn.com/data/reviews_photos/b1c/fea90f81c81bb6f69c081e9fea43cb1c_1554193252.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1605&cropw=1200&croph=464&cropoffsetx=2&cropoffsety=734&cropgravity=NorthWest	1	99	0	0	0	baja-cantina-glebe	https://www.zomato.com/sydney/baja-cantina-glebe	Takeaway Available,Full Bar Available,Indoor Seating,Table booking recommended	60	(151.191565096400012,-33.883303285300002)
73372	Mrs Jones - Orient Hotel	+61	(02) 9251 1255	\N	2259	1	https://b.zmtcdn.com/data/pictures/3/19145973/c3072bea5303c42230063ccf7b9e0603.jpg?resize=1204%3A1204&crop=1200%3A464%3B2%2C530	1	99	0	0	0	mrs-jones-orient-hotel-the-rocks	https://www.zomato.com/sydney/mrs-jones-orient-hotel-the-rocks	Full Bar Available,Table booking recommended,Outdoor Seating,Indoor Seating,Parking available 35 metres away	100	(151.2086175755,-33.8590880813000012)
64009	Harvest Buffet At The Star	+61	1800 700 700	\N	2476	1	https://b.zmtcdn.com/data/res_imagery/16559060_RESTAURANT_f4277f8a2df1816b3d1c8bcc6b6a269f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	harvest-buffet-at-the-star-pyrmont	https://www.zomato.com/sydney/harvest-buffet-at-the-star-pyrmont	Breakfast,Full Bar Available,Indoor Seating,Table booking recommended,Kid Friendly,Buffet	100	(151.195562593599988,-33.8691369427999973)
73419	Montien Thai Kitchen	+61	(02) 9523 5163	\N	491	1	https://b.zmtcdn.com/data/pictures/3/19184433/f5c058f32946ad87835e7127f444f4a0.jpg?resize=1204%3A1204&crop=1200%3A464%3B-1%2C339	1	99	0	0	0	montien-thai-kitchen-2-cronulla	https://www.zomato.com/sydney/montien-thai-kitchen-2-cronulla	Takeaway Available,Full Bar Available,Table Reservation Not Required,Indoor Seating	80	(151.152979507999987,-34.0547319430000002)
69747	Sydney Star Kebab	+61	(02) 9708 5315	\N	420	1	https://b.zmtcdn.com/data/pictures/4/16715884/b275dcefe9e3fce3bbc9b294b1ff982e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	sydney-star-kebab-bankstown	https://www.zomato.com/sydney/sydney-star-kebab-bankstown	Breakfast,Home Delivery,Takeaway Available,Serves Halal,No Alcohol Available,Indoor Seating,Outdoor Seating,Vegetarian Friendly,Kid Friendly	30	(151.032684445400008,-33.9174084305999983)
64120	Gibbons Street Cafe	+61	(02) 8094 1196	\N	32	1	https://b.zmtcdn.com/data/pictures/3/17742983/375dc361a34b587f90680334f5e42a0f.jpg?resize=1204%3A963&crop=1200%3A464%3B0%2C316	1	99	0	0	0	gibbons-street-cafe-redfern	https://www.zomato.com/sydney/gibbons-street-cafe-redfern	Breakfast,No Alcohol Available,Indoor Seating,Desserts and Bakes,Vegetarian Friendly,Brunch,Kid Friendly	40	(151.199437379800003,-33.8930843492999969)
73505	Transform Health Deli	+61	0423 187 128	\N	12	1	https://b.zmtcdn.com/data/pictures/1/19130081/a1deab8b53886314c643ab5faa85cee7.jpg?resize=1204%3A1204&crop=1200%3A464%3B1%2C420	1	99	0	0	0	transform-health-deli-darlinghurst	https://www.zomato.com/sydney/transform-health-deli-darlinghurst	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegan Options,Desserts and Bakes	30	(151.218650042999997,-33.8816304587999966)
64127	Flour Drum Newtown	+61	(02) 9565 2822	\N	85	1	https://b.zmtcdn.com/data/pictures/chains/4/17976554/c8eaca7d2552d4c62a8eeb21c4975fb2.jpg?resize=1204%3A903&crop=1200%3A464%3B2%2C339	1	99	0	0	0	flour-drum-newtown-newtown	https://www.zomato.com/sydney/flour-drum-newtown-newtown	Breakfast,Takeaway Available,Wheelchair Accessible,Wine,Vegetarian Friendly,Outdoor Seating,Gluten Free Options,Vegan Options,Indoor Seating,Brunch,Desserts and Bakes	45	(151.179589033100001,-33.9033713054000003)
60598	Cosmopolitan Espresso & Food Emporium	+61	(02) 8104 1004	\N	371	1	https://b.zmtcdn.com/data/reviews_photos/144/1ce622dd54021b100aea728298b67144_1506608111.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1605&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=501&cropgravity=NorthWest	1	99	0	0	0	cosmopolitan-espresso-food-emporium-liverpool	https://www.zomato.com/sydney/cosmopolitan-espresso-food-emporium-liverpool	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Available for Functions,Brunch,Kid Friendly,Desserts and Bakes,Indoor Seating,Catering Available,Parking available 85 metres away	30	(150.929267853499994,-33.9204173967999978)
69812	Heathcote Fish & Chips	+61	(02) 9548 5031	\N	503	1	https://b.zmtcdn.com/data/res_imagery/15543794_RESTAURANT_2796a1ecbf3fc5d8c15b88968bed59e2.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	heathcote-fish-chips-heathcote	https://www.zomato.com/sydney/heathcote-fish-chips-heathcote	Takeaway Available,No Alcohol Available,Indoor Seating	30	(151.008411124399998,-34.0880283966999968)
64131	Alice's Makan	+61	(02) 8318 2204	\N	2449	1	https://b.zmtcdn.com/data/pictures/chains/6/16557106/a647104dd6877780f1d05c2b52f73c45.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=803&cropw=1200&croph=464&cropoffsetx=-2&cropoffsety=123&cropgravity=NorthWest	1	99	0	0	0	alices-makan-cbd	https://www.zomato.com/sydney/alices-makan-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,Table booking not available,Vegan Options,Vegetarian Friendly,Pram Friendly,Indoor Seating,Desserts and Bakes,Lunch Menu,Kid Friendly,Wifi,Gluten Free Options,Dairy Free,Parking available 99 metres away	25	(151.207300946099991,-33.8748199628999984)
69803	Savvy Coffee	+61	(02) 9446 3238	\N	153	1	https://b.zmtcdn.com/data/res_imagery/15543699_RESTAURANT_0fe73b08024b226a7029d84b1faa060c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	savvy-coffee-asquith	https://www.zomato.com/sydney/savvy-coffee-asquith	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Brunch	35	(151.108600683499986,-33.6878124456000023)
64160	Salmon & Bear	+61	(02) 9662 8188	\N	34	1	https://b.zmtcdn.com/data/pictures/chains/4/17985854/72f15d8f3389b6bd2cfd853a1f1c80fe.jpg?resize=1204%3A803&crop=1200%3A464%3B1%2C255	1	99	0	0	0	salmon-bear-zetland	https://www.zomato.com/sydney/salmon-bear-zetland	Home Delivery,Takeaway Available,Full Bar Available,Table booking recommended,Kid Friendly,Indoor Seating,Parking available 77 metres away	65	(151.212616413799992,-33.9065736029000036)
64155	Red Lantern	+61	(02) 9698 4355	\N	12	1	https://b.zmtcdn.com/data/res_imagery/16565418_RESTAURANT_67145a1bbae15063b5aea153efae07ca.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	red-lantern-darlinghurst	https://www.zomato.com/sydney/red-lantern-darlinghurst	Takeaway Available,Full Bar Available,Outdoor Seating,Vegan Options,Table booking recommended,Indoor Seating,Gluten Free Options,Vegetarian Friendly,Set Menu,Parking available 36 metres away	150	(151.215428039399995,-33.8747523199999989)
55568	Barbeque Hot	+61	(02) 9874 9159	\N	253	1	https://b.zmtcdn.com/data/reviews_photos/e91/b5ad5cb2056c30c8e7596c59df2a1e91_1480329258.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C171	1	99	0	0	0	barbeque-hot-eastwood	https://www.zomato.com/sydney/barbeque-hot-eastwood	Wine and Beer,Indoor Seating,Vegetarian Friendly	65	(151.077847480799988,-33.7922318943999969)
73532	KB Chickens	+61	(02) 9639 3990	\N	319	1	\N	1	99	0	0	0	kb-chickens-baulkham-hills	https://www.zomato.com/sydney/kb-chickens-baulkham-hills	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Indoor Seating	40	(150.990980789100007,-33.759474369800003)
69848	The Rail Cafe	+61	(02) 4505 1587	\N	2106	1	\N	1	99	0	0	0	the-rail-cafe-richmond	https://www.zomato.com/sydney/the-rail-cafe-richmond	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly	50	(150.753034000000014,-33.5982309999999984)
64177	The Mews	+61	(02) 8318 0472	\N	173	1	https://b.zmtcdn.com/data/pictures/3/16568703/4eaed75c6d543cd311b165fb04a14dea.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=748&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=72&cropgravity=NorthWest	1	99	0	0	0	the-mews-mosman	https://www.zomato.com/sydney/the-mews-mosman	Breakfast,Takeaway Available,No Alcohol Available,Kid Friendly,Vegetarian Friendly,Outdoor Seating,Vegan Options,Gluten Free Options,Brunch,Pet Friendly,Indoor Seating,Desserts and Bakes	45	(151.240836940700007,-33.825049028499997)
73543	Chunoma109 Cafe	+61	(02) 8541 2302	\N	9	1	\N	1	99	0	0	0	chunoma109-cafe-glebe	https://www.zomato.com/sydney/chunoma109-cafe-glebe	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Desserts and Bakes,Brunch,Wifi,Vegan Options,Gluten Free Options	40	(151.190012767899987,-33.8821787931999978)
64209	Frango's	+61	(02) 9560 2369	\N	101	1	https://b.zmtcdn.com/data/reviews_photos/e2f/dc0b185562faa641721ea7e48c030e2f_1489672536.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=903&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=149&cropgravity=NorthWest	1	99	0	0	0	frangos-petersham	https://www.zomato.com/sydney/frangos-petersham	Takeaway Available,No Alcohol Available,Indoor Seating	40	(151.153485999999987,-33.8965310000000031)
67276	Pho Saigon	+61	0422 435 746	\N	451	1	https://b.zmtcdn.com/data/res_imagery/16561381_CHAIN_ddb6b679881fe4f176349d0b38d77a79_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	pho-saigon-rockdale	https://www.zomato.com/sydney/pho-saigon-rockdale	Home Delivery,Takeaway Available,Wheelchair Accessible,BYO,Corkage Fee Charged,Table Reservation Not Required,Kid Friendly,Indoor Seating,BYO Cake,Vegetarian Friendly,Pram Friendly	45	(151.137679181999999,-33.9534992768000023)
69860	Khamin Thai	+61	(02) 4588 5521	\N	2106	1	https://b.zmtcdn.com/data/reviews_photos/c5a/29b756bf9a16f1b894620f346ee7dc5a_1503631236.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	khamin-thai-richmond	https://www.zomato.com/sydney/khamin-thai-richmond	Takeaway Available,BYO,Indoor Seating,Table Reservation Not Required,Pet Friendly	70	(150.752884999999992,-33.5982150000000033)
64210	The Font Cafe	+61	0450 515 993	\N	21	1	https://b.zmtcdn.com/data/pictures/chains/6/17745706/b234e7bcbb082541052138717577d245.jpeg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=803&cropw=1200&croph=464&cropoffsetx=-1&cropoffsety=192&cropgravity=NorthWest	1	99	0	0	0	the-font-cafe-chippendale	https://www.zomato.com/sydney/the-font-cafe-chippendale	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Kid Friendly,All Day Breakfast,Desserts and Bakes,Vegan Options,Gluten Free Options,Pram Friendly,Pet Friendly,Vegetarian Friendly,Brunch,Outdoor Seating,Split Bills,Wifi	50	(151.199346855300007,-33.8859825226999973)
63432	Sharetea	+61	\N	\N	10	1	https://b.zmtcdn.com/data/pictures/chains/5/16542035/5245f354c46c8b40519c68390f54d1b3.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C359	1	99	0	0	0	sharetea-burwood	https://www.zomato.com/sydney/sharetea-burwood	Home Delivery,Takeaway Available,Indoor Seating	15	(151.103901788600012,-33.879422611599999)
67287	The Penny Royal	+61	0416 452 644	\N	173	1	https://b.zmtcdn.com/data/res_imagery/16568657_RESTAURANT_4a484b3602c4ff4bf1186d3ed67a0198_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-penny-royal-mosman	https://www.zomato.com/sydney/the-penny-royal-mosman	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Outdoor Seating,Brunch,Desserts and Bakes,Kid Friendly,Vegan Options,Gluten Free Options	35	(151.240823864899994,-33.8248392969000022)
64250	Napoli in Bocca	+61	(02) 9798 4096	\N	90	1	https://b.zmtcdn.com/data/res_imagery/16558560_RESTAURANT_e42a83cb449716fda6e5f99a18908255.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	napoli-in-bocca-haberfield	https://www.zomato.com/sydney/napoli-in-bocca-haberfield	Takeaway Available,Wheelchair Accessible,Wine and Beer,Vegetarian Friendly,Outdoor Seating,Vegan Options,Gluten Free Options,Indoor Seating	75	(151.138912327599996,-33.8812215716000011)
72567	Big Bun	+61	\N	\N	463	1	https://b.zmtcdn.com/data/pictures/8/19090618/a5b8a2971e6a0a3d8a5ab0fd5234cf4e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	big-bun-hurstville	https://www.zomato.com/sydney/big-bun-hurstville	Breakfast,Takeaway Available,Table booking not available,No Alcohol Available,Indoor Seating	20	(151.103088408699989,-33.9659896065000027)
64263	Public Dining Room	+61	(02) 9968 4880	\N	173	1	https://b.zmtcdn.com/data/res_imagery/16561876_RESTAURANT_5da9351064c80c6dd958827bceed0d21_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	croissant-dining-room-mosman	https://www.zomato.com/sydney/croissant-dining-room-mosman	Wheelchair Accessible,Full Bar Available,Vegetarian Friendly,Kid Friendly,Vegan Options,Table Reservation Not Required,Indoor Seating,Gluten Free Options,Outdoor Seating,Wifi,Waterfront,Available for Functions	120	(151.252491474200013,-33.8276117233999969)
64288	Thai La-Ong	+61	(02) 9550 5866	\N	85	1	https://b.zmtcdn.com/data/pictures/5/18903215/89e82d06f53c7a8c7cfda9b71f605f91.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=802&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=129&cropgravity=NorthWest	1	99	0	0	0	thai-la-ong-newtown	https://www.zomato.com/sydney/thai-la-ong-newtown	Home Delivery,Takeaway Available,BYO,No Alcohol Available,Indoor Seating,Wifi,Table Reservation Not Required,Vegetarian Friendly,Vegan Options	40	(151.185178086200011,-33.8927879530999974)
73675	Cafe Presto	+61	0414 740 044	\N	194	1	https://b.zmtcdn.com/data/pictures/3/16715673/1ce6040d029893a88f1ced64d81a2011.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cafe-presto-brookvale	https://www.zomato.com/sydney/cafe-presto-brookvale	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Vegetarian Friendly,Indoor Seating	25	(151.271515376899998,-33.7625973282999965)
73701	Versace Lounge	+61	(02) 9555 6293	\N	82	1	\N	1	99	0	0	0	versace-lounge-balmain	https://www.zomato.com/sydney/versace-lounge-balmain	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Outdoor Seating,Kid Friendly,Desserts and Bakes,Brunch,Vegetarian Friendly	50	(151.175917088999995,-33.8561769060000017)
69973	Bento & Studio	+61	\N	\N	79	1	\N	1	99	0	0	0	bento-studio-leichhardt	https://www.zomato.com/sydney/bento-studio-leichhardt	Takeaway Available,No Alcohol Available,Indoor Seating,Outdoor Seating,Table Reservation Not Required,Vegetarian Friendly	40	(151.157398112099997,-33.8875055257)
69920	Burger Doctor	+61	(02) 8678 2566	\N	309	1	https://b.zmtcdn.com/data/pictures/1/17746191/78b893c4288f1eff1bb6b96c478983cf.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	burger-doctor-blacktown	https://www.zomato.com/sydney/burger-doctor-blacktown	Breakfast,Takeaway Available,Indoor Seating,Outdoor Seating,Parking available 52 metres away	40	(150.906305462099994,-33.7703512726000028)
69929	Richard's On The Park	+61	(02) 9724 3360	\N	357	1	https://b.zmtcdn.com/data/res_imagery/15545465_RESTAURANT_28454fcda6f0f1d8b45026ebe3861a65_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	richards-on-the-park-canley-vale	https://www.zomato.com/sydney/richards-on-the-park-canley-vale	Full Bar Available,Live Music,Nightlife,Indoor Seating	50	(150.941726379100004,-33.8867164732999981)
67338	Peanut Butter Jelly	+61	(02) 9977 5511	\N	184	1	\N	1	99	0	0	0	peanut-butter-jelly-manly	https://www.zomato.com/sydney/peanut-butter-jelly-manly	Wheelchair Accessible,Full Bar Available,Shared Plates,Craft Beer,Outdoor Seating,Serves Cocktails,Available for Functions,Feed Me Menu,Gluten Free Options,Desserts and Bakes,Nightlife,Indoor Seating,Table Reservation Not Required,Group Bookings Available,Vegan Options,Group Meal	80	(151.285074949299997,-33.7972571994000006)
64328	Oregano Bakery	+61	(02) 9546 3666	\N	463	1	https://b.zmtcdn.com/data/pictures/chains/5/15543275/eb6b3f93dfae75669d3f8c59e3ddc9d7.jpg?resize=1204%3A802&crop=1200%3A464%3B3%2C15	1	99	0	0	0	oregano-bakery-south-hurstville	https://www.zomato.com/sydney/oregano-bakery-south-hurstville	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Brunch,Desserts and Bakes,Vegetarian Friendly,Kid Friendly,Indoor Seating	30	(151.105193942800014,-33.9774160329000026)
73726	Shanghai Chinese Restaurant	+61	(02) 9625 9174	\N	2153	1	https://b.zmtcdn.com/data/pictures/7/19196197/aca33c0fa55d87bd068e14296e6fa337.jpg?resize=1204%3A1605&crop=1200%3A464%3B-1%2C89	1	99	0	0	0	shanghai-chinese-restaurant-rooty-hill	https://www.zomato.com/sydney/shanghai-chinese-restaurant-rooty-hill	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	\N	(150.844445675600014,-33.7727458787000003)
73748	Lana's Rapid Cafe	+61	(02) 9728 4913	\N	350	1	\N	1	99	0	0	0	lanas-rapid-cafe-fairfield	https://www.zomato.com/sydney/lanas-rapid-cafe-fairfield	No Alcohol Available,Indoor Seating	30	(150.955187045000002,-33.872765044300003)
64367	Lord of the Fries	+61	1300 667 552	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16567259_CHAIN_f3621d68785301e0bf999c8e4ea5a02a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	lord-of-the-fries-sydney	https://www.zomato.com/sydney/lord-of-the-fries-sydney	Takeaway Only,Wheelchair Accessible,Kid Friendly,Parking available 131 metres away	30	(151.206483207600002,-33.876016369200002)
73800	Land Thai Cuisine	+61	(02) 9979 3397	\N	209	1	https://b.zmtcdn.com/data/pictures/3/17747413/10b047c0c5ddeb30fc4454d51b93451b.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=677&cropw=1200&croph=464&cropoffsetx=-2&cropoffsety=94&cropgravity=NorthWest	1	99	0	0	0	land-thai-cuisine-newport	https://www.zomato.com/sydney/land-thai-cuisine-newport	Home Delivery,Takeaway Available,BYO,Indoor Seating,Vegetarian Friendly,Table Reservation Not Required	60	(151.309604086000007,-33.6604569332999972)
55876	Royal Orchard Thai	+61	(02) 9544 5100	\N	491	1	\N	1	99	0	0	0	royal-orchard-thai-cronulla	https://www.zomato.com/sydney/royal-orchard-thai-cronulla	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Table Reservation Not Required,Vegetarian Friendly,Indoor Seating,Kid Friendly	60	(151.153554506599988,-34.0532138765999974)
66172	Indian Chopsticks	+61	(02) 9891 4177	\N	313	1	https://b.zmtcdn.com/data/pictures/0/16565540/4a41491c43bd47b3958e5532b72c33d3.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	indian-chopsticks-harris-park	https://www.zomato.com/sydney/indian-chopsticks-harris-park	No Alcohol Available,Table Reservation Not Required,Indoor Seating	50	(151.009324416499993,-33.8212038674000013)
64378	Bloom	+61	(02) 9960 1761	\N	173	1	https://b.zmtcdn.com/data/reviews_photos/768/1ddd33ae1bae1f3f7b3cc2393b3eb768_1521629139.jpg?resize=1204%3A808&crop=1200%3A464%3B19%2C239	1	99	0	0	0	bloom-mosman	https://www.zomato.com/sydney/bloom-mosman	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Brunch,Desserts and Bakes,Vegan Options,Gluten Free Options,All Day Breakfast	45	(151.244214177099991,-33.8314883461999969)
73892	iBar	+61	(02) 9217 6666	\N	2449	1	https://b.zmtcdn.com/data/pictures/1/15544011/63d4b86acd110ad04266489997d0d22e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	ibar-cbd	https://www.zomato.com/sydney/ibar-cbd	Wheelchair Accessible,Full Bar Available,Indoor Seating,Parking available 269 metres away	50	(151.208028495299999,-33.8779484549000003)
73860	Norths Cafe	+61	(02) 9245 3000	\N	111	1	https://b.zmtcdn.com/data/res_imagery/16561688_RESTAURANT_25cea36e2e446142978003132cb981f8.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	norths-cafe-cammeray	https://www.zomato.com/sydney/norths-cafe-cammeray	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Vegetarian Friendly,Wifi,Indoor Seating,Gluten Free Options	20	(151.2090792507,-33.8214929916000031)
73905	The Green Chocolate Lounge	+61	(02) 4706 0877	\N	2098	1	https://b.zmtcdn.com/data/pictures/7/17743237/2d9272109dd7f150d0152c0f2db5de0b.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-green-chocolate-lounge-jordan-springs	https://www.zomato.com/sydney/the-green-chocolate-lounge-jordan-springs	Breakfast,No Alcohol Available,Outdoor Seating,Desserts and Bakes,Free Parking,Indoor Seating	25	(150.72556950149999,-33.727361563499997)
64429	Machiavelli	+61	(02) 8310 4393	\N	2449	1	https://b.zmtcdn.com/data/pictures/3/16558393/9bd11b07b9f0d604c1bebac601bbcb06.jpg?resize=1204%3A677&crop=1200%3A464%3B1%2C208	1	99	0	0	0	machiavelli-cbd	https://www.zomato.com/sydney/machiavelli-cbd	Full Bar Available,Gluten Free Options,Indoor Seating,Vegetarian Friendly,Available for Functions,Parking available 190 metres away	140	(151.204900704300002,-33.8672742552000017)
64435	Medan Ciak	+61	0403 363 326	\N	13	1	https://b.zmtcdn.com/data/pictures/7/18398457/5edd485c7d68fa744198ac001decf92b.jpg?resize=1204%3A801&crop=1200%3A464%3B-1%2C176	1	99	0	0	0	medan-ciak-surry-hills	https://www.zomato.com/sydney/medan-ciak-surry-hills	Takeaway Available,No Alcohol Available,BYO Cake,Free Parking,Pram Friendly,Indoor Seating,Set Menu,Vegetarian Friendly,Table Reservation Not Required,Kid Friendly	35	(151.208361089199997,-33.8877546253999995)
74007	The Little Corner Shop	+61	(02) 9525 8545	\N	482	1	\N	1	99	0	0	0	the-little-corner-shop-miranda	https://www.zomato.com/sydney/the-little-corner-shop-miranda	Breakfast,Takeaway Available,No Alcohol Available,Wifi,Brunch,Gluten Free Options,Outdoor Seating,Vegetarian Friendly,Kid Friendly	30	(151.111799217800012,-34.0274148142000001)
74064	Westside Bakery	+61	(02) 4625 0534	\N	1681	1	https://b.zmtcdn.com/data/pictures/6/15543596/b605d09f0411c64acfa01c5948b5c7da.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	westside-bakery-campbelltown	https://www.zomato.com/sydney/westside-bakery-campbelltown	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Desserts and Bakes	20	(150.813806131500002,-34.0670640794999997)
74050	Ronnie's Pizzeria	+61	(02) 9623 3345	\N	2135	1	\N	1	99	0	0	0	ronnies-pizzeria-st-marys	https://www.zomato.com/sydney/ronnies-pizzeria-st-marys	Home Delivery,Takeaway Available,Outdoor Seating,Indoor Seating	30	(150.77555313709999,-33.7782182166999974)
69994	Valentine Cafe	+61	(02) 9836 3104	\N	2156	1	https://b.zmtcdn.com/data/res_imagery/16569362_RESTAURANT_51d5f8999ee60db83360452da9f7a741.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	valentine-cafe-glenwood	https://www.zomato.com/sydney/valentine-cafe-glenwood	Breakfast,Takeaway Available,No Alcohol Available,Gluten Free Options,Brunch,Outdoor Seating,Kid Friendly,Indoor Seating	50	(150.944778397699992,-33.7399733757000035)
67394	Eastern Bay Thai Restaurant	+61	(02) 9337 5221	\N	56	1	https://b.zmtcdn.com/data/res_imagery/16565282_RESTAURANT_46b9aed619ab9733b671cda16ad1027a.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	eastern-bay-thai-restaurant-watsons-bay	https://www.zomato.com/sydney/eastern-bay-thai-restaurant-watsons-bay	Home Delivery,Takeaway Available,BYO,Vegetarian Friendly,Outdoor Seating,Indoor Seating,Table Reservation Not Required,Gluten Free Options,Kid Friendly	50	(151.284447312400005,-33.8449257955999983)
64486	The Bulgogi	+61	(02) 9747 8292	\N	266	1	https://b.zmtcdn.com/data/reviews_photos/453/55c3b4f74d33a958328ee1ee61d60453_1548567439.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=800&cropw=1200&croph=464&cropoffsetx=-2&cropoffsety=157&cropgravity=NorthWest	1	99	0	0	0	the-bulgogi-strathfield	https://www.zomato.com/sydney/the-bulgogi-strathfield	Takeaway Available,Wine and Beer,Kid Friendly,Outdoor Seating	70	(151.094708181899989,-33.8739926566999969)
70002	Degani Cafe	+61	(02) 4647 7207	\N	1706	1	https://b.zmtcdn.com/data/pictures/7/17744537/714b756075ffdf0fb8a179a263358cca.jpg?resize=1204%3A896&crop=1200%3A464%3B13%2C153	1	99	0	0	0	degani-cafe-narellan	https://www.zomato.com/sydney/degani-cafe-narellan	Breakfast,Indoor Seating,Available for Functions,Kid Friendly,Gluten Free Options,Catering Available	35	(150.736756000000014,-34.0393830000000008)
66208	Ladda's The Thai Takeaway	+61	(02) 9516 2870	\N	85	1	https://b.zmtcdn.com/data/pictures/0/16558280/efebfad189194e532cef08737fe579da.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	laddas-the-thai-takeaway-newtown	https://www.zomato.com/sydney/laddas-the-thai-takeaway-newtown	Home Delivery,Takeaway Available,No Alcohol Available,Vegetarian Friendly,Gluten Free Options,Indoor Seating,Table Reservation Not Required	50	(151.18081748489999,-33.9057026389000029)
74160	The Oat Mill - Oatley RSL	+61	(02) 9580 2002	\N	17	1	https://b.zmtcdn.com/data/reviews_photos/fbe/d57ba1e14f853f43f7338d3b9ea8efbe_1501420905.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-oat-mill-oatley-rsl-oatley	https://www.zomato.com/sydney/the-oat-mill-oatley-rsl-oatley	Takeaway Available,Full Bar Available,Kid Friendly,Vegetarian Friendly,Indoor Seating,Sports Bar	50	(151.081305853999993,-33.9818057413000005)
64495	Burger Point	+61	(02) 8809 5427	\N	2824	1	https://b.zmtcdn.com/data/pictures/4/18459424/a23c48d008685fcca53964742f42ed84.jpg?resize=1204%3A1204&crop=1200%3A464%3B-1%2C381	1	99	0	0	0	burger-point-marsden-park	https://www.zomato.com/sydney/burger-point-marsden-park	Takeaway Available,No Alcohol Available,Outdoor Seating,Table Reservation Not Required,Indoor Seating	50	(150.840808264900005,-33.719604568100003)
70018	Aunty Jack’s	+61	(02) 4760 8837	\N	2191	1	https://b.zmtcdn.com/data/pictures/2/17744842/407200cfa47487b686d26b1cc6e6340d.jpg?resize=1204%3A868&crop=1200%3A464%3B2%2C145	1	99	0	0	0	aunty-jack-s-katoomba	https://www.zomato.com/sydney/aunty-jack-s-katoomba	Full Bar Available,Indoor Seating,Serves Cocktails	70	(150.311797000000013,-33.7147280000000009)
73488	Add Me Thai	+61	\N	\N	2449	1	\N	1	99	0	0	0	add-me-thai-cbd	https://www.zomato.com/sydney/add-me-thai-cbd	Takeaway Available,Indoor Seating,Parking available 248 metres away	40	(151.207811236400005,-33.8662149744000018)
64501	The Forresters	+61	(02) 8322 2040	\N	13	1	https://b.zmtcdn.com/data/pictures/chains/8/16560398/a3534c671878db6fde7674d2e3035aa8.jpg?resize=1204%3A803&crop=1200%3A464%3B-1%2C151	1	99	0	0	0	the-forresters-surry-hills	https://www.zomato.com/sydney/the-forresters-surry-hills	Full Bar Available,Vegetarian Friendly,Indoor Seating,Outdoor Seating,Table Reservation Not Required	70	(151.212886646399994,-33.8847940493999999)
8	Maximus Cafe	+61	(02) 9627 7282	4	1	1	https://imgur.com/B3NiiYR.jpg	8	99	0	0	0	\N	\N	\N	\N	(151.206751999999994,-33.8806530000000024)
23	Anastasia Café and Eatery	+61	(02) 9627 7282	4	1	1	https://imgur.com/7xdUPm4.jpg	13	99	0	1	0	\N	\N	\N	\N	(151.15152599999999,-33.8153160000000028)
25	Bills	+61	(02) 9627 7282	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/c28/5af30180b449cff001d2d41eb5cd2c28_1544341757.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.214503000000008,-33.8827220000000011)
26	Lorraine's Patisserie	+61	(02) 9627 7282	\N	13	1	https://b.zmtcdn.com/data/pictures/5/16566535/6f55afcd0e5c7b30645c4edae6303efc.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.207657000000012,-33.8663219999999967)
27	Flour & Stone	+61	(02) 9627 7282	\N	12	1	https://b.zmtcdn.com/data/pictures/6/16564656/4ded590717ab792f34cff33c9fde11e3.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.215420999999992,-33.8741219999999998)
29	Aqua S	+61	(02) 9627 7282	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/dd9/6e036069be9cb6f5f230c17f0cfcadd9_1552339233.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.206509000000011,-33.8746709999999993)
30	Mecca Coffee Specialists	+61	(02) 9627 7282	\N	9	1	https://b.zmtcdn.com/data/reviews_photos/885/9275c0ec1e2ef00f4b0cd92852abc885_1477301450.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.267565999999988,-33.7828960000000009)
31	Bubble Nini	+61	(02) 9627 7282	4	1	1	https://b.zmtcdn.com/data/pictures/3/17745593/2a0d941a5c71cc9e6b1a67b336dfe2a6.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.170197000000002,-33.8143499999999975)
3	Workshop Meowpresso	+61	(02) 9627 7282	4	1	1	https://i.imgur.com/sLPotj2.jpg	3	1	1	5	0	\N	\N	\N	\N	(151.209465999999992,-33.8394010000000023)
4	The Walrus Cafe	+61	(02) 9627 7282	\N	3	1	https://imgur.com/rxOxA57.jpg	4	1	1	4	0	\N	\N	\N	\N	(151.208361999999994,-33.8740009999999998)
5	Frankie's Pizza	+61	(02) 9627 7282	\N	3	1	https://imgur.com/q9978qK.jpg	6	1	1	0	0	\N	\N	\N	\N	(151.209641000000005,-33.8658980000000014)
6	Cié Lest	+61	(02) 9627 7282	\N	4	1	https://imgur.com/euQ3uUf.jpg	5	99	0	0	0	\N	\N	\N	\N	(151.213120000000004,-33.8779299999999992)
7	Pablo & Rusty's Sydney CBD	+61	(02) 9627 7282	\N	4	1	https://imgur.com/H7hHQe6.jpg	7	99	0	0	0	\N	\N	\N	\N	(151.209060999999991,-33.8723110000000034)
9	8bit	+61	(02) 9627 7282	6	5	1	https://imgur.com/bmvua2K.jpg	9	99	0	0	0	\N	\N	\N	\N	(151.205338000000012,-33.872760999999997)
10	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	7	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.185439000000002,-33.7955789999999965)
11	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	9	9	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.204746,-33.8810929999999999)
12	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	10	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.205637999999993,-33.8738310000000027)
13	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	11	2	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.205459999999988,-33.8775789999999972)
14	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	\N	7	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.195296000000013,-33.8843740000000011)
15	CoCo Fresh Tea & Juice	+61	(02) 9627 7282	\N	8	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(151.185958999999997,-33.7944790000000026)
32	The Moment	+61	(02) 9627 7282	14	11	1	http://b.zmtcdn.com/data/reviews_photos/45e/9909395d1ccafe5e637890950810645e_1521863198.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.182298000000003,-33.7961370000000016)
33	Mr. Tea	+61	(02) 9627 7282	\N	12	1	https://b.zmtcdn.com/data/pictures/4/15547454/1a52ca1626e3070bfebb32d9ca568e2d.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.203293000000002,-33.8782690000000031)
70029	Cafe Bikini	+61	(02) 9130 3842	\N	2451	1	https://b.zmtcdn.com/data/pictures/3/16569753/4dd319576db2ad034c548a92bc4075ee.jpg?resize=1204%3A903&crop=1200%3A464%3B-1%2C2	1	99	0	0	0	cafe-bikini-bondi-beach	https://www.zomato.com/sydney/cafe-bikini-bondi-beach	Home Delivery,Takeaway Available,No Alcohol Available,Outdoor Seating,Gluten Free Options,Indoor Seating,Table Reservation Not Required,Smoking Area,Vegetarian Friendly	75	(151.273088492499994,-33.8903065331999969)
74180	Hangang Korean Restaurant 한강	+61	(02) 8756 5689	\N	2683	1	https://b.zmtcdn.com/data/pictures/0/16715110/559487d612968b5ef4a4757ad68b8f98.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=3&cropoffsety=372&cropgravity=NorthWest	1	99	0	0	0	hangang-korean-restaurant-strathfield	https://www.zomato.com/sydney/hangang-korean-restaurant-strathfield	Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Outdoor Seating,Table booking recommended,Wifi,Vegetarian Friendly	60	(151.092234849899995,-33.8721231156999991)
74182	Dalat Restaurant	+61	(02) 9326 3688	\N	59	1	https://b.zmtcdn.com/data/pictures/3/16562173/13616effc1d87d39b23044f3bad86a38.jpg?resize=1204%3A963&crop=1200%3A464%3B2%2C207	1	99	0	0	0	dalat-restaurant-randwick	https://www.zomato.com/sydney/dalat-restaurant-randwick	Home Delivery,Takeaway Available,Wheelchair Accessible,Wine and Beer,BYO,BYO Cake,Desserts and Bakes,Available for Functions,Vegetarian Friendly,Indoor Seating,Kid Friendly,Vegan Options,Pram Friendly,Dairy Free,Split Bills,Gluten Free Options,Table Reservation Not Required	50	(151.2409398705,-33.9160426059000031)
34	Bean Code	+61	(02) 9627 7282	\N	4	1	https://b.zmtcdn.com/data/pictures/6/17742416/677976c7ecb967c9632e5e9005912994_featured_v2.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.183624000000009,-33.7969280000000012)
36	Koomi	+61	(02) 9627 7282	\N	7	1	https://b.zmtcdn.com/data/pictures/chains/6/17747176/a5738e150615432b80bcfbdb9e83f0f5.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.204940999999991,-33.8780819999999991)
37	Chapayum	+61	(02) 9627 7282	\N	13	1	https://b.zmtcdn.com/data/pictures/7/19018017/7c2119e91ec0f4e8c8bbb7302fa23e27.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.207335999999998,-33.8736839999999972)
38	Choux Love	+61	(02) 9627 7282	\N	1	1	https://b.zmtcdn.com/data/reviews_photos/372/13299ecd4b16d6b896a09836b1628372_1522897753.jpg	1	99	0	0	0	\N	\N	\N	\N	(151.204224000000011,-33.8767700000000005)
55552	Origami Cafe	+61	\N	\N	12	1	https://b.zmtcdn.com/data/res_imagery/18411658_RESTAURANT_cad171fba106e8bcf0c12f747fd65bf0.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	origami-cafe-darlinghurst	https://www.zomato.com/sydney/origami-cafe-darlinghurst	Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes	50	(151.217540614299992,-33.8826436221999998)
64530	The Clock	+61	(02) 9331 5333	\N	2481	1	https://b.zmtcdn.com/data/res_imagery/16559466_RESTAURANT_f7e907e910c6b88939a23f17ba1ec1bc_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-clock-surry-hills	https://www.zomato.com/sydney/the-clock-surry-hills	Wheelchair Accessible,Full Bar Available,Outdoor Seating,Gluten Free Options,Nightlife,Pet Friendly,Vegan Options,Sports Bar,Smoking Area,Vegetarian Friendly,Live Sports Screening,Indoor Seating	90	(151.213946454199998,-33.8863874904999989)
64184	Lil Miss Collins	+61	\N	\N	255	1	https://b.zmtcdn.com/data/pictures/chains/7/17742687/05f8141f41b5d8cb94b9ceb6a83736eb.jpg?resize=1204%3A804&crop=1200%3A464%3B0%2C100	1	99	0	0	0	lil-miss-collins-parramatta	https://www.zomato.com/sydney/lil-miss-collins-parramatta	Breakfast,Takeaway Available,Wheelchair Accessible,Wine and Beer,Kid Friendly,Pet Friendly,Smoking Area,Gluten Free Options,Vegetarian Friendly,All Day Breakfast,Brunch,Desserts and Bakes,Outdoor Seating,Available for Functions,Dairy Free,Vegan Options,Garden,Indoor Seating,Parking available 39 metres away	60	(151.005186773800006,-33.8190111707000014)
64522	Café Giulia	+61	(02) 9698 4424	\N	21	1	https://b.zmtcdn.com/data/res_imagery/16557454_RESTAURANT_68e1d39b47cf638b554bfcde3f9cc075_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	café-giulia-chippendale	https://www.zomato.com/sydney/café-giulia-chippendale	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Wifi,Kid Friendly,Gluten Free Options,Pet Friendly,Vegan Options,Vegetarian Friendly,Brunch,Desserts and Bakes	20	(151.199174188099988,-33.8874250900000007)
64518	Zilver Bondi	+61	(02) 8866 2999	\N	44	1	https://b.zmtcdn.com/data/res_imagery/18218109_RESTAURANT_6a66ebddb3505319cf0afbc37bb95922.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	zilver-bondi-bondi-junction	https://www.zomato.com/sydney/zilver-bondi-bondi-junction	Takeaway Available,Wheelchair Accessible,Full Bar Available,Available for Functions,Pram Friendly,BYO Cake,Dairy Free,Vegan Options,Indoor Seating,Kid Friendly,Vegetarian Friendly,Free Parking,Corkage Fee Charged,Set Menu,Split Bills,Parking available 139 metres away	100	(151.251597292700012,-33.8915119067000035)
73731	Fish and Chips	+61	\N	\N	2449	1	https://b.zmtcdn.com/data/pictures/7/17747157/184ae902adf7b49e8d0b4a05a680bd0a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	fish-and-chips-circular-quay	https://www.zomato.com/sydney/fish-and-chips-circular-quay	Breakfast,Takeaway Only,Seating Not Available,Kid Friendly	40	(151.211927756699993,-33.8612616532000033)
73901	Pure Thai	+61	\N	\N	317	1	https://b.zmtcdn.com/data/pictures/6/17748276/b36a3a6eb2897f10d25718eaf8ee7f11.jpg?resize=1204%3A1605&crop=1200%3A464%3B3%2C516	1	99	0	0	0	pure-thai-northmead	https://www.zomato.com/sydney/pure-thai-northmead	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating,Table booking recommended	40	(150.994677543600005,-33.7940480150000013)
64554	Sunny Harbour Seafood	+61	(02) 9585 1633	\N	463	1	https://b.zmtcdn.com/data/res_imagery/16559091_RESTAURANT_1d608c36d39b29afbd7bd2cb76a2dfe6_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sunny-harbour-seafood-hurstville	https://www.zomato.com/sydney/sunny-harbour-seafood-hurstville	Takeaway Available,Wheelchair Accessible,Table Reservation Not Required,Indoor Seating	75	(151.102561019400014,-33.9660477226999973)
70007	Campus Village Cafe	+61	\N	\N	62	1	https://b.zmtcdn.com/data/pictures/7/17747237/33da86c21db9bb98d956505b7eeca5df.jpg?resize=1204%3A1605&crop=1200%3A464%3B0%2C459	1	99	0	0	0	campus-village-cafe-kensington	https://www.zomato.com/sydney/campus-village-cafe-kensington	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Vegan Options,Desserts and Bakes,Gluten Free Options	25	(151.2285007909,-33.9158787276999973)
67496	Biber Diner	+61	(02) 9682 3546	\N	336	1	https://b.zmtcdn.com/data/pictures/9/16562179/a2e028c628770a549b9f251e537dbc72.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	biber-diner-merrylands	https://www.zomato.com/sydney/biber-diner-merrylands	Breakfast,Home Delivery,Takeaway Available,No Alcohol Available,Kid Friendly,Indoor Seating,Table Reservation Not Required	35	(150.991325452900014,-33.8367806453000028)
64596	Emperor's Garden Restaurant	+61	(02) 9211 2135	\N	5	1	https://b.zmtcdn.com/data/res_imagery/16557804_RESTAURANT_680bd280720142df8653a09bb5f86619_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	emperors-garden-restaurant-haymarket	https://www.zomato.com/sydney/emperors-garden-restaurant-haymarket	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Outdoor Seating,Set Menu,Table Reservation Not Required,Indoor Seating,Wifi,Vegetarian Friendly,Parking available 282 metres away	80	(151.204080283600007,-33.8793427250000008)
70549	Uncle Lim	+61	\N	\N	2	1	https://b.zmtcdn.com/data/pictures/8/17746828/7748b19d6b2eb664fe0e6e616285f45c.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C300	1	99	0	0	0	uncle-lim-1-chatswood	https://www.zomato.com/sydney/uncle-lim-1-chatswood	Breakfast,Takeaway Available,No Alcohol Available,Table Reservation Not Required,Indoor Seating,Kid Friendly	30	(151.182596795299986,-33.7979740809999996)
64585	Oliveto Ristorante & Bar	+61	(02) 8765 0006	\N	277	1	https://b.zmtcdn.com/data/res_imagery/16558622_RESTAURANT_5950264e200ed3c1d69f485a243175b3.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	oliveto-ristorante-bar-rhodes	https://www.zomato.com/sydney/oliveto-ristorante-bar-rhodes	Takeaway Available,Wheelchair Accessible,Full Bar Available,BYO,Kid Friendly,Gluten Free Options,Outdoor Seating,Wifi,Waterfront,Table booking recommended,Pet Friendly,Vegetarian Friendly,Indoor Seating	90	(151.089579127700006,-33.8319311707000026)
64598	One Penny Red	+61	(02) 9797 8118	\N	17	1	https://b.zmtcdn.com/data/res_imagery/16568989_RESTAURANT_056bfe44f7c04ca05da018846e6913ff_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	one-penny-red-summer-hill	https://www.zomato.com/sydney/one-penny-red-summer-hill	Wheelchair Accessible,Full Bar Available,Nightlife,Vegetarian Friendly,Kid Friendly,Farm-to-Table,Outdoor Seating,Indoor Seating	140	(151.137627549499996,-33.8922151956999969)
68888	Cafe Azzuri	+61	\N	\N	2931	1	https://b.zmtcdn.com/data/reviews_photos/9a6/b53ba0821bd3ca9d6b2d54f0ab9769a6_1440866652.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cafe-azzuri-darlington	https://www.zomato.com/sydney/cafe-azzuri-darlington	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Vegan Options,Brunch,All Day Breakfast,Vegetarian Friendly,Outdoor Seating,Indoor Seating,Desserts and Bakes	25	(151.191343478899995,-33.8893805744000005)
64607	6 Points Cafe	+61	0450 033 662	\N	350	1	https://b.zmtcdn.com/data/reviews_photos/5ea/dbe355a1ee53ca3f31ae0d4fc8ec25ea_1502103299.jpg?resize=1204%3A1204&crop=1200%3A464%3B1%2C456	1	99	0	0	0	6-points-cafe-fairfield-heights	https://www.zomato.com/sydney/6-points-cafe-fairfield-heights	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Indoor Seating,All Day Breakfast,Brunch,Free Parking,Desserts and Bakes,Gluten Free Options,Outdoor Seating	40	(150.938297174899986,-33.872375879099998)
70812	MAZE Coffee & Food	+61	\N	\N	2778	1	https://b.zmtcdn.com/data/res_imagery/15545649_RESTAURANT_49f6b461abf564716a9f2e64d590fb81.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	maze-coffee-food-kensington	https://www.zomato.com/sydney/maze-coffee-food-kensington	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Gluten Free Options,Desserts and Bakes	35	(151.228063255600006,-33.9156049475000003)
64638	Viet Hoa Oyster Bar & Kitchen	+61	(02) 8318 2271	\N	354	1	https://b.zmtcdn.com/data/pictures/chains/0/18422250/49a2b505eb2fe6cbaee62023905270fa.jpg?resize=1204%3A1208&crop=1200%3A464%3B1%2C450	1	99	0	0	0	viet-hoa-oyster-bar-kitchen-cabramatta	https://www.zomato.com/sydney/viet-hoa-oyster-bar-kitchen-cabramatta	Takeaway Available,Wheelchair Accessible,Free Parking,Outdoor Seating,Kid Friendly,Pet Friendly,Corkage Fee Charged,Indoor Seating,Pram Friendly	85	(150.935877151800014,-33.894485051300002)
64636	Mordeo Bistro & Bar	+61	(02) 9232 1306	\N	2449	1	https://b.zmtcdn.com/data/pictures/chains/2/16568292/c9a60a79b98e68a8dfa6bf7bfe53ecc7.jpg?resize=1239%3A825&crop=1200%3A464%3B14%2C172	1	99	0	0	0	mordeo-bistro-bar-cbd	https://www.zomato.com/sydney/mordeo-bistro-bar-cbd	Breakfast,Takeaway Available,Full Bar Available,Table booking recommended,Indoor Seating,Live Music,Gluten Free Options,Vegetarian Friendly,Outdoor Seating,Parking available 152 metres away	80	(151.211823821100012,-33.8666617948999971)
71037	Organic Bread Bar	+61	\N	\N	41	1	https://b.zmtcdn.com/data/pictures/2/17743362/aa589637678f4a06acad6c988edca420.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	organic-bread-bar-1-paddington	https://www.zomato.com/sydney/organic-bread-bar-1-paddington	Breakfast,No Alcohol Available,Gluten Free Options,Indoor Seating	45	(151.222095340500005,-33.8759531811000016)
67504	Gertrude & Petunias	+61	(02) 9663 0951	\N	62	1	https://b.zmtcdn.com/data/res_imagery/17849000_RESTAURANT_0fb678abd54e74d57ff94c7345af0ad6.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	gertrude-petunias-kensington	https://www.zomato.com/sydney/gertrude-petunias-kensington	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Desserts and Bakes,Indoor Seating	40	(151.217080280200008,-33.9074551319000008)
13121	TenFourteen	+61	\N	\N	61	1	\N	1	99	0	0	0	tenfourteen-kingsford	https://www.zomato.com/sydney/tenfourteen-kingsford	Takeaway Only,Seating Not Available,No Alcohol Available	12	(151.227497309499995,-33.9229708308999989)
13126	Yan Tea	+61	\N	\N	463	1	\N	1	99	0	0	0	yan-tea-hurstville	https://www.zomato.com/sydney/yan-tea-hurstville	Takeaway Available,Indoor Seating	15	(151.100608371199996,-33.9651859869999981)
64689	MCA Cafe & Sculpture Terrace	+61	(02) 9250 8443	\N	2458	1	https://b.zmtcdn.com/data/res_imagery/16565151_RESTAURANT_5fb0f428bb2fa374c0cce2663d4378e7_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	mca-cafe-sculpture-terrace-circular-quay	https://www.zomato.com/sydney/mca-cafe-sculpture-terrace-circular-quay	Breakfast,Wheelchair Accessible,Wine and Beer,Vegetarian Friendly,Gluten Free Options,Brunch,Waterfront,Outdoor Seating,Wifi,Kid Friendly,Indoor Seating,Parking available 176 metres away	90	(151.209116801600004,-33.8600533466999991)
64685	Gigino	+61	(02) 9609 6264	\N	350	1	https://b.zmtcdn.com/data/res_imagery/16565127_CHAIN_c5bb896f3f51ca07f5ce78bc3db1e35a_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	gigino-fairfield-west	https://www.zomato.com/sydney/gigino-fairfield-west	Takeaway Available,Full Bar Available,BYO,Indoor Seating,Table booking recommended,Serves Cocktails	70	(150.953528098800007,-33.8626392131999978)
67537	Bunker 64	+61	0433 530 531	\N	281	1	https://b.zmtcdn.com/data/pictures/6/17746706/899b3019d0fe9a04e91e7e7b42f42a5e.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=4&cropoffsety=628&cropgravity=NorthWest	1	99	0	0	0	bunker-64-lidcombe	https://www.zomato.com/sydney/bunker-64-lidcombe	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes	40	(151.044413074900007,-33.8639886324000017)
53679	Chongqing Street Noodle	+61	0416 835 686	\N	10	1	https://b.zmtcdn.com/data/reviews_photos/c0e/76d7e07a834b47574bf22e8dff370c0e_1540637355.jpg?resize=1204%3A1194&crop=1200%3A464%3B3%2C497	1	99	0	0	0	chongqing-street-noodle-burwood	https://www.zomato.com/sydney/chongqing-street-noodle-burwood	Takeaway Available,Wheelchair Accessible,BYO,Free Parking,Indoor Seating,Table Reservation Not Required,Pram Friendly,Vegetarian Friendly,BYO Cake,Kid Friendly,Desserts and Bakes	35	(151.10223747789999,-33.8786501856000015)
67554	The Lucky Cat Dumpling Bar	+61	0459 934 361	\N	63	1	https://b.zmtcdn.com/data/pictures/2/17746602/4c3463389ad97f4512dc698e26afdf66.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=-1&cropoffsety=286&cropgravity=NorthWest	1	99	0	0	0	the-lucky-cat-dumpling-bar-coogee	https://www.zomato.com/sydney/the-lucky-cat-dumpling-bar-coogee	Full Bar Available,Indoor Seating,Table Reservation Not Required	55	(151.256032660599999,-33.9206366311999972)
71442	Alfredo’s Deli	+61	\N	\N	102	1	\N	1	99	0	0	0	alfredos-deli-camperdown	https://www.zomato.com/sydney/alfredos-deli-camperdown	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Indoor Seating,Kid Friendly,Parking available 234 metres away	20	(151.183191575100011,-33.8898534352999974)
71405	G'day Fresh	+61	\N	\N	117	1	https://b.zmtcdn.com/data/pictures/0/15548750/a5aa75a88cd8ca4b7952354b4275ae17.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	gday-fresh-st-leonards	https://www.zomato.com/sydney/gday-fresh-st-leonards	Takeaway Available,No Alcohol Available,Outdoor Seating,Vegan Options,Gluten Free Options,Parking available 186 metres away	30	(151.194326765800014,-33.8225603473999996)
71588	Hikari	+61	\N	\N	2	1	https://b.zmtcdn.com/data/pictures/1/16716311/c390c391f8c13ebb02f00ef3b42f9562.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	hikari-chatswood	https://www.zomato.com/sydney/hikari-chatswood	Breakfast,Takeaway Available,Wheelchair Accessible,Indoor Seating,Vegetarian Friendly,Gluten Free Options,Kid Friendly	25	(151.182756386699992,-33.7962463666999966)
67567	K & J Takeaway Food	+61	(02) 9804 7172	\N	253	1	https://b.zmtcdn.com/data/reviews_photos/b9f/37ab5f5fd6d08068260a27b5a22c1b9f_1485864366.jpg?resize=1203%3A677&crop=1200%3A464%3B0%2C91	1	99	0	0	0	k-j-takeaway-food-eastwood	https://www.zomato.com/sydney/k-j-takeaway-food-eastwood	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating	30	(151.080315448300013,-33.7909301039000027)
71647	Hong Minh Minh Roll	+61	\N	\N	354	1	https://b.zmtcdn.com/data/reviews_photos/41c/e8228b1e39956d7f087b5c1c9d21c41c_1483117896.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	hong-minh-minh-roll-cabramatta	https://www.zomato.com/sydney/hong-minh-minh-roll-cabramatta	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available,Kid Friendly	15	(150.936792120299998,-33.8955022365000005)
64759	Rose of Australia	+61	(02) 9565 1441	\N	86	1	https://b.zmtcdn.com/data/res_imagery/16558880_RESTAURANT_b3f5eefa67950c3f720b4220ee2371a3_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	rose-of-australia-erskineville	https://www.zomato.com/sydney/rose-of-australia-erskineville	Full Bar Available,Live Sports Screening,Kid Friendly,Gluten Free Options,Indoor Seating,Nightlife,Outdoor Seating,Vegetarian Friendly,Table booking recommended	80	(151.184978261600008,-33.8999651844999974)
64750	Baby Coffee Co	+61	0468 462 229	\N	33	1	https://b.zmtcdn.com/data/reviews_photos/a12/828945a4fbdec55744d4def18f001a12_1509053726.jpg?resize=1204%3A803&crop=1200%3A464%3B-10%2C130	1	99	0	0	0	baby-coffee-co-waterloo	https://www.zomato.com/sydney/baby-coffee-co-waterloo	Breakfast,Takeaway Available,Wine,Gluten Free Options,Kid Friendly,Outdoor Seating,Vegan Options,Brunch,Desserts and Bakes,Indoor Seating	50	(151.206585131600008,-33.9007296256000004)
69096	The Local Bar	+61	\N	\N	78	1	\N	1	99	0	0	0	the-local-bar-rozelle	https://www.zomato.com/sydney/the-local-bar-rozelle	Breakfast,Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegetarian Friendly,Outdoor Seating,Kid Friendly,Gluten Free Options,Brunch	30	(151.168668083900002,-33.8650407025000035)
67624	Quoi Dining	+61	03 9899 3554	\N	2977	1	https://b.zmtcdn.com/data/reviews_photos/8f3/1ac6287aa4787bfc0beb1054162ff8f3_1521696181.jpg?resize=1204%3A1204&crop=1200%3A464%3B2%2C143	1	99	0	0	0	quoi-dining-baulkham-hills	https://www.zomato.com/sydney/quoi-dining-baulkham-hills	Full Bar Available,Waterfront,Indoor Seating,Table booking recommended	130	(150.964565053600012,-33.7319699191000026)
71746	The Village Kitchen	+61	(02) 4573 0988	\N	2126	1	\N	1	99	0	0	0	the-village-kitchen-windsor	https://www.zomato.com/sydney/the-village-kitchen-windsor	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Indoor Seating,Kid Friendly	40	(150.66676799999999,-33.553955000000002)
69034	Eddy Avenue Food And Coffee Express	+61	(02) 9211 4121	\N	5	1	\N	1	99	0	0	0	eddy-avenue-food-and-coffee-express-haymarket	https://www.zomato.com/sydney/eddy-avenue-food-and-coffee-express-haymarket	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating	30	(151.2075249106,-33.8829038695999998)
69092	The Chef’s Wife Bistro - Royal Sheaf Hotel	+61	(02) 9744 2891	\N	10	1	\N	1	99	0	0	0	the-chefs-wife-bistro-royal-sheaf-hotel-burwood	https://www.zomato.com/sydney/the-chefs-wife-bistro-royal-sheaf-hotel-burwood	Wine,Table booking not available,Indoor Seating,Kid Friendly	40	(151.10233638439999,-33.8879001883000015)
71916	Lisa's Patisserie Cafe	+61	\N	\N	141	1	\N	1	99	0	0	0	lisas-patisserie-cafe-pymble	https://www.zomato.com/sydney/lisas-patisserie-cafe-pymble	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Desserts and Bakes	15	(151.142853163199987,-33.7446984242999974)
56779	Twinkle Village	+61	(02) 9859 9888	\N	253	1	\N	1	99	0	0	0	twinkle-village-eastwood	https://www.zomato.com/sydney/twinkle-village-eastwood	Indoor Seating,Table Reservation Not Required	\N	(151.078949533399992,-33.7902449283999999)
67689	Mr. Pretzels	+61	0410 765 903	\N	255	1	https://b.zmtcdn.com/data/res_imagery/18315676_RESTAURANT_815c830af87ed478773f15c314b40604.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	mr-pretzels-parramatta	https://www.zomato.com/sydney/mr-pretzels-parramatta	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available,All Day Breakfast,Desserts and Bakes,Parking available 167 metres away	15	(151.002378836300011,-33.8178588126000008)
53829	Chicken Zone	+61	(02) 7901 7955	\N	281	1	https://b.zmtcdn.com/data/reviews_photos/d89/a93cb2e5d9c381079458bbcf44affd89_1462347019.jpg?resize=1204%3A677&crop=1200%3A464%3B0%2C36	1	99	0	0	0	chicken-zone-lidcombe	https://www.zomato.com/sydney/chicken-zone-lidcombe	Takeaway Available,Wheelchair Accessible,Wine and Beer,Vegetarian Friendly,Indoor Seating,Table Reservation Not Required	75	(151.045263670400004,-33.860956794099998)
56813	Seabay Kitchen	+61	0403 094 365	\N	65	1	https://b.zmtcdn.com/data/pictures/1/17746901/ac094c80199d5538ea6f6e2dde952e2b.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	seabay-kitchen-maroubra	https://www.zomato.com/sydney/seabay-kitchen-maroubra	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	65	(151.237928084999993,-33.9415892780000021)
72060	Chick a bouli	+61	0431 686 935	\N	295	1	\N	1	99	0	0	0	chick-a-bouli-greystanes	https://www.zomato.com/sydney/chick-a-bouli-greystanes	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Outdoor Seating	25	(150.952626876500005,-33.8299014002000007)
63256	Marilynas Famous Pizza	+61	(02) 9953 0844	\N	175	1	\N	1	99	0	0	0	marilynas-famous-pizza-cremorne	https://www.zomato.com/sydney/marilynas-famous-pizza-cremorne	Home Delivery,Takeaway Available,Seating Not Available,Table booking not available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Gluten Free Options,Vegan Options	40	(151.230151019999994,-33.8283481253000033)
67729	Zensation Teahouse	+61	(02) 9319 2788	\N	33	1	https://b.zmtcdn.com/data/reviews_photos/fbc/aaeb799b9295f571f7279ab2f4b69fbc.jpg?resize=1204%3A1169&crop=1200%3A464%3B-10%2C370	1	99	0	0	0	zensation-teahouse-waterloo	https://www.zomato.com/sydney/zensation-teahouse-waterloo	Home Delivery,No Alcohol Available,Outdoor Seating,Indoor Seating,Table booking recommended,Smoking Area,Desserts and Bakes,Parking available 252 metres away	60	(151.212283819899994,-33.8990496270999984)
53862	Ken's Bento Box	+61	(02) 9511 2700	\N	2884	1	https://b.zmtcdn.com/data/reviews_photos/e4c/54dfd3d27fe7811e0eebe307e8a6ce4c_1502620796.jpg?resize=1204%3A803&crop=1200%3A464%3B-1%2C110	1	99	0	0	0	kens-bento-box-hurstville	https://www.zomato.com/sydney/kens-bento-box-hurstville	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Wifi,Vegetarian Friendly,Indoor Seating	30	(151.103980243199999,-33.9667025692999971)
72197	Darya Food Bar	+61	(02) 9661 4164	\N	73	1	\N	1	99	0	0	0	bunnerong-gourmet-chickens-matraville	https://www.zomato.com/sydney/bunnerong-gourmet-chickens-matraville	Breakfast,Takeaway Available,No Alcohol Available,Vegetarian Friendly,Brunch,Indoor Seating,Kid Friendly	35	(151.230990216099997,-33.9578181932999996)
67728	Marlies Eatery	+61	0413 887 663	\N	108	1	https://b.zmtcdn.com/data/pictures/0/17744740/bd35f82e20d45b8cfccabf99ecf3917f.jpg?resize=1204%3A677&crop=1200%3A464%3B-4%2C226	1	99	0	0	0	marlies-eatery-north-sydney	https://www.zomato.com/sydney/marlies-eatery-north-sydney	Takeaway Available,Full Bar Available,Table booking not available,Indoor Seating,Vegan Options,Outdoor Seating,Catering Available,Parking available 41 metres away	30	(151.208049617699999,-33.8394254188999994)
72222	Chicken Empire	+61	(02) 4647 1474	\N	1705	1	\N	1	99	0	0	0	chicken-empire-mount-annan	https://www.zomato.com/sydney/chicken-empire-mount-annan	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Vegetarian Friendly	45	(150.75876199999999,-34.0481789999999975)
73445	Amigo French Hot Bread	+61	(02) 4655 3326	\N	1710	1	\N	1	99	0	0	0	amigo-french-hot-bread-camden	https://www.zomato.com/sydney/amigo-french-hot-bread-camden	Breakfast,Takeaway Available,Wheelchair Accessible,Vegetarian Friendly,Desserts and Bakes,Outdoor Seating	20	(150.694580555599998,-34.0556944443999967)
64852	Graffiti at the Arthouse Hotel	+61	(02) 9284 1230	\N	2449	1	https://b.zmtcdn.com/data/pictures/0/16557730/f77f5ffb7d6ec05c0e470dc341a8362d.jpg?resize=1204%3A903&crop=1200%3A464%3B0%2C174	1	99	0	0	0	graffiti-at-the-arthouse-hotel-cbd	https://www.zomato.com/sydney/graffiti-at-the-arthouse-hotel-cbd	Wheelchair Accessible,Full Bar Available,Live Music,Gluten Free Options,Dairy Free,Set Menu,Indoor Seating,Available for Functions,Group Bookings Available,Vegetarian Friendly,Vegan Options,BYO Cake,Live Entertainment,Kid Friendly,Smoking Area,Wifi,Parking available 43 metres away	80	(151.208221614400003,-33.8730230948999989)
70113	Talee Thai	+61	(02) 9804 1666	\N	238	1	https://b.zmtcdn.com/data/res_imagery/16565091_RESTAURANT_443ac3e122b49e7e9456ca28688e3a43.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	talee-thai-1-ermington	https://www.zomato.com/sydney/talee-thai-1-ermington	No Alcohol Available,Outdoor Seating,Vegetarian Friendly,Indoor Seating	40	(151.065777875500004,-33.8084658320999978)
70111	Greenbay Sushi	+61	\N	\N	108	1	https://b.zmtcdn.com/data/pictures/2/17746482/7f4292eba9aa6703be39f0c1dee3e7f0.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	greenbay-sushi-north-sydney	https://www.zomato.com/sydney/greenbay-sushi-north-sydney	Takeaway Available,Table booking not available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Parking available 8 metres away	40	(151.207462213899987,-33.8400160747000029)
72547	Star Taste Chinese Restaurant	+61	(02) 9649 1668	\N	292	1	\N	1	99	0	0	0	star-taste-chinese-restaurant-2-auburn	https://www.zomato.com/sydney/star-taste-chinese-restaurant-2-auburn	Takeaway Available,Wine and Beer,Indoor Seating,Kid Friendly,Table Reservation Not Required	\N	(151.03221405299999,-33.8493977931000032)
72566	The Anatolian	+61	(02) 9809 7841	\N	237	1	\N	1	99	0	0	0	the-anatolian-west-ryde	https://www.zomato.com/sydney/the-anatolian-west-ryde	Breakfast,Takeaway Available,Wheelchair Accessible,Indoor Seating,Brunch,Vegetarian Friendly,Gluten Free Options,Desserts and Bakes,Parking available 252 metres away	45	(151.0880643502,-33.8075194848999985)
72607	Gymea Fresh Deli	+61	(02) 9526 1523	\N	480	1	\N	1	99	0	0	0	gymea-fresh-deli-gymea	https://www.zomato.com/sydney/gymea-fresh-deli-gymea	Breakfast,Takeaway Available,Brunch,Indoor Seating,Desserts and Bakes,Gluten Free Options,Vegetarian Friendly	35	(151.085276864500003,-34.0358668224000027)
72684	Seasalt Fish & Chips	+61	(02) 9636 2376	\N	295	1	\N	1	99	0	0	0	seasalt-fish-chips-greystanes	https://www.zomato.com/sydney/seasalt-fish-chips-greystanes	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	50	(150.952133685400014,-33.829769663999997)
72895	I Bangkok	+61	(02) 8084 0123	\N	232	1	\N	1	99	0	0	0	i-bangkok-north-ryde	https://www.zomato.com/sydney/i-bangkok-north-ryde	Takeaway Available,Indoor Seating,Table booking recommended	60	(151.131221093199997,-33.8009354376000033)
64877	Osteria Riva	+61	(02) 9369 4071	\N	44	1	https://b.zmtcdn.com/data/reviews_photos/f96/3ad7feab75244475f165760a2b0c2f96_1492914202.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C262	1	99	0	0	0	osteria-riva-bondi-junction	https://www.zomato.com/sydney/osteria-riva-bondi-junction	Takeaway Available,Wine,BYO,Pet Friendly,Vegetarian Friendly,Outdoor Seating,Gluten Free Options,Table booking recommended	90	(151.250683665299988,-33.8953043663999978)
72966	Charlie's Family Restaurant	+61	(02) 9631 3390	\N	302	1	\N	1	99	0	0	0	charlies-family-restaurant-toongabbie	https://www.zomato.com/sydney/charlies-family-restaurant-toongabbie	Full Bar Available,Indoor Seating,Desserts and Bakes,Outdoor Seating,Table Reservation Not Required,Wifi,Kid Friendly	55	(150.931876636999988,-33.8056323308000017)
72996	Vinh Thanh Hot Bread	+61	(02) 9528 8920	\N	479	1	\N	1	99	0	0	0	vinh-thanh-hot-bread-jannali	https://www.zomato.com/sydney/vinh-thanh-hot-bread-jannali	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Desserts and Bakes	20	(151.065360792000007,-34.0161526826000014)
73043	K.S. Johnny's Bakery	+61	(02) 9542 5715	\N	500	1	\N	1	99	0	0	0	k-s-johnnys-bakery-sutherland	https://www.zomato.com/sydney/k-s-johnnys-bakery-sutherland	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Desserts and Bakes	15	(151.05678711089999,-34.0314279489999976)
64897	Girdlers	+61	(02) 9972 1336	\N	190	1	https://b.zmtcdn.com/data/res_imagery/16563461_RESTAURANT_4d2e5cdc0ec9a70f8467bb7faea5f65f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	girdlers-dee-why	https://www.zomato.com/sydney/girdlers-dee-why	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Brunch,Gluten Free Options,Vegetarian Friendly,Indoor Seating	50	(151.29615180190001,-33.7551479199999989)
73336	Cafe Sianos	+61	(02) 9700 9383	\N	39	1	\N	1	99	0	0	0	cafe-sianos-mascot	https://www.zomato.com/sydney/cafe-sianos-mascot	Breakfast,Takeaway Available,No Alcohol Available,Desserts and Bakes,Vegetarian Friendly,Kid Friendly,Indoor Seating,Catering Available,Parking available 290 metres away	25	(151.186458505699989,-33.9319167057999991)
67810	Jade Delight	+61	(02) 9808 2888	\N	235	1	https://b.zmtcdn.com/data/res_imagery/16560657_CHAIN_3a1bda3bd16ab66d45109924d59e6941.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	jade-delight-meadowbank	https://www.zomato.com/sydney/jade-delight-meadowbank	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Indoor Seating,Table Reservation Not Required,Vegetarian Friendly	40	(151.090086735800014,-33.818127613999998)
73395	Copper Espresso	+61	0431 087 868	\N	2449	1	\N	1	99	0	0	0	copper-espresso-cbd	https://www.zomato.com/sydney/copper-espresso-cbd	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Parking available 89 metres away	\N	(151.207147999999989,-33.8747970000000009)
69838	54 Foveaux Vietnamese Cafe	+61	0478 591 047	\N	13	1	\N	1	99	0	0	0	54-foveaux-vietnamese-cafe-1-surry-hills	https://www.zomato.com/sydney/54-foveaux-vietnamese-cafe-1-surry-hills	Breakfast,Takeaway Available,No Alcohol Available,Desserts and Bakes,All Day Breakfast,Indoor Seating	30	(151.211079508099999,-33.8843089137999982)
73537	The Wentworthville Hotel	+61	(02) 9636 5205	\N	299	1	\N	1	99	0	0	0	the-wentworthville-hotel-wentworthville	https://www.zomato.com/sydney/the-wentworthville-hotel-wentworthville	Full Bar Available,Live Sports Screening,Table Reservation Not Required,Nightlife,Outdoor Seating	80	(150.971902906899999,-33.8090138005999989)
64946	Sealevel	+61	(02) 9523 8888	\N	491	1	https://b.zmtcdn.com/data/res_imagery/16558960_RESTAURANT_95d3ec76496ffbbc0c12b8127b55be90.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sealevel-cronulla	https://www.zomato.com/sydney/sealevel-cronulla	Wheelchair Accessible,Full Bar Available,Kid Friendly,Wifi,Indoor Seating,Vegetarian Friendly	150	(151.155599690999992,-34.0520113485999971)
64953	Meet The Greek	+61	(02) 9597 5062	\N	2461	1	https://b.zmtcdn.com/data/res_imagery/16565747_RESTAURANT_d2b0e3282a0afc1323946f6bba270ae1_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	meet-the-greek-brighton-le-sands	https://www.zomato.com/sydney/meet-the-greek-brighton-le-sands	Takeaway Available,Full Bar Available,Outdoor Seating,Indoor Seating,Kid Friendly,Gluten Free Options,Vegetarian Friendly,Live Music	70	(151.155966483100002,-33.9613590964000025)
69865	Blue Dolphin Seafood	+61	(02) 9969 3010	\N	173	1	\N	1	99	0	0	0	blue-dolphin-seafood-mosman	https://www.zomato.com/sydney/blue-dolphin-seafood-mosman	Breakfast,Takeaway Only,Seating Not Available,No Alcohol Available	45	(151.244508214299998,-33.8306934842999993)
73603	The Commercial Hotel	+61	(02) 6351 2312	\N	2220	1	\N	1	99	0	0	0	the-commercial-hotel-lithgow	https://www.zomato.com/sydney/the-commercial-hotel-lithgow	Full Bar Available,Table Reservation Not Required,Indoor Seating	55	(150.153202999999991,-33.4825489999999988)
64950	Rio's Brazilian Steakhouse	+61	(02) 9687 7125	\N	255	1	https://b.zmtcdn.com/data/res_imagery/16565319_RESTAURANT_9b372b60c853fdcf88dfbfbb11de1a5e_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	rios-brazilian-steakhouse-parramatta	https://www.zomato.com/sydney/rios-brazilian-steakhouse-parramatta	Full Bar Available,Live Music,Indoor Seating	125	(151.004080027300006,-33.8123993151999969)
70185	Al Fayhaa Halal Chicken	+61	(02) 9740 5775	\N	413	1	\N	1	99	0	0	0	al-fayhaa-halal-chicken-lakemba	https://www.zomato.com/sydney/al-fayhaa-halal-chicken-lakemba	Breakfast,Takeaway Available,Wheelchair Accessible,Serves Halal,Kid Friendly,Indoor Seating,Vegetarian Friendly	25	(151.077586636000007,-33.9209941379999975)
72680	The Local Burger Bar	+61	\N	\N	439	1	\N	1	99	0	0	0	the-local-burger-bar-lugarno	https://www.zomato.com/sydney/the-local-burger-bar-lugarno	Takeaway Available,Beer,Outdoor Seating,Serves Cocktails,Table booking recommended,Pet Friendly,Gluten Free Options,Wine Tasting,Indoor Seating,Vegan Options,All Day Breakfast	\N	(151.047449000200004,-33.9750143724999987)
64970	Newtown North Indian Diner	+61	(02) 9519 2035	\N	85	1	https://b.zmtcdn.com/data/reviews_photos/885/f57134fdf994b8b36c794585cbd5f885_1459095512.jpg?resize=1204%3A1322&crop=1200%3A464%3B-2%2C304	1	99	0	0	0	newtown-north-indian-diner-newtown	https://www.zomato.com/sydney/newtown-north-indian-diner-newtown	Takeaway Available,Gluten Free Options,Indoor Seating,Vegetarian Friendly	40	(151.182418763599998,-33.8946606591999995)
69918	Sam's Chaoshan Hotpot	+61	0451 038 888	\N	253	1	\N	1	99	0	0	0	sams-chaoshan-hotpot-eastwood	https://www.zomato.com/sydney/sams-chaoshan-hotpot-eastwood	Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,BYO Cake,Indoor Seating,Lunch Menu,Catering Available,Pet Friendly,Group Bookings Available,Table reservation required,Split Bills,Kid Friendly	60	(151.093926318000001,-33.7840053716999975)
61632	Villaggio Fresco	+61	(02) 9797 2248	\N	688	1	\N	1	99	0	0	0	villaggio-fresco-summer-hill	https://www.zomato.com/sydney/villaggio-fresco-summer-hill	Breakfast,Takeaway Available,No Alcohol Available,Desserts and Bakes,Indoor Seating	15	(151.138005070399998,-33.8917275973999992)
63561	Olive and Peel	+61	\N	\N	190	1	\N	1	99	0	0	0	olive-and-peel-dee-why	https://www.zomato.com/sydney/olive-and-peel-dee-why	Home Delivery,Takeaway Available,Full Bar Available,Indoor Seating,Catering Available,Table booking recommended,Vegetarian Friendly	80	(151.292205601900008,-33.7536484828000027)
73885	Minto Chicken Corner	+61	(02) 9824 8883	\N	1699	1	\N	1	99	0	0	0	minto-chicken-corner-minto	https://www.zomato.com/sydney/minto-chicken-corner-minto	Wheelchair Accessible,Indoor Seating,Kid Friendly	20	(150.849774889700001,-34.0302629007999968)
65001	Harpoon Harry at Hotel Harry	+61	(02) 8262 8800	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/91a/d8c67345231690b8dbd5d4e0fb54b91a_1455697315.jpg?resize=1204%3A677&crop=1200%3A464%3B1%2C60	1	99	0	0	0	harpoon-harry-at-hotel-harry-surry-hills	https://www.zomato.com/sydney/harpoon-harry-at-hotel-harry-surry-hills	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,Live Music,Indoor Seating,Smoking Area,Nightlife,Rooftop,Vegetarian Friendly,Gluten Free Options,Wifi,Live Entertainment,Outdoor Seating,Available for Functions,Table Reservation Not Required,Parking available 225 metres away	90	(151.211282350099992,-33.8785508136000004)
65022	Ichiraku Dado	+61	(02) 9858 2211	\N	253	1	https://b.zmtcdn.com/data/res_imagery/16563961_RESTAURANT_08c89a40d64187d67a25f6bb33561a3b_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ichiraku-dado-eastwood	https://www.zomato.com/sydney/ichiraku-dado-eastwood	Takeaway Available,Wheelchair Accessible,Full Bar Available,BYO,Table Reservation Not Required,Indoor Seating	60	(151.081427894499996,-33.7907032916000034)
16572	Frangipani Gelato Bar	+61	(02) 9544 0216	\N	491	1	https://b.zmtcdn.com/data/res_imagery/16560584_RESTAURANT_6f7d3fbb999057ce5ee15649be268281.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	frangipani-gelato-bar-cronulla	https://www.zomato.com/sydney/frangipani-gelato-bar-cronulla	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Indoor Seating,Desserts and Bakes	20	(151.151690036100007,-34.055046386299999)
65050	1606 Luis de Torres	+61	0424 869 584	\N	277	1	https://b.zmtcdn.com/data/reviews_photos/537/e01bdceca76abdc4a9c43e4fd9e2c537_1464445710.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C419	1	99	0	0	0	1606-luis-de-torres-rhodes	https://www.zomato.com/sydney/1606-luis-de-torres-rhodes	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Outdoor Seating,Pet Friendly,All Day Breakfast,Indoor Seating,Wifi	20	(151.086159646499993,-33.831870456499999)
73037	Al Sahra Diner Kebabs	+61	\N	\N	445	1	\N	1	99	0	0	0	al-sahra-diner-kebabs-panania	https://www.zomato.com/sydney/al-sahra-diner-kebabs-panania	Breakfast,Takeaway Available,Indoor Seating	20	(151.002355031700006,-33.9567227722000027)
67869	Sea Breeze	+61	(02) 8668 4526	\N	78	1	https://b.zmtcdn.com/data/res_imagery/16564030_RESTAURANT_79618f449be3ce7024e1d777a61e26a5.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sea-breeze-rozelle	https://www.zomato.com/sydney/sea-breeze-rozelle	Takeaway Available,Indoor Seating	35	(151.170707903800007,-33.8638828400999969)
67879	Bamiyan Restaurant	+61	(02) 9894 7766	\N	319	1	\N	1	99	0	0	0	bamiyan-restaurant-baulkham-hills	https://www.zomato.com/sydney/bamiyan-restaurant-baulkham-hills	Takeaway Available,Full Bar Available,Vegetarian Friendly,Indoor Seating,Table Reservation Not Required	75	(150.964373275599996,-33.7319930621000026)
73224	La Banette	+61	\N	\N	203	1	\N	1	99	0	0	0	la-banette-mona-vale	https://www.zomato.com/sydney/la-banette-mona-vale	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available,Desserts and Bakes,Kid Friendly,Vegetarian Friendly	30	(151.302918680000005,-33.6767476277999975)
69741	Maru1	+61	\N	\N	482	1	\N	1	99	0	0	0	maru1-miranda	https://www.zomato.com/sydney/maru1-miranda	Breakfast,Takeaway Available,Wheelchair Accessible,Indoor Seating	25	(151.099520064899991,-34.0348846556000026)
61732	Bakelicious - Narraweena Cake Shop	+61	(02) 9971 9714	\N	191	1	https://b.zmtcdn.com/data/pictures/3/17745283/7e2e694367e3cf4435892403a8b97e4a.jpg?resize=1204%3A1605&crop=1200%3A464%3B1%2C169	1	99	0	0	0	bakelicious-narraweena-cake-shop-narraweena	https://www.zomato.com/sydney/bakelicious-narraweena-cake-shop-narraweena	Breakfast,Takeaway Only,Seating Not Available,Desserts and Bakes,All Day Breakfast	20	(151.274891942700009,-33.7504373856000015)
17757	Iraqi traditional bakery	+61	\N	\N	350	1	\N	1	99	0	0	0	iraqi-traditional-bakery-fairfield	https://www.zomato.com/sydney/iraqi-traditional-bakery-fairfield	Seating Not Available,Kid Friendly,Desserts and Bakes	10	(150.955353006699994,-33.8708668033999984)
73786	Sydney Marina	+61	\N	\N	303	1	\N	1	99	0	0	0	sydney-marina-pendle-hill	https://www.zomato.com/sydney/sydney-marina-pendle-hill	Takeaway Available,Indoor Seating,All Day Breakfast	30	(150.955298692000014,-33.8026357544000007)
67901	Tandoori Connection	+61	(02) 9887 2325	\N	231	1	\N	1	99	0	0	0	tandoori-connection-macquarie-park	https://www.zomato.com/sydney/tandoori-connection-macquarie-park	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Kid Friendly,Indoor Seating,Wifi,Parking available 163 metres away	30	(151.120093613899996,-33.7769922940000029)
67924	Thanh Van	+61	(02) 9708 2973	\N	420	1	https://b.zmtcdn.com/data/pictures/0/16563880/795d890bd89d43c7560c530642fea55e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	thanh-van-bankstown	https://www.zomato.com/sydney/thanh-van-bankstown	Breakfast,Takeaway Available,Wheelchair Accessible,Table booking not available,No Alcohol Available,Indoor Seating,Vegetarian Friendly	50	(151.032188571999995,-33.9188819052999975)
73808	The Lunch Box	+61	\N	\N	114	1	\N	1	99	0	0	0	the-lunch-box-crows-nest	https://www.zomato.com/sydney/the-lunch-box-crows-nest	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Vegan Options,Kid Friendly,Desserts and Bakes,Vegetarian Friendly,Gluten Free Options	25	(151.200297698399993,-33.8261528266000013)
67943	IRO Cafe	+61	(02) 9519 4171	\N	102	1	https://b.zmtcdn.com/data/res_imagery/16561729_RESTAURANT_1ef36dc9061f910b5597238f5bbb20be.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	iro-cafe-camperdown	https://www.zomato.com/sydney/iro-cafe-camperdown	Breakfast,Takeaway Available,BYO,Outdoor Seating,Indoor Seating,Brunch	40	(151.180247180200013,-33.8875795598000025)
74035	Sushi & Coffee	+61	\N	\N	194	1	\N	1	99	0	0	0	sushi-coffee-brookvale	https://www.zomato.com/sydney/sushi-coffee-brookvale	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Outdoor Seating	25	(151.272546015699987,-33.7655838784000011)
74098	Seasons Cafe	+61	\N	\N	114	1	\N	1	99	0	0	0	seasons-cafe-crows-nest	https://www.zomato.com/sydney/seasons-cafe-crows-nest	Takeaway Available,No Alcohol Available,Vegetarian Friendly,Indoor Seating,All Day Breakfast	45	(151.200976967799988,-33.8271566215999968)
67970	Lane Cove Chinese Kitchen	+61	(02) 9427 0099	\N	119	1	https://b.zmtcdn.com/data/reviews_photos/b96/938f86f0243762834fc47d03ee0a7b96_1496220914.jpg?resize=1204%3A903&crop=1200%3A464%3B0%2C149	1	99	0	0	0	lane-cove-chinese-kitchen-lane-cove	https://www.zomato.com/sydney/lane-cove-chinese-kitchen-lane-cove	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly	65	(151.169591434300003,-33.8145186409999994)
68409	T. Dumpling	+61	\N	\N	2463	1	\N	1	99	0	0	0	t-dumpling-wentworth-point	https://www.zomato.com/sydney/t-dumpling-wentworth-point	Wheelchair Accessible,Kid Friendly,Dairy Free,Outdoor Seating,BYO Cake,Wifi,Indoor Seating,Pram Friendly	\N	(151.079019941399991,-33.8235580568000032)
70944	David Jones Cafe	+61	\N	\N	2456	1	\N	1	99	0	0	0	david-jones-cafe-barangaroo	https://www.zomato.com/sydney/david-jones-cafe-barangaroo	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Outdoor Seating,Brunch,Parking available 229 metres away	12	(151.202699951800014,-33.8654165380999999)
67975	Peroni Bar	+61	(02) 9114 6558	\N	17	1	https://b.zmtcdn.com/data/pictures/7/17743337/75e0f64adb5e5ac03da26b84418e9274.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	peroni-bar-mascot	https://www.zomato.com/sydney/peroni-bar-mascot	Breakfast,Wheelchair Accessible,Full Bar Available,Indoor Seating	50	(151.165200999999996,-33.9392849999999981)
67994	Cafe Rodem	+61	(02) 8386 5296	\N	281	1	https://b.zmtcdn.com/data/reviews_photos/fc1/d3b89affae1425c5c88cfe7c9fb47fc1_1458872226.jpg?resize=1204%3A1605&crop=1200%3A464%3B-2%2C812	1	99	0	0	0	cafe-rodem-lidcombe	https://www.zomato.com/sydney/cafe-rodem-lidcombe	Breakfast,Takeaway Available,No Alcohol Available,Wifi,Brunch,Indoor Seating	25	(151.04508630929999,-33.8627525240000011)
65101	Little Jack Horner	+61	(02) 9665 5160	\N	63	1	https://b.zmtcdn.com/data/res_imagery/16570600_RESTAURANT_5c666cbde29f3f69d2c7b33c8778b941.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	little-jack-horner-coogee	https://www.zomato.com/sydney/little-jack-horner-coogee	Breakfast,Takeaway Available,No Alcohol Available,Wifi,Outdoor Seating,Gluten Free Options,Brunch	50	(151.256650909799987,-33.9206961694000029)
65112	The Vic	+61	(02) 9114 7348	\N	423	1	https://b.zmtcdn.com/data/res_imagery/16566342_RESTAURANT_d1cce902b54544c901fc1195f2188f13.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-vic-marrickville	https://www.zomato.com/sydney/the-vic-marrickville	Serves Alcohol,Nightlife,Live Music,Live Sports Screening,Sports Bar,Indoor Seating,Outdoor Seating,Vegetarian Friendly,Gastro Pub	70	(151.1678302288,-33.9045828944000007)
65130	Tropicana Cafe	+61	(02) 9665 5619	\N	63	1	https://b.zmtcdn.com/data/res_imagery/16561175_RESTAURANT_5d6a59d0af5ea98fda13257140c5a6e1.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	tropicana-cafe-coogee	https://www.zomato.com/sydney/tropicana-cafe-coogee	Breakfast,Takeaway Available,Wheelchair Accessible,BYO,Wifi,Smoking Area,Gluten Free Options,Outdoor Seating,Brunch,Vegetarian Friendly,Pet Friendly,Kid Friendly	55	(151.254809573300008,-33.9206608360000033)
67984	Danny's cafe	+61	(02) 8095 0501	\N	44	1	https://b.zmtcdn.com/data/pictures/0/16562370/fa3619fe23d423eb47d8084b74edb723.jpg?resize=1204%3A1078&crop=1200%3A464%3B15%2C86	1	99	0	0	0	dannys-cafe-1-bondi-junction	https://www.zomato.com/sydney/dannys-cafe-1-bondi-junction	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Indoor Seating,Kid Friendly,Vegetarian Friendly,Brunch	35	(151.247101910400005,-33.8924328327999973)
58002	Mad Mex	+61	(02) 9222 1700	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16561973_CHAIN_4435b17e243896c97092c08f4cb2de1a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	mad-mex-2-cbd	https://www.zomato.com/sydney/mad-mex-2-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,Beer,Kid Friendly,Gluten Free Options,Indoor Seating,Parking available 88 metres away	30	(151.207475960300002,-33.8703980129999991)
65115	Kaffeine & Co	+61	(02) 9791 1000	\N	419	1	https://b.zmtcdn.com/data/reviews_photos/026/30aca17c5b35ad42bfb014334165a026_1511001238.jpg?resize=1204%3A1204&crop=1200%3A464%3B-1%2C351	1	99	0	0	0	kaffeine-co-yagoona	https://www.zomato.com/sydney/kaffeine-co-yagoona	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly	50	(151.010073423400002,-33.9101060639000025)
70125	The Outlook Brasserie	+61	(02) 9580 3749	\N	470	1	\N	1	99	0	0	0	the-outlook-brasserie-penshurst	https://www.zomato.com/sydney/the-outlook-brasserie-penshurst	No Alcohol Available,Desserts and Bakes,Indoor Seating	60	(151.088189072900008,-33.9647241107999989)
68050	Yellow Fever	+61	0410 577 266	\N	32	1	https://b.zmtcdn.com/data/res_imagery/15548107_RESTAURANT_0d09acebb5fe91da58171904ca5fb077.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	yellow-fever-redfern	https://www.zomato.com/sydney/yellow-fever-redfern	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Brunch,Desserts and Bakes,Vegetarian Friendly,Kid Friendly,Gluten Free Options	15	(151.200425773900008,-33.8937831725000009)
61506	Yianni's Bakery	+61	(02) 9588 6142	\N	453	1	\N	1	99	0	0	0	yiannis-bakery-kogarah	https://www.zomato.com/sydney/yiannis-bakery-kogarah	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Desserts and Bakes	20	(151.13234594459999,-33.9645086048000024)
68079	Sanduba	+61	(02) 9252 2004	\N	2449	1	https://b.zmtcdn.com/data/pictures/1/16716111/51801a4985493b30fa3c68cf65e149bc.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	sanduba-cbd	https://www.zomato.com/sydney/sanduba-cbd	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegan Options,Outdoor Seating,Gluten Free Options,Vegetarian Friendly,Brunch,Parking available 189 metres away	40	(151.206836588700014,-33.8639563378999995)
70197	Silkroad Uyghur Restaurant	+61	(02) 9798 0008	\N	263	1	\N	1	99	0	0	0	silkroad-uyghur-restaurant-ashfield	https://www.zomato.com/sydney/silkroad-uyghur-restaurant-ashfield	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Kid Friendly	45	(151.1267086119,-33.8899394350000023)
54007	Cha No 9 Noodle Shop	+61	(02) 9918 8828	\N	212	1	\N	1	99	0	0	0	cha-no-9-noodle-shop-avalon	https://www.zomato.com/sydney/cha-no-9-noodle-shop-avalon	Takeaway Available,Outdoor Seating,Table Reservation Not Required,Vegetarian Friendly,Kid Friendly,Indoor Seating	40	(151.334192566599995,-33.6216646211999972)
68107	Ilcha Restaurant	+61	(02) 8773 3566	\N	354	1	https://b.zmtcdn.com/data/pictures/0/17748160/2801bf6078765c738e8d887b0adbd10c.jpg?resize=1204%3A902&crop=1200%3A464%3B1%2C111	1	99	0	0	0	ilcha-restaurant-cabramatta	https://www.zomato.com/sydney/ilcha-restaurant-cabramatta	Wine and Beer,Table booking recommended,Buffet,Kid Friendly,Indoor Seating	80	(150.934190377600004,-33.8952406359999969)
68115	Roadhouse Bar & Grill - Atura Blacktown	+61	(02) 9421 0000	\N	312	1	https://b.zmtcdn.com/data/res_imagery/18231506_RESTAURANT_4df67a162609a9919b8de6260438829e.JPG?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	roadhouse-bar-grill-atura-blacktown-prospect	https://www.zomato.com/sydney/roadhouse-bar-grill-atura-blacktown-prospect	Breakfast,Full Bar Available,Live Entertainment,Wifi,Indoor Seating,Table Reservation Not Required	75	(150.902610048700012,-33.8067310862999975)
65192	The Good Kitchen	+61	(02) 9579 1688	\N	2482	1	https://b.zmtcdn.com/data/res_imagery/16563543_RESTAURANT_1c31c0c9bfa354b2fbd1704f37c6dc7f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-good-kitchen-hurstville	https://www.zomato.com/sydney/the-good-kitchen-hurstville	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Lunch Menu,Vegetarian Friendly	60	(151.10567908729999,-33.9675172970000006)
70275	The House Dining	+61	(02) 8957 4664	\N	85	1	\N	1	99	0	0	0	the-house-dining-newtown	https://www.zomato.com/sydney/the-house-dining-newtown	Breakfast,Takeaway Available,Full Bar Available,Table booking not available,Vegan Options,Indoor Seating,Serves Cocktails,Desserts and Bakes,Outdoor Seating,Brunch,Vegetarian Friendly	20	(151.17779128250001,-33.8986742179000018)
65172	Rey's Place	+61	(02) 9361 5938	\N	12	1	https://b.zmtcdn.com/data/pictures/6/17744316/a64192e75b1b0a50bf705b3389d0d041.jpg?resize=1204%3A803&crop=1200%3A464%3B0%2C176	1	99	0	0	0	reys-place-darlinghurst	https://www.zomato.com/sydney/reys-place-darlinghurst	Wine,Serves Cocktails,Table booking recommended,Vegetarian Friendly,Indoor Seating,Parking available 256 metres away	60	(151.215668767700009,-33.8766663410000035)
54145	Izakaya Fujiyama	+61	(02) 9698 2797	\N	13	1	https://b.zmtcdn.com/data/res_imagery/16563680_RESTAURANT_0bc92bc3cacf0cc17436dfab4199ce9d_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	izakaya-fujiyama-surry-hills	https://www.zomato.com/sydney/izakaya-fujiyama-surry-hills	Wine and Beer,Outdoor Seating,Sake	80	(151.210340894799998,-33.8868628729999983)
65169	Goblin	+61	(02) 8213 2673	\N	17	1	https://b.zmtcdn.com/data/res_imagery/16565506_RESTAURANT_00472c881b080db1888f9649db72dc96_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	goblin-summer-hill	https://www.zomato.com/sydney/goblin-summer-hill	Breakfast,Takeaway Available,Full Bar Available,Wifi,Vegetarian Friendly,Kid Friendly,Gluten Free Options,Vegan Options,Brunch,Pet Friendly,Outdoor Seating,Indoor Seating,Desserts and Bakes	50	(151.139597967300006,-33.8899728328999998)
70475	Shuk Bakery	+61	0403 575 361	\N	2606	1	\N	1	99	0	0	0	shuk-bakery-north-bondi	https://www.zomato.com/sydney/shuk-bakery-north-bondi	Breakfast,Takeaway Available,No Alcohol Available,Desserts and Bakes,Indoor Seating,Outdoor Seating	20	(151.276916340000014,-33.884587247799999)
68231	Cafe 10	+61	(02) 9514 4764	\N	2504	1	\N	1	99	0	0	0	cafe-10-ultimo	https://www.zomato.com/sydney/cafe-10-ultimo	Breakfast,Takeaway Available,Table booking not available,No Alcohol Available,Indoor Seating,Outdoor Seating,Vegetarian Friendly	45	(151.199248284100008,-33.8835162134000001)
65210	Ginger Indian Restaurant	+61	(02) 9635 9680	\N	313	1	https://b.zmtcdn.com/data/res_imagery/16557941_RESTAURANT_4339fd600645a7108c5b3bd689a7098a_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ginger-indian-restaurant-harris-park	https://www.zomato.com/sydney/ginger-indian-restaurant-harris-park	Home Delivery,Takeaway Available,Full Bar Available,BYO,Kid Friendly,Outdoor Seating,Wifi,Indoor Seating,Vegetarian Friendly,Gluten Free Options,Vegan Options	70	(151.009100787300014,-33.8208442712000021)
68382	Chimack	+61	(02) 9411 1040	\N	2	1	\N	1	99	0	0	0	chimack-chatswood	https://www.zomato.com/sydney/chimack-chatswood	Beer,Outdoor Seating,Indoor Seating,Kid Friendly,Table Reservation Not Required	50	(151.179909892399991,-33.7975366530000016)
70562	Kaaj Restaurant	+61	(02) 8897 2176	\N	336	1	\N	1	99	0	0	0	kaaj-restaurant-merrylands	https://www.zomato.com/sydney/kaaj-restaurant-merrylands	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	50	(150.99249355500001,-33.8365968421000005)
65233	Wa Japanese Restaurant Cafe	+61	(02) 8068 4842	\N	44	1	https://b.zmtcdn.com/data/reviews_photos/190/7f30efa6d2e8a1c8e0042d643114b190_1454138406.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	wa-japanese-restaurant-cafe-bondi-junction	https://www.zomato.com/sydney/wa-japanese-restaurant-cafe-bondi-junction	Takeaway Available,BYO,Kid Friendly,Vegetarian Friendly,Indoor Seating	75	(151.245705820599994,-33.8912269157000026)
65245	The Galley at Sydney Boathouse	+61	0457 373 386	\N	78	1	https://b.zmtcdn.com/data/pictures/1/17746071/b9f38573f70103fa50dd25d3beb249d8.png?resize=1204%3A502&crop=1200%3A464%3B-1%2C30	1	99	0	0	0	the-galley-at-sydney-boathouse-rozelle	https://www.zomato.com/sydney/the-galley-at-sydney-boathouse-rozelle	Breakfast,Wheelchair Accessible,Full Bar Available,Vegan Options,Waterfront,Available for Functions,Desserts and Bakes,Pet Friendly,Brunch,Outdoor Seating,Kid Friendly,Vegetarian Friendly,Indoor Seating	40	(151.178957708199988,-33.8700138478999975)
68206	The Rusty Flute	+61	(02) 8824 5350	\N	320	1	https://b.zmtcdn.com/data/reviews_photos/79d/417714c09a70695325f190512f45a79d_1502934940.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-rusty-flute-bella-vista	https://www.zomato.com/sydney/the-rusty-flute-bella-vista	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Outdoor Seating,Kid Friendly,Brunch	45	(150.945674590799996,-33.7344007291000025)
68199	Comoros Coffee	+61	\N	\N	39	1	https://b.zmtcdn.com/data/pictures/2/17746722/7fee8a06bd1a19b766db4380c044f3e2.jpg?resize=1204%3A1204&crop=1200%3A464%3B7%2C733	1	99	0	0	0	comoros-coffee-mascot	https://www.zomato.com/sydney/comoros-coffee-mascot	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Kid Friendly,Vegetarian Friendly,Indoor Seating,Desserts and Bakes,Outdoor Seating	30	(151.194644607599997,-33.9320018286000007)
68203	Sushi Season	+61	(02) 9517 2012	\N	85	1	https://b.zmtcdn.com/data/pictures/1/16570561/dee6434ac8e64d66e61beae10e249424.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	iktus-gourmet-sushi-newtown	https://www.zomato.com/sydney/iktus-gourmet-sushi-newtown	Breakfast,Home Delivery,Takeaway Available,Full Bar Available,Gluten Free Options,Kid Friendly,Indoor Seating,Outdoor Seating,Vegetarian Friendly,Table Reservation Not Required	35	(151.181179583100004,-33.895948068700001)
65298	Kahii	+61	(02) 9290 1889	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/18289504_RESTAURANT_1036b061cb4931386d6cb66fba1f07da.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	kahii-cbd	https://www.zomato.com/sydney/kahii-cbd	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Brunch,Kid Friendly,Parking available 71 metres away	30	(151.204942949100001,-33.8706318517999989)
65317	Zaida	+61	(02) 8094 8182	\N	13	1	https://b.zmtcdn.com/data/pictures/1/16567011/46da22d0ca745a4df6943b2dd6d64ced.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=963&cropw=1200&croph=464&cropoffsetx=5&cropoffsety=329&cropgravity=NorthWest	1	99	0	0	0	zaida-surry-hills	https://www.zomato.com/sydney/zaida-surry-hills	Takeaway Available,Full Bar Available,Indoor Seating,Gluten Free Options,Vegetarian Friendly,Outdoor Seating,Table booking recommended,Vegan Options	70	(151.214781627099995,-33.8806646023000013)
68724	Ken's Kissa	+61	(02) 8021 4766	\N	174	1	\N	1	99	0	0	0	kens-kissa-neutral-bay	https://www.zomato.com/sydney/kens-kissa-neutral-bay	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Table Reservation Not Required,Outdoor Seating,Indoor Seating,Desserts and Bakes,Vegetarian Friendly,Kid Friendly	30	(151.218753643300005,-33.8303860095000033)
70265	Al Carbón	+61	0416 061 974	\N	2449	1	\N	1	99	0	0	0	al-carbón-cbd	https://www.zomato.com/sydney/al-carbón-cbd	Takeaway Available,No Alcohol Available,Kid Friendly,Outdoor Seating,Vegetarian Friendly,Parking available 162 metres away	25	(151.207575872500001,-33.8675648939999974)
65310	Tommy Thai Smile	+61	(02) 9809 5062	\N	237	1	https://b.zmtcdn.com/data/reviews_photos/3a1/fdba2b2732f85d5ebff4de2337ea13a1_1432903368.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	tommy-thai-smile-west-ryde	https://www.zomato.com/sydney/tommy-thai-smile-west-ryde	Takeaway Available,Vegetarian Friendly,Table Reservation Not Required,Indoor Seating,Parking available 284 metres away	45	(151.088418401799998,-33.8075233850999979)
70263	Artie's Deli	+61	(02) 9499 4000	\N	2940	1	https://b.zmtcdn.com/data/reviews_photos/7fd/6e87e2c27919d42c6295d23fa06ec7fd_1496911051.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	arties-deli-gordon	https://www.zomato.com/sydney/arties-deli-gordon	Breakfast,Takeaway Available,Wheelchair Accessible,Vegetarian Friendly,Indoor Seating,Brunch	35	(151.151930429000004,-33.7551858307000003)
70325	Little Wok	+61	\N	\N	2449	1	\N	1	99	0	0	0	little-wok-cbd	https://www.zomato.com/sydney/little-wok-cbd	Takeaway Available,No Alcohol Available,Indoor Seating,Parking available 201 metres away	40	(151.207144707400005,-33.8776984914999986)
70712	LaCantina on Kent	+61	(02) 9262 4321	\N	2449	1	\N	1	99	0	0	0	lacantina-on-kent-cbd	https://www.zomato.com/sydney/lacantina-on-kent-cbd	Breakfast,Takeaway Available,Full Bar Available,Indoor Seating,Gluten Free Options,Vegetarian Friendly,Outdoor Seating,Kid Friendly,Vegan Options,Brunch,Parking available 56 metres away	30	(151.204238198700011,-33.867875297300003)
70368	The Local Collective Cafe	+61	(02) 9653 1461	\N	868	1	\N	1	99	0	0	0	the-local-collective-cafe-dural	https://www.zomato.com/sydney/the-local-collective-cafe-dural	Breakfast,No Alcohol Available,Indoor Seating,Brunch	40	(151.046915575899988,-33.6529467499000035)
70349	Arncliffe Bakery And Pizza	+61	(02) 9597 1515	\N	424	1	https://b.zmtcdn.com/data/pictures/0/16563550/91e1e1249408f274802121483f978ce8.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	arncliffe-bakery-abou-ali-lebanese-pizza-arncliffe	https://www.zomato.com/sydney/arncliffe-bakery-abou-ali-lebanese-pizza-arncliffe	Takeaway Available,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Desserts and Bakes	30	(151.142216473800005,-33.936627538499998)
70357	Brown Rice	+61	(02) 8317 4913	\N	13	1	https://b.zmtcdn.com/data/pictures/2/17746782/37dc9b6514a9d02013eddfdf2a147bbb.jpg?resize=1204%3A803&crop=1200%3A464%3B-3%2C268	1	99	0	0	0	brown-rice-surry-hills	https://www.zomato.com/sydney/brown-rice-surry-hills	Takeaway Available,BYO,Table Reservation Not Required,Vegan Options,Vegetarian Friendly,Indoor Seating,Gluten Free Options	50	(151.207974851100005,-33.888439019499998)
65311	Lugarno Seafood Restaurant	+61	(02) 9534 5136	\N	439	1	https://b.zmtcdn.com/data/res_imagery/16558383_RESTAURANT_748cbaa6a7bc148f1e8bae66f414df32.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	lugarno-seafood-restaurant-lugarno	https://www.zomato.com/sydney/lugarno-seafood-restaurant-lugarno	Wheelchair Accessible,Full Bar Available,Vegetarian Friendly,Indoor Seating,Gluten Free Options,Waterfront	120	(151.041895821699995,-33.991377850100001)
65320	Ichibandori	+61	(02) 9953 5422	\N	174	1	https://b.zmtcdn.com/data/res_imagery/16564032_RESTAURANT_8ffb239c39b356fb201b38fd11116144_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ichibandori-neutral-bay	https://www.zomato.com/sydney/ichibandori-neutral-bay	Takeaway Available,Wine and Beer,Vegetarian Friendly,Sake,Outdoor Seating,Gluten Free Options	50	(151.219310201700011,-33.8305848656000023)
70395	Kogarah Seafood And Grill	+61	(02) 8937 0622	\N	453	1	https://b.zmtcdn.com/data/reviews_photos/057/6fef954817d5b9036dc46c1dc7fb2057_1477124713.jpg?resize=1204%3A1204&crop=1200%3A464%3B-4%2C25	1	99	0	0	0	kogarah-seafood-and-grill-kogarah	https://www.zomato.com/sydney/kogarah-seafood-and-grill-kogarah	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Vegetarian Friendly,Outdoor Seating,Indoor Seating,Parking available 284 metres away	30	(151.132989674800001,-33.9623804886999991)
65339	Top's Kitchen	+61	(02) 9331 7008	\N	2481	1	https://b.zmtcdn.com/data/res_imagery/16566210_RESTAURANT_0ea98fbeefd90a11331ebcb8808cc517_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	tops-kitchen-surry-hills	https://www.zomato.com/sydney/tops-kitchen-surry-hills	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Wifi,Vegetarian Friendly,Indoor Seating	30	(151.213883757600001,-33.8852460609000019)
70806	Thai Square	+61	(02) 4773 8880	\N	2561	1	\N	1	99	0	0	0	thai-square-penrith	https://www.zomato.com/sydney/thai-square-penrith	Takeaway Available,No Alcohol Available,Vegetarian Friendly,Table booking recommended,Indoor Seating	80	(150.6496334821,-33.8400884791999985)
66225	The Salisbury Hotel	+61	(02) 9569 1013	\N	99	1	https://b.zmtcdn.com/data/res_imagery/16568457_RESTAURANT_2919f8dcd415a52b0cb7ae038badbc57.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	the-salisbury-hotel-stanmore	https://www.zomato.com/sydney/the-salisbury-hotel-stanmore	Wine,Live Music,Outdoor Seating,Gluten Free Options,Vegetarian Friendly,Wifi,Vegan Options,Live Sports Screening,Table Reservation Not Required	70	(151.164141520899989,-33.8934369621999991)
70452	Ayman Pizzeria Bakery	+61	(02) 9759 0404	\N	408	1	\N	1	99	0	0	0	ayman-pizzeria-bakery-belmore	https://www.zomato.com/sydney/ayman-pizzeria-bakery-belmore	Breakfast,Takeaway Available,Serves Halal,No Alcohol Available,Table Reservation Not Required,Indoor Seating	50	(151.083853952600009,-33.9101080116999967)
70451	Phan's Hot Bread	+61	\N	\N	279	1	https://b.zmtcdn.com/data/pictures/8/16715208/9b6e3224c5deb9876b307657645cf739.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	phans-hot-bread-homebush	https://www.zomato.com/sydney/phans-hot-bread-homebush	Breakfast,Takeaway Only,Wheelchair Accessible,Seating Not Available,Vegetarian Friendly,Desserts and Bakes	15	(151.084775961899993,-33.8670147953000011)
62667	Cafe Without A Name	+61	(02) 9698 9174	\N	29	1	https://b.zmtcdn.com/data/reviews_photos/709/cfa6f25aae74464d04febfd781cd1709_1494900901.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cafe-without-a-name-alexandria	https://www.zomato.com/sydney/cafe-without-a-name-alexandria	Breakfast,Home Delivery,Takeaway Available,No Alcohol Available,Outdoor Seating,Kid Friendly,Indoor Seating,Brunch,Desserts and Bakes	20	(151.199499070600012,-33.9037166406999972)
70905	Nevaggio Espresso	+61	(02) 9267 4694	\N	2449	1	\N	1	99	0	0	0	nevaggio-espresso-cbd	https://www.zomato.com/sydney/nevaggio-espresso-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Indoor Seating,Vegetarian Friendly,Desserts and Bakes,Gluten Free Options,Parking available 24 metres away	30	(151.203925050799995,-33.8721957712999995)
70902	Ming Kee Chinese BBQ Restaurant	+61	(02) 9858 2886	\N	253	1	\N	1	99	0	0	0	ming-kee-chinese-bbq-restaurant-eastwood	https://www.zomato.com/sydney/ming-kee-chinese-bbq-restaurant-eastwood	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Table Reservation Not Required	35	(151.080709062500006,-33.7907609700000009)
70464	Chick-Filla	+61	\N	\N	65	1	\N	1	99	0	0	0	chick-filla-maroubra	https://www.zomato.com/sydney/chick-filla-maroubra	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required,Outdoor Seating	45	(151.238612048300013,-33.9407756927000008)
71043	Thai Thyme	+61	(02) 9482 1045	\N	154	1	\N	1	99	0	0	0	thai-thyme-hornsby	https://www.zomato.com/sydney/thai-thyme-hornsby	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Kid Friendly	30	(151.101365424699992,-33.7033763859000004)
68296	Grow Salad & Juice	+61	(02) 9232 3387	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16567893_RESTAURANT_afba2b451c0883904925d95421d80c1e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	grow-salad-juice-cbd	https://www.zomato.com/sydney/grow-salad-juice-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Wifi,Vegetarian Friendly,Indoor Seating,Vegan Options,Gluten Free Options,Parking available 168 metres away	40	(151.211701780600009,-33.866981666800001)
68337	JM Formula	+61	0433 660 052	\N	117	1	https://b.zmtcdn.com/data/pictures/3/17745223/d7fada334bc3a1c228b2c56834d8c31d.jpg?resize=1204%3A1505&crop=1200%3A464%3B8%2C997	1	99	0	0	0	jm-formula-st-leonards	https://www.zomato.com/sydney/jm-formula-st-leonards	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Outdoor Seating,Gluten Free Options,Vegetarian Friendly,Kid Friendly,Vegan Options	45	(151.193477846700006,-33.8211289400000013)
54366	Sydney Kopitiam Cafe	+61	(02) 9282 9883	\N	8	1	https://b.zmtcdn.com/data/res_imagery/16559821_RESTAURANT_6dbfca4eba0ca34bf5a30380c8fb9192.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sydney-kopitiam-cafe-ultimo	https://www.zomato.com/sydney/sydney-kopitiam-cafe-ultimo	Takeaway Available,Wheelchair Accessible,BYO,Corkage Fee Charged,Indoor Seating,BYO Cake,Split Bills,Vegetarian Friendly,Pram Friendly,Table Reservation Not Required	50	(151.200087815500012,-33.8801154229999995)
68317	Yum Yai	+61	(02) 9698 1211	\N	29	1	\N	1	99	0	0	0	yum-yai-alexandria	https://www.zomato.com/sydney/yum-yai-alexandria	Home Delivery,Takeaway Available,Wheelchair Accessible,BYO,Vegetarian Friendly,Kid Friendly,Indoor Seating	55	(151.199545338799993,-33.8975223775999979)
62717	Cake Mania	+61	(02) 9635 4792	\N	255	1	https://b.zmtcdn.com/data/pictures/5/16715655/36eb7fb03a42d6927e42fa45cea66881.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	cake-mania-parramatta	https://www.zomato.com/sydney/cake-mania-parramatta	Breakfast,Home Delivery,Takeaway Available,Seating Not Available,No Alcohol Available,Vegetarian Friendly,Desserts and Bakes	25	(151.003775261300007,-33.8153367736999968)
65391	Cucina Locale Revolving Restaurant	+61	(02) 9830 0600	\N	309	1	https://b.zmtcdn.com/data/res_imagery/15546812_RESTAURANT_64a0408518af854b006ff4992fffc3ef.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	cucina-locale-revolving-restaurant-blacktown	https://www.zomato.com/sydney/cucina-locale-revolving-restaurant-blacktown	Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegetarian Friendly,Table booking recommended,Gluten Free Options,High Tea	140	(150.908650718600001,-33.7733336507000033)
62291	Kepos & Co.	+61	(02) 9690 0931	\N	33	1	https://b.zmtcdn.com/data/res_imagery/15544721_RESTAURANT_4aaee5f4a66ba39cadafc381a7034943.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	kepos-co-waterloo	https://www.zomato.com/sydney/kepos-co-waterloo	Breakfast,Home Delivery,Takeaway Available,Full Bar Available,Kid Friendly,Outdoor Seating,Indoor Seating,Gluten Free Options,Table Reservation Not Required,Parking available 96 metres away	55	(151.211141198900009,-33.897453083000002)
68391	Chim Chim	+61	(02) 9398 9552	\N	59	1	\N	1	99	0	0	0	chim-chim-randwick	https://www.zomato.com/sydney/chim-chim-randwick	Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Table Reservation Not Required,Indoor Seating	50	(151.239818036600013,-33.9141130524999994)
68379	Mumtaz Mahal	+61	(02) 9524 9037	\N	484	1	https://b.zmtcdn.com/data/res_imagery/16558547_RESTAURANT_99f67ec11e11df711a834b9f7349556f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	mumtaz-mahal-caringbah	https://www.zomato.com/sydney/mumtaz-mahal-caringbah	Home Delivery,Takeaway Available,BYO,Table booking recommended,Vegetarian Friendly,Indoor Seating	60	(151.121353581600005,-34.040865556)
68400	Istanbul In Parra	+61	(02) 9630 6818	\N	255	1	https://b.zmtcdn.com/data/res_imagery/16716702_RESTAURANT_113d965efbb062b561424c1ab9f19c48.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	istanbul-in-parra-parramatta	https://www.zomato.com/sydney/istanbul-in-parra-parramatta	Home Delivery,Takeaway Available,Serves Halal,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Parking available 296 metres away	45	(151.005636714399998,-33.8079863916999983)
68425	Hamlets Pies & Coffee	+61	(02) 9977 5909	\N	184	1	https://b.zmtcdn.com/data/res_imagery/16714888_RESTAURANT_e5cbbd9c48d1142ceead6c33128ad45f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	hamlets-pies-coffee-manly	https://www.zomato.com/sydney/hamlets-pies-coffee-manly	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Desserts and Bakes,Brunch,Indoor Seating,Vegetarian Friendly	35	(151.285729743500013,-33.7983181708999965)
68504	Siam	+61	\N	\N	2449	1	https://b.zmtcdn.com/data/pictures/3/16714163/a2f9435ee2d7c345f6e3d443adf1176d.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	siam-cbd	https://www.zomato.com/sydney/siam-cbd	Takeaway Available,Wheelchair Accessible,Vegetarian Friendly,Indoor Seating,Gluten Free Options,Parking available 248 metres away	25	(151.207910142799989,-33.8661843511999976)
65411	Stanton & Co.	+61	(02) 8339 0580	\N	36	1	https://b.zmtcdn.com/data/pictures/chains/0/17743720/2a2cca7467090a60910103ebc399bb27.jpg?resize=1204%3A803&crop=1200%3A464%3B2%2C209	1	99	0	0	0	stanton-co-rosebery	https://www.zomato.com/sydney/stanton-co-rosebery	Full Bar Available,Indoor Seating,Outdoor Seating,Table booking recommended	120	(151.203056015100003,-33.9165553839999987)
70520	Kennys Kebabs	+61	(02) 9525 5128	\N	482	1	https://b.zmtcdn.com/data/pictures/2/15544362/ae1885cd15e9af53c1dc99df4eae84a7.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	kennys-kebabs-miranda	https://www.zomato.com/sydney/kennys-kebabs-miranda	Takeaway Available,Wheelchair Accessible,Serves Halal,No Alcohol Available,Wifi,Indoor Seating,Vegetarian Friendly,Kid Friendly	30	(151.10259890559999,-34.0351527730000001)
68457	Beans & Barrels	+61	\N	\N	255	1	https://b.zmtcdn.com/data/pictures/1/17746781/fb14b42dfa83777ab32deae3b7b6ff72.jpg?resize=1204%3A502&crop=1200%3A464%3B0%2C36	1	99	0	0	0	beans-barrels-parramatta	https://www.zomato.com/sydney/beans-barrels-parramatta	Breakfast,Takeaway Available,Full Bar Available,Indoor Seating,Outdoor Seating	35	(151.009452827300009,-33.814897205900003)
68442	Beans & Balls	+61	\N	\N	2449	1	https://b.zmtcdn.com/data/reviews_photos/1fe/99e65dcb7847356ec235e5ae39e601fe_1490411475.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	beans-balls-cbd	https://www.zomato.com/sydney/beans-balls-cbd	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Indoor Seating,Catering Available,Parking available 149 metres away	25	(151.209269687500012,-33.8685180929999987)
70514	Spring Garden Restaurant	+61	(02) 9726 8660	\N	418	1	https://b.zmtcdn.com/data/pictures/0/16560270/b07214c56f619bdbacf2648fd40fd969.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	spring-garden-restaurant-georges-hall	https://www.zomato.com/sydney/spring-garden-restaurant-georges-hall	Takeaway Available,Full Bar Available,Vegetarian Friendly,Indoor Seating	50	(150.990240499399988,-33.9006798133000018)
62725	Dani & Fiori's Gourmet Pizzeria	+61	(02) 9559 7773	\N	428	1	https://b.zmtcdn.com/data/reviews_photos/ff7/bfbf3620308579225d03d920bd078ff7_1511012225.jpg?resize=1204%3A903&crop=1200%3A464%3B0%2C149	1	99	0	0	0	dani-fioris-gourmet-pizzeria-earlwood	https://www.zomato.com/sydney/dani-fioris-gourmet-pizzeria-earlwood	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating	50	(151.130237728400004,-33.9264338975999991)
68511	Fable coffee Sydney	+61	0431 094 021	\N	12	1	\N	1	99	0	0	0	fable-coffee-sydney-darlinghurst	https://www.zomato.com/sydney/fable-coffee-sydney-darlinghurst	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating	40	(151.220437400000009,-33.8783275739000018)
68550	Nanya Singapore	+61	(02) 9663 3888	\N	61	1	https://b.zmtcdn.com/data/pictures/7/17746267/8402c323a71f8aaadea6163a38cb905e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	nanya-singapore-kingsford	https://www.zomato.com/sydney/nanya-singapore-kingsford	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Kid Friendly,Table Reservation Not Required	80	(151.227629073000003,-33.9227969506000022)
65488	La Paula	+61	(02) 9726 2379	\N	350	1	https://b.zmtcdn.com/data/res_imagery/16562852_RESTAURANT_0320c4482425dcf465c4b87dfe7ad8fb_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	la-paula-fairfield	https://www.zomato.com/sydney/la-paula-fairfield	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes,Shisha	15	(150.953767150599987,-33.8701950737999979)
70574	Café Sienna	+61	(02) 9745 6558	\N	10	1	https://b.zmtcdn.com/data/pictures/6/16714916/00ce82000b69dc94db99e42638cb5d29.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	café-sienna-1-burwood	https://www.zomato.com/sydney/café-sienna-1-burwood	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Desserts and Bakes,Vegan Options,Wifi,Kid Friendly,Brunch	35	(151.107481531800005,-33.8754234569999966)
68585	Elissar Lebanese Restaurant	+61	(02) 8958 6410	\N	66	1	https://b.zmtcdn.com/data/res_imagery/16569060_RESTAURANT_f6d0de6cb63563eaf0459ba706c86db7_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	elissar-lebanese-restaurant-pagewood	https://www.zomato.com/sydney/elissar-lebanese-restaurant-pagewood	Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegetarian Friendly,Shisha	65	(151.229807026700001,-33.9399785107000014)
70571	The Stables Restaurant & Bar	+61	(02) 9360 0098	\N	2644	1	https://b.zmtcdn.com/data/pictures/8/17745378/9476d4b2fc0b201142e000cf2ba43d7c.jpg?resize=1204%3A802&crop=1200%3A464%3B0%2C99	1	99	0	0	0	the-stables-restaurant-bar-paddington	https://www.zomato.com/sydney/the-stables-restaurant-bar-paddington	Full Bar Available,Serves Cocktails,Indoor Seating,Table booking recommended	170	(151.229904591999997,-33.8864297962999999)
70590	The Coffee Stop Shop	+61	(02) 8964 6891	\N	428	1	https://b.zmtcdn.com/data/reviews_photos/9d6/7f4c3ff66938972e7145732d983d19d6_1498774094.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-coffee-stop-shop-earlwood	https://www.zomato.com/sydney/the-coffee-stop-shop-earlwood	Breakfast,Takeaway Available,No Alcohol Available,Kid Friendly,Vegetarian Friendly,Indoor Seating,Gluten Free Options,Brunch	25	(151.122933067399998,-33.9219275434000025)
65518	Mango Tree Restaurant Karaoke & Bar	+61	(02) 9007 1178	\N	253	1	https://b.zmtcdn.com/data/pictures/chains/9/17742359/a142300b2f221128c2bc420cb16f73ae.jpg?resize=1204%3A800&crop=1200%3A464%3B0%2C165	1	99	0	0	0	mango-tree-restaurant-karaoke-bar-eastwood	https://www.zomato.com/sydney/mango-tree-restaurant-karaoke-bar-eastwood	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,Nightlife,Table booking recommended,Indoor Seating,Lunch Menu	60	(151.080083437300004,-33.7917568212000035)
70636	Java Lounge - Revesby Workers'	+61	(02) 9772 2100	\N	442	1	\N	1	99	0	0	0	java-lounge-revesby-workers-revesby	https://www.zomato.com/sydney/java-lounge-revesby-workers-revesby	No Alcohol Available,Indoor Seating,Wifi	75	(151.013875000000013,-33.9534299999999973)
70614	Mattree	+61	(02) 9907 7758	\N	177	1	https://b.zmtcdn.com/data/res_imagery/16715409_RESTAURANT_ba3a3abd4cfd609214d2769565a840a8_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	matree-seaforth	https://www.zomato.com/sydney/matree-seaforth	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Wifi,Brunch,Gluten Free Options,Indoor Seating,Outdoor Seating,Vegan Options,Vegetarian Friendly,Desserts and Bakes	30	(151.251626797,-33.7967083197999969)
70639	Black Cat White Cat	+61	(02) 4773 9224	\N	2082	1	https://b.zmtcdn.com/data/pictures/2/19238322/c9eaffd67f765ccde15331231b04e4e9.jpg?resize=1204%3A1204&crop=1200%3A464%3B0%2C426	1	99	0	0	0	black-cat-white-cat-glenmore-park	https://www.zomato.com/sydney/black-cat-white-cat-glenmore-park	Breakfast,Takeaway Available,BYO,Gluten Free Options,Indoor Seating	55	(150.652145999999988,-33.8465709999999973)
68600	De Zhuang Hotpot 德莊火鍋	+61	(02) 8318 0747	\N	2449	1	https://b.zmtcdn.com/data/pictures/3/17747193/c4825e3ba8fbfd8312219365552fb59e.jpg?resize=1204%3A803&crop=1200%3A464%3B1%2C108	1	99	0	0	0	de-zhuang-hotpot-cbd	https://www.zomato.com/sydney/de-zhuang-hotpot-cbd	Takeaway Available,No Alcohol Available,Table booking for Groups,Available for Functions,Split Bills,Group Bookings Available,Group Meal,Indoor Seating,Table booking recommended,Pram Friendly,Kid Friendly,Wifi,Vegetarian Friendly,Parking available 98 metres away	\N	(151.207563802599992,-33.8768620274000014)
68666	Blue Pearl	+61	(02) 9997 8918	\N	2455	1	https://b.zmtcdn.com/data/reviews_photos/407/1266ecb2012767e2861d776db9e9b407.jpg?resize=1204%3A903&crop=1200%3A464%3B0%2C149	1	99	0	0	0	blue-pearl-bayview	https://www.zomato.com/sydney/blue-pearl-bayview	Takeaway Available,Indoor Seating,Gluten Free Options,Waterfront,Vegan Options,Vegetarian Friendly,Outdoor Seating	60	(151.297975000000008,-33.6591027778000011)
70680	Les Wadham Oysters - Broken Bay Pacific Oysters	+61	(02) 9985 9704	\N	162	1	https://b.zmtcdn.com/data/res_imagery/16563369_RESTAURANT_2cc7a3f8ca504fd37c2f4e6b1ecf6028.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	les-wadham-oysters-broken-bay-pacific-oysters-brooklyn	https://www.zomato.com/sydney/les-wadham-oysters-broken-bay-pacific-oysters-brooklyn	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Table booking recommended	\N	(151.202610433100006,-33.5279669764999966)
70682	Palm Beach Paradise Cafe	+61	(02) 8407 1784	\N	216	1	https://b.zmtcdn.com/data/res_imagery/15545586_RESTAURANT_45c9780f63850bb7d4a043d51dac099d.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	palm-beach-paradise-cafe-palm-beach	https://www.zomato.com/sydney/palm-beach-paradise-cafe-palm-beach	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Outdoor Seating,Kid Friendly,Pet Friendly,Brunch	40	(151.324344999999994,-33.5971449999999976)
68663	Pennant Hills Cafe	+61	(02) 9980 9901	\N	247	1	https://b.zmtcdn.com/data/reviews_photos/79c/a7f9d09e380a8ef5ac6ccaba836e379c_1504761264.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	pennant-hills-cafe-pennant-hills	https://www.zomato.com/sydney/pennant-hills-cafe-pennant-hills	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Kid Friendly,Outdoor Seating,Brunch	25	(151.070257164499992,-33.7382127071999989)
68681	Sea Cow	+61	(02) 9332 2458	\N	12	1	https://b.zmtcdn.com/data/res_imagery/16558955_RESTAURANT_c665933d8c4ced28389dee59b5e1a6d4.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	sea-cow-darlinghurst	https://www.zomato.com/sydney/sea-cow-darlinghurst	No Alcohol Available,Indoor Seating	50	(151.222613342100004,-33.8756700866999978)
70684	Gao Thai	+61	(02) 9008 5413	\N	470	1	\N	1	99	0	0	0	gao-thai-penshurst	https://www.zomato.com/sydney/gao-thai-penshurst	Home Delivery,Takeaway Available,No Alcohol Available,Indoor Seating	70	(151.088596098099998,-33.9670368032000027)
68770	5th Season Cafe	+61	0422 451 379	\N	2924	1	https://b.zmtcdn.com/data/res_imagery/16716980_RESTAURANT_c04017f03c33fcb1b3ccae52bb50b2f8.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	5th-season-cafe-cronulla	https://www.zomato.com/sydney/5th-season-cafe-cronulla	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Vegetarian Friendly,Outdoor Seating,Gluten Free Options,Brunch	40	(151.1528500915,-34.0523185795999979)
68725	Pisco Sour	+61	(02) 8399 3351	\N	21	1	https://b.zmtcdn.com/data/res_imagery/16570291_RESTAURANT_e9654a213476009402f6d09d28b4620f_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	pisco-sour-chippendale	https://www.zomato.com/sydney/pisco-sour-chippendale	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Vegan Options,Kid Friendly,Desserts and Bakes,Indoor Seating,Wifi,Brunch,All Day Breakfast	45	(151.199903748899999,-33.8876997957000015)
65531	Kingswood Coffee	+61	0447 777 567	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16569475_RESTAURANT_949cf2effe43028f8080e1267ff3c654.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	kingswood-coffee-cbd	https://www.zomato.com/sydney/kingswood-coffee-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Wifi,Vegetarian Friendly,Brunch,Parking available 298 metres away	25	(151.206223368600007,-33.8775011367999994)
68739	Tuk Tuk	+61	(02) 9361 3575	\N	41	1	https://b.zmtcdn.com/data/res_imagery/16714761_RESTAURANT_55742eff59d9e966fb236ea9329540ba.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	tuk-tuk-paddington	https://www.zomato.com/sydney/tuk-tuk-paddington	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Gluten Free Options,Desserts and Bakes,Pet Friendly,Brunch,Outdoor Seating,Indoor Seating,Vegetarian Friendly	35	(151.228413954399997,-33.8827546796999997)
68799	Pameer Restaurant & Bakery	+61	(02) 8678 5686	\N	309	1	https://b.zmtcdn.com/data/res_imagery/15543846_RESTAURANT_0dd2adb60a88c081390d245ae5a40d1e.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	pameer-restaurant-bakery-blacktown	https://www.zomato.com/sydney/pameer-restaurant-bakery-blacktown	Home Delivery,Takeaway Available,No Alcohol Available,Shisha,Live Sports Screening,Outdoor Seating,Indoor Seating,Table Reservation Not Required	45	(150.910231210299997,-33.7710513784999975)
68824	Aunty Eight's Vietnamese - Revesby Workers'	+61	(02) 9772 2100	\N	442	1	https://b.zmtcdn.com/data/reviews_photos/1b8/697fb4fb48913f75c16dfc6ab0f1e1b8_1486546304.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	aunty-eights-vietnamese-revesby-workers-revesby	https://www.zomato.com/sydney/aunty-eights-vietnamese-revesby-workers-revesby	Takeaway Available,No Alcohol Available,Table Reservation Not Required,Indoor Seating	45	(151.01392899999999,-33.9533860000000018)
65551	Charing Cross Hotel	+61	(02) 9389 3093	\N	43	1	https://b.zmtcdn.com/data/res_imagery/16562958_RESTAURANT_f92949aba00cbaf60c8740dd93132978_c.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	charing-cross-hotel-queens-park	https://www.zomato.com/sydney/charing-cross-hotel-queens-park	Wheelchair Accessible,Full Bar Available,Live Music,Live Sports Screening,Outdoor Seating,Nightlife,Indoor Seating,Gluten Free Options,Kid Friendly,Vegetarian Friendly	100	(151.254112198999991,-33.901034899199999)
68785	Bamboo Box	+61	(02) 4782 6998	\N	2191	1	https://b.zmtcdn.com/data/pictures/9/15546579/18e129525f9a0cecd42fda77b16327cd.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	bamboo-box-katoomba	https://www.zomato.com/sydney/bamboo-box-katoomba	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Gluten Free Options,Vegetarian Friendly,Indoor Seating,Vegan Options,Lunch Menu	40	(150.311696603900003,-33.7132195861999975)
68788	Boschetto Cafe	+61	(02) 9599 0603	\N	451	1	\N	1	99	0	0	0	boschetto-cafe-rockdale	https://www.zomato.com/sydney/boschetto-cafe-rockdale	Breakfast,Takeaway Available,Wheelchair Accessible,Serves Alcohol,Wifi,Brunch,Vegan Options,Pet Friendly,Vegetarian Friendly,Outdoor Seating,Gluten Free Options	40	(151.138368509700001,-33.9516384319000011)
68860	Malaysian Noodle	+61	(02) 9568 4300	\N	79	1	https://b.zmtcdn.com/data/reviews_photos/ca6/fd3d15504da9fcd0106dc462651b7ca6.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	malaysian-noodle-leichhardt	https://www.zomato.com/sydney/malaysian-noodle-leichhardt	Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly	40	(151.147743500800004,-33.8841035025999986)
68801	De Nero's Cafe	+61	(02) 9697 9491	\N	61	1	\N	1	99	0	0	0	de-neros-cafe-kingsford	https://www.zomato.com/sydney/de-neros-cafe-kingsford	Breakfast,Takeaway Available,Brunch,Kid Friendly,Desserts and Bakes,Outdoor Seating,Indoor Seating,Gluten Free Options	30	(151.227204278100004,-33.9234290388000019)
70743	Loc Highway Hot Bread and Cafe	+61	(02) 4739 2058	\N	2176	1	https://b.zmtcdn.com/data/pictures/6/15546626/4eb6db79329e31de45774df4f3960a51.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	loc-highway-hot-bread-and-cafe-blaxland	https://www.zomato.com/sydney/loc-highway-hot-bread-and-cafe-blaxland	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes,Brunch	15	(150.60985799880001,-33.7440243094999985)
62438	Borrelli's	+61	(02) 9876 6563	\N	250	1	https://b.zmtcdn.com/data/reviews_photos/7be/95ff3f341c768bc2179fc38f352457be_1492305953.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	borrellis-epping	https://www.zomato.com/sydney/borrellis-epping	Home Delivery,Takeaway Available,Full Bar Available,Indoor Seating,Table booking recommended	120	(151.08158413320001,-33.7740554704000004)
68915	The Balkan Butler	+61	(02) 8084 1514	\N	13	1	https://b.zmtcdn.com/data/pictures/7/18935907/9fa430b40ef122b48508dd09c59f68e9.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=15&cropoffsety=510&cropgravity=NorthWest	1	99	0	0	0	the-balkan-butler-surry-hills	https://www.zomato.com/sydney/the-balkan-butler-surry-hills	Breakfast,Takeaway Available,No Alcohol Available,Vegetarian Friendly,Indoor Seating,Brunch,Outdoor Seating,Desserts and Bakes	35	(151.209642179300005,-33.8838385271999982)
68885	Mirchi	+61	(02) 9262 9080	\N	2449	1	https://b.zmtcdn.com/data/reviews_photos/b6b/c5f0e90acf23aca36477e7bd1b4cbb6b_1491640188.jpg?resize=1204%3A1605&crop=1200%3A464%3B-8%2C850	1	99	0	0	0	mirchi-cbd	https://www.zomato.com/sydney/mirchi-cbd	Takeaway Available,No Alcohol Available,Indoor Seating,Outdoor Seating,Parking available 133 metres away	30	(151.207218803500012,-33.8770774768999985)
70768	Little Deli Co	+61	(02) 8021 7378	\N	431	1	https://b.zmtcdn.com/data/pictures/5/15546415/6ecf5a6b4267d4214d6b40d36f56cc2c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	little-deli-co-bexley	https://www.zomato.com/sydney/little-deli-co-bexley	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Brunch,Indoor Seating	20	(151.126633510000005,-33.9495964895999975)
65586	Bellbird	+61	(02) 9824 1121	\N	17	1	https://b.zmtcdn.com/data/reviews_photos/f3e/4f660ff9cb7f146b4232992e3d3bff3e_1518435218.JPG?impolicy=newfitandcrop&fittype=ignore&fitw=1203&fith=964&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=180&cropgravity=NorthWest	1	99	0	0	0	bellbird-casula	https://www.zomato.com/sydney/bellbird-casula	Breakfast,Takeaway Available,Serves Alcohol,Indoor Seating,Brunch	30	(150.912625081800002,-33.9495094375999997)
70866	i WOK	+61	(02) 9281 8870	\N	5	1	https://b.zmtcdn.com/data/reviews_photos/6b3/f427ccc0e42e41737c281fedf149e6b3_1452291201.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	i-wok-haymarket	https://www.zomato.com/sydney/i-wok-haymarket	Breakfast,Home Delivery,Takeaway Available,Wheelchair Accessible,Table booking not available,No Alcohol Available,Outdoor Seating,Vegetarian Friendly,Vegan Options,Kid Friendly,Split Bills	20	(151.204255297799989,-33.8842693902999983)
70856	Botany Charcoal Chicken	+61	(02) 9666 6131	\N	2457	1	https://b.zmtcdn.com/data/pictures/4/16716564/fa70717ced2824c7cb35dd7ad5713eb7.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	botany-charcoal-chicken-botany	https://www.zomato.com/sydney/botany-charcoal-chicken-botany	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Vegetarian Friendly	35	(151.196566075100009,-33.9443479002000004)
70908	The Corner Grind	+61	0426 707 968	\N	434	1	https://b.zmtcdn.com/data/pictures/2/15543002/0ffd55846fd7e92776c41a58b52bdc19.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	corner-coffee-house-beverly-hills	https://www.zomato.com/sydney/corner-coffee-house-beverly-hills	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Gluten Free Options,Indoor Seating,Wifi,Outdoor Seating,Vegan Options	20	(151.081508360800001,-33.9482389686000019)
65633	Cucina 105	+61	(02) 9602 1300	\N	371	1	https://b.zmtcdn.com/data/res_imagery/16557661_RESTAURANT_a7060a039a0d5b0e7bb09f740af058aa_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cucina-105-liverpool	https://www.zomato.com/sydney/cucina-105-liverpool	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,Indoor Seating,Vegan Options,Kid Friendly,Outdoor Seating,Vegetarian Friendly,Table booking recommended,Gluten Free Options	100	(150.9222387895,-33.9225652022999995)
71529	The Grillhouse at Pendle	+61	(02) 9631 8395	\N	298	1	\N	1	99	0	0	0	the-grillhouse-at-pendle-pendle-hill	https://www.zomato.com/sydney/the-grillhouse-at-pendle-pendle-hill	Full Bar Available,Table Reservation Not Required,Indoor Seating	50	(150.956916064000012,-33.8007897264999997)
65675	Ashin	+61	(02) 9787 2800	\N	412	1	https://b.zmtcdn.com/data/res_imagery/16564547_CHAIN_6f3a7a5c8a969a8219be570f5c552a9a_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	ashin-campsie	https://www.zomato.com/sydney/ashin-campsie	Takeaway Available,Full Bar Available,Indoor Seating,Table Reservation Not Required,Vegetarian Friendly,Gluten Free Options	55	(151.103824004500012,-33.9090865486000013)
68934	The Village Penrith NSW	+61	(02) 4721 1155	\N	2098	1	https://b.zmtcdn.com/data/pictures/0/17743760/c8c087be0564046c8af71ee7bf328b50.jpg?resize=1246%3A831&crop=1200%3A464%3B19%2C354	1	99	0	0	0	the-village-penrith-nsw-penrith	https://www.zomato.com/sydney/the-village-penrith-nsw-penrith	Breakfast,Full Bar Available,Serves Cocktails,Indoor Seating,Brunch,Available for Functions,Table booking recommended,High Tea	60	(150.701026283200008,-33.7532214212999975)
59015	Chisolm's Restaurant	+61	(02) 6359 3911	\N	2657	1	https://b.zmtcdn.com/data/res_imagery/16565032_RESTAURANT_119ffd54a3b648b5b10a120361d0aa61.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	chisolms-restaurant-jenolan	https://www.zomato.com/sydney/chisolms-restaurant-jenolan	Breakfast,Takeaway Available,No Alcohol Available,Outdoor Seating,Buffet,Indoor Seating,Table booking recommended	110	(150.021580099999994,-33.820591499999999)
70990	Yummy Charcoal Chicken	+61	(02) 9625 2547	\N	2167	1	https://b.zmtcdn.com/data/reviews_photos/32d/63fc7d757233ea9faa5de3212549d32d_1510203268.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	yummy-charcoal-chicken-mount-druitt	https://www.zomato.com/sydney/yummy-charcoal-chicken-mount-druitt	Takeaway Available,No Alcohol Available,Indoor Seating	45	(150.823877826299992,-33.7660337332999987)
65691	Toco Fresh	+61	(02) 8765 0850	\N	272	1	https://b.zmtcdn.com/data/res_imagery/16568305_RESTAURANT_052f7459d22b2769e6322385f7a5735e.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	toco-fresh-concord	https://www.zomato.com/sydney/toco-fresh-concord	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Pet Friendly,Vegetarian Friendly,Brunch,Gluten Free Options,Outdoor Seating,Vegan Options,Indoor Seating	35	(151.103347912400011,-33.8554624613000001)
65729	Cafe Madame Frou Frou	+61	(02) 9518 6230	\N	9	1	https://b.zmtcdn.com/data/res_imagery/16564738_CHAIN_9fbf8bd56fff2192955c946da5deacda.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	cafe-madame-frou-frou-glebe	https://www.zomato.com/sydney/cafe-madame-frou-frou-glebe	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Gluten Free Options,Outdoor Seating,Vegan Options,Kid Friendly,Indoor Seating,Vegetarian Friendly,Brunch,Pet Friendly,Desserts and Bakes	40	(151.183831952499986,-33.875579897199998)
68921	Lina's Kitchen	+61	(02) 9580 1523	\N	434	1	https://b.zmtcdn.com/data/reviews_photos/3cb/1b5fffe126a5179c2d3a5150c33173cb_1508055428.jpg?resize=1204%3A858&crop=1200%3A464%3B-2%2C167	1	99	0	0	0	linas-kitchen-1-beverly-hills	https://www.zomato.com/sydney/linas-kitchen-1-beverly-hills	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	45	(151.080769076899998,-33.9496571200999995)
68923	Thai Sensation	+61	0422 128 191	\N	354	1	https://b.zmtcdn.com/data/pictures/3/16567753/dc722f50a97c40549b87f413a0639238.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	thai-sensation-cabramatta	https://www.zomato.com/sydney/thai-sensation-cabramatta	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly	40	(150.937409363699999,-33.8940305841000011)
68948	The Occidental Bistro	+61	(02) 9299 2531	\N	2449	1	https://b.zmtcdn.com/data/pictures/chains/9/16560279/df160b1ba244be73859961d167890444.jpg?resize=1204%3A1219&crop=1200%3A464%3B0%2C307	1	99	0	0	0	the-occidental-bistro-cbd	https://www.zomato.com/sydney/the-occidental-bistro-cbd	Takeaway Available,Wheelchair Accessible,Full Bar Available,Live Sports Screening,Live Music,Outdoor Seating,Nightlife,Parking available 176 metres away	40	(151.205691285400007,-33.8667185867999976)
68970	Teo's On Oxford	+61	(02) 9605 9555	\N	1697	1	\N	1	99	0	0	0	teos-on-oxford-ingleburn	https://www.zomato.com/sydney/teos-on-oxford-ingleburn	Breakfast,Takeaway Available,Wine and Beer,Gluten Free Options,Kid Friendly,Outdoor Seating	30	(150.865988843100013,-33.9987024317000035)
68983	Green Bean Espresso	+61	(02) 9299 9547	\N	2773	1	https://b.zmtcdn.com/data/res_imagery/16714080_RESTAURANT_3ec5dfcaaf46cc4261b7eaddda516e61.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	green-bean-espresso-cbd	https://www.zomato.com/sydney/green-bean-espresso-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,Wine,BYO,Pet Friendly,Vegan Options,Outdoor Seating,Gluten Free Options,Live Sports Screening,Brunch,Wifi,Vegetarian Friendly,Parking available 282 metres away	60	(151.206566691400013,-33.8664875213000016)
71026	Mafi Metlo Bakery	+61	(02) 9687 8804	\N	336	1	https://b.zmtcdn.com/data/reviews_photos/3dc/6dcce6d60cb938f9a85c3c9237b2f3dc_1443601823.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	mafi-metlo-bakery-merrylands	https://www.zomato.com/sydney/mafi-metlo-bakery-merrylands	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Desserts and Bakes,Outdoor Seating	25	(150.98320540040001,-33.8271126153000026)
71071	Yogi Asian Fusion Restaurant	+61	(02) 8057 8047	\N	281	1	https://b.zmtcdn.com/data/pictures/1/17742191/9b1f30021b1eb9b2162a3fba91292f6a.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	yogi-asian-fusion-restaurant-lidcombe	https://www.zomato.com/sydney/yogi-asian-fusion-restaurant-lidcombe	Breakfast,Wheelchair Accessible,No Alcohol Available,Indoor Seating	40	(151.045395098600011,-33.8607777758000026)
71038	Deep-Sea Food	+61	(02) 9939 8777	\N	2462	1	https://b.zmtcdn.com/data/pictures/0/16714920/31ef5695f9f2446f7592ee270eb440d7.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	deep-sea-food-freshwater	https://www.zomato.com/sydney/deep-sea-food-freshwater	Breakfast,Takeaway Available,BYO,Outdoor Seating	45	(151.284443288999995,-33.7790336309000025)
65734	Easy Lane	+61	(02) 4587 6900	\N	2126	1	https://b.zmtcdn.com/data/res_imagery/18256769_RESTAURANT_0d5ce54f31f1c0cbafe60838aa936e68.JPG?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	easy-lane-south-windsor	https://www.zomato.com/sydney/easy-lane-south-windsor	Breakfast,Full Bar Available,Table Reservation Not Required,Vegetarian Friendly,Indoor Seating	70	(150.810584000000006,-33.618267000000003)
71108	Picadilly Cafe	+61	(02) 9331 4329	\N	41	1	https://b.zmtcdn.com/data/pictures/7/16567907/f464c1658d50830b284b825426f2e64e.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=903&cropw=1200&croph=464&cropoffsetx=6&cropoffsety=196&cropgravity=NorthWest	1	99	0	0	0	picadilly-cafe-paddington	https://www.zomato.com/sydney/picadilly-cafe-paddington	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Brunch,Desserts and Bakes,Vegetarian Friendly,Kid Friendly,Gluten Free Options	30	(151.232393011499994,-33.8885261340000028)
71112	Texas Charcoal Chicken	+61	(02) 9713 4853	\N	94	1	\N	1	99	0	0	0	texas-charcoal-chicken-five-dock	https://www.zomato.com/sydney/texas-charcoal-chicken-five-dock	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating	30	(151.129907816700012,-33.8688671883000012)
71128	Fresca	+61	(02) 9358 6670	\N	26	1	\N	1	99	0	0	0	fresca-potts-point	https://www.zomato.com/sydney/fresca-potts-point	Breakfast,Takeaway Available,Wheelchair Accessible,Table booking not available,No Alcohol Available,Gluten Free Options,Indoor Seating,Kid Friendly,Vegetarian Friendly,Vegan Options	25	(151.222983822200007,-33.8747979720000032)
65766	Photown	+61	(02) 9690 0718	\N	29	1	https://b.zmtcdn.com/data/reviews_photos/a17/477d530052015af227374d08870e2a17_1502879546.jpg?resize=1204%3A963&crop=1200%3A464%3B0%2C179	1	99	0	0	0	photown-alexandria	https://www.zomato.com/sydney/photown-alexandria	Breakfast,Takeaway Available,BYO,Outdoor Seating,Kid Friendly,Indoor Seating,Vegetarian Friendly,Table Reservation Not Required	30	(151.198198869799995,-33.9026285934000029)
71183	Strathfield Superbowl	+61	(02) 9642 5500	\N	267	1	\N	1	99	0	0	0	strathfield-superbowl-strathfield-south	https://www.zomato.com/sydney/strathfield-superbowl-strathfield-south	Breakfast,Takeaway Available,Wheelchair Accessible,Wine and Beer,Outdoor Seating	45	(151.079666018500006,-33.8904657292000024)
65789	Chinese Noodle Bar	+61	(02) 9282 9570	\N	5	1	https://b.zmtcdn.com/data/res_imagery/16564607_RESTAURANT_51b568a52764e8d11f43350e5924442e_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	chinese-noodle-bar-haymarket	https://www.zomato.com/sydney/chinese-noodle-bar-haymarket	Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly,Parking available 242 metres away	30	(151.204848066000011,-33.8815071526000011)
71248	Pancho's Mexican Restaurant	+61	(02) 9534 2170	\N	438	1	https://b.zmtcdn.com/data/pictures/4/18953614/2677042469f5f51175069f919854a881.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=803&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=158&cropgravity=NorthWest	1	99	0	0	0	panchos-mexican-restaurant-riverwood-southern-sydney	https://www.zomato.com/sydney/panchos-mexican-restaurant-riverwood-southern-sydney	Takeaway Available,No Alcohol Available,Indoor Seating,Table Reservation Not Required	70	(151.051707342300006,-33.9542120660999984)
59288	Penny's Cheese Shop	+61	(02) 8591 4754	\N	26	1	https://b.zmtcdn.com/data/pictures/1/17746111/da1529433d4e30b5c667661151e6fbbd.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1219&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=307&cropgravity=NorthWest	1	99	0	0	0	pennys-cheese-shop-potts-point	https://www.zomato.com/sydney/pennys-cheese-shop-potts-point	Breakfast,Takeaway Available,Indoor Seating,Parking available 145 metres away	25	(151.224990449899991,-33.8738637722000036)
65834	Pho Mumum	+61	(02) 9280 1838	\N	8	1	https://b.zmtcdn.com/data/res_imagery/16564286_RESTAURANT_a260443f55388f44f698baefb6af0f90.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	pho-mumum-ultimo	https://www.zomato.com/sydney/pho-mumum-ultimo	Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Indoor Seating,Table Reservation Not Required,Vegetarian Friendly	40	(151.201764196200003,-33.8842752353000023)
59358	Don Adan Coffee House	+61	(02) 9968 2828	\N	173	1	https://b.zmtcdn.com/data/reviews_photos/328/e7f09a4d5af03ce2a126b401b0717328.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	don-adan-coffee-house-mosman	https://www.zomato.com/sydney/don-adan-coffee-house-mosman	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Brunch,Desserts and Bakes	40	(151.241648979500013,-33.824154671499997)
71382	Moorebank Chinese Takeaway	+61	(02) 9821 4861	\N	374	1	\N	1	99	0	0	0	moorebank-chinese-takeaway-moorebank	https://www.zomato.com/sydney/moorebank-chinese-takeaway-moorebank	Home Delivery,Takeaway Available,Seating Not Available,No Alcohol Available,Vegetarian Friendly	30	(150.948934815799987,-33.9325834985000014)
71376	Georgetown Fusion	+61	0401 383 086	\N	2449	1	https://b.zmtcdn.com/data/pictures/3/16714203/aea2be583a6919c72315b0395b7fd83f.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	georgetown-fusion-cbd	https://www.zomato.com/sydney/georgetown-fusion-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Brunch,Gluten Free Options,Indoor Seating,Vegetarian Friendly,Kid Friendly,Parking available 166 metres away	30	(151.207952722899989,-33.8657609134000026)
71439	The Old Tab Cafe	+61	0449 699 738	\N	412	1	https://b.zmtcdn.com/data/pictures/9/15543439/110468418f1d9de824410bc5d31328e7.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	the-old-tab-cafe-campsie	https://www.zomato.com/sydney/the-old-tab-cafe-campsie	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Outdoor Seating,Kid Friendly,Desserts and Bakes,Brunch,Indoor Seating	25	(151.103060916099992,-33.9116116630999969)
65876	Viet	+61	(02) 9211 5081	\N	21	1	https://b.zmtcdn.com/data/res_imagery/15547061_RESTAURANT_63a3b3d9e94ed9b981ba189c2cdfa1f1.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	viet-1-chippendale	https://www.zomato.com/sydney/viet-1-chippendale	Takeaway Available,Full Bar Available,Vegetarian Friendly,Indoor Seating,Outdoor Seating,Lunch Menu,Table Reservation Not Required	70	(151.202157810300008,-33.8848928576000006)
65890	Pizza Pasta Bene	+61	(02) 8188 2097	\N	108	1	https://b.zmtcdn.com/data/pictures/chains/1/15543081/f64e291888c5af7c4273be6db6bd41c0.jpg?resize=1207%3A806&crop=1200%3A464%3B2%2C126	1	99	0	0	0	pizza-pasta-bene-north-sydney	https://www.zomato.com/sydney/pizza-pasta-bene-north-sydney	Home Delivery,Takeaway Available,Wheelchair Accessible,Full Bar Available,Dairy Free,Garden,Wine Tasting,Vegan Options,Outdoor Seating,Craft Beer,Farm-to-Table,Free Parking,Indoor Seating,Serves Cocktails,Vegetarian Friendly,Gluten Free Options,Shared Plates,Wine Cellar,Table Reservation Not Required	80	(151.207254007500012,-33.8349473294999967)
65905	Pier 8 Cafe	+61	(02) 9241 2479	\N	15	1	https://b.zmtcdn.com/data/reviews_photos/a50/f8d5c0444edc540a9fe927a11e23ba50.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	pier-8-cafe-millers-point	https://www.zomato.com/sydney/pier-8-cafe-millers-point	Breakfast,Home Delivery,Takeaway Available,Full Bar Available,Vegetarian Friendly,Brunch,Kid Friendly,Indoor Seating,Waterfront,Outdoor Seating,Parking available 179 metres away	50	(151.203796640000007,-33.8561922194000005)
71475	Xtract Coffee	+61	(02) 8668 4087	\N	451	1	https://b.zmtcdn.com/data/res_imagery/16715843_RESTAURANT_043c36d68a2071bede88dc734d659b41.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	xtract-coffee-rockdale	https://www.zomato.com/sydney/xtract-coffee-rockdale	Breakfast,Takeaway Available,No Alcohol Available,Brunch,Pet Friendly,Vegetarian Friendly,Outdoor Seating,Gluten Free Options	30	(151.135029830000008,-33.951536085699999)
71483	Ellie May's Nook	+61	(02) 8068 6559	\N	111	1	https://b.zmtcdn.com/data/pictures/1/17747531/f45e2740b7d18a8d3da96d41f3812277.jpg?resize=1204%3A1505&crop=1200%3A464%3B-5%2C609	1	99	0	0	0	ellie-mays-nook-cammeray	https://www.zomato.com/sydney/ellie-mays-nook-cammeray	Breakfast,Takeaway Available,No Alcohol Available,Desserts and Bakes,Indoor Seating,Table Reservation Not Required,Kid Friendly,Brunch,Outdoor Seating,Pet Friendly	45	(151.20950941000001,-33.8230753586000006)
65898	Taste Of Cho	+61	\N	\N	5	1	https://b.zmtcdn.com/data/reviews_photos/944/326fe92d227edef499bdbbb77a8c5944_1435492303.jpg?resize=1204%3A1204&crop=1200%3A464%3B3%2C646	1	99	0	0	0	taste-of-cho-haymarket	https://www.zomato.com/sydney/taste-of-cho-haymarket	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Wifi,Parking available 123 metres away	30	(151.203607544300013,-33.8798320641000004)
71535	Calypso Bakery Cafe	+61	0425 882 620	\N	298	1	\N	1	99	0	0	0	calypso-bakery-cafe-pendle-hill	https://www.zomato.com/sydney/calypso-bakery-cafe-pendle-hill	Breakfast,No Alcohol Available,Indoor Seating,Kid Friendly	\N	(150.958015099199997,-33.7987360919999986)
59523	Classroom 48	+61	\N	\N	2887	1	https://b.zmtcdn.com/data/pictures/5/17746805/846bae1b35825553454ce548c3286ea7.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1204&fith=1204&cropw=1200&croph=464&cropoffsetx=3&cropoffsety=460&cropgravity=NorthWest	1	99	0	0	0	classroom-48-manly	https://www.zomato.com/sydney/classroom-48-manly	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Gluten Free Options,Brunch,Desserts and Bakes,Outdoor Seating,Vegan Options,Vegetarian Friendly	45	(151.284997835799999,-33.7993866516999972)
65918	An Viet	+61	(02) 9415 4249	\N	2	1	https://b.zmtcdn.com/data/reviews_photos/892/a28875fd9d856361abc8131a8d1a9892_1538087997.jpg?resize=1203%3A902&crop=1200%3A464%3B0%2C148	1	99	0	0	0	an-viet-chatswood	https://www.zomato.com/sydney/an-viet-chatswood	Takeaway Available,Wine and Beer,Corkage Fee Charged,Kid Friendly,Pram Friendly,Indoor Seating,Table Reservation Not Required,BYO Cake,Vegetarian Friendly,Outdoor Seating	75	(151.183924824000002,-33.7966389433999979)
71632	Central Hotel	+61	(02) 8814 9200	\N	309	1	\N	1	99	0	0	0	central-hotel-blacktown	https://www.zomato.com/sydney/central-hotel-blacktown	Full Bar Available,Indoor Seating,Nightlife,Outdoor Seating,Live Sports Screening	45	(150.908719785500011,-33.7694150948999976)
65980	Three Lanes and Seven Alleys	+61	(02) 9281 7770	\N	5	1	https://b.zmtcdn.com/data/res_imagery/16569703_RESTAURANT_e6b13c14167dd0f5065cc749e1d5be85_c.jpg?impolicy=newfitandcrop&fittype=ignore&fitw=1200&fith=464&cropw=1200&croph=464&cropoffsetx=0&cropoffsety=0&cropgravity=Center	1	99	0	0	0	three-lanes-and-seven-alleys-haymarket	https://www.zomato.com/sydney/three-lanes-and-seven-alleys-haymarket	Home Delivery,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Table booking recommended,Vegan Options,Vegetarian Friendly	50	(151.20407894249999,-33.8780489410999976)
65970	Shanghai Chef Kitchen	+61	(02) 9687 4332	\N	255	1	https://b.zmtcdn.com/data/res_imagery/16560121_RESTAURANT_32cf5275f176dbed7c113df0017c8759_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	shanghai-chef-kitchen-parramatta	https://www.zomato.com/sydney/shanghai-chef-kitchen-parramatta	Breakfast,Takeaway Available,No Alcohol Available,Indoor Seating,Parking available 178 metres away	40	(151.003662608599996,-33.8184791436000012)
65979	Alpha sushi	+61	(02) 9635 1160	\N	255	1	https://b.zmtcdn.com/data/reviews_photos/1c9/9cf4544056a9d9186e19bb8809b0e1c9_1501591396.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	alpha-sushi-parramatta	https://www.zomato.com/sydney/alpha-sushi-parramatta	Takeaway Available,No Alcohol Available,Indoor Seating,Vegetarian Friendly	30	(151.004324443600012,-33.8124363649000017)
66004	Formaggi Ocello	+61	(02) 9357 7878	\N	13	1	https://b.zmtcdn.com/data/res_imagery/16562674_RESTAURANT_ef1761cbe118b579124473fc37ea9f18.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	formaggi-ocello-surry-hills	https://www.zomato.com/sydney/formaggi-ocello-surry-hills	Wheelchair Accessible,Wine,Indoor Seating,Gluten Free Options,Wine Tasting,Outdoor Seating,Vegetarian Friendly,Wine Cellar,Available for Functions	50	(151.216098591699989,-33.8830449873999981)
66015	Noodles Your Way	+61	(02) 9283 8688	\N	2449	1	https://b.zmtcdn.com/data/res_imagery/16562954_RESTAURANT_37754c05471eac4e8863f04c05b80c08.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	noodles-your-way-cbd	https://www.zomato.com/sydney/noodles-your-way-cbd	Takeaway Available,Vegetarian Friendly,Gluten Free Options,Indoor Seating	40	(151.206762492699994,-33.8773455353000017)
66058	Loaves and the Dishes	+61	(02) 4784 3600	\N	2192	1	https://b.zmtcdn.com/data/res_imagery/16558357_RESTAURANT_f85d27a131d2c7b7467b34b2a8f6491f_c.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	loaves-and-the-dishes-leura	https://www.zomato.com/sydney/loaves-and-the-dishes-leura	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Kid Friendly,Gluten Free Options,Vegetarian Friendly,Brunch,Outdoor Seating,Vegan Options,Desserts and Bakes	40	(150.331060476599987,-33.7140066142000023)
66077	Taste Baguette Centrepoint	+61	(02) 8318 2299	\N	2449	1	https://b.zmtcdn.com/data/pictures/chains/7/16542027/15c44a14e574f62b4277f0d75fcc4506.jpg?resize=1203%3A871&crop=1200%3A464%3B-1%2C187	1	99	0	0	0	taste-baguette-centrepoint-cbd	https://www.zomato.com/sydney/taste-baguette-centrepoint-cbd	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Lunch Menu,Catering Available,Kid Friendly,Wifi,Dairy Free,Vegetarian Friendly,All Day Breakfast,Brunch,Desserts and Bakes,Indoor Seating,Available for Functions,Pram Friendly,Gluten Free Options,Parking available 254 metres away	30	(151.209272369699988,-33.8706351923)
62711	Al Pacino's Pizza & Italian Cuisine	+61	(02) 9806 9669	\N	336	1	https://b.zmtcdn.com/data/reviews_photos/4e2/c6d80add53f19d24d39e81955a4dd4e2_1484286178.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	al-pacinos-pizza-italian-cuisine-merrylands	https://www.zomato.com/sydney/al-pacinos-pizza-italian-cuisine-merrylands	Home Delivery,Takeaway Available,No Alcohol Available,Outdoor Seating,Indoor Seating,Table Reservation Not Required	35	(150.982762165400004,-33.8268574896999965)
62755	Subway	+61	(02) 9420 0056	\N	119	1	https://b.zmtcdn.com/data/res_imagery/15543035_CHAIN_0ab22d8a8193aa2116aa917e26ef5786.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B0%2C0	1	99	0	0	0	subway-1-lane-cove	https://www.zomato.com/sydney/subway-1-lane-cove	Breakfast,Home Delivery,Takeaway Available,Kid Friendly,Vegetarian Friendly,Indoor Seating	30	(151.149985492199988,-33.8108727441000028)
71569	Pei Jie Hotpot 珮姊老火鍋	+61	(02) 9212 0050	\N	5	1	https://b.zmtcdn.com/data/pictures/8/17747848/e54daff2e9c7d204a3edebb59dd8ca7d.jpg?resize=1204%3A643&crop=1200%3A464%3B1%2C81	1	99	0	0	0	pei-jie-hotpot-haymarket	https://www.zomato.com/sydney/pei-jie-hotpot-haymarket	Wine,BYO,Split Bills,Group Bookings Available,Vegetarian Friendly,Indoor Seating,Table booking recommended,Kid Friendly,Group Meal,Nightlife,Parking available 278 metres away	\N	(151.204478999999992,-33.8790819999999968)
71589	Ryan's Gourmet Kitchen	+61	(02) 9481 9072	\N	249	1	https://b.zmtcdn.com/data/reviews_photos/d91/8c7b7cb50192f0e35e34334d8706fd91_1550561175.JPG?resize=1204%3A903&crop=1200%3A464%3B-4%2C167	1	99	0	0	0	ryans-gourmet-kitchen-westleigh	https://www.zomato.com/sydney/ryans-gourmet-kitchen-westleigh	No Alcohol Available,Indoor Seating,Table booking recommended,Kid Friendly,Vegetarian Friendly	35	(151.0690830275,-33.7196720546999984)
71591	Teresa's Siopao & Catering	+61	04 1696 0352	\N	309	1	https://b.zmtcdn.com/data/pictures/8/15547848/587c3a1c6de0cd1b0dd436e9d205f3ec.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	teresas-siopao-catering-doonside	https://www.zomato.com/sydney/teresas-siopao-catering-doonside	Breakfast,Takeaway Available,Wheelchair Accessible,No Alcohol Available,Indoor Seating,Outdoor Seating,Kid Friendly,Brunch	30	(150.869825072600008,-33.7633262065999986)
71612	Thai Flavour	+61	(02) 8824 4333	\N	2557	1	https://b.zmtcdn.com/data/pictures/4/17745814/4f3736d7e0ad5de54221f4b21cd8a2c8.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	thai-flavour-bella-vista	https://www.zomato.com/sydney/thai-flavour-bella-vista	Home Delivery,Takeaway Available,No Alcohol Available,Outdoor Seating,Vegetarian Friendly,Indoor Seating,Table Reservation Not Required	60	(150.945740975400014,-33.734199140100003)
71727	Fiji Style Desi Dhaba	+61	0403 692 511	\N	371	1	https://b.zmtcdn.com/data/pictures/0/15546020/b3995dc5d94e663fb09b71788a309214.jpg?fit=around%7C1200%3A464&crop=1200%3A464%3B%2A%2C%2A	1	99	0	0	0	fiji-style-desi-dhaba-liverpool	https://www.zomato.com/sydney/fiji-style-desi-dhaba-liverpool	Takeaway Available,No Alcohol Available,Indoor Seating,Kid Friendly,Vegetarian Friendly	40	(150.925540588800004,-33.9244987372999987)
\.


--
-- Data for Name: suburbs; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.suburbs (id, name, city_id, postcode, document, coords) FROM stdin;
5	Haymarket	1	2000	'haymarket':1	(-33.8807770000000019,151.202796000000006)
8	Ultimo	1	2007	'ultimo':1	(-33.8784160000000014,151.197271999999998)
9	Glebe	1	2037	'glebe':1	(-33.8808149999999983,151.187791000000004)
4	Bathurst	1	2795	'bathurst':1	(-33.4197800000000029,149.574257999999986)
3	Broken Hill	1	2880	'broken':1 'hill':2	(-31.9591929999999991,141.466613999999993)
1	Sydney CBD	1	2000	'cbd':2 'sydney':1	(-33.7948829999999987,151.268070999999992)
6	Town Hall	1	2000	'hall':2 'town':1	(-33.7948829999999987,151.268070999999992)
7	Chinatown	1	2000	'chinatown':1	(-33.7948829999999987,151.268070999999992)
102	Camperdown	1	2050	'camperdown':1	(-33.8886600000000016,151.177188000000001)
98	Drummoyne	1	2047	'drummoyn':1	(-33.8510559999999998,151.154541999999992)
423	Marrickville	1	2204	'marrickvill':1	(-33.9109229999999968,151.157186999999993)
433	Kingsgrove	1	2208	'kingsgrov':1	(-33.9394810000000007,151.098940999999996)
482	Miranda	1	2228	'miranda':1	(-34.0340139999999991,151.100427999999994)
484	Caringbah	1	2229	'caringbah':1	(-34.0431600000000003,151.123101999999989)
117	St Leonards	1	2065	'leonard':2 'st':1	(-33.8232479999999995,151.195504)
184	Manly	1	2095	'man':1	(-33.797144000000003,151.288039999999995)
203	Mona Vale	1	2103	'mona':1 'vale':2	(-33.6770700000000005,151.300316000000009)
250	Epping	1	2121	'ep':1	(-33.7725489999999979,151.08236500000001)
304	Seven Hills	1	2147	'hill':2 'seven':1	(-33.7754770000000022,150.934257000000002)
255	Parramatta	1	2124	'parramatta':1	(-33.8169570000000022,151.003451000000013)
314	Parramatta	1	2150	'parramatta':1	(-33.8169570000000022,151.003451000000013)
2135	St Marys	1	2760	'mari':2 'st':1	(-33.7667599999999979,150.774014999999991)
625	Silverwater	1	2264	'silverwat':1	(-33.101384000000003,151.561990000000009)
292	Auburn	1	2144	'auburn':1	(-33.8493220000000008,151.033421000000004)
374	Moorebank	1	2170	'moorebank':1	(-33.9338049999999996,150.953601999999989)
1697	Ingleburn	1	2565	'ingleburn':1	(-33.9987179999999967,150.866343999999998)
2259	The Rocks	1	2795	'rock':2	(-33.4250800000000012,149.424871999999993)
83	Balmain East	1	2041	'balmain':1 'east':2	(-33.8578329999999994,151.190597999999994)
955	Enmore	1	2350	'enmor':1	(-30.7215409999999984,151.731618999999995)
979	Enmore	1	2358	'enmor':1	(-30.7215409999999984,151.731618999999995)
89	Tempe	1	2044	'temp':1	(-33.9247769999999988,151.160746999999986)
92	Canada Bay	1	2046	'bay':2 'canada':1	(-33.863194,151.116398000000004)
99	Stanmore	1	2048	'stanmor':1	(-33.8973510000000005,151.165349999999989)
108	North Sydney	1	2060	'north':1 'sydney':2	(-33.8382649999999998,151.206480999999997)
111	Cammeray	1	2062	'cammeray':1	(-33.8219530000000006,151.210430000000002)
118	Wollstonecraft	1	2065	'wollstonecraft':1	(-33.8281580000000019,151.196620999999993)
124	Northwood	1	2066	'northwood':1	(-33.8297319999999999,151.177751000000001)
129	North Willoughby	1	2068	'north':1 'willoughbi':2	(-33.7930890000000019,151.195786999999996)
134	Roseville Chase	1	2069	'chase':2 'rosevill':1	(-33.7789020000000022,151.195195000000012)
142	West Pymble	1	2073	'pymbl':2 'west':1	(-33.7603829999999974,151.126037999999994)
146	Warrawee	1	2074	'warrawe':1	(-33.7228390000000005,151.126134000000008)
151	North Wahroonga	1	2076	'north':1 'wahroonga':2	(-33.7027039999999971,151.123178999999993)
157	Mount Kuring-gai	1	2080	'gai':4 'kure':3 'kuring-gai':2 'mount':1	(-33.6287289999999999,151.226791999999989)
164	Milsons Passage	1	2083	'milson':1 'passag':2	(-33.5189670000000035,151.176540999999986)
171	Forestville	1	2087	'forestvill':1	(-33.7620110000000011,151.214059999999989)
176	Cremorne Point	1	2090	'cremorn':1 'point':2	(-33.8444700000000012,151.228230999999994)
182	Manly Vale	1	2093	'man':1 'vale':2	(-33.7840360000000004,151.267314999999996)
185	Queenscliff	1	2096	'queenscliff':1	(-33.784595000000003,151.28781699999999)
192	North Curl Curl	1	2099	'curl':2,3 'north':1	(-33.761651999999998,151.295691000000005)
196	Oxford Falls	1	2100	'fall':2 'oxford':1	(-33.7301969999999969,151.248218000000008)
199	North Narrabeen	1	2101	'narrabeen':2 'north':1	(-33.7026609999999991,151.293621999999999)
209	Newport	1	2106	'newport':1	(-33.6598960000000034,151.309312000000006)
211	Whale Beach	1	2107	'beach':2 'whale':1	(-33.6142740000000018,151.330437999999987)
219	Woolwich	1	2110	'woolwich':1	(-33.8383930000000035,151.172535000000011)
225	Tennyson Point	1	2111	'point':2 'tennyson':1	(-33.8314480000000017,151.117286000000007)
229	Denistone East	1	2113	'deniston':1 'east':2	(-33.7971769999999978,151.097545999999994)
241	Dundas	1	2117	'dunda':1	(-33.7994050000000001,151.044188999999989)
244	Carlingford	1	2118	'carlingford':1	(-33.7829589999999982,151.047707000000003)
251	North Epping	1	2121	'ep':2 'north':1	(-33.7597769999999997,151.087741999999992)
258	Homebush Bay	1	2127	'bay':2 'homebush':1	(-33.8528299999999973,151.076186000000007)
688	Summer Hill	1	2287	'hill':2 'summer':1	(-32.478428000000001,151.519412999999986)
265	Croydon Park	1	2133	'croydon':1 'park':2	(-33.8952990000000014,151.108580999999987)
272	Concord	1	2137	'concord':1	(-33.8578570000000028,151.103501999999992)
276	Liberty Grove	1	2138	'grove':2 'liberti':1	(-33.841664999999999,151.083608999999996)
281	Lidcombe	1	2141	'lidcomb':1	(-33.8652179999999987,151.043519000000003)
283	Rosehill	1	2142	'rosehil':1	(-33.8199919999999992,151.024558000000013)
291	Regents Park	1	2143	'park':2 'regent':1	(-33.8839279999999974,151.023796000000004)
300	South Wentworthville	1	2145	'south':1 'wentworthvill':2	(-33.8238920000000007,150.969376000000011)
307	Lalor Park	1	2147	'lalor':1 'park':2	(-33.7613389999999995,150.930337000000009)
311	Marayong	1	2148	'marayong':1	(-33.7461679999999973,150.898337999999995)
320	Bella Vista	1	2153	'bella':1 'vista':2	(-33.7373449999999977,150.955009999999987)
324	Kellyville Ridge	1	2155	'kellyvill':1 'ridg':2	(-33.7001040000000032,150.928650000000005)
868	Dural	1	2330	'dural':1	(-32.5688579999999988,150.843641999999988)
331	Middle Dural	1	2158	'dural':2 'middl':1	(-33.6484710000000007,151.021276)
337	Merrylands West	1	2160	'merryland':1 'west':2	(-33.8328640000000007,150.972036000000003)
343	Chester Hill	1	2162	'chester':1 'hill':2	(-33.8831569999999971,151.001184999999992)
1137	Lansdowne	1	2430	'lansdown':1	(-31.7829890000000006,152.534579000000008)
348	Wetherill Park	1	2164	'park':2 'wetheril':1	(-33.8475120000000018,150.913204000000007)
355	Cabramatta West	1	2166	'cabramatta':1 'west':2	(-33.8991359999999986,150.917514000000011)
360	Ashcroft	1	2168	'ashcroft':1	(-33.9175869999999975,150.899094999999988)
365	Hinchinbrook	1	2168	'hinchinbrook':1	(-33.9166110000000032,150.863863000000009)
370	Hammondville	1	2170	'hammondvill':1	(-33.9481129999999993,150.953726999999986)
377	Warwick Farm	1	2170	'farm':2 'warwick':1	(-33.9134230000000017,150.932751999999994)
381	Middleton Grange	1	2171	'grang':2 'middleton':1	(-33.9140930000000012,150.843547000000001)
389	Horsley Park	1	2175	'horsley':1 'park':2	(-33.8450339999999983,150.848192000000012)
395	St Johns Park	1	2176	'john':2 'park':3 'st':1	(-33.8858239999999995,150.905403000000007)
401	Mount Vernon	1	2178	'mount':1 'vernon':2	(-33.8623770000000022,150.807886999999994)
406	Mount Lewis	1	2190	'lewi':2 'mount':1	(-33.9171570000000031,151.047838000000013)
411	Hurlstone Park	1	2193	'hurlston':1 'park':2	(-33.9099640000000022,151.132239999999996)
417	Bass Hill	1	2197	'bass':1 'hill':2	(-33.9006079999999983,150.992887999999994)
422	Dulwich Hill	1	2203	'dulwich':1 'hill':2	(-33.9046889999999976,151.138774000000012)
429	Bardwell Park	1	2207	'bardwel':1 'park':2	(-33.9320700000000031,151.125594000000007)
439	Lugarno	1	2210	'lugarno':1	(-33.9829560000000015,151.046942000000001)
440	Padstow	1	2211	'padstow':1	(-33.9539150000000021,151.038162999999997)
444	East Hills	1	2213	'east':1 'hill':2	(-33.963358999999997,150.986694999999997)
449	Brighton-le-sands	1	2216	'brighton':2 'brighton-le-sand':1 'le':3 'sand':4	(-33.9605379999999997,151.155361999999997)
457	Ramsgate Beach	1	2217	'beach':2 'ramsgat':1	(-33.981113999999998,151.148300000000006)
464	Hurstville Grove	1	2220	'grove':2 'hurstvill':1	(-33.9806529999999967,151.091136000000006)
466	South Hurstville	1	2221	'hurstvill':2 'south':1	(-33.9775950000000009,151.104908999999992)
475	Sylvania Waters	1	2224	'sylvania':1 'water':2	(-34.0198019999999985,151.115847000000002)
481	Gymea Bay	1	2227	'bay':2 'gymea':1	(-34.0481559999999988,151.086086999999992)
1530	Lilli Pilli	1	2536	'lilli':1 'pilli':2	(-35.7733169999999987,150.225055999999995)
487	Port Hacking	1	2229	'hack':2 'port':1	(-34.0675030000000021,151.122448999999989)
493	Woolooware	1	2230	'wooloowar':1	(-34.0482760000000013,151.141431000000011)
498	Kirrawee	1	2232	'kirrawe':1	(-34.0337430000000012,151.071195999999986)
503	Heathcote	1	2233	'heathcot':1	(-34.0791120000000021,151.00861900000001)
507	Alfords Point	1	2234	'alford':1 'point':2	(-33.9933029999999974,151.024751000000009)
515	East Gosford	1	2250	'east':1 'gosford':2	(-33.4385339999999971,151.35416699999999)
521	Lisarow	1	2250	'lisarow':1	(-33.3808429999999987,151.371283000000005)
525	Mount White	1	2250	'mount':1 'white':2	(-33.4614040000000017,151.190611999999987)
529	Point Clare	1	2250	'clare':2 'point':1	(-33.4367719999999977,151.320952000000005)
517	West Gosford	1	2250	'gosford':2 'west':1	(-33.4208289999999977,151.321753000000001)
539	Green Point	1	2251	'green':1 'point':2	(-32.2517589999999998,152.516738000000004)
545	Koolewong	1	2256	'koolewong':1	(-33.4663200000000032,151.318160000000006)
550	Booker Bay	1	2257	'bay':2 'booker':1	(-33.511566000000002,151.344779999999986)
554	Hardys Bay	1	2257	'bay':2 'hardi':1	(-33.5251570000000001,151.357439999999997)
559	Kangy Angy	1	2258	'angi':2 'kangi':1	(-33.3223970000000023,151.395062999999993)
564	Gwandalan	1	2259	'gwandalan':1	(-33.1395610000000005,151.587571999999994)
569	Lake Munmorah	1	2259	'lake':1 'munmorah':2	(-33.1941479999999984,151.570420000000013)
574	Summerland Point	1	2259	'point':2 'summerland':1	(-33.1390850000000015,151.56543099999999)
580	Watanobbi	1	2259	'watanobbi':1	(-33.2690720000000013,151.431782999999996)
584	Wyongah	1	2259	'wyongah':1	(-33.2748589999999993,151.490379999999988)
588	North Avoca	1	2260	'avoca':2 'north':1	(-33.4590069999999997,151.435833000000002)
594	Chittaway Bay	1	2261	'bay':2 'chittaway':1	(-33.3277599999999978,151.429428000000001)
600	Shelly Beach	1	2261	'beach':2 'shelli':1	(-33.3686750000000032,151.485687000000013)
605	Blue Haven	1	2262	'blue':1 'haven':2	(-33.2073510000000027,151.492750999999998)
610	San Remo	1	2262	'remo':2 'san':1	(-33.2097380000000015,151.516160000000013)
615	Norah Head	1	2263	'head':2 'norah':1	(-33.2797860000000014,151.555052999999987)
620	Dora Creek	1	2264	'creek':2 'dora':1	(-33.0835870000000014,151.501807000000014)
627	Yarrawonga Park	1	2264	'park':2 'yarrawonga':1	(-33.1009219999999971,151.544375000000002)
632	Killingworth	1	2278	'killingworth':1	(-32.9345440000000025,151.560841000000011)
637	Croudace Bay	1	2280	'bay':2 'croudac':1	(-33.0049199999999985,151.643487999999991)
643	Cams Wharf	1	2281	'cam':1 'wharf':2	(-33.1278239999999968,151.62158500000001)
648	Swansea	1	2281	'swansea':1	(-33.0894290000000026,151.637045999999998)
652	Arcadia Vale	1	2283	'arcadia':1 'vale':2	(-33.0603430000000031,151.575815000000006)
658	Carey Bay	1	2283	'bay':2 'carey':1	(-33.0271260000000026,151.605836000000011)
662	Fishing Point	1	2283	'fish':1 'point':2	(-33.0506519999999995,151.590191000000004)
668	Booragul	1	2284	'booragul':1	(-32.9761250000000032,151.605889999999988)
672	Woodrising	1	2284	'woodris':1	(-32.982483000000002,151.605191999999988)
676	Cardiff South	1	2285	'cardiff':1 'south':2	(-32.9577420000000032,151.66144700000001)
682	Birmingham Gardens	1	2287	'birmingham':1 'garden':2	(-32.8908440000000013,151.690829000000008)
689	Wallsend	1	2287	'wallsend':1	(-32.9041029999999992,151.667395999999997)
694	Kotara	1	2289	'kotara':1	(-32.9399500000000032,151.694692000000003)
698	Dudley	1	2290	'dudley':1	(-32.9896839999999969,151.719580000000008)
775	Hillsborough	1	2320	'hillsborough':1	(-32.6368209999999976,151.467756000000008)
702	Mount Hutton	1	2290	'hutton':2 'mount':1	(-32.9853650000000016,151.670747000000006)
707	Merewether Heights	1	2291	'height':2 'mereweth':1	(-32.9482420000000005,151.736231000000004)
713	Carrington	1	2294	'carrington':1	(-32.6643419999999978,152.018721999999997)
718	Georgetown	1	2298	'georgetown':1	(-32.9078140000000019,151.7286)
723	North Lambton	1	2299	'lambton':2 'north':1	(-32.905389999999997,151.706279999999992)
727	Newcastle East	1	2300	'east':2 'newcastl':1	(-32.9278809999999993,151.788038999999998)
744	Hamilton	1	2309	'hamilton':1	(-32.924042,151.746873999999991)
737	Warabrook	1	2304	'warabrook':1	(-32.8878860000000017,151.719956999999994)
742	Callaghan	1	2308	'callaghan':1	(-35.1252350000000035,147.322357000000011)
750	Lostock	1	2311	'lostock':1	(-32.3262599999999978,151.459683000000012)
754	Fingal Bay	1	2315	'bay':2 'fingal':1	(-32.7481129999999965,152.170141000000001)
758	Boat Harbour	1	2316	'boat':1 'harbour':2	(-28.7803110000000011,153.364249000000001)
763	Fullerton Cove	1	2318	'cove':2 'fullerton':1	(-32.8410489999999982,151.837967999999989)
769	Lemon Tree Passage	1	2319	'lemon':1 'passag':3 'tree':2	(-32.7309270000000012,152.039550999999989)
773	Bolwarra Heights	1	2320	'bolwarra':1 'height':2	(-32.7005789999999976,151.584708000000006)
781	Rothbury	1	2320	'rothburi':1	(-32.737997,151.331700000000012)
784	Clarence Town	1	2321	'clarenc':1 'town':2	(-32.5836609999999993,151.779595999999998)
790	Lochinvar	1	2321	'lochinvar':1	(-32.6990389999999991,151.454790000000003)
794	Beresfield	1	2322	'beresfield':1	(-32.8010939999999991,151.657881000000003)
799	Thornton	1	2322	'thornton':1	(-32.7769049999999993,151.638802999999996)
803	Brunkerville	1	2323	'brunkervill':1	(-32.9488380000000021,151.478757999999999)
2065	Green Hills	1	2730	'green':1 'hill':2	(-35.443992999999999,148.072874000000013)
808	Mount Vincent	1	2323	'mount':1 'vincent':2	(-32.984059000000002,149.904292999999996)
815	Cells River	1	2324	'cell':1 'river':2	(-31.5530429999999988,152.062940999999995)
820	Limeburners Creek	1	2324	'creek':2 'limeburn':1	(-31.345129,152.86581000000001)
826	Raymond Terrace	1	2324	'raymond':1 'terrac':2	(-32.7650509999999997,151.743022999999994)
1309	Swan Bay	1	2471	'bay':2 'swan':1	(-29.0598649999999985,153.313616999999994)
831	Twelve Mile Creek	1	2324	'creek':3 'mile':2 'twelv':1	(-32.6353859999999969,151.871462000000008)
837	Ellalong	1	2325	'ellalong':1	(-32.9122610000000009,151.311291000000011)
842	Millfield	1	2325	'millfield':1	(-32.8885059999999996,151.264273000000003)
846	Paynes Crossing	1	2325	'cross':2 'payn':1	(-32.885781999999999,151.102745999999996)
851	Bishops Bridge	1	2326	'bishop':1 'bridg':2	(-32.7463910000000027,151.467063999999993)
856	Stanford Merthyr	1	2327	'merthyr':2 'stanford':1	(-32.8250650000000022,151.493708999999996)
863	Uarbry	1	2329	'uarbri':1	(-32.0472630000000009,149.765034000000014)
867	Carrowbrook	1	2330	'carrowbrook':1	(-32.270899,151.306284000000005)
872	Howes Valley	1	2330	'how':1 'valley':2	(-32.8442840000000018,150.835756000000003)
1693	Long Point	1	2564	'long':1 'point':2	(-33.0469980000000021,149.212518999999986)
878	Ravensworth	1	2330	'ravensworth':1	(-32.4432580000000002,151.054960999999992)
884	Baerami Creek	1	2333	'baerami':1 'creek':2	(-32.5202170000000024,150.454381000000012)
888	Mccullys Gap	1	2333	'gap':2 'mcculli':1	(-32.2029130000000023,150.978703999999993)
894	Belford	1	2335	'belford':1	(-32.6534339999999972,151.27521200000001)
898	North Rothbury	1	2335	'north':1 'rothburi':2	(-32.6974799999999988,151.341011000000009)
904	Upper Rouchel	1	2336	'rouchel':2 'upper':1	(-32.1235330000000019,151.090225000000004)
909	Moonan Brook	1	2337	'brook':2 'moonan':1	(-31.9354000000000013,151.262562000000003)
914	Stewarts Brook	1	2337	'brook':2 'stewart':1	(-32.0013840000000016,151.270252999999997)
920	Warrah Creek	1	2339	'creek':2 'warrah':1	(-31.7157400000000003,150.651204000000007)
927	Kingswood	1	2340	'kingswood':1	(-33.7599670000000032,150.720460000000003)
1649	Kingswood	1	2550	'kingswood':1	(-33.7599670000000032,150.720460000000003)
932	South Tamworth	1	2340	'south':1 'tamworth':2	(-31.1109699999999982,150.916778999999991)
953	Tamworth	1	2348	'tamworth':1	(-31.091743000000001,150.930821000000009)
941	Colly Blue	1	2343	'blue':2 'colli':1	(-31.4595969999999987,150.200081000000011)
946	Duri	1	2344	'duri':1	(-31.219024000000001,150.819075999999995)
950	Barraba	1	2347	'barraba':1	(-30.3783390000000004,150.610642000000013)
956	Hillgrove	1	2350	'hillgrov':1	(-35.0432330000000007,147.349885999999998)
2269	Lyndhurst	1	2797	'lyndhurst':1	(-33.6748880000000028,149.045193000000012)
961	University Of New England	1	2351	'england':4 'new':3 'univers':1	(-30.4929899999999989,151.639713999999998)
968	Walcha	1	2354	'walcha':1	(-30.9920660000000012,151.592051999999995)
972	Watsons Creek	1	2355	'creek':2 'watson':1	(-30.7185869999999994,151.010762999999997)
974	Bugaldie	1	2357	'bugaldi':1	(-31.122204,149.110038000000003)
980	Kingstown	1	2358	'kingstown':1	(-30.5055489999999985,151.117523000000006)
985	Gilgai	1	2360	'gilgai':1	(-29.8523159999999983,151.117346999999995)
988	Inverell	1	2360	'inverel':1	(-29.7756669999999986,151.112928000000011)
993	Ashford	1	2361	'ashford':1	(-29.3212450000000011,151.096080999999998)
998	Guyra	1	2365	'guyra':1	(-30.2171839999999996,151.673119000000014)
1002	Tingha	1	2369	'tingha':1	(-29.9555860000000003,151.212232)
1006	Matheson	1	2370	'matheson':1	(-29.7201839999999997,151.589631999999995)
1960	Morven	1	2660	'morven':1	(-35.6591280000000026,147.120414000000011)
1011	Emmaville	1	2371	'emmavill':1	(-29.4439869999999999,151.598632000000009)
1395	Back Creek	1	2484	'back':1 'creek':2	(-33.8288969999999978,147.446044999999998)
1014	Black Swamp	1	2372	'black':1 'swamp':2	(-28.9904870000000017,152.137344000000013)
1020	Tenterfield	1	2372	'tenterfield':1	(-29.0416570000000007,152.021334999999993)
1025	Orange Grove	1	2380	'grove':2 'orang':1	(-30.9696859999999994,150.393834999999996)
1031	Burren Junction	1	2386	'burren':1 'junction':2	(-30.1051760000000002,148.965674000000007)
1036	Baan Baa	1	2390	'baa':2 'baan':1	(-30.6013799999999989,149.966152999999991)
1041	Weetaliba	1	2395	'weetaliba':1	(-31.6436309999999992,149.586455999999998)
1046	Pallamallawa	1	2399	'pallamallawa':1	(-29.4751079999999988,150.136975000000007)
1050	Terry Hie Hie	1	2400	'hie':2,3 'terri':1	(-29.7955979999999983,150.151074999999992)
1057	Boomi	1	2405	'boomi':1	(-28.7254119999999986,149.579149999999998)
1060	North Star	1	2408	'north':1 'star':2	(-28.9325900000000011,150.391368)
1065	Stroud Road	1	2415	'road':2 'stroud':1	(-32.3447590000000034,151.929068000000001)
1071	Wallarobba	1	2420	'wallarobba':1	(-32.4972369999999984,151.697483000000005)
1075	Belbora	1	2422	'belbora':1	(-32.0032819999999987,152.157652000000013)
1083	Upper Bowman	1	2422	'bowman':2 'upper':1	(-31.9227440000000016,151.780767999999995)
1088	Coolongolook	1	2423	'coolongolook':1	(-32.2186799999999991,152.321932000000004)
1092	Upper Myall	1	2423	'myall':2 'upper':1	(-32.2519619999999989,152.172288000000009)
1098	Mount George	1	2424	'georg':2 'mount':1	(-31.8844449999999995,152.181488000000002)
1104	Washpool	1	2425	'washpool':1	(-29.296914000000001,152.448464000000001)
1108	Harrington	1	2427	'harrington':1	(-31.8721530000000008,152.689810999999992)
1113	Tarbuck Bay	1	2428	'bay':2 'tarbuck':1	(-32.3684879999999993,152.478147000000007)
1119	Comboyne	1	2429	'comboyn':1	(-31.6054689999999994,152.467889000000014)
1124	Kimbriki	1	2429	'kimbriki':1	(-31.9228260000000006,152.267063000000007)
1128	Wherrol Flat	1	2429	'flat':2 'wherrol':1	(-31.7832110000000014,152.227658999999989)
1134	Ghinni Ghinni	1	2430	'ghinni':1,2	(-31.8805450000000015,152.551827000000003)
1140	Purfleet	1	2430	'purfleet':1	(-31.9441799999999994,152.468837000000008)
1145	South West Rocks	1	2431	'rock':3 'south':1 'west':2	(-30.8844230000000017,153.040451999999988)
1150	Bellimbopinni	1	2440	'bellimbopinni':1	(-31.0159289999999999,152.903409000000011)
1155	Crescent Head	1	2440	'crescent':1 'head':2	(-31.1895169999999986,152.976799999999997)
2470	Collaroy Plateau	1	1	\N	\N
1160	Hickeys Creek	1	2440	'creek':2 'hickey':1	(-30.8748380000000004,152.598290999999989)
1165	South Kempsey	1	2440	'kempsey':2 'south':1	(-31.0942280000000011,152.832549999999998)
1171	Eungai Creek	1	2441	'creek':2 'eungai':1	(-30.8315850000000005,152.88169400000001)
1176	Rollands Plains	1	2441	'plain':2 'rolland':1	(-31.2786989999999996,152.678061000000014)
1180	Camden Head	1	2443	'camden':1 'head':2	(-31.6468640000000008,152.83456000000001)
1182	Hannam Vale	1	2443	'hannam':1 'vale':2	(-31.7129750000000001,152.591297999999995)
1188	North Haven	1	2443	'haven':2 'north':1	(-31.6400019999999991,152.817329999999998)
1192	Lake Cathie	1	2445	'cathi':2 'lake':1	(-31.5522869999999998,152.854925000000009)
1197	Ellenborough	1	2446	'ellenborough':1	(-31.4445610000000002,152.456672999999995)
1202	Pappinbarra	1	2446	'pappinbarra':1	(-31.3803640000000001,152.501526000000013)
1207	Scotts Head	1	2447	'head':2 'scott':1	(-30.7466650000000001,152.99272400000001)
1211	Nambucca Heads	1	2448	'head':2 'nambucca':1	(-30.6424419999999991,153.00288599999999)
1217	Coffs Harbour	1	2450	'coff':1 'harbour':2	(-30.2822789999999991,153.128592999999995)
1222	Lowanna	1	2450	'lowanna':1	(-30.2123899999999992,152.900526000000013)
1226	Upper Orara	1	2450	'orara':2 'upper':1	(-30.2848219999999984,153.009510000000006)
1232	Dundurrabin	1	2453	'dundurrabin':1	(-30.1887809999999988,152.547363999999988)
1237	Bellingen	1	2454	'bellingen':1	(-30.4523879999999991,152.898146999999994)
1241	Raleigh	1	2454	'raleigh':1	(-30.4807379999999988,152.99487400000001)
1244	Arrawarra Headland	1	2455	'arrawarra':1 'headland':2	(-30.0597710000000014,153.202738000000011)
1246	Arrawarra Headland	1	2456	'arrawarra':1 'headland':2	(-30.0597710000000014,153.202738000000011)
1257	Copmanhurst	1	2460	'copmanhurst':1	(-29.5862370000000006,152.77639400000001)
1263	Junction Hill	1	2460	'hill':2 'junction':1	(-29.6413699999999984,152.925803000000002)
1269	South Grafton	1	2460	'grafton':2 'south':1	(-29.7032419999999995,152.934605000000005)
1274	Ulmarra	1	2462	'ulmarra':1	(-29.6305790000000009,153.028111999999993)
1279	Woodford	1	2463	'woodford':1	(-33.7351740000000007,150.479149000000007)
2189	Woodford	1	2778	'woodford':1	(-33.7351740000000007,150.479149000000007)
1282	Iluka	1	2466	'iluka':1	(-29.4074750000000016,153.350886000000003)
1286	Old Bonalbo	1	2469	'bonalbo':2 'old':1	(-28.6539509999999993,152.596340999999995)
1292	Coombell	1	2470	'coombel':1	(-29.0152889999999992,152.973561999999987)
1296	Ellangowan	1	2470	'ellangowan':1	(-29.0497620000000012,153.039519000000013)
1300	Mongogarie	1	2470	'mongogari':1	(-28.9478270000000002,152.90191200000001)
1304	Shannon Brook	1	2470	'brook':2 'shannon':1	(-28.8962749999999993,152.957506999999993)
1311	Broadwater	1	2472	'broadwat':1	(-36.9825779999999966,149.887263999999988)
1636	Broadwater	1	2549	'broadwat':1	(-36.9825779999999966,149.887263999999988)
1316	Ettrick	1	2474	'ettrick':1	(-28.6650370000000017,152.921436)
1320	Lynchs Creek	1	2474	'creek':2 'lynch':1	(-28.450334999999999,152.997433999999998)
1326	Acacia Plateau	1	2476	'acacia':1 'plateau':2	(-28.3810719999999996,152.368571000000003)
1331	Cabbage Tree Island	1	2477	'cabbag':1 'island':3 'tree':2	(-28.9839950000000002,153.45688899999999)
1339	Ballina	1	2478	'ballina':1	(-28.8699839999999988,153.559167000000002)
1343	Pimlico	1	2478	'pimlico':1	(-28.8894120000000001,153.494218999999987)
1347	Binna Burra	1	2479	'binna':1 'burra':2	(-28.7096529999999994,153.490298999999993)
1354	Clunes	1	2480	'clune':1	(-28.7299879999999987,153.40559300000001)
1358	Eltham	1	2480	'eltham':1	(-28.7542870000000015,153.409528999999992)
1363	Goonellabah	1	2480	'goonellabah':1	(-28.8198410000000003,153.317703999999992)
1368	North Lismore	1	2480	'lismor':2 'north':1	(-28.7881399999999985,153.277442000000008)
1373	Ruthven	1	2480	'ruthven':1	(-28.9323879999999996,153.278838000000007)
1378	Whian Whian	1	2480	'whian':1,2	(-28.6351970000000016,153.316230999999988)
1382	Suffolk Park	1	2481	'park':2 'suffolk':1	(-28.6898419999999987,153.61015900000001)
1385	Mullumbimby	1	2482	'mullumbimbi':1	(-28.5531609999999993,153.499637000000007)
1391	New Brighton	1	2483	'brighton':2 'new':1	(-28.5093579999999989,153.549644000000001)
1396	Bray Park	1	2484	'bray':1 'park':2	(-28.3435309999999987,153.375834999999995)
1402	Dunbible	1	2484	'dunbibl':1	(-28.3825360000000018,153.401834000000008)
1406	Murwillumbah	1	2484	'murwillumbah':1	(-28.3264099999999992,153.395974999999993)
1412	Tweed Heads	1	2485	'head':2 'tweed':1	(-28.1775370000000009,153.538537999999988)
1417	Terranora	1	2486	'terranora':1	(-28.2407240000000002,153.502794999999992)
1421	Duranbah	1	2487	'duranbah':1	(-28.3075749999999999,153.518473999999998)
1426	Cabarita Beach	1	2488	'beach':2 'cabarita':1	(-28.3321490000000011,153.569694999999996)
1431	Gwynneville	1	2500	'gwynnevill':1	(-34.4165059999999983,150.885131000000001)
1435	Mount Saint Thomas	1	2500	'mount':1 'saint':2 'thoma':3	(-34.4429050000000032,150.873919999999998)
1471	Wollongong	1	2520	'wollongong':1	(-33.9377890000000022,151.139593999999988)
1445	Port Kembla	1	2505	'kembla':2 'port':1	(-34.4794729999999987,150.901650999999987)
1451	Stanwell Park	1	2508	'park':2 'stanwel':1	(-34.2260190000000009,150.986147999999986)
1456	Scarborough	1	2515	'scarborough':1	(-34.2683510000000027,150.962389000000002)
1460	Russell Vale	1	2517	'russel':1 'vale':2	(-34.3580929999999967,150.90078299999999)
1466	Towradgi	1	2518	'towradgi':1	(-34.3844330000000014,150.906759999999991)
1470	Mount Pleasant	1	2519	'mount':1 'pleasant':2	(-34.3966599999999971,150.863798000000003)
1477	Kembla Grange	1	2526	'grang':2 'kembla':1	(-34.4707799999999978,150.808911999999992)
1485	Mount Warrigal	1	2528	'mount':1 'warrig':2	(-34.5518560000000008,150.843468000000001)
1491	Oak Flats	1	2529	'flat':2 'oak':1	(-34.5649330000000035,150.819333999999998)
1496	Horsley	1	2530	'horsley':1	(-34.4896049999999974,150.766762)
1501	Bombo	1	2533	'bombo':1	(-34.6563960000000009,150.854028)
1505	Foxground	1	2534	'foxground':1	(-34.7270839999999978,150.768404000000004)
1866	Rose Valley	1	2630	'rose':1 'valley':2	(-36.1241270000000014,149.257968000000005)
1509	Werri Beach	1	2534	'beach':2 'werri':1	(-34.7340829999999983,150.832547000000005)
1514	Jaspers Brush	1	2535	'brush':2 'jasper':1	(-34.8033229999999989,150.657591999999994)
1521	Bimbimbie	1	2536	'bimbimbi':1	(-35.8153950000000023,150.128745000000009)
1525	Denhams Beach	1	2536	'beach':2 'denham':1	(-35.7477220000000031,150.213231000000007)
1531	Long Beach	1	2536	'beach':2 'long':1	(-35.6988920000000007,150.234429000000006)
1536	North Batemans Bay	1	2536	'bateman':2 'bay':3 'north':1	(-35.7003150000000034,150.183190999999994)
1543	Woodlands	1	2536	'woodland':1	(-34.4221849999999989,150.383214000000009)
1548	Congo	1	2537	'congo':1	(-35.9561849999999978,150.153669000000008)
1550	Deua River Valley	1	2537	'deua':1 'river':2 'valley':3	(-35.8259010000000018,149.975941000000006)
1558	Turlinjah	1	2537	'turlinjah':1	(-36.0332679999999996,150.090191000000004)
1562	Bendalong	1	2539	'bendalong':1	(-35.2467770000000016,150.529888)
1567	Cunjurong Point	1	2539	'cunjurong':1 'point':2	(-35.2597590000000025,150.504908999999998)
1574	Ulladulla	1	2539	'ulladulla':1	(-35.3570939999999965,150.474300999999997)
1580	Brundee	1	2540	'brunde':1	(-34.8920940000000002,150.65130400000001)
1583	Callala Beach	1	2540	'beach':2 'callala':1	(-35.0090840000000014,150.696524000000011)
1586	Culburra Beach	1	2540	'beach':2 'culburra':1	(-34.9303049999999971,150.758745000000005)
1594	Hyams Beach	1	2540	'beach':2 'hyam':1	(-35.1017259999999993,150.681004000000001)
1599	Old Erowal Bay	1	2540	'bay':3 'erow':2 'old':1	(-35.0843670000000003,150.646501000000001)
1605	Swanhaven	1	2540	'swanhaven':1	(-35.1807640000000035,150.574812000000009)
1610	Wandandian	1	2540	'wandandian':1	(-35.0890660000000025,150.509966999999989)
1615	Bangalee	1	2541	'bangale':1	(-34.8439759999999978,150.570380999999998)
1619	South Nowra	1	2541	'nowra':2 'south':1	(-34.8983630000000034,150.602210000000014)
1625	Dalmeny	1	2546	'dalmeni':1	(-36.1710339999999988,150.131434000000013)
1629	North Narooma	1	2546	'narooma':2 'north':1	(-36.2026779999999988,150.11908600000001)
1635	Tura Beach	1	2548	'beach':2 'tura':1	(-36.8653300000000002,149.917713999999989)
1640	South Pambula	1	2549	'pambula':2 'south':1	(-36.943446999999999,149.862176000000005)
1646	Candelo	1	2550	'candelo':1	(-36.7673109999999994,149.695188000000002)
1651	Morans Crossing	1	2550	'cross':2 'moran':1	(-36.6637569999999968,149.647066999999993)
1657	Towamba	1	2550	'towamba':1	(-37.0879779999999997,149.652671999999995)
1663	Eden	1	2551	'eden':1	(-37.0631899999999987,149.90370200000001)
1666	Wonboyn Lake	1	2551	'lake':2 'wonboyn':1	(-37.2510460000000023,149.914952999999997)
1672	Eschol Park	1	2558	'eschol':1 'park':2	(-34.0313569999999999,150.809679999999986)
1677	Ambarvale	1	2560	'ambarval':1	(-34.0804669999999987,150.803643999999991)
1681	Campbelltown	1	2560	'campbelltown':1	(-34.0674410000000023,150.812522000000001)
1689	St Helens Park	1	2560	'helen':2 'park':3 'st':1	(-34.1122640000000033,150.798121000000009)
1694	Macquarie Fields	1	2564	'field':2 'macquari':1	(-33.9894710000000018,150.882625999999988)
1703	Currans Hill	1	2567	'curran':1 'hill':2	(-34.0451789999999974,150.764006999999992)
1709	Douglas Park	1	2569	'dougla':1 'park':2	(-34.1936960000000028,150.712877999999989)
1715	Ellis Lane	1	2570	'elli':1 'lane':2	(-34.0400610000000015,150.67200600000001)
1720	Orangeville	1	2570	'orangevill':1	(-34.0427899999999966,150.573125000000005)
1726	Picton	1	2571	'picton':1	(-34.1855240000000009,150.606454000000014)
1730	Thirlmere	1	2572	'thirlmer':1	(-34.2040879999999987,150.571101999999996)
1735	Aylmerton	1	2575	'aylmerton':1	(-34.4190690000000004,150.492737000000005)
1851	Braemar	1	2628	'braemar':1	(-36.103116,148.652751999999992)
1740	Yerrinbool	1	2575	'yerrinbool':1	(-34.3759080000000026,150.53813199999999)
1744	Avoca	1	2577	'avoca':1	(-34.6135220000000032,150.479322999999994)
1748	Burrawang	1	2577	'burrawang':1	(-34.5933020000000013,150.518263999999988)
1752	New Berrima	1	2577	'berrima':2 'new':1	(-34.5043950000000024,150.332393999999994)
1758	Exeter	1	2579	'exet':1	(-34.6131609999999981,150.317392000000012)
1763	Bannister	1	2580	'bannist':1	(-34.595404000000002,149.490386000000001)
1768	Lake Bathurst	1	2580	'bathurst':2 'lake':1	(-35.0126569999999973,149.714504000000005)
1773	Wombeyan Caves	1	2580	'cave':2 'wombeyan':1	(-34.3296339999999987,150.02274700000001)
1779	Dalton	1	2581	'dalton':1	(-34.7219100000000012,149.181024000000008)
1783	Burrinjuck	1	2582	'burrinjuck':1	(-34.9766580000000005,148.623310000000004)
1788	Binda	1	2583	'binda':1	(-34.3288319999999985,149.365499)
1793	Grabben Gullen	1	2583	'grabben':1 'gullen':2	(-34.5454739999999987,149.410915999999986)
1800	Binalong	1	2584	'binalong':1	(-34.6709320000000005,148.628208999999998)
1804	Reids Flat	1	2586	'flat':2 'reid':1	(-34.1466380000000029,148.961379999999991)
1809	Wombat	1	2587	'wombat':1	(-34.4234819999999999,148.244439999999997)
1814	Bribbaree	1	2594	'bribbare':1	(-34.1212519999999984,147.873720999999989)
1818	Brindabella	1	2611	'brindabella':1	(-35.3495029999999986,148.724491)
1824	Karabar	1	2620	'karabar':1	(-35.3628989999999988,149.216387999999995)
1828	Queanbeyan West	1	2620	'queanbeyan':1 'west':2	(-35.3582979999999978,149.228993000000003)
1834	Araluen	1	2622	'araluen':1	(-35.6469299999999976,149.812149000000005)
1838	Gundillion	1	2622	'gundillion':1	(-35.7587949999999992,149.638180000000006)
1843	Nerriga	1	2622	'nerriga':1	(-35.1131820000000019,150.088704000000007)
1847	Thredbo Village	1	2625	'thredbo':1 'villag':2	(-36.506610000000002,148.301005000000004)
1854	Numbla Vale	1	2628	'numbla':1 'vale':2	(-36.6366849999999999,148.817930999999987)
1859	Bunyan	1	2630	'bunyan':1	(-36.1696299999999979,149.153752999999995)
1863	Numeralla	1	2630	'numeralla':1	(-36.1772229999999979,149.340667999999994)
1869	Bibbenluke	1	2632	'bibbenluk':1	(-36.8158049999999974,149.283408000000009)
1874	Delegate	1	2633	'deleg':1	(-37.0440279999999973,148.941734999999994)
1877	North Albury	1	2640	'alburi':2 'north':1	(-36.0629520000000028,146.931552000000011)
2021	Lavington	1	2708	'lavington':1	(-36.050576999999997,146.933346)
1883	Brocklesby	1	2642	'brocklesbi':1	(-35.8225890000000007,146.680116999999996)
1888	Khancoban	1	2642	'khancoban':1	(-36.218086999999997,148.129398000000009)
1892	Yerong Creek	1	2642	'creek':2 'yerong':1	(-35.3874470000000017,147.061230999999992)
1896	Mullengandra	1	2644	'mullengandra':1	(-35.8771199999999979,147.180565000000001)
1902	Lowesdale	1	2646	'lowesdal':1	(-35.8425560000000019,146.365642000000008)
1906	Mulwala	1	2647	'mulwala':1	(-35.9541589999999971,145.963942000000003)
1911	Pomona	1	2648	'pomona':1	(-34.0206250000000026,141.894925999999998)
1915	Laurel Hill	1	2649	'hill':2 'laurel':1	(-35.6003899999999973,148.093099999999993)
1920	Downside	1	2650	'downsid':1	(-34.9766290000000026,147.344313999999997)
1924	Lake Albert	1	2650	'albert':2 'lake':1	(-35.1660850000000025,147.381815999999986)
1995	Wagga Wagga	1	2678	'wagga':1,2	(-35.1098610000000022,147.370515000000012)
1934	Goolgowi	1	2652	'goolgowi':1	(-33.9835470000000015,145.70808199999999)
1939	Mangoplah	1	2652	'mangoplah':1	(-35.3751689999999996,147.253055999999987)
1943	Old Junee	1	2652	'june':2 'old':1	(-34.836390999999999,147.514785999999987)
1950	French Park	1	2655	'french':1 'park':2	(-35.2670460000000006,146.926513)
1954	Urangeline East	1	2656	'east':2 'urangelin':1	(-35.4828779999999995,146.694288999999998)
1961	Kapooka	1	2661	'kapooka':1	(-35.1477900000000005,147.295748000000003)
1966	Beckom	1	2665	'beckom':1	(-34.3273099999999971,146.959973999999988)
1970	Moombooldool	1	2665	'moombooldool':1	(-34.3017320000000012,146.678024999999991)
1975	Temora	1	2666	'temora':1	(-34.4468579999999989,147.53374199999999)
1979	Erigolia	1	2669	'erigolia':1	(-33.8562080000000023,146.353487000000001)
1984	Tullibigeal	1	2669	'tullibig':1	(-33.4200930000000014,146.728082999999998)
1988	West Wyalong	1	2671	'west':1 'wyalong':2	(-33.9234960000000001,147.205200999999988)
1996	Beelbangera	1	2680	'beelbangera':1	(-34.2570970000000017,146.100091999999989)
2005	Yoogali	1	2680	'yoogali':1	(-34.3011800000000022,146.084632999999997)
2009	Narrandera	1	2700	'narrandera':1	(-34.744608999999997,146.556960000000004)
2013	Corbie Hill	1	2705	'corbi':1 'hill':2	(-34.5715379999999968,146.456385000000012)
2018	Darlington Point	1	2706	'darlington':1 'point':2	(-34.5577290000000019,146.010495999999989)
2026	Mathoura	1	2710	'mathoura':1	(-35.8126200000000026,144.902600000000007)
2030	Wanganella	1	2710	'wanganella':1	(-35.2113349999999983,144.815368000000007)
2035	Maude	1	2711	'maud':1	(-34.4678589999999971,144.303163000000012)
2039	Finley	1	2713	'finley':1	(-35.6454340000000016,145.575435999999996)
2043	Jerilderie	1	2716	'jerilderi':1	(-35.3564480000000003,145.729279999999989)
2048	Tumut	1	2720	'tumut':1	(-35.3006340000000023,148.224961000000008)
2052	Muttama	1	2722	'muttama':1	(-34.8027739999999994,148.116901000000013)
2056	Adjungbilly	1	2727	'adjungbilli':1	(-35.0814629999999994,148.40992)
2061	Mount Horeb	1	2729	'horeb':2 'mount':1	(-35.2102629999999976,148.033504999999991)
2068	Womboota	1	2731	'womboota':1	(-35.9571899999999971,144.588650999999999)
2073	Tooleybuc	1	2736	'tooleybuc':1	(-35.0278909999999968,143.33827500000001)
2078	Buronga	1	2739	'buronga':1	(-34.1714429999999965,142.182794000000001)
2084	Wallacia	1	2745	'wallacia':1	(-33.8651789999999977,150.640418000000011)
2089	Werrington	1	2747	'werrington':1	(-33.7577250000000006,150.739981999999998)
2094	Cranebrook	1	2749	'cranebrook':1	(-33.7143099999999976,150.709985999999986)
2098	Penrith	1	2751	'penrith':1	(-33.7321269999999984,151.280351999999993)
2103	Grose Wold	1	2753	'grose':1 'wold':2	(-33.6023920000000018,150.688627999999994)
2108	North Richmond	1	2754	'north':1 'richmond':2	(-33.5823549999999997,150.721890999999999)
2115	Cornwallis	1	2756	'cornwal':1	(-33.592374999999997,150.812216000000006)
2119	Lower Portland	1	2756	'lower':1 'portland':2	(-33.4514089999999982,150.865870999999999)
2124	Scheyville	1	2756	'scheyvill':1	(-33.6106899999999982,150.880310000000009)
2129	Blaxlands Ridge	1	2758	'blaxland':1 'ridg':2	(-33.5022530000000032,150.712367)
2136	Dean Park	1	2761	'dean':1 'park':2	(-33.7361599999999981,150.860027000000002)
2141	Schofields	1	2762	'schofield':1	(-33.697217000000002,150.888428000000005)
2146	Maraylya	1	2765	'maraylya':1	(-33.5819800000000015,150.906949999999995)
2152	Eastern Creek	1	2766	'creek':2 'eastern':1	(-33.8031140000000008,150.852192000000002)
2158	Stanhope Gardens	1	2768	'garden':2 'stanhop':1	(-33.7112150000000028,150.933620999999988)
2164	Hebersham	1	2770	'hebersham':1	(-33.7435040000000015,150.822681999999986)
2168	Shalvey	1	2770	'shalvey':1	(-33.7293730000000025,150.808375000000012)
2173	Lapstone	1	2773	'lapston':1	(-33.7741120000000024,150.636657000000014)
2177	Central Macdonald	1	2775	'central':1 'macdonald':2	(-33.3316579999999973,150.975497999999988)
2183	Hawkesbury Heights	1	2777	'hawkesburi':1 'height':2	(-33.6651140000000026,150.650801999999999)
2191	Katoomba	1	2780	'katoomba':1	(-33.7140429999999967,150.311588999999998)
2196	Bullaburra	1	2784	'bullaburra':1	(-33.7227510000000024,150.413639999999987)
2201	Mount Irvine	1	2786	'irvin':2 'mount':1	(-33.4921480000000003,150.445296000000013)
2206	Edith	1	2787	'edith':1	(-33.8002139999999969,149.922382999999996)
2210	Porters Retreat	1	2787	'porter':1 'retreat':2	(-33.9888150000000024,149.760627999999997)
2215	Cobar Park	1	2790	'cobar':1 'park':2	(-33.4699480000000023,150.154967999999997)
2221	Little Hartley	1	2790	'hartley':2 'littl':1	(-33.5717009999999974,150.208607000000001)
2227	Mandurama	1	2792	'mandurama':1	(-33.6488549999999975,149.07527300000001)
2232	Noonbinna	1	2794	'noonbinna':1	(-33.8876630000000034,148.643696000000006)
2237	Burraga	1	2795	'burraga':1	(-33.9479639999999989,149.530130000000014)
2241	Eglinton	1	2795	'eglinton':1	(-33.3745970000000014,149.558661999999998)
2245	Hobbys Yards	1	2795	'hobbi':1 'yard':2	(-33.7001360000000005,149.327337999999997)
2251	Mount David	1	2795	'david':2 'mount':1	(-33.8608210000000014,149.604107999999997)
2257	Sofala	1	2795	'sofala':1	(-33.0806979999999982,149.689626000000004)
2262	Wambool	1	2795	'wambool':1	(-33.5075760000000002,149.763254999999987)
2266	Wisemans Creek	1	2795	'creek':2 'wiseman':1	(-33.6189779999999985,149.718319000000008)
2274	Blayney	1	2799	'blayney':1	(-33.5323190000000011,149.255263000000014)
2279	Cargo	1	2800	'cargo':1	(-33.4236330000000024,148.808929000000006)
2282	Mullion Creek	1	2800	'creek':2 'mullion':1	(-33.1407039999999995,149.120663000000008)
2289	Canowindra	1	2804	'canowindra':1	(-33.562223000000003,148.664909999999992)
2293	Greenethorpe	1	2809	'greenethorp':1	(-34.0419550000000015,148.395001000000008)
2299	Bakers Swamp	1	2820	'baker':1 'swamp':2	(-32.778925000000001,148.923303000000004)
2305	Neurea	1	2820	'neurea':1	(-32.7081930000000014,148.947814999999991)
2309	Wellington	1	2820	'wellington':1	(-32.5558800000000019,148.944796999999994)
2314	Canonba	1	2825	'canonba':1	(-31.3470720000000007,147.345555999999988)
2315	Miandetta	1	2825	'miandetta':1	(-31.5662209999999988,146.970792999999986)
2320	Gilgandra	1	2827	'gilgandra':1	(-31.7117150000000017,148.663130999999993)
2324	Coonamble	1	2829	'coonambl':1	(-30.9543110000000006,148.388448000000011)
2329	Armatree	1	2831	'armatre':1	(-31.4537259999999996,148.40769499999999)
2333	Coolabah	1	2831	'coolabah':1	(-31.0279859999999985,146.714263999999986)
2338	Goodooga	1	2831	'goodooga':1	(-29.1130369999999985,147.452138999999988)
2343	Nymagee	1	2831	'nymage':1	(-32.163806000000001,146.299530000000004)
2347	Come By Chance	1	2832	'chanc':3 'come':1	(-30.3615910000000007,148.467361000000011)
2352	Lightning Ridge	1	2834	'lightn':1 'ridg':2	(-29.4257239999999989,147.979235999999986)
2357	Weilmoringle	1	2839	'weilmoringl':1	(-29.2188119999999998,146.867097000000001)
2363	Tilpa	1	2840	'tilpa':1	(-30.9405789999999996,144.421864999999997)
2367	Mendooran	1	2842	'mendooran':1	(-31.8224879999999999,149.118008000000003)
2371	Leadville	1	2844	'leadvill':1	(-32.0175070000000019,149.544871000000001)
2376	Charbon	1	2848	'charbon':1	(-32.8812649999999991,149.965118999999987)
2381	Hargraves	1	2850	'hargrav':1	(-32.7888599999999997,149.465034000000003)
2386	Mudgee	1	2850	'mudge':1	(-32.5907199999999975,149.586126000000007)
2389	Twelve Mile	1	2850	'mile':2 'twelv':1	(-32.4930140000000023,149.270450000000011)
2394	Yarrawonga	1	2850	'yarrawonga':1	(-32.356620999999997,149.658829999999995)
2399	Toogong	1	2864	'toogong':1	(-33.3514189999999999,148.624917000000011)
2403	Larras Lee	1	2866	'larra':1 'lee':2	(-32.9703769999999992,148.881707000000006)
2408	Peak Hill	1	2869	'hill':2 'peak':1	(-32.7253279999999975,148.185188000000011)
2414	Goonumbla	1	2870	'goonumbla':1	(-32.9986719999999991,148.161010000000005)
2418	Bedgerebong	1	2871	'bedgerebong':1	(-33.3609149999999985,147.696172999999987)
103	University Of New South Wales	1	2052	'new':3 'south':4 'univers':1 'wale':5	(-33.9179999999999993,151.230999999999995)
293	Constitution Hill	1	2145	'constitut':1 'hill':2	(-33.8160000000000025,150.955999999999989)
1592	Hmas Creswell	1	2540	'creswel':2 'hmas':1	(-34.2650000000000006,150.692000000000007)
1595	Jervis Bay	1	2540	'bay':2 'jervi':1	(-34.2650000000000006,150.692000000000007)
385	Voyager	1	2172	'voyag':1	(-33.9669999999999987,150.980999999999995)
1723	Balmoral Village	1	2571	'balmor':1 'villag':2	(-34.2430000000000021,150.580999999999989)
1575	Yatte Yattah	1	2539	'yatt':1 'yattah':2	(-35.4040000000000035,150.402999999999992)
17	Sydney	1	2001	'sydney':1	(-33.7948829999999987,151.268070999999992)
12	Darlinghurst	1	2010	'darlinghurst':1	(-33.8798249999999967,151.219560000000001)
26	Potts Point	1	2011	'point':2 'pott':1	(-33.8690259999999981,151.225603000000007)
44	Bondi Junction	1	2022	'bondi':1 'junction':2	(-33.8923240000000021,151.247330000000005)
53	Double Bay	1	2028	'bay':2 'doubl':1	(-33.8790600000000026,151.243095000000011)
28	Strawberry Hills	1	2012	'hill':2 'strawberri':1	(-33.7260980000000004,150.931837999999999)
31	Eveleigh	1	2015	'eveleigh':1	(-33.897075000000001,151.191129999999987)
29	Alexandria	1	2015	'alexandria':1	(-33.8975709999999992,151.195567000000011)
33	Waterloo	1	2017	'waterloo':1	(-33.9003999999999976,151.206143999999995)
36	Rosebery	1	2018	'roseberi':1	(-33.9204119999999989,151.203106999999989)
38	Botany	1	2019	'botani':1	(-33.9447699999999983,151.196528000000001)
39	Mascot	1	2020	'mascot':1	(-33.9311890000000034,151.194310000000002)
62	Kensington	1	2033	'kensington':1	(-33.9129969999999972,151.219017000000008)
10	Burwood	1	2134	'burwood':1	(-33.8774230000000003,151.103681999999992)
14	Dawes Point	1	2000	'daw':1 'point':2	(-33.8556010000000001,151.208220000000011)
15	Millers Point	1	2000	'miller':1 'point':2	(-33.8583149999999975,151.203519)
16	The Rocks	1	2000	'rock':2	(-33.4250800000000012,149.424871999999993)
18	World Square	1	2002	'squar':2 'world':1	(-35.9744340000000022,146.405059999999992)
21	Chippendale	1	2008	'chippendal':1	(-33.8868440000000035,151.201715000000007)
22	Darlington	1	2008	'darlington':1	(-32.558283000000003,151.159556000000009)
23	Pyrmont	1	2009	'pyrmont':1	(-33.8697090000000003,151.193929999999995)
13	Surry Hills	1	2010	'hill':2 'surri':1	(-33.8888210000000001,151.21332799999999)
25	Elizabeth Bay	1	2011	'bay':2 'elizabeth':1	(-33.872829000000003,151.226593000000008)
27	Rushcutters Bay	1	2011	'bay':2 'rushcutt':1	(-33.8762400000000028,151.228613999999993)
24	Woolloomooloo	1	2011	'woolloomooloo':1	(-33.8692830000000029,151.22041200000001)
30	Beaconsfield	1	2015	'beaconsfield':1	(-33.9116130000000027,151.201889999999992)
32	Redfern	1	2016	'redfern':1	(-33.8927779999999998,151.203901000000002)
34	Zetland	1	2017	'zetland':1	(-33.9099379999999968,151.206233999999995)
35	Eastlakes	1	2018	'eastlak':1	(-33.9251330000000024,151.213199000000003)
37	Banksmeadow	1	2019	'banksmeadow':1	(-33.957419999999999,151.206715000000003)
40	Moore Park	1	2021	'moor':1 'park':2	(-33.8936319999999967,151.219357000000002)
41	Paddington	1	2021	'paddington':1	(-33.8850320000000025,151.226474999999994)
43	Queens Park	1	2022	'park':2 'queen':1	(-33.9031880000000001,151.247205000000008)
45	Bellevue Hill	1	2023	'bellevu':1 'hill':2	(-33.8871889999999993,151.258935000000008)
46	Bronte	1	2024	'bront':1	(-33.9023279999999971,151.263837999999993)
47	Waverley	1	2024	'waverley':1	(-33.8979550000000032,151.252059000000003)
48	Woollahra	1	2025	'woollahra':1	(-33.8857950000000017,151.244130000000013)
49	Bondi	1	2026	'bondi':1	(-33.8937389999999965,151.262502000000012)
50	Darling Point	1	2027	'darl':1 'point':2	(-33.8738079999999968,151.236682999999999)
51	Edgecliff	1	2027	'edgecliff':1	(-33.8785859999999985,151.235106000000002)
52	Point Piper	1	2027	'piper':2 'point':1	(-33.8700830000000011,151.252329000000003)
54	Rose Bay	1	2029	'bay':2 'rose':1	(-33.8665549999999982,151.280455999999987)
57	Dover Heights	1	2030	'dover':1 'height':2	(-33.874405000000003,151.280416000000002)
55	Vaucluse	1	2030	'vauclus':1	(-33.8590469999999968,151.278434000000004)
56	Watsons Bay	1	2030	'bay':2 'watson':1	(-33.8448059999999984,151.282367999999991)
58	Clovelly	1	2031	'clovelli':1	(-33.9126389999999986,151.262021000000004)
59	Randwick	1	2031	'randwick':1	(-33.9131640000000019,151.241993000000008)
60	Daceyville	1	2032	'daceyvill':1	(-33.9280430000000024,151.225130000000007)
61	Kingsford	1	2032	'kingsford':1	(-33.9249220000000022,151.227811000000003)
63	Coogee	1	2034	'cooge':1	(-33.9204909999999984,151.254401000000001)
64	South Coogee	1	2034	'cooge':2 'south':1	(-33.9312929999999966,151.256089000000003)
65	Maroubra	1	2035	'maroubra':1	(-33.946123,151.242818)
66	Pagewood	1	2035	'pagewood':1	(-33.9401080000000022,151.228410999999994)
67	Chifley	1	2036	'chifley':1	(-33.976545999999999,151.240248000000008)
68	Eastgardens	1	2036	'eastgarden':1	(-33.9460430000000031,151.223300999999992)
69	Hillsdale	1	2036	'hillsdal':1	(-33.9526850000000024,151.231340999999986)
70	La Perouse	1	2036	'la':1 'perous':2	(-33.9896340000000023,151.231506999999993)
71	Little Bay	1	2036	'bay':2 'littl':1	(-33.9811770000000024,151.243205999999986)
72	Malabar	1	2036	'malabar':1	(-33.9653759999999991,151.245969000000002)
73	Matraville	1	2036	'matravill':1	(-33.9575490000000002,151.230846000000014)
74	Phillip Bay	1	2036	'bay':2 'phillip':1	(-33.980556,151.236692000000005)
75	Port Botany	1	2036	'botani':2 'port':1	(-33.9662450000000007,151.22501299999999)
76	Forest Lodge	1	2037	'forest':1 'lodg':2	(-33.8812149999999974,151.181127000000004)
77	Annandale	1	2038	'annandal':1	(-33.8814350000000033,151.170681000000002)
78	Rozelle	1	2039	'rozell':1	(-33.8630629999999968,151.17057299999999)
79	Leichhardt	1	2040	'leichhardt':1	(-33.8837929999999972,151.157057000000009)
80	Lilyfield	1	2040	'lilyfield':1	(-33.872990999999999,151.165787999999992)
81	Birchgrove	1	2040	'birchgrov':1	(-33.8533860000000004,151.180609000000004)
2	Chatswood	1	2057	'chatswood':1	(-33.795617,151.185328999999996)
11	Central Tilba	1	2546	'central':1 'tilba':2	(-36.3117730000000023,150.084816999999987)
19	Eastern Suburbs	1	2004	'eastern':1 'suburb':2	(-32.8310000000000031,150.13900000000001)
20	University Of Sydney	1	2006	'sydney':3 'univers':1	(-33.8879999999999981,151.187000000000012)
42	Centennial Park	1	2021	'centenni':1 'park':2	(-33.8909999999999982,151.228000000000009)
110	Milsons Point	1	2061	'milson':1 'point':2	(-33.847526000000002,151.211568)
113	Artarmon	1	2064	'artarmon':1	(-33.8076640000000026,151.189661999999998)
114	Crows Nest	1	2065	'crow':1 'nest':2	(-33.8260900000000007,151.199192000000011)
119	Lane Cove	1	2066	'cove':2 'lane':1	(-33.8145990000000012,151.168722000000002)
154	Hornsby	1	2077	'hornsbi':1	(-33.7047480000000022,151.09869599999999)
170	Frenchs Forest	1	2086	'forest':2 'french':1	(-33.7509640000000033,151.226035999999993)
82	Balmain	1	2041	'balmain':1	(-33.856498000000002,151.178009000000003)
84	Enmore	1	2042	'enmor':1	(-30.7215409999999984,151.731618999999995)
85	Newtown	1	2042	'newtown':1	(-33.8964489999999969,151.180013000000002)
86	Erskineville	1	2043	'erskinevill':1	(-33.902234,151.186192000000005)
87	St Peters	1	2044	'peter':2 'st':1	(-33.9110620000000011,151.180126000000001)
88	Sydenham	1	2044	'sydenham':1	(-33.915222,151.16610399999999)
90	Haberfield	1	2045	'haberfield':1	(-33.8804960000000008,151.13883899999999)
91	Abbotsford	1	2046	'abbotsford':1	(-33.8524689999999993,151.129453000000012)
93	Chiswick	1	2046	'chiswick':1	(-33.8514369999999971,151.135953999999998)
94	Five Dock	1	2046	'dock':2 'five':1	(-33.8663680000000014,151.130135999999993)
95	Rodd Point	1	2046	'point':2 'rodd':1	(-33.8682080000000028,151.141651999999993)
96	Russell Lea	1	2046	'lea':2 'russel':1	(-33.8607200000000006,151.14071100000001)
97	Wareemba	1	2046	'wareemba':1	(-33.8568280000000001,151.130728000000005)
100	Lewisham	1	2049	'lewisham':1	(-33.8949020000000019,151.144412999999986)
101	Petersham	1	2049	'petersham':1	(-33.8962420000000009,151.154135999999994)
104	North Sydney	1	2059	'north':1 'sydney':2	(-33.8382649999999998,151.206480999999997)
126	Chatswood	1	2067	'chatswood':1	(-33.795617,151.185328999999996)
106	Lavender Bay	1	2060	'bay':2 'lavend':1	(-33.8430699999999973,151.208014999999989)
107	Mcmahons Point	1	2060	'mcmahon':1 'point':2	(-33.8446399999999983,151.204250000000002)
105	Waverton	1	2060	'waverton':1	(-33.8399690000000035,151.195808)
109	Kirribilli	1	2061	'kirribilli':1	(-33.8462749999999986,151.212705)
112	Northbridge	1	2063	'northbridg':1	(-33.8150279999999981,151.222265999999991)
115	Greenwich	1	2065	'greenwich':1	(-33.8319580000000002,151.186128999999994)
116	Naremburn	1	2065	'naremburn':1	(-33.8172989999999984,151.201159999999987)
120	Lane Cove North	1	2066	'cove':2 'lane':1 'north':3	(-33.8075559999999982,151.170911999999987)
121	Lane Cove West	1	2066	'cove':2 'lane':1 'west':3	(-33.8062460000000016,151.153280999999993)
122	Linley Point	1	2066	'linley':1 'point':2	(-33.8267769999999999,151.148250999999988)
123	Longueville	1	2066	'longuevill':1	(-33.8330959999999976,151.16534200000001)
125	Riverview	1	2066	'riverview':1	(-29.9046430000000001,150.687307000000004)
127	Chatswood West	1	2067	'chatswood':1 'west':2	(-33.7963319999999996,151.167142000000013)
132	Castlecrag	1	2068	'castlecrag':1	(-33.8024029999999982,151.212643000000014)
128	Middle Cove	1	2068	'cove':2 'middl':1	(-33.7940869999999975,151.207975000000005)
130	Willoughby	1	2068	'willoughbi':1	(-33.8014829999999975,151.198599999999999)
131	Willoughby East	1	2068	'east':2 'willoughbi':1	(-33.8025340000000014,151.203505000000007)
135	Castle Cove	1	2069	'castl':1 'cove':2	(-33.7841650000000016,151.199948000000006)
133	Roseville	1	2069	'rosevill':1	(-33.7846350000000015,151.177110999999996)
136	East Lindfield	1	2070	'east':1 'lindfield':2	(-33.7664150000000021,151.186094999999995)
137	Lindfield	1	2070	'lindfield':1	(-33.7764409999999984,151.168735999999996)
139	East Killara	1	2071	'east':1 'killara':2	(-33.7534980000000004,151.170003000000008)
138	Killara	1	2071	'killara':1	(-33.7663760000000011,151.162047000000001)
140	Gordon	1	2072	'gordon':1	(-33.7573489999999978,151.155677999999995)
141	Pymble	1	2073	'pymbl':1	(-33.7441400000000016,151.141102999999987)
145	North Turramurra	1	2074	'north':1 'turramurra':2	(-33.7134190000000018,151.147145999999992)
144	South Turramurra	1	2074	'south':1 'turramurra':2	(-33.746026999999998,151.113440999999995)
143	Turramurra	1	2074	'turramurra':1	(-33.7332439999999991,151.129808999999995)
147	St Ives	1	2075	'ive':2 'st':1	(-33.7306010000000001,151.158550999999989)
148	St Ives Chase	1	2075	'chase':3 'ive':2 'st':1	(-33.7078950000000006,151.163445999999993)
149	Normanhurst	1	2076	'normanhurst':1	(-33.7209989999999991,151.097330999999997)
150	Wahroonga	1	2076	'wahroonga':1	(-33.7164050000000017,151.118119000000007)
153	Asquith	1	2077	'asquith':1	(-33.6874839999999978,151.108685000000008)
155	Hornsby Heights	1	2077	'height':2 'hornsbi':1	(-33.6700859999999977,151.095503000000008)
152	Waitara	1	2077	'waitara':1	(-33.7095410000000015,151.104136000000011)
156	Mount Colah	1	2079	'colah':2 'mount':1	(-33.6648169999999993,151.11716100000001)
158	Berowra	1	2081	'berowra':1	(-33.6235810000000015,151.150116999999995)
159	Cowan	1	2081	'cowan':1	(-33.5894910000000024,151.171015000000011)
160	Berowra Heights	1	2082	'berowra':1 'height':2	(-33.6109679999999997,151.136829000000006)
161	Berowra Waters	1	2082	'berowra':1 'water':2	(-33.6016529999999989,151.118369999999999)
162	Brooklyn	1	2083	'brooklyn':1	(-33.5480060000000009,151.225189999999998)
163	Dangar Island	1	2083	'dangar':1 'island':2	(-33.5393570000000025,151.241761999999994)
165	Mooney Mooney	1	2083	'mooney':1,2	(-33.4903559999999985,151.18617900000001)
166	Duffys Forest	1	2084	'duffi':1 'forest':2	(-33.6767749999999992,151.19987900000001)
167	Terrey Hills	1	2084	'hill':2 'terrey':1	(-33.683644000000001,151.228469999999987)
168	Belrose	1	2085	'belros':1	(-33.7392880000000019,151.211439000000013)
169	Davidson	1	2085	'davidson':1	(-33.7387310000000014,151.194197000000003)
172	Killarney Heights	1	2087	'height':2 'killarney':1	(-33.7737279999999984,151.216125000000005)
173	Mosman	1	2088	'mosman':1	(-33.8290769999999981,151.24409)
174	Neutral Bay	1	2089	'bay':2 'neutral':1	(-33.8311199999999985,151.221231999999986)
175	Cremorne	1	2090	'cremorn':1	(-33.8281309999999991,151.230232999999998)
177	Seaforth	1	2092	'seaforth':1	(-33.7971059999999994,151.251146000000006)
178	Balgowlah	1	2093	'balgowlah':1	(-33.794120999999997,151.262679999999989)
277	Rhodes	1	2138	'rhode':1	(-33.8307640000000021,151.088105000000013)
221	Gladesville	1	2111	'gladesvill':1	(-33.8328940000000031,151.126963999999987)
227	Ryde	1	2112	'ryde':1	(-33.8129530000000003,151.104941999999994)
237	West Ryde	1	2114	'ryde':2 'west':1	(-33.8077120000000022,151.088724000000013)
238	Ermington	1	2115	'ermington':1	(-33.8141439999999989,151.054495000000003)
247	Pennant Hills	1	2120	'hill':2 'pennant':1	(-33.7386809999999997,151.071433000000013)
254	Parramatta	1	2123	'parramatta':1	(-33.8169570000000022,151.003451000000013)
263	Ashfield	1	2131	'ashfield':1	(-33.8894980000000032,151.127443999999997)
260	Silverwater	1	2128	'silverwat':1	(-33.101384000000003,151.561990000000009)
266	Strathfield	1	2135	'strathfield':1	(-33.8739130000000017,151.093993000000012)
180	Balgowlah Heights	1	2093	'balgowlah':1 'height':2	(-33.8005530000000007,151.257400999999987)
181	Clontarf	1	2093	'clontarf':1	(-33.8082380000000029,151.255095000000011)
179	North Balgowlah	1	2093	'balgowlah':2 'north':1	(-33.7870739999999969,151.251721000000003)
183	Fairlight	1	2094	'fairlight':1	(-33.7941629999999975,151.273978)
186	Curl Curl	1	2096	'curl':1,2	(-33.7689370000000011,151.294035000000008)
187	Harbord	1	2096	'harbord':1	(-33.7786630000000017,151.285772000000009)
188	Collaroy	1	2097	'collaroy':1	(-33.7409689999999998,151.303133000000003)
189	Cromer	1	2099	'cromer':1	(-33.7403529999999989,151.278523000000007)
190	Dee Why	1	2099	'dee':1	(-33.7534509999999983,151.285539999999997)
191	Narraweena	1	2099	'narraweena':1	(-33.7499120000000019,151.274687)
197	Allambie Heights	1	2100	'allambi':1 'height':2	(-33.7650760000000005,151.248863999999998)
193	Beacon Hill	1	2100	'beacon':1 'hill':2	(-33.7524060000000006,151.261271999999991)
194	Brookvale	1	2100	'brookval':1	(-33.7666290000000018,151.273823999999991)
195	North Manly	1	2100	'man':2 'north':1	(-33.7757020000000026,151.269339000000002)
200	Elanora Heights	1	2101	'elanora':1 'height':2	(-33.6950149999999979,151.280156000000005)
201	Ingleside	1	2101	'inglesid':1	(-33.6831760000000031,151.262322000000012)
198	Narrabeen	1	2101	'narrabeen':1	(-33.7231269999999981,151.287365999999992)
202	Warriewood	1	2102	'warriewood':1	(-33.6862649999999988,151.299080000000004)
204	Bayview	1	2104	'bayview':1	(-33.6644500000000022,151.298945000000003)
205	Church Point	1	2105	'church':1 'point':2	(-33.6448729999999969,151.284352000000013)
206	Elvina Bay	1	2105	'bay':2 'elvina':1	(-33.6420109999999966,151.276108999999991)
207	Lovett Bay	1	2105	'bay':2 'lovett':1	(-33.6374050000000011,151.278428999999988)
208	Scotland Island	1	2105	'island':2 'scotland':1	(-33.6417519999999968,151.290116000000012)
210	Newport Beach	1	2106	'beach':2 'newport':1	(-33.6524849999999986,151.322776000000005)
213	Avalon Beach	1	2107	'avalon':1 'beach':2	(-33.6363249999999994,151.330596000000014)
214	Bilgola	1	2107	'bilgola':1	(-33.6455619999999982,151.323857000000004)
215	Careel Bay	1	2107	'bay':2 'careel':1	(-33.6231349999999978,151.327045999999996)
216	Palm Beach	1	2108	'beach':2 'palm':1	(-33.6042819999999978,151.321418999999992)
217	The Basin	1	2108	'basin':2	(-30.2207739999999987,151.285035999999991)
218	Macquarie University	1	2109	'macquari':1 'univers':2	(-33.7743210000000005,151.111987999999997)
220	Hunters Hill	1	2110	'hill':2 'hunter':1	(-33.8348399999999998,151.154196000000013)
222	Henley	1	2111	'henley':1	(-33.8422160000000005,151.135942999999997)
223	Huntleys Cove	1	2111	'cove':2 'huntley':1	(-33.8397980000000018,151.144587000000001)
224	Huntleys Point	1	2111	'huntley':1 'point':2	(-33.8400880000000015,151.145968000000011)
228	Denistone East	1	2112	'deniston':1 'east':2	(-33.7971769999999978,151.097545999999994)
226	Putney	1	2112	'putney':1	(-33.8247349999999969,151.112549000000001)
230	East Ryde	1	2113	'east':1 'ryde':2	(-33.8137690000000006,151.140288999999996)
231	Macquarie Park	1	2113	'macquari':1 'park':2	(-33.779795,151.134040999999996)
232	North Ryde	1	2113	'north':1 'ryde':2	(-33.7967700000000022,151.124355000000008)
233	Denistone	1	2114	'deniston':1	(-33.7994410000000016,151.079589999999996)
234	Denistone West	1	2114	'deniston':1 'west':2	(-33.8023820000000015,151.066084999999987)
235	Meadowbank	1	2114	'meadowbank':1	(-33.8159119999999973,151.090714999999989)
236	Melrose Park	1	2114	'melros':1 'park':2	(-33.8165750000000003,151.076088999999996)
239	Rydalmere	1	2116	'rydalmer':1	(-33.8112440000000021,151.034464000000014)
242	Dundas Valley	1	2117	'dunda':1 'valley':2	(-33.7872399999999971,151.061184999999995)
243	Oatlands	1	2117	'oatland':1	(-33.7962980000000002,151.026314000000013)
240	Telopea	1	2117	'telopea':1	(-33.7959859999999992,151.045106000000004)
246	Beecroft	1	2119	'beecroft':1	(-33.7494980000000027,151.064533000000011)
245	Cheltenham	1	2119	'cheltenham':1	(-33.7616900000000015,151.079363999999998)
248	Thornleigh	1	2120	'thornleigh':1	(-33.7308159999999972,151.081225999999987)
249	Westleigh	1	2120	'westleigh':1	(-33.7119560000000007,151.072835999999995)
253	Eastwood	1	2122	'eastwood':1	(-33.789985999999999,151.080914000000007)
252	Marsfield	1	2122	'marsfield':1	(-33.7839710000000011,151.094241000000011)
256	West Pennant Hills	1	2125	'hill':3 'pennant':2 'west':1	(-33.7536759999999987,151.039112999999986)
257	Cherrybrook	1	2126	'cherrybrook':1	(-33.7220190000000031,151.041806000000008)
259	Newington	1	2127	'newington':1	(-33.8392759999999981,151.054827999999986)
261	Sydney Markets	1	2129	'market':2 'sydney':1	(-33.8712090000000003,151.191883999999988)
262	Summer Hill	1	2130	'hill':2 'summer':1	(-32.478428000000001,151.519412999999986)
264	Croydon	1	2132	'croydon':1	(-33.8831630000000033,151.11477099999999)
268	Burwood Heights	1	2136	'burwood':1 'height':2	(-33.8883280000000013,151.103411999999992)
269	Enfield	1	2136	'enfield':1	(-33.8868539999999996,151.092424999999992)
267	Strathfield South	1	2136	'south':2 'strathfield':1	(-33.8917110000000008,151.08299199999999)
270	Breakfast Point	1	2137	'breakfast':1 'point':2	(-33.841583,151.107502000000011)
271	Cabarita	1	2137	'cabarita':1	(-33.8490809999999982,151.113765000000001)
273	Mortlake	1	2137	'mortlak':1	(-33.8434349999999995,151.106979999999993)
274	North Strathfield	1	2137	'north':1 'strathfield':2	(-33.8574600000000032,151.091953999999987)
275	Concord West	1	2138	'concord':1 'west':2	(-33.848041000000002,151.08732599999999)
212	Avalon	1	2107	'avalon':1	(-33.6289999999999978,151.324000000000012)
315	North Parramatta	1	2151	'north':1 'parramatta':2	(-33.7980429999999998,151.010706999999996)
319	Baulkham Hills	1	2153	'baulkham':1 'hill':2	(-33.7586009999999987,150.992886999999996)
321	Castle Hill	1	2154	'castl':1 'hill':2	(-33.7323069999999987,151.005616000000003)
284	Granville	1	2142	'granvill':1	(-33.8358869999999996,151.010639999999995)
338	Guildford	1	2161	'guildford':1	(-33.853983999999997,150.985958000000011)
350	Fairfield	1	2165	'fairfield':1	(-33.8685290000000023,150.955511999999999)
371	Liverpool	1	2170	'liverpool':1	(-33.9250499999999988,150.924429000000003)
278	Concord Repatriation Hospital	1	2139	'concord':1 'hospit':3 'repatri':2	(-33.8377020000000002,151.095045999999996)
279	Homebush	1	2140	'homebush':1	(-33.859653999999999,151.08184700000001)
280	Homebush West	1	2140	'homebush':1 'west':2	(-33.8667879999999997,151.069368999999995)
282	Berala	1	2141	'berala':1	(-33.8719040000000007,151.031033000000008)
286	Camellia	1	2142	'camellia':1	(-33.8168719999999965,151.022190999999992)
287	Clyde	1	2142	'clyde':1	(-33.8323219999999978,151.019414000000012)
288	Holroyd	1	2142	'holroyd':1	(-33.8298360000000002,150.993334000000004)
285	South Granville	1	2142	'granvill':2 'south':1	(-33.8630220000000008,151.006224000000003)
289	Birrong	1	2143	'birrong':1	(-33.8902199999999993,151.02239800000001)
290	Potts Hill	1	2143	'hill':2 'pott':1	(-33.8982469999999978,151.031087000000014)
294	Girraween	1	2145	'girraween':1	(-33.7998430000000027,150.947275999999988)
295	Greystanes	1	2145	'greystan':1	(-33.8296670000000006,150.951451999999989)
296	Mays Hill	1	2145	'hill':2 'may':1	(-33.8206599999999966,150.990510999999998)
297	Pemulwuy	1	2145	'pemulwuy':1	(-33.821944000000002,150.923752000000007)
298	Pendle Hill	1	2145	'hill':2 'pendl':1	(-33.8019120000000015,150.955613999999997)
299	Wentworthville	1	2145	'wentworthvill':1	(-33.8059220000000025,150.970182999999992)
301	Westmead	1	2145	'westmead':1	(-33.8053319999999999,150.98660799999999)
303	Old Toongabbie	1	2146	'old':1 'toongabbi':2	(-33.7927129999999991,150.974108000000001)
302	Toongabbie	1	2146	'toongabbi':1	(-33.7889419999999987,150.950644000000011)
306	Kings Langley	1	2147	'king':1 'langley':2	(-33.7420789999999968,150.922710999999993)
305	Seven Hills West	1	2147	'hill':2 'seven':1 'west':3	(-33.7710470000000029,150.923870999999991)
308	Arndell Park	1	2148	'arndel':1 'park':2	(-33.7872660000000025,150.871959000000004)
309	Blacktown	1	2148	'blacktown':1	(-33.7701840000000004,150.908501000000001)
310	Kings Park	1	2148	'king':1 'park':2	(-33.7457360000000008,150.904597999999993)
312	Prospect	1	2148	'prospect':1	(-33.8015529999999984,150.916198000000009)
313	Harris Park	1	2150	'harri':1 'park':2	(-33.8224269999999976,151.008960999999999)
316	North Rocks	1	2151	'north':1 'rock':2	(-33.7681189999999987,151.028539999999992)
317	Northmead	1	2152	'northmead':1	(-33.7838489999999965,150.994336000000004)
318	Winston Hills	1	2153	'hill':2 'winston':1	(-33.776054000000002,150.987795000000006)
322	Beaumont Hills	1	2155	'beaumont':1 'hill':2	(-33.7034159999999972,150.946875000000006)
323	Kellyville	1	2155	'kellyvill':1	(-33.712415,150.958009000000004)
325	Rouse Hill	1	2155	'hill':2 'rous':1	(-33.682068000000001,150.915397000000013)
327	Annangrove	1	2156	'annangrov':1	(-33.6577720000000014,150.943504999999988)
328	Glenhaven	1	2156	'glenhaven':1	(-33.7032179999999997,151.006899000000004)
326	Kenthurst	1	2156	'kenthurst':1	(-33.6610230000000001,151.005033999999995)
329	Glenorie	1	2157	'glenori':1	(-33.6200109999999981,151.023034999999993)
330	Dural	1	2158	'dural':1	(-32.5688579999999988,150.843641999999988)
332	Arcadia	1	2159	'arcadia':1	(-33.6231009999999984,151.052726000000007)
333	Berrilee	1	2159	'berrile':1	(-33.6149699999999996,151.095573000000002)
334	Fiddletown	1	2159	'fiddletown':1	(-33.6023210000000034,151.055701999999997)
335	Galston	1	2159	'galston':1	(-33.6526610000000019,151.043059)
336	Merrylands	1	2160	'merryland':1	(-33.8363810000000029,150.989218999999991)
339	Guildford West	1	2161	'guildford':1 'west':2	(-33.8510989999999978,150.972298999999992)
340	Old Guildford	1	2161	'guildford':2 'old':1	(-33.8670839999999984,150.988073000000014)
341	Yennora	1	2161	'yennora':1	(-33.8608890000000002,150.969356000000005)
342	Sefton	1	2162	'sefton':1	(-33.8855009999999979,151.011469000000005)
344	Carramar	1	2163	'carramar':1	(-33.8845579999999984,150.961883999999998)
345	Lansdowne	1	2163	'lansdown':1	(-31.7829890000000006,152.534579000000008)
346	Villawood	1	2163	'villawood':1	(-33.8836790000000008,150.976468000000011)
347	Smithfield	1	2164	'smithfield':1	(-33.8535460000000015,150.94043099999999)
349	Woodpark	1	2164	'woodpark':1	(-33.8406299999999973,150.961859000000004)
351	Fairfield East	1	2165	'east':2 'fairfield':1	(-33.869449000000003,150.977528000000007)
352	Fairfield Heights	1	2165	'fairfield':1 'height':2	(-33.8646030000000025,150.938450999999986)
353	Fairfield West	1	2165	'fairfield':1 'west':2	(-33.8689549999999997,150.922056999999995)
354	Cabramatta	1	2166	'cabramatta':1	(-33.8950699999999969,150.935889000000003)
356	Canley Heights	1	2166	'canley':1 'height':2	(-33.8836330000000032,150.923894999999987)
357	Canley Vale	1	2166	'canley':1 'vale':2	(-33.8872909999999976,150.943275)
358	Lansvale	1	2166	'lansval':1	(-33.8973299999999966,150.952786000000003)
359	Glenfield	1	2167	'glenfield':1	(-33.971305000000001,150.894517000000008)
361	Busby	1	2168	'busbi':1	(-33.910896000000001,150.875155000000007)
362	Cartwright	1	2168	'cartwright':1	(-33.9265770000000018,150.890355999999997)
363	Green Valley	1	2168	'green':1 'valley':2	(-33.9035259999999994,150.866359999999986)
364	Heckenberg	1	2168	'heckenberg':1	(-33.9110829999999979,150.889920999999987)
367	Sadleir	1	2168	'sadleir':1	(-33.9206289999999981,150.890211999999991)
368	Casula	1	2170	'casula':1	(-33.9473500000000001,150.907753000000014)
369	Chipping Norton	1	2170	'chip':1 'norton':2	(-33.9168289999999999,150.96166199999999)
372	Liverpool South	1	2170	'liverpool':1 'south':2	(-33.9333760000000026,150.906608000000006)
373	Lurnea	1	2170	'lurnea':1	(-33.931947000000001,150.896105000000006)
375	Mount Pritchard	1	2170	'mount':1 'pritchard':2	(-33.8948170000000033,150.903040000000004)
2312	Warren	1	2824	'warren':1	(-31.6993790000000004,147.837310000000002)
366	Miller	1	2168	'miller':1	(-33.9110000000000014,150.877999999999986)
463	Hurstville	1	2220	'hurstvill':1	(-33.9659229999999965,151.101183999999989)
420	Bankstown	1	2200	'bankstown':1	(-33.9195390000000003,151.034908999999999)
447	Milperra	1	2214	'milperra':1	(-33.9378340000000023,150.989262999999994)
376	Prestons	1	2170	'preston':1	(-33.9429030000000012,150.872144999999989)
378	Cecil Hills	1	2171	'cecil':1 'hill':2	(-33.8836960000000005,150.853171000000003)
379	Horningsea Park	1	2171	'horningsea':1 'park':2	(-33.9450879999999984,150.842974999999996)
380	Hoxton Park	1	2171	'hoxton':1 'park':2	(-33.9267800000000008,150.857888000000003)
382	West Hoxton	1	2171	'hoxton':2 'west':1	(-33.9222719999999995,150.839967000000001)
383	Pleasure Point	1	2172	'pleasur':1 'point':2	(-33.9669090000000011,150.987639999999999)
384	Sandy Point	1	2172	'point':2 'sandi':1	(-33.9754190000000023,150.993966999999998)
386	Holsworthy	1	2173	'holsworthi':1	(-33.9504030000000014,150.949972000000002)
387	Wattle Grove	1	2173	'grove':2 'wattl':1	(-33.963315999999999,150.936403000000013)
390	Abbotsbury	1	2176	'abbotsburi':1	(-33.8775380000000013,150.867768000000012)
391	Bossley Park	1	2176	'bossley':1 'park':2	(-33.8662599999999969,150.884150000000005)
499	Loftus	1	2232	'loftus':1	(-34.0480749999999972,151.051175999999998)
392	Edensor Park	1	2176	'edensor':1 'park':2	(-33.8770570000000006,150.875292000000002)
393	Greenfield Park	1	2176	'greenfield':1 'park':2	(-33.8721869999999967,150.889408000000003)
394	Prairiewood	1	2176	'prairiewood':1	(-33.8673420000000007,150.90213)
396	Wakeley	1	2176	'wakeley':1	(-33.8739660000000029,150.908880000000011)
397	Bonnyrigg	1	2177	'bonnyrigg':1	(-33.8888010000000008,150.886505)
398	Bonnyrigg Heights	1	2177	'bonnyrigg':1 'height':2	(-33.892667000000003,150.868448000000001)
399	Cecil Park	1	2178	'cecil':1 'park':2	(-33.8747800000000012,150.838224999999994)
400	Kemps Creek	1	2178	'creek':2 'kemp':1	(-33.8801300000000012,150.79048499999999)
402	Austral	1	2179	'austral':1	(-33.9331090000000017,150.81203099999999)
403	Leppington	1	2179	'leppington':1	(-33.9643330000000034,150.817270000000008)
404	Chullora	1	2190	'chullora':1	(-33.892440999999998,151.055898000000013)
405	Greenacre	1	2190	'greenacr':1	(-33.9067440000000033,151.057270999999986)
407	Belfield	1	2191	'belfield':1	(-33.9021070000000009,151.083552999999995)
408	Belmore	1	2192	'belmor':1	(-33.9160350000000008,151.087500000000006)
409	Ashbury	1	2193	'ashburi':1	(-33.9018969999999982,151.119319999999988)
410	Canterbury	1	2193	'canterburi':1	(-33.9108480000000014,151.121145000000013)
412	Campsie	1	2194	'campsi':1	(-33.9143729999999977,151.103465)
413	Lakemba	1	2195	'lakemba':1	(-33.920456999999999,151.075920999999994)
414	Wiley Park	1	2195	'park':2 'wiley':1	(-33.922463999999998,151.068194000000005)
415	Punchbowl	1	2196	'punchbowl':1	(-29.4945990000000009,152.795220999999998)
416	Roselands	1	2196	'roseland':1	(-33.9331669999999974,151.073196999999993)
418	Georges Hall	1	2198	'georg':1 'hall':2	(-33.9128510000000034,150.982469000000009)
419	Yagoona	1	2199	'yagoona':1	(-33.9077249999999992,151.026107999999994)
421	Condell Park	1	2200	'condel':1 'park':2	(-33.9220339999999965,151.011618999999996)
424	Arncliffe	1	2205	'arncliff':1	(-33.9365919999999974,151.146805000000001)
425	Turrella	1	2205	'turrella':1	(-33.9299630000000008,151.140643000000011)
426	Wolli Creek	1	2205	'creek':2 'wolli':1	(-33.9307439999999971,151.155271999999997)
427	Clemton Park	1	2206	'clemton':1 'park':2	(-33.9253569999999982,151.103282000000007)
428	Earlwood	1	2206	'earlwood':1	(-33.9265100000000004,151.126479999999987)
430	Bardwell Valley	1	2207	'bardwel':1 'valley':2	(-33.9350829999999988,151.134685999999988)
431	Bexley	1	2207	'bexley':1	(-33.9491349999999983,151.127209999999991)
432	Bexley North	1	2207	'bexley':1 'north':2	(-33.9383059999999972,151.114185999999989)
434	Beverly Hills	1	2209	'bever':1 'hill':2	(-33.9542179999999973,151.076364000000012)
435	Narwee	1	2209	'narwe':1	(-33.9486089999999976,151.069627999999994)
436	Peakhurst	1	2210	'peakhurst':1	(-33.9597150000000028,151.062186999999994)
437	Peakhurst Heights	1	2210	'height':2 'peakhurst':1	(-33.9681270000000026,151.05759599999999)
438	Riverwood	1	2210	'riverwood':1	(-33.9498589999999965,151.052469000000002)
441	Padstow Heights	1	2211	'height':2 'padstow':1	(-33.971072999999997,151.030955000000006)
442	Revesby	1	2212	'revesbi':1	(-33.9515069999999994,151.017246999999998)
443	Revesby Heights	1	2212	'height':2 'revesbi':1	(-33.9688019999999966,151.015062999999998)
445	Panania	1	2213	'panania':1	(-33.9561300000000017,150.998047000000014)
446	Picnic Point	1	2213	'picnic':1 'point':2	(-33.9793030000000016,151.000056000000001)
448	Banksia	1	2216	'banksia':1	(-33.9452369999999988,151.140161000000006)
450	Kyeemagh	1	2216	'kyeemagh':1	(-33.9514520000000033,151.159942999999998)
451	Rockdale	1	2216	'rockdal':1	(-33.9527470000000022,151.137623999999988)
452	Beverley Park	1	2217	'beverley':1 'park':2	(-33.9751350000000016,151.13134500000001)
453	Kogarah	1	2217	'kogarah':1	(-33.9631070000000008,151.133462000000009)
454	Kogarah Bay	1	2217	'bay':2 'kogarah':1	(-33.9791170000000022,151.123296000000011)
455	Monterey	1	2217	'monterey':1	(-33.9730679999999978,151.150982999999997)
456	Ramsgate	1	2217	'ramsgat':1	(-33.9846829999999969,151.139847000000003)
458	Allawah	1	2218	'allawah':1	(-33.9700180000000032,151.114517000000006)
459	Carlton	1	2218	'carlton':1	(-33.9685229999999976,151.124527999999998)
460	Dolls Point	1	2219	'doll':1 'point':2	(-33.9934950000000029,151.146801000000011)
461	Sandringham	1	2219	'sandringham':1	(-33.9987629999999967,151.139251999999999)
462	Sans Souci	1	2219	'san':1 'souci':2	(-33.9906140000000008,151.133073999999993)
467	Blakehurst	1	2221	'blakehurst':1	(-33.9887429999999995,151.112313999999998)
468	Carss Park	1	2221	'carss':1 'park':2	(-33.9865560000000002,151.11904100000001)
469	Connells Point	1	2221	'connel':1 'point':2	(-33.9918710000000033,151.089494999999999)
465	Kyle Bay	1	2221	'bay':2 'kyle':1	(-33.9912380000000027,151.098300999999992)
470	Penshurst	1	2222	'penshurst':1	(-33.9633460000000014,151.08674400000001)
471	Mortdale	1	2223	'mortdal':1	(-33.9722390000000019,151.075390999999996)
472	Oatley	1	2223	'oatley':1	(-33.9814280000000011,151.082764999999995)
2313	Bogan	1	2825	'bogan':1	(-30.1981409999999997,146.538199999999989)
388	Edmondson Park	1	2174	'edmondson':1 'park':2	(-33.9609999999999985,150.858000000000004)
500	Sutherland	1	2232	'sutherland':1	(-34.0314320000000023,151.057964999999996)
473	Kangaroo Point	1	2224	'kangaroo':1 'point':2	(-33.9979719999999972,151.096235000000007)
474	Sylvania	1	2224	'sylvania':1	(-34.0080749999999981,151.105104000000011)
476	Oyster Bay	1	2225	'bay':2 'oyster':1	(-34.0068940000000026,151.08106699999999)
477	Bonnet Bay	1	2226	'bay':2 'bonnet':1	(-34.0095179999999999,151.054251999999991)
478	Como	1	2226	'como':1	(-34.0041859999999971,151.068287999999995)
479	Jannali	1	2226	'jannali':1	(-34.0170740000000009,151.065080999999992)
480	Gymea	1	2227	'gymea':1	(-34.033141999999998,151.085420999999997)
483	Yowie Bay	1	2228	'bay':2 'yowi':1	(-34.0498660000000015,151.104324999999989)
485	Dolans Bay	1	2229	'bay':2 'dolan':1	(-34.0596800000000002,151.126745999999997)
486	Lilli Pilli	1	2229	'lilli':1 'pilli':2	(-35.7733169999999987,150.225055999999995)
488	Taren Point	1	2229	'point':2 'taren':1	(-34.0125450000000029,151.125456000000014)
489	Bundeena	1	2230	'bundeena':1	(-34.0850640000000027,151.15125900000001)
490	Burraneer	1	2230	'burran':1	(-34.0650630000000021,151.137170999999995)
491	Cronulla	1	2230	'cronulla':1	(-34.0519719999999992,151.153661999999997)
492	Maianbar	1	2230	'maianbar':1	(-34.0818259999999995,151.129787999999991)
494	Kurnell	1	2231	'kurnel':1	(-34.0084870000000024,151.204879000000005)
495	Audley	1	2232	'audley':1	(-34.075294999999997,151.056519000000009)
496	Grays Point	1	2232	'gray':1 'point':2	(-34.0588399999999965,151.081651999999991)
497	Kareela	1	2232	'kareela':1	(-34.0146680000000003,151.08273299999999)
501	Woronora	1	2232	'woronora':1	(-34.0206540000000004,151.047945999999996)
502	Engadine	1	2233	'engadin':1	(-34.0657160000000019,151.012663000000003)
504	Waterfall	1	2233	'waterfal':1	(-34.1351999999999975,150.994956999999999)
505	Woronora Heights	1	2233	'height':2 'woronora':1	(-34.0348359999999985,151.027656000000007)
506	Yarrawarrah	1	2233	'yarrawarrah':1	(-34.0584619999999987,151.032790000000006)
508	Bangor	1	2234	'bangor':1	(-34.0188759999999988,151.030056999999999)
509	Barden Ridge	1	2234	'barden':1 'ridg':2	(-34.0328510000000009,151.00539599999999)
510	Illawong	1	2234	'illawong':1	(-33.9980180000000018,151.042590999999987)
511	Lucas Heights	1	2234	'height':2 'luca':1	(-34.0479849999999971,150.988369000000006)
512	Menai	1	2234	'menai':1	(-34.0125639999999976,151.014645000000002)
513	Calga	1	2250	'calga':1	(-33.4383499999999998,151.236467000000005)
518	Erina	1	2250	'erina':1	(-33.4378930000000025,151.383647999999994)
514	Gosford	1	2250	'gosford':1	(-33.4269379999999998,151.341843000000011)
519	Kariong	1	2250	'kariong':1	(-33.4397329999999968,151.29333299999999)
520	Kulnura	1	2250	'kulnura':1	(-33.2259239999999991,151.222101000000009)
522	Lower Mangrove	1	2250	'lower':1 'mangrov':2	(-33.4120449999999991,151.150688000000002)
523	Mangrove Mountain	1	2250	'mangrov':1 'mountain':2	(-33.3008469999999974,151.191661000000011)
524	Matcham	1	2250	'matcham':1	(-33.4170039999999986,151.420834000000013)
526	Narara	1	2250	'narara':1	(-33.3958069999999978,151.346114)
527	Niagara Park	1	2250	'niagara':1 'park':2	(-33.3819960000000009,151.355782000000005)
516	North Gosford	1	2250	'gosford':2 'north':1	(-33.4168400000000005,151.348820999999987)
528	Peats Ridge	1	2250	'peat':1 'ridg':2	(-33.3511990000000011,151.229736000000003)
530	Somersby	1	2250	'somersbi':1	(-33.3609920000000031,151.291053000000005)
531	Springfield	1	2250	'springfield':1	(-36.5423509999999965,149.076874000000004)
532	Tascott	1	2250	'tascott':1	(-33.4508179999999982,151.319442000000009)
533	Wendoree Park	1	2250	'park':2 'wendore':1	(-33.4555519999999973,151.155631)
534	Wyoming	1	2250	'wyom':1	(-33.4048500000000033,151.350775999999996)
535	Avoca Beach	1	2251	'avoca':1 'beach':2	(-33.464936999999999,151.432387000000006)
536	Bensville	1	2251	'bensvill':1	(-33.4985789999999994,151.381089000000003)
537	Copacabana	1	2251	'copacabana':1	(-33.4899399999999972,151.430557999999991)
538	Davistown	1	2251	'davistown':1	(-33.4856849999999966,151.360521000000006)
540	Kincumber	1	2251	'kincumb':1	(-33.4677379999999971,151.382147000000003)
541	Macmasters Beach	1	2251	'beach':2 'macmast':1	(-33.4928209999999993,151.41647900000001)
542	Saratoga	1	2251	'saratoga':1	(-33.4756920000000022,151.354149000000007)
543	Yattalunga	1	2251	'yattalunga':1	(-33.4705680000000001,151.360535999999996)
544	Blackwall	1	2256	'blackwal':1	(-33.5034339999999986,151.327631999999994)
546	Patonga	1	2256	'patonga':1	(-33.5464520000000022,151.27118999999999)
547	Pearl Beach	1	2256	'beach':2 'pearl':1	(-33.5389150000000029,151.302812999999986)
548	Phegans Bay	1	2256	'bay':2 'phegan':1	(-33.4885900000000021,151.308452999999986)
549	Woy Woy	1	2256	'woy':1,2	(-33.4858550000000008,151.324774999999988)
551	Daleys Point	1	2257	'daley':1 'point':2	(-33.5056900000000013,151.348181000000011)
552	Empire Bay	1	2257	'bay':2 'empir':1	(-33.4941859999999991,151.362188000000003)
553	Ettalong Beach	1	2257	'beach':2 'ettalong':1	(-33.513696000000003,151.335288999999989)
555	Killcare	1	2257	'killcar':1	(-33.5259780000000021,151.362657000000013)
556	Pretty Beach	1	2257	'beach':2 'pretti':1	(-35.5644630000000035,150.379514)
557	St Huberts Island	1	2257	'hubert':2 'island':3 'st':1	(-33.4957210000000032,151.344440999999989)
558	Umina Beach	1	2257	'beach':2 'umina':1	(-33.5287459999999982,151.307502999999997)
560	Ourimbah	1	2258	'ourimbah':1	(-33.3597030000000032,151.369650000000007)
561	Chain Valley Bay	1	2259	'bay':3 'chain':1 'valley':2	(-33.1741019999999978,151.580195000000003)
562	Dooralong	1	2259	'dooralong':1	(-33.1893839999999969,151.350214999999992)
563	Durren Durren	1	2259	'durren':1,2	(-33.1714309999999983,151.382287999999988)
565	Halloran	1	2259	'halloran':1	(-33.2394460000000009,151.439517999999993)
566	Hamlyn Terrace	1	2259	'hamlyn':1 'terrac':2	(-33.2505740000000003,151.469872000000009)
567	Jilliby	1	2259	'jillibi':1	(-33.2308540000000008,151.391869000000014)
568	Kanwal	1	2259	'kanwal':1	(-33.2634120000000024,151.479653000000013)
570	Lemon Tree	1	2259	'lemon':1 'tree':2	(-33.1461019999999991,151.364802999999995)
571	Mannering Park	1	2259	'manner':1 'park':2	(-33.1505379999999974,151.53760299999999)
572	Mardi	1	2259	'mardi':1	(-33.2834199999999996,151.404775000000001)
573	Ravensdale	1	2259	'ravensdal':1	(-33.1474699999999984,151.288583999999986)
575	Tacoma	1	2259	'tacoma':1	(-33.2854889999999983,151.453688999999997)
576	Tuggerah	1	2259	'tuggerah':1	(-33.3070099999999982,151.415900999999991)
577	Tuggerawong	1	2259	'tuggerawong':1	(-33.2806569999999979,151.476312000000007)
578	Wallarah	1	2259	'wallarah':1	(-33.2418509999999969,151.456522000000007)
579	Warnervale	1	2259	'warnerval':1	(-33.2424340000000029,151.459786000000008)
581	Woongarrah	1	2259	'woongarrah':1	(-33.2460820000000012,151.477238999999997)
582	Wyee	1	2259	'wyee':1	(-33.1758439999999979,151.484958000000006)
583	Wyong	1	2259	'wyong':1	(-33.2834799999999973,151.422404)
585	Yarramalong	1	2259	'yarramalong':1	(-33.2225290000000015,151.277494999999988)
586	Erina Heights	1	2260	'erina':1 'height':2	(-33.4269490000000005,151.41321099999999)
587	Forresters Beach	1	2260	'beach':2 'forrest':1	(-33.4071080000000009,151.463884000000007)
589	Terrigal	1	2260	'terrig':1	(-33.448011000000001,151.44446099999999)
590	Wamberal	1	2260	'wamber':1	(-33.4182980000000001,151.446192999999994)
591	Bateau Bay	1	2261	'bateau':1 'bay':2	(-33.3812130000000025,151.479104000000007)
592	Berkeley Vale	1	2261	'berkeley':1 'vale':2	(-33.3417880000000011,151.431630000000013)
593	Blue Bay	1	2261	'bay':2 'blue':1	(-33.3571839999999966,151.500047999999992)
595	Chittaway Point	1	2261	'chittaway':1 'point':2	(-33.3266160000000013,151.463661000000002)
596	Glenning Valley	1	2261	'glen':1 'valley':2	(-33.353709000000002,151.425995999999998)
597	Killarney Vale	1	2261	'killarney':1 'vale':2	(-33.369601000000003,151.459782999999987)
598	Long Jetty	1	2261	'jetti':2 'long':1	(-33.3591630000000023,151.484178000000014)
599	Magenta	1	2261	'magenta':1	(-33.3133350000000021,151.519517000000008)
601	The Entrance	1	2261	'entranc':2	(-33.3446479999999994,151.496394000000009)
602	The Entrance North	1	2261	'entranc':2 'north':3	(-33.3262539999999987,151.511248999999992)
603	Toowoon Bay	1	2261	'bay':2 'toowoon':1	(-33.3580200000000033,151.496591999999993)
604	Tumbi Umbi	1	2261	'tumbi':1 'umbi':2	(-33.362679,151.447302000000008)
606	Budgewoi	1	2262	'budgewoi':1	(-33.2343490000000017,151.554753000000005)
607	Buff Point	1	2262	'buff':1 'point':2	(-33.2381960000000021,151.535266000000007)
608	Doyalson	1	2262	'doyalson':1	(-33.1971679999999978,151.521116000000006)
609	Halekulani	1	2262	'halekulani':1	(-33.2234839999999991,151.550635)
611	Canton Beach	1	2263	'beach':2 'canton':1	(-33.2719220000000035,151.544045000000011)
612	Charmhaven	1	2263	'charmhaven':1	(-33.2299119999999988,151.502912000000009)
613	Gorokan	1	2263	'gorokan':1	(-33.2575440000000029,151.510399000000007)
614	Lake Haven	1	2263	'haven':2 'lake':1	(-33.2400919999999971,151.501927999999992)
616	Noraville	1	2263	'noravill':1	(-33.2659420000000026,151.559913999999992)
617	Toukley	1	2263	'toukley':1	(-33.2654589999999999,151.540694999999999)
618	Bonnells Bay	1	2264	'bay':2 'bonnel':1	(-33.107405,151.51826299999999)
619	Brightwaters	1	2264	'brightwat':1	(-33.1144549999999995,151.545925000000011)
621	Eraring	1	2264	'erar':1	(-33.0712490000000017,151.52294599999999)
622	Mandalong	1	2264	'mandalong':1	(-33.1452409999999986,151.414626999999996)
623	Mirrabooka	1	2264	'mirrabooka':1	(-33.1086340000000021,151.555005999999992)
624	Morisset	1	2264	'morisset':1	(-33.1083360000000013,151.487758000000014)
628	Cooranbong	1	2265	'cooranbong':1	(-33.0766089999999977,151.453989000000007)
629	Martinsville	1	2265	'martinsvill':1	(-33.0557850000000002,151.406242999999989)
630	Wangi Wangi	1	2267	'wangi':1,2	(-33.0714910000000017,151.584365999999989)
631	Barnsley	1	2278	'barnsley':1	(-32.9324119999999994,151.590415000000007)
633	Wakefield	1	2278	'wakefield':1	(-32.9565839999999994,151.560504000000009)
634	Belmont	1	2280	'belmont':1	(-33.0360569999999996,151.660562999999996)
635	Belmont North	1	2280	'belmont':1 'north':2	(-33.0222279999999984,151.672028000000012)
636	Belmont South	1	2280	'belmont':1 'south':2	(-33.0531700000000015,151.654854)
638	Floraville	1	2280	'floravill':1	(-33.0090360000000018,151.664654000000013)
639	Jewells	1	2280	'jewel':1	(-33.0141249999999999,151.683174000000008)
640	Marks Point	1	2280	'mark':1 'point':2	(-33.0552119999999974,151.646097999999995)
641	Valentine	1	2280	'valentin':1	(-33.0088859999999968,151.635154999999997)
642	Blacksmiths	1	2281	'blacksmith':1	(-33.0771609999999967,151.652305000000013)
644	Catherine Hill Bay	1	2281	'bay':3 'catherin':1 'hill':2	(-33.1617949999999979,151.626395000000002)
645	Caves Beach	1	2281	'beach':2 'cave':1	(-33.1082120000000018,151.640147000000013)
646	Middle Camp	1	2281	'camp':2 'middl':1	(-33.1344700000000003,151.626475999999997)
647	Nords Wharf	1	2281	'nord':1 'wharf':2	(-33.1351749999999967,151.603971999999999)
649	Eleebana	1	2282	'eleebana':1	(-32.993625999999999,151.635401000000002)
650	Lakelands	1	2282	'lakeland':1	(-32.9614830000000012,151.650876000000011)
651	Warners Bay	1	2282	'bay':2 'warner':1	(-32.9754179999999977,151.644681999999989)
653	Awaba	1	2283	'awaba':1	(-33.0077390000000008,151.543407000000002)
654	Balmoral	1	2283	'balmor':1	(-34.2944219999999973,150.525259000000005)
655	Blackalls Park	1	2283	'blackal':1 'park':2	(-33.0004410000000021,151.584634999999992)
656	Bolton Point	1	2283	'bolton':1 'point':2	(-33.0004169999999988,151.610354000000001)
657	Buttaba	1	2283	'buttaba':1	(-33.0509360000000001,151.571936999999991)
659	Coal Point	1	2283	'coal':1 'point':2	(-33.0412960000000027,151.612171999999987)
660	Fassifern	1	2283	'fassifern':1	(-32.9883680000000012,151.583244000000008)
661	Fennell Bay	1	2283	'bay':2 'fennel':1	(-32.9921039999999977,151.600092999999987)
663	Kilaben Bay	1	2283	'bay':2 'kilaben':1	(-33.0245340000000027,151.587294000000014)
664	Rathmines	1	2283	'rathmin':1	(-33.0457850000000022,151.594150000000013)
665	Toronto	1	2283	'toronto':1	(-33.0132899999999978,151.593162000000007)
666	Argenton	1	2284	'argenton':1	(-32.9348129999999983,151.630878999999993)
667	Boolaroo	1	2284	'boolaroo':1	(-32.9552690000000013,151.622332)
669	Marmong Point	1	2284	'marmong':1 'point':2	(-32.9830189999999988,151.618114999999989)
670	Speers Point	1	2284	'point':2 'speer':1	(-32.9735429999999994,151.631366000000014)
671	Teralba	1	2284	'teralba':1	(-32.9637269999999987,151.605034999999987)
626	Sunshine	1	2264	'sunshin':1	(-33.107999999999997,151.472000000000008)
745	Hunter Region	1	2310	'hunter':1 'region':2	\N
673	Cameron Park	1	2285	'cameron':1 'park':2	(-32.9339519999999979,151.655731000000003)
674	Cardiff	1	2285	'cardiff':1	(-32.9397049999999965,151.659343000000007)
675	Cardiff Heights	1	2285	'cardiff':1 'height':2	(-32.9362190000000012,151.672253000000012)
677	Edgeworth	1	2285	'edgeworth':1	(-32.9237660000000005,151.622249000000011)
678	Glendale	1	2285	'glendal':1	(-32.9268229999999988,151.650189000000012)
679	Macquarie Hills	1	2285	'hill':2 'macquari':1	(-32.9531509999999983,151.647116000000011)
680	Holmesville	1	2286	'holmesvill':1	(-32.9136609999999976,151.576846999999987)
681	West Wallsend	1	2286	'wallsend':2 'west':1	(-32.9024760000000001,151.582845999999989)
683	Elermore Vale	1	2287	'elermor':1 'vale':2	(-32.916279000000003,151.675532000000004)
684	Fletcher	1	2287	'fletcher':1	(-32.8765730000000005,151.637462999999997)
685	Maryland	1	2287	'maryland':1	(-32.8798329999999979,151.66045299999999)
686	Minmi	1	2287	'minmi':1	(-32.8771520000000024,151.617788999999988)
687	Rankin Park	1	2287	'park':2 'rankin':1	(-32.9283879999999982,151.682894000000005)
690	Adamstown	1	2289	'adamstown':1	(-32.932538000000001,151.726249999999993)
691	Adamstown Heights	1	2289	'adamstown':1 'height':2	(-32.9509839999999983,151.717694999999992)
692	Garden Suburb	1	2289	'garden':1 'suburb':2	(-32.9483549999999994,151.683365000000009)
693	Highfields	1	2289	'highfield':1	(-32.955758000000003,151.712668000000008)
695	Kotara South	1	2289	'kotara':1 'south':2	(-32.9508110000000016,151.694264000000004)
696	Bennetts Green	1	2290	'bennett':1 'green':2	(-32.9954680000000025,151.689084000000008)
697	Charlestown	1	2290	'charlestown':1	(-32.9656710000000004,151.695454000000012)
699	Gateshead	1	2290	'gateshead':1	(-32.989024999999998,151.693850999999995)
700	Hillsborough	1	2290	'hillsborough':1	(-32.6368209999999976,151.467756000000008)
701	Kahibah	1	2290	'kahibah':1	(-32.9617950000000022,151.712351000000012)
703	Redhead	1	2290	'redhead':1	(-33.0134869999999978,151.714384999999993)
704	Tingira Heights	1	2290	'height':2 'tingira':1	(-32.9971869999999967,151.669718999999986)
705	Whitebridge	1	2290	'whitebridg':1	(-32.981226999999997,151.711319000000003)
706	Merewether	1	2291	'mereweth':1	(-32.9422369999999987,151.751451000000003)
708	The Junction	1	2291	'junction':2	(-32.9375280000000004,151.759625)
2465	Caringbah South	1	1	\N	\N
709	Broadmeadow	1	2292	'broadmeadow':1	(-32.9241650000000021,151.737829000000005)
710	Hamilton North	1	2292	'hamilton':1 'north':2	(-32.9124130000000008,151.73778999999999)
711	Maryville	1	2293	'maryvill':1	(-32.9118440000000021,151.753661999999991)
712	Wickham	1	2293	'wickham':1	(-32.9209729999999965,151.76003)
714	Fern Bay	1	2295	'bay':2 'fern':1	(-32.8544359999999998,151.81034600000001)
715	Stockton	1	2295	'stockton':1	(-32.9161199999999994,151.784379999999999)
716	Islington	1	2296	'islington':1	(-32.9119150000000005,151.745721000000003)
717	Tighes Hill	1	2297	'hill':2 'tigh':1	(-32.9080140000000014,151.751114999999999)
719	Waratah	1	2298	'waratah':1	(-32.9081520000000012,151.727219999999988)
720	Waratah West	1	2298	'waratah':1 'west':2	(-32.8987899999999982,151.711761999999993)
721	Jesmond	1	2299	'jesmond':1	(-32.9031310000000019,151.690857999999992)
722	Lambton	1	2299	'lambton':1	(-32.9114470000000026,151.707392999999996)
724	Bar Beach	1	2300	'bar':1 'beach':2	(-32.9399620000000013,151.768383)
725	Cooks Hill	1	2300	'cook':1 'hill':2	(-32.9341300000000032,151.769243999999986)
726	Newcastle	1	2300	'newcastl':1	(-32.926357000000003,151.78121999999999)
728	The Hill	1	2300	'hill':2	(-32.9298080000000013,151.777381999999989)
729	Newcastle West	1	2302	'newcastl':1 'west':2	(-32.9249080000000021,151.761141000000009)
730	Hamilton	1	2303	'hamilton':1	(-32.924042,151.746873999999991)
731	Kooragang	1	2304	'kooragang':1	(-32.8757280000000023,151.745980000000003)
732	Mayfield	1	2304	'mayfield':1	(-33.6632900000000035,149.780209000000013)
733	Mayfield East	1	2304	'east':2 'mayfield':1	(-32.9000169999999983,151.750101999999998)
734	Mayfield North	1	2304	'mayfield':1 'north':2	(-32.8838409999999968,151.739289000000014)
735	Mayfield West	1	2304	'mayfield':1 'west':2	(-32.8905389999999969,151.725500000000011)
736	Sandgate	1	2304	'sandgat':1	(-32.8678450000000026,151.708213999999998)
738	New Lambton	1	2305	'lambton':2 'new':1	(-32.9239320000000006,151.713174000000009)
739	New Lambton Heights	1	2305	'height':3 'lambton':2 'new':1	(-32.9325740000000025,151.690552999999994)
740	Windale	1	2306	'windal':1	(-32.9976940000000027,151.681052999999991)
741	Shortland	1	2307	'shortland':1	(-32.8808730000000011,151.691532999999993)
746	Allynbrook	1	2311	'allynbrook':1	(-32.3633430000000004,151.536228999999992)
748	East Gresford	1	2311	'east':1 'gresford':2	(-32.4286159999999981,151.553226999999993)
747	Gresford	1	2311	'gresford':1	(-32.4270309999999995,151.537783999999988)
749	Halton	1	2311	'halton':1	(-32.3151349999999979,151.514132999999987)
751	Nabiac	1	2312	'nabiac':1	(-32.0986940000000018,152.377769000000001)
752	Williamtown Raaf	1	2314	'raaf':2 'williamtown':1	(-32.7973649999999992,151.836989999999986)
753	Corlette	1	2315	'corlett':1	(-32.7211580000000026,152.10678200000001)
755	Nelson Bay	1	2315	'bay':2 'nelson':1	(-32.7170750000000012,152.154863000000006)
756	Shoal Bay	1	2315	'bay':2 'shoal':1	(-32.7241360000000014,152.174979000000008)
757	Anna Bay	1	2316	'anna':1 'bay':2	(-32.7769189999999995,152.083273999999989)
759	Bobs Farm	1	2316	'bob':1 'farm':2	(-32.7675440000000009,152.01273900000001)
760	Salamander Bay	1	2317	'bay':2 'salamand':1	(-32.7209369999999993,152.076399000000009)
761	Soldiers Point	1	2317	'point':2 'soldier':1	(-32.7104920000000021,152.064758000000012)
762	Campvale	1	2318	'campval':1	(-32.7699059999999989,151.851897000000008)
764	Medowie	1	2318	'medowi':1	(-32.7414860000000019,151.867570000000001)
765	Oyster Cove	1	2318	'cove':2 'oyster':1	(-32.7353519999999989,151.952662000000004)
766	Salt Ash	1	2318	'ash':2 'salt':1	(-32.7887399999999971,151.907238000000007)
767	Williamtown	1	2318	'williamtown':1	(-32.8068310000000025,151.844223999999997)
768	Tanilba Bay	1	2319	'bay':2 'tanilba':1	(-32.7325889999999973,152.002388999999994)
743	University Of Newcastle	1	2308	'newcastl':3 'univers':1	(-32.8900000000000006,151.704000000000008)
814	Carrington	1	2324	'carrington':1	(-32.6643419999999978,152.018721999999997)
770	Mallabula	1	2319	'mallabula':1	(-32.72898,152.011748000000011)
771	Aberglasslyn	1	2320	'aberglasslyn':1	(-32.6946560000000019,151.534606999999994)
772	Bolwarra	1	2320	'bolwarra':1	(-32.7128170000000011,151.572047999999995)
774	Farley	1	2320	'farley':1	(-32.7290629999999965,151.512184999999988)
776	Largs	1	2320	'larg':1	(-32.7025280000000009,151.602415000000008)
777	Lorn	1	2320	'lorn':1	(-32.7285779999999988,151.557063999999997)
778	Maitland	1	2320	'maitland':1	(-32.7347139999999968,151.558572999999996)
780	Pokolbin	1	2320	'pokolbin':1	(-32.7713230000000024,151.290973000000008)
782	Rutherford	1	2320	'rutherford':1	(-32.7164130000000029,151.527920999999992)
779	South Maitland	1	2320	'maitland':2 'south':1	(-32.7422940000000011,151.566213000000005)
783	Telarah	1	2320	'telarah':1	(-32.729498999999997,151.536856)
785	Duns Creek	1	2321	'creek':2 'dun':1	(-32.5803129999999967,151.782749999999993)
786	Gillieston Heights	1	2321	'gillieston':1 'height':2	(-32.7663530000000023,151.527365000000003)
787	Glen William	1	2321	'glen':1 'william':2	(-32.5215079999999972,151.797570000000007)
788	Heddon Greta	1	2321	'greta':2 'heddon':1	(-32.804507000000001,151.509565000000009)
789	Hinton	1	2321	'hinton':1	(-32.7165880000000016,151.651387999999997)
791	Morpeth	1	2321	'morpeth':1	(-32.7248820000000009,151.626663000000008)
792	Raworth	1	2321	'raworth':1	(-32.7359810000000024,151.607064000000008)
793	Woodville	1	2321	'woodvill':1	(-32.6761830000000018,151.609949999999998)
795	Black Hill	1	2322	'black':1 'hill':2	(-32.8235979999999969,151.583654999999993)
796	Hexham	1	2322	'hexham':1	(-32.8306490000000011,151.685483000000005)
797	Lenaghan	1	2322	'lenaghan':1	(-32.8492010000000008,151.627282000000008)
798	Tarro	1	2322	'tarro':1	(-32.8088470000000001,151.668182000000002)
800	Tomago	1	2322	'tomago':1	(-32.8183829999999972,151.757485000000003)
801	Woodberry	1	2322	'woodberri':1	(-32.7936920000000001,151.66539499999999)
802	Ashtonfield	1	2323	'ashtonfield':1	(-32.7738200000000006,151.600999999999999)
804	East Maitland	1	2323	'east':1 'maitland':2	(-32.7511200000000002,151.589963000000012)
805	Freemans Waterhole	1	2323	'freeman':1 'waterhol':2	(-32.9816789999999997,151.483970999999997)
806	Green Hills	1	2323	'green':1 'hill':2	(-35.443992999999999,148.072874000000013)
807	Metford	1	2323	'metford':1	(-32.7659129999999976,151.609199999999987)
809	Mulbring	1	2323	'mulbr':1	(-32.9003769999999989,151.483000000000004)
810	Tenambit	1	2323	'tenambit':1	(-32.7432569999999998,151.604324999999989)
811	Balickera	1	2324	'balickera':1	(-32.6730220000000031,151.80536699999999)
812	Brandy Hill	1	2324	'brandi':1 'hill':2	(-32.6937970000000035,151.694171000000011)
813	Bundabah	1	2324	'bundabah':1	(-32.6622130000000013,152.074062999999995)
816	Eagleton	1	2324	'eagleton':1	(-32.6980080000000015,151.756420999999989)
817	East Seaham	1	2324	'east':1 'seaham':2	(-32.6654240000000016,151.741457999999994)
818	Heatherbrae	1	2324	'heatherbra':1	(-32.7874260000000035,151.732385999999991)
819	Karuah	1	2324	'karuah':1	(-32.6540639999999982,151.961443000000003)
821	Millers Forest	1	2324	'forest':2 'miller':1	(-32.7635390000000015,151.702595000000002)
822	Nelsons Plains	1	2324	'nelson':1 'plain':2	(-32.7023289999999989,151.710584000000011)
823	North Arm Cove	1	2324	'arm':2 'cove':3 'north':1	(-32.6591200000000015,152.037583000000012)
824	Osterley	1	2324	'osterley':1	(-32.7247559999999993,151.700846000000013)
825	Pindimar	1	2324	'pindimar':1	(-32.684153000000002,152.098138000000006)
827	Seaham	1	2324	'seaham':1	(-32.657671999999998,151.721912000000003)
828	Swan Bay	1	2324	'bay':2 'swan':1	(-29.0598649999999985,153.313616999999994)
829	Tahlee	1	2324	'tahle':1	(-32.6675109999999975,152.004792000000009)
830	Tea Gardens	1	2324	'garden':2 'tea':1	(-32.6673860000000005,152.160371999999995)
832	Aberdare	1	2325	'aberdar':1	(-32.8442000000000007,151.376513999999986)
833	Abernethy	1	2325	'abernethi':1	(-32.8832420000000027,151.396677000000011)
834	Bellbird	1	2325	'bellbird':1	(-32.8599609999999984,151.317660999999987)
835	Cessnock	1	2325	'cessnock':1	(-32.8329430000000002,151.353993000000003)
836	Congewai	1	2325	'congewai':1	(-32.9965090000000032,151.301842999999991)
838	Elrington	1	2325	'elrington':1	(-32.8698589999999982,151.425092000000006)
839	Kearsley	1	2325	'kearsley':1	(-32.8586489999999998,151.395667000000003)
840	Kitchener	1	2325	'kitchen':1	(-32.8796019999999984,151.366669999999999)
841	Laguna	1	2325	'laguna':1	(-32.9945850000000007,151.12778800000001)
843	Mount View	1	2325	'mount':1 'view':2	(-32.8524310000000028,151.270296999999999)
844	Nulkaba	1	2325	'nulkaba':1	(-32.8096219999999974,151.349640999999991)
845	Paxton	1	2325	'paxton':1	(-32.9020450000000011,151.279669000000013)
847	Pelton	1	2325	'pelton':1	(-32.8795209999999969,151.301339000000013)
848	Quorrobolong	1	2325	'quorrobolong':1	(-32.922469999999997,151.363966000000005)
849	Wollombi	1	2325	'wollombi':1	(-32.9376000000000033,151.142664999999994)
850	Abermain	1	2326	'abermain':1	(-32.8108149999999981,151.428667999999988)
852	Loxford	1	2326	'loxford':1	(-32.7977739999999969,151.482991999999996)
853	Weston	1	2326	'weston':1	(-32.8138989999999993,151.459017999999986)
854	Kurri Kurri	1	2327	'kurri':1,2	(-32.8173120000000011,151.482952000000012)
855	Pelaw Main	1	2327	'main':2 'pelaw':1	(-32.8336639999999989,151.480398000000008)
857	Denman	1	2328	'denman':1	(-32.3894030000000015,150.686421999999993)
858	Hollydeen	1	2328	'hollydeen':1	(-32.332810000000002,150.618598999999989)
859	Kerrabee	1	2328	'kerrabe':1	(-32.4240769999999969,150.30904799999999)
860	Borambil	1	2329	'borambil':1	(-31.5064300000000017,150.642145999999997)
861	Cassilis	1	2329	'cassili':1	(-32.0078829999999996,149.980435)
862	Merriwa	1	2329	'merriwa':1	(-32.1394189999999966,150.355718999999993)
864	Broke	1	2330	'broke':1	(-32.7512219999999985,151.103474000000006)
865	Bulga	1	2330	'bulga':1	(-32.6446240000000003,151.037920000000014)
866	Camberwell	1	2330	'camberwel':1	(-32.4797009999999986,151.092002000000008)
869	Glennies Creek	1	2330	'creek':2 'glenni':1	(-32.4574240000000032,151.111863999999997)
870	Greenlands	1	2330	'greenland':1	(-36.5008890000000008,149.428698999999995)
871	Hebden	1	2330	'hebden':1	(-32.3857229999999987,151.064804000000009)
2422	Albert	1	2873	'albert':1	(-32.4158600000000021,147.508111000000014)
926	Gowrie	1	2340	'gowri':1	(-31.3330170000000017,150.858393000000007)
873	Jerrys Plains	1	2330	'jerri':1 'plain':2	(-32.4918639999999996,150.904924999999992)
874	Mirannie	1	2330	'miranni':1	(-32.3966080000000005,151.377575000000007)
875	Mitchells Flat	1	2330	'flat':2 'mitchel':1	(-32.5582459999999969,151.288740999999987)
876	Mount Olive	1	2330	'mount':1 'oliv':2	(-33.5981870000000029,149.917271)
877	Putty	1	2330	'putti':1	(-32.9698029999999989,150.674176999999986)
879	Reedy Creek	1	2330	'creek':2 'reedi':1	(-32.7293820000000011,149.993110999999999)
880	Singleton	1	2330	'singleton':1	(-32.5640250000000009,151.168366999999989)
881	St Clair	1	2330	'clair':2 'st':1	(-33.7943619999999996,150.790260999999987)
882	Warkworth	1	2330	'warkworth':1	(-32.5487880000000018,151.010847000000012)
885	Edderton	1	2333	'edderton':1	(-32.3809979999999982,150.822204999999997)
886	Gungal	1	2333	'gungal':1	(-32.225912000000001,150.469254000000006)
887	Liddell	1	2333	'liddel':1	(-32.4027639999999977,151.018323000000009)
889	Muscle Creek	1	2333	'creek':2 'muscl':1	(-32.2704489999999993,150.997753999999986)
890	Muswellbrook	1	2333	'muswellbrook':1	(-32.2633229999999998,150.888821000000007)
891	Sandy Hollow	1	2333	'hollow':2 'sandi':1	(-32.3347499999999997,150.566791999999992)
892	Wybong	1	2333	'wybong':1	(-32.2777540000000016,150.657226000000009)
893	Greta	1	2334	'greta':1	(-32.6774429999999967,151.38874100000001)
895	Branxton	1	2335	'branxton':1	(-32.6582459999999983,151.352047999999996)
896	Dalwood	1	2335	'dalwood':1	(-28.8885460000000016,153.409839000000005)
897	Elderslie	1	2335	'eldersli':1	(-34.059038000000001,150.711426999999986)
899	Stanhope	1	2335	'stanhop':1	(-32.6073379999999986,151.388821000000007)
900	Aberdeen	1	2336	'aberdeen':1	(-29.9960580000000014,151.080554000000006)
901	Dartbrook	1	2336	'dartbrook':1	(-32.1493990000000025,150.849591000000004)
902	Davis Creek	1	2336	'creek':2 'davi':1	(-32.1524169999999998,151.122519000000011)
903	Rouchel	1	2336	'rouchel':1	(-32.148375999999999,151.061442)
905	Bunnan	1	2337	'bunnan':1	(-32.0686800000000005,150.602156000000008)
906	Ellerston	1	2337	'ellerston':1	(-31.8217309999999998,151.303370000000001)
907	Gundy	1	2337	'gundi':1	(-32.0144749999999974,150.996748999999994)
908	Kars Springs	1	2337	'kar':1 'spring':2	(-31.928566,150.547480000000007)
910	Moonan Flat	1	2337	'flat':2 'moonan':1	(-31.9264340000000004,151.235462000000012)
911	Owens Gap	1	2337	'gap':2 'owen':1	(-32.0255510000000001,150.718094000000008)
912	Parkville	1	2337	'parkvill':1	(-31.9811590000000017,150.865404000000012)
913	Scone	1	2337	'scone':1	(-32.0507070000000027,150.867526999999995)
915	Wingen	1	2337	'wingen':1	(-31.8942149999999991,150.880095000000011)
916	Woolooma	1	2337	'woolooma':1	(-31.9943279999999994,151.219601000000011)
917	Ardglen	1	2338	'ardglen':1	(-31.7345049999999986,150.78558799999999)
918	Blandford	1	2338	'blandford':1	(-31.7930980000000005,150.928753)
919	Murrurundi	1	2338	'murrurundi':1	(-31.7636870000000009,150.834935000000002)
921	Willow Tree	1	2339	'tree':2 'willow':1	(-31.6485890000000012,150.726215999999994)
922	Bowling Alley Point	1	2340	'alley':2 'bowl':1 'point':3	(-31.3978949999999983,151.145265999999992)
923	Calala	1	2340	'calala':1	(-31.1297640000000015,150.946877999999998)
924	Carroll	1	2340	'carrol':1	(-30.9866430000000008,150.444919999999996)
925	Dungowan	1	2340	'dungowan':1	(-31.2145520000000012,151.120119999999986)
928	Nemingha	1	2340	'nemingha':1	(-31.1236539999999984,150.990411999999992)
929	Nundle	1	2340	'nundl':1	(-31.4625480000000017,151.127044000000012)
930	Oxley Vale	1	2340	'oxley':1 'vale':2	(-31.06203,150.900141999999988)
931	Somerton	1	2340	'somerton':1	(-30.9386539999999997,150.637122000000005)
933	Tamworth	1	2340	'tamworth':1	(-31.091743000000001,150.930821000000009)
934	West Tamworth	1	2340	'tamworth':2 'west':1	(-31.1053789999999992,150.898482999999999)
935	Westdale	1	2340	'westdal':1	(-35.5604999999999976,147.908455000000004)
936	Woolomin	1	2340	'woolomin':1	(-31.2848590000000009,151.148989999999998)
937	Werris Creek	1	2341	'creek':2 'werri':1	(-31.3459210000000006,150.619914999999992)
938	Currabubula	1	2342	'currabubula':1	(-31.2627220000000001,150.734255999999988)
939	Blackville	1	2343	'blackvill':1	(-31.6582100000000004,150.302809999999994)
940	Caroona	1	2343	'caroona':1	(-31.3991140000000009,150.427945999999991)
942	Pine Ridge	1	2343	'pine':1 'ridg':2	(-31.4798000000000009,150.512226999999996)
943	Quirindi	1	2343	'quirindi':1	(-31.508146,150.680051999999989)
944	Spring Ridge	1	2343	'ridg':2 'spring':1	(-31.4984830000000002,150.683758000000012)
945	Wallabadah	1	2343	'wallabadah':1	(-31.5232659999999996,150.758768000000003)
947	Attunga	1	2345	'attunga':1	(-30.9309909999999988,150.847933000000012)
948	Garthowen	1	2345	'garthowen':1	(-33.5967720000000014,149.622184000000004)
949	Manilla	1	2346	'manilla':1	(-30.7477529999999994,150.720249999999993)
951	Cobbadah	1	2347	'cobbadah':1	(-30.2317099999999996,150.578145000000006)
952	Upper Horton	1	2347	'horton':2 'upper':1	(-30.1409400000000005,150.447100000000006)
954	Armidale	1	2350	'armidal':1	(-30.5141659999999995,151.66898599999999)
957	Invergowrie	1	2350	'invergowri':1	(-30.497561000000001,151.498196000000007)
958	Jeogla	1	2350	'jeogla':1	(-30.5718940000000003,152.110822000000013)
959	West Armidale	1	2350	'armidal':2 'west':1	(-30.5029569999999985,151.650203000000005)
960	Wollomombi	1	2350	'wollomombi':1	(-30.5113400000000006,152.045006999999998)
962	Kootingal	1	2352	'kooting':1	(-31.0574130000000004,151.054338000000001)
963	Limbri	1	2352	'limbri':1	(-31.0391919999999999,151.154776999999996)
964	Moonbi	1	2353	'moonbi':1	(-30.9514309999999995,151.045963)
965	Kentucky	1	2354	'kentucki':1	(-30.7578420000000001,151.45129)
966	Niangala	1	2354	'niangala':1	(-31.3423809999999996,151.365244999999987)
967	Nowendoc	1	2354	'nowendoc':1	(-31.5152029999999996,151.719540999999992)
969	Wollun	1	2354	'wollun':1	(-30.8413199999999996,151.429836999999992)
970	Woolbrook	1	2354	'woolbrook':1	(-30.9449110000000012,151.342556000000002)
971	Bendemeer	1	2355	'bendem':1	(-30.8783990000000017,151.159905000000009)
973	Gwabegar	1	2356	'gwabegar':1	(-30.6197979999999994,148.969490000000008)
883	Singleton Milpo	1	2331	'milpo':2 'singleton':1	(-32.6890000000000001,151.180000000000007)
975	Coonabarabran	1	2357	'coonabarabran':1	(-31.2734389999999998,149.277272000000011)
976	Purlewaugh	1	2357	'purlewaugh':1	(-31.3797309999999996,149.640952999999996)
977	Rocky Glen	1	2357	'glen':2 'rocki':1	(-31.1151310000000016,149.566421999999989)
978	Ulamambri	1	2357	'ulamambri':1	(-31.3322320000000012,149.384556000000003)
981	Uralla	1	2358	'uralla':1	(-30.642828999999999,151.502566000000002)
982	Bundarra	1	2359	'bundarra':1	(-30.1713699999999996,151.07583600000001)
983	Bukkulla	1	2360	'bukkulla':1	(-29.5031369999999988,151.12903399999999)
984	Elsmore	1	2360	'elsmor':1	(-29.8033029999999997,151.270898999999986)
986	Graman	1	2360	'graman':1	(-29.4674650000000007,150.926679000000007)
987	Gum Flat	1	2360	'flat':2 'gum':1	(-29.7943339999999992,150.929553999999996)
989	Little Plain	1	2360	'littl':1 'plain':2	(-29.7290670000000006,150.950761999999997)
990	Mount Russell	1	2360	'mount':1 'russel':2	(-29.6780070000000009,150.930115000000001)
991	Nullamanna	1	2360	'nullamanna':1	(-29.6712649999999982,151.22238999999999)
992	Wallangra	1	2360	'wallangra':1	(-29.1584639999999986,150.883868000000007)
994	Bonshaw	1	2361	'bonshaw':1	(-29.0502959999999995,151.27534399999999)
995	Ben Lomond	1	2365	'ben':1 'lomond':2	(-30.0173610000000011,151.657999999999987)
996	Black Mountain	1	2365	'black':1 'mountain':2	(-30.3080420000000004,151.650341999999995)
997	Glencoe	1	2365	'glenco':1	(-29.9258880000000005,151.726756999999992)
999	Llangothlin	1	2365	'llangothlin':1	(-30.1230040000000017,151.686705999999987)
1000	Wandsworth	1	2365	'wandsworth':1	(-30.0559979999999989,151.513693999999987)
1001	Stannifer	1	2369	'stannif':1	(-29.8652930000000012,151.226371999999998)
1003	Dundee	1	2370	'dunde':1	(-29.5666870000000017,151.865747999999996)
1004	Furracabad	1	2370	'furracabad':1	(-29.7781950000000002,151.649581000000012)
1005	Glen Innes	1	2370	'glen':1 'inn':2	(-29.7356550000000013,151.738526000000007)
1007	Newton Boyd	1	2370	'boyd':2 'newton':1	(-29.7520099999999985,152.244431999999989)
1008	Red Range	1	2370	'rang':2 'red':1	(-29.7941360000000017,151.832384999999988)
1009	Swan Vale	1	2370	'swan':1 'vale':2	(-29.7697530000000015,151.484701000000001)
1010	Deepwater	1	2371	'deepwat':1	(-29.4423199999999987,151.847464000000002)
1012	Stannum	1	2371	'stannum':1	(-29.3250759999999993,151.790638999999999)
1013	Torrington	1	2371	'torrington':1	(-29.3119869999999985,151.696579000000014)
1015	Bolivia	1	2372	'bolivia':1	(-29.2994340000000015,151.950187999999997)
1016	Boonoo Boonoo	1	2372	'boonoo':1,2	(-28.8740750000000013,152.10228699999999)
1017	Bungulla	1	2372	'bungulla':1	(-29.1211209999999987,151.997171000000009)
1018	Liston	1	2372	'liston':1	(-28.647746999999999,152.086291999999986)
1019	Sandy Flat	1	2372	'flat':2 'sandi':1	(-29.2337379999999989,152.005604000000005)
1021	Wylie Creek	1	2372	'creek':2 'wyli':1	(-28.541481000000001,152.152444000000003)
1022	Mullaley	1	2379	'mullaley':1	(-31.0985230000000001,149.908463000000012)
1023	Gunnedah	1	2380	'gunnedah':1	(-30.9785889999999995,150.255412000000007)
1024	Kelvin	1	2380	'kelvin':1	(-30.7922459999999987,150.354669999999999)
1026	Breeza	1	2381	'breeza':1	(-31.2441749999999985,150.457900999999993)
1027	Curlewis	1	2381	'curlewi':1	(-31.1173420000000007,150.264679000000001)
1028	Premer	1	2381	'premer':1	(-31.4525979999999983,149.902147000000014)
1029	Tambar Springs	1	2381	'spring':2 'tambar':1	(-31.3452020000000005,149.829180000000008)
1030	Boggabri	1	2382	'boggabri':1	(-30.7047279999999994,150.042507999999998)
1032	Rowena	1	2387	'rowena':1	(-29.7965780000000002,148.935904999999991)
1033	Cuttabri	1	2388	'cuttabri':1	(-30.329854000000001,149.221121000000011)
1034	Pilliga	1	2388	'pilliga':1	(-30.3518609999999995,148.890832999999986)
1035	Wee Waa	1	2388	'waa':2 'wee':1	(-30.2248680000000007,149.444421000000006)
1037	Edgeroi	1	2390	'edgeroi':1	(-30.1173980000000014,149.799587000000002)
1038	Narrabri	1	2390	'narrabri':1	(-30.3248350000000002,149.782833000000011)
1039	Turrawan	1	2390	'turrawan':1	(-30.4564769999999996,149.885748000000007)
1040	Binnaway	1	2395	'binnaway':1	(-31.5521150000000006,149.37849700000001)
1042	Baradine	1	2396	'baradin':1	(-30.943207000000001,149.065814999999986)
1043	Kenebri	1	2396	'kenebri':1	(-30.7481180000000016,148.923271999999997)
1044	Bellata	1	2397	'bellata':1	(-29.9196239999999989,149.790977999999996)
1045	Gurley	1	2398	'gurley':1	(-29.7356009999999991,149.799880000000002)
1047	Ashley	1	2400	'ashley':1	(-29.3177720000000015,149.808064000000002)
1048	Crooble	1	2400	'croobl':1	(-29.2692060000000005,150.252228000000002)
1049	Moree	1	2400	'more':1	(-29.4629750000000001,149.841580999999991)
1051	Gravesend	1	2401	'gravesend':1	(-29.5823390000000011,150.337608999999986)
1052	Coolatai	1	2402	'coolatai':1	(-29.2682590000000005,150.734490999999991)
1053	Warialda	1	2402	'warialda':1	(-29.5411760000000001,150.576165000000003)
1054	Delungra	1	2403	'delungra':1	(-29.6524849999999986,150.830948000000006)
1055	Bingara	1	2404	'bingara':1	(-29.8687129999999996,150.571783000000011)
1056	Dinoga	1	2404	'dinoga':1	(-29.9135430000000007,150.639454000000001)
1058	Garah	1	2405	'garah':1	(-29.0754820000000009,149.636398000000014)
1059	Mungindi	1	2406	'mungindi':1	(-28.9990130000000015,149.100730999999996)
1061	Boggabilla	1	2409	'boggabilla':1	(-28.7448210000000017,150.415346999999997)
1062	Yetman	1	2410	'yetman':1	(-28.9025570000000016,150.780675000000002)
1063	Croppa Creek	1	2411	'creek':2 'croppa':1	(-29.1294409999999999,150.381167000000005)
1064	Monkerai	1	2415	'monkerai':1	(-32.2923359999999988,151.859783999999991)
1066	Bandon Grove	1	2420	'bandon':1 'grove':2	(-32.2998619999999974,151.715890000000002)
1067	Dungog	1	2420	'dungog':1	(-32.4038669999999982,151.757171)
1068	Hilldale	1	2420	'hilldal':1	(-32.5032210000000035,151.650069999999999)
1069	Marshdale	1	2420	'marshdal':1	(-32.4442179999999993,151.789235999999988)
1070	Salisbury	1	2420	'salisburi':1	(-32.2149840000000012,151.559446000000008)
1072	Paterson	1	2421	'paterson':1	(-32.5991530000000012,151.618292999999994)
1073	Vacy	1	2421	'vaci':1	(-32.5434580000000011,151.577149999999989)
1074	Barrington	1	2422	'barrington':1	(-31.973631000000001,151.910491000000007)
1076	Bretti	1	2422	'bretti':1	(-31.7868439999999985,151.923449000000005)
1077	Bundook	1	2422	'bundook':1	(-31.9074610000000014,152.136524000000009)
1078	Copeland	1	2422	'copeland':1	(-31.9858919999999998,151.805912000000006)
1079	Craven	1	2422	'craven':1	(-32.1510729999999967,151.944997000000001)
1111	Green Point	1	2428	'green':1 'point':2	(-32.2517589999999998,152.516738000000004)
1080	Gloucester	1	2422	'gloucest':1	(-32.0070359999999994,151.958361999999994)
1081	Rawdon Vale	1	2422	'rawdon':1 'vale':2	(-31.9958379999999991,151.709185999999988)
1082	Stratford	1	2422	'stratford':1	(-32.1192789999999988,151.937940999999995)
1084	Wards River	1	2422	'river':2 'ward':1	(-32.2234669999999994,151.935901000000001)
1085	Boolambayte	1	2423	'boolambayt':1	(-32.4066270000000003,152.271206000000006)
1086	Bulahdelah	1	2423	'bulahdelah':1	(-32.4133759999999995,152.20798099999999)
1087	Bungwahl	1	2423	'bungwahl':1	(-32.3872649999999993,152.444151000000005)
1089	Markwell	1	2423	'markwel':1	(-32.3202980000000011,152.18181100000001)
1090	Nerong	1	2423	'nerong':1	(-32.5235330000000005,152.198242999999991)
1091	Seal Rocks	1	2423	'rock':2 'seal':1	(-32.4353120000000033,152.528897999999998)
1093	Wang Wauk	1	2423	'wang':1 'wauk':2	(-32.1599649999999997,152.291937999999988)
1094	Willina	1	2423	'willina':1	(-32.1708720000000028,152.283468999999997)
1095	Wootton	1	2423	'wootton':1	(-32.3253360000000001,152.279475999999988)
1096	Cundle Flat	1	2424	'cundl':1 'flat':2	(-31.8271060000000006,152.023797999999999)
1097	Knorrit Flat	1	2424	'flat':2 'knorrit':1	(-31.8429949999999984,152.124676999999991)
1099	Number One	1	2424	'number':1 'one':2	(-31.7211210000000001,152.064756999999986)
1100	Allworth	1	2425	'allworth':1	(-32.5416880000000006,151.960926999999998)
1101	Booral	1	2425	'booral':1	(-32.4797510000000003,152.00175200000001)
1102	Girvan	1	2425	'girvan':1	(-32.4678669999999983,152.068465000000003)
1103	Stroud	1	2425	'stroud':1	(-32.4023639999999986,151.96660700000001)
1105	Coopernook	1	2426	'coopernook':1	(-31.8262460000000011,152.609895999999992)
1106	Langley Vale	1	2426	'langley':1 'vale':2	(-31.7904170000000015,152.565407999999991)
1107	Crowdy Head	1	2427	'crowdi':1 'head':2	(-31.8448209999999996,152.738877000000002)
1109	Charlotte Bay	1	2428	'bay':2 'charlott':1	(-32.3552269999999993,152.505783000000008)
1110	Forster	1	2428	'forster':1	(-32.1795979999999986,152.511775)
1112	Smiths Lake	1	2428	'lake':2 'smith':1	(-32.3823790000000002,152.501878000000005)
1114	Tuncurry	1	2428	'tuncurri':1	(-32.1746240000000014,152.499268000000001)
1115	Bobin	1	2429	'bobin':1	(-31.7260209999999994,152.283882000000006)
1116	Bunyah	1	2429	'bunyah':1	(-32.1642480000000006,152.219203999999991)
1117	Burrell Creek	1	2429	'burrel':1 'creek':2	(-31.9519990000000007,152.295686999999987)
1118	Caparra	1	2429	'caparra':1	(-31.7307319999999997,152.248477000000008)
1120	Dyers Crossing	1	2429	'cross':2 'dyer':1	(-32.0917320000000004,152.300833000000011)
1121	Elands	1	2429	'eland':1	(-31.6346090000000011,152.297219000000013)
1122	Firefly	1	2429	'firefli':1	(-32.0825689999999994,152.244923)
1123	Killabakh	1	2429	'killabakh':1	(-31.7355160000000005,152.399887000000007)
1125	Krambach	1	2429	'krambach':1	(-32.048174000000003,152.250244000000009)
1126	Marlee	1	2429	'marle':1	(-31.7988810000000015,152.319146999999987)
1127	Mooral Creek	1	2429	'creek':2 'mooral':1	(-31.7203750000000007,152.35565299999999)
1129	Wingham	1	2429	'wingham':1	(-31.8690460000000009,152.37424200000001)
1130	Bohnock	1	2430	'bohnock':1	(-31.9459949999999999,152.567809000000011)
1131	Cundletown	1	2430	'cundletown':1	(-31.8976970000000009,152.516665999999987)
1132	Diamond Beach	1	2430	'beach':2 'diamond':1	(-32.0439939999999979,152.53443200000001)
1133	Failford	1	2430	'failford':1	(-32.0919209999999993,152.454662000000013)
1135	Hallidays Point	1	2430	'halliday':1 'point':2	(-32.0697749999999999,152.488055000000003)
1136	Koorainghat	1	2430	'koorainghat':1	(-31.9858009999999986,152.47009700000001)
1138	Manning Point	1	2430	'man':1 'point':2	(-31.8951409999999989,152.661511999999988)
1139	Old Bar	1	2430	'bar':2 'old':1	(-31.9690370000000001,152.585162999999994)
1141	Taree	1	2430	'tare':1	(-31.9117139999999999,152.463871000000012)
1142	Tinonee	1	2430	'tinone':1	(-31.9377700000000004,152.413824000000005)
1143	Upper Lansdowne	1	2430	'lansdown':2 'upper':1	(-31.7024329999999992,152.474860000000007)
1144	Jerseyville	1	2431	'jerseyvill':1	(-30.9350999999999985,153.035331000000014)
1146	Kendall	1	2439	'kendal':1	(-31.6320319999999988,152.705557999999996)
1147	Kew	1	2439	'kew':1	(-31.6348529999999997,152.722926999999999)
1148	Lorne	1	2439	'lorn':1	(-31.6575549999999986,152.591667999999999)
1149	Bellbrook	1	2440	'bellbrook':1	(-30.8181800000000017,152.50834900000001)
1151	Carrai	1	2440	'carrai':1	(-30.899756,152.248557000000005)
1152	Clybucca	1	2440	'clybucca':1	(-30.954388999999999,152.965544999999992)
1153	Collombatti	1	2440	'collombatti':1	(-30.9928260000000009,152.841538000000014)
1154	Comara	1	2440	'comara':1	(-30.7530040000000007,152.399864000000008)
1156	Frederickton	1	2440	'frederickton':1	(-31.0377620000000007,152.878932999999989)
1157	Gladstone	1	2440	'gladston':1	(-31.0220729999999989,152.948990000000009)
1158	Greenhill	1	2440	'greenhil':1	(-31.0601540000000007,152.800013000000007)
1159	Hat Head	1	2440	'hat':1 'head':2	(-31.0544909999999987,153.049962999999991)
1161	Kempsey	1	2440	'kempsey':1	(-31.0806210000000007,152.84199000000001)
1179	Kempsey	1	2442	'kempsey':1	(-31.0806210000000007,152.84199000000001)
1162	Lower Creek	1	2440	'creek':2 'lower':1	(-30.7435849999999995,152.278989999999993)
1163	Millbank	1	2440	'millbank':1	(-30.8461089999999984,152.649970999999994)
1164	Smithtown	1	2440	'smithtown':1	(-31.0151760000000003,152.943995000000001)
1166	Toorooka	1	2440	'toorooka':1	(-30.9129499999999986,152.587524000000002)
1167	Verges Creek	1	2440	'creek':2 'verg':1	(-31.0877550000000014,152.899709999999999)
1168	Willawarrin	1	2440	'willawarrin':1	(-30.9299950000000017,152.627873999999991)
1169	Ballengarra	1	2441	'ballengarra':1	(-31.318479,152.709685000000007)
1170	Bonville	1	2441	'bonvill':1	(-30.3760520000000014,153.034866999999991)
1172	Eungai Rail	1	2441	'eungai':1 'rail':2	(-30.8462740000000011,152.900574000000006)
1173	Grassy Head	1	2441	'grassi':1 'head':2	(-30.7939129999999999,152.992331000000007)
1174	Gum Scrub	1	2441	'gum':1 'scrub':2	(-31.2710459999999983,152.726685000000003)
1175	Kundabung	1	2441	'kundabung':1	(-31.2086150000000018,152.823012000000006)
1177	Stuarts Point	1	2441	'point':2 'stuart':1	(-30.8211079999999988,152.993982999999986)
1178	Telegraph Point	1	2441	'point':2 'telegraph':1	(-31.321632000000001,152.799679999999995)
1181	Dunbogan	1	2443	'dunbogan':1	(-31.6493810000000018,152.807220000000001)
1184	Herons Creek	1	2443	'creek':2 'heron':1	(-31.5879779999999997,152.726709999999997)
1185	Johns River	1	2443	'john':1 'river':2	(-31.7334919999999983,152.695146999999992)
1186	Laurieton	1	2443	'laurieton':1	(-31.6502289999999995,152.798179000000005)
1187	Moorland	1	2443	'moorland':1	(-31.7722279999999984,152.652347999999989)
1183	West Haven	1	2443	'haven':2 'west':1	(-31.6343959999999988,152.782454000000001)
1189	Blackmans Point	1	2444	'blackman':1 'point':2	(-31.4006660000000011,152.851835999999992)
1190	Port Macquarie	1	2444	'macquari':2 'port':1	(-31.4342590000000008,152.908480999999995)
1191	Bonny Hills	1	2445	'bonni':1 'hill':2	(-31.5949810000000006,152.840605000000011)
1193	Bagnoo	1	2446	'bagnoo':1	(-31.4636390000000006,152.533220999999998)
1194	Beechwood	1	2446	'beechwood':1	(-31.4368049999999997,152.67840799999999)
1195	Bellangry	1	2446	'bellangri':1	(-31.3274749999999997,152.607852000000008)
1196	Byabarra	1	2446	'byabarra':1	(-31.5343499999999999,152.528239000000013)
1198	Hollisdale	1	2446	'hollisdal':1	(-31.3950099999999992,152.548686000000004)
1199	Huntingdon	1	2446	'huntingdon':1	(-31.4743500000000012,152.660392000000002)
1200	King Creek	1	2446	'creek':2 'king':1	(-31.4824540000000006,152.751920000000013)
1201	Long Flat	1	2446	'flat':2 'long':1	(-31.4370839999999987,152.488756999999993)
1203	Pembrooke	1	2446	'pembrook':1	(-31.3881100000000011,152.753487000000007)
1204	Toms Creek	1	2446	'creek':2 'tom':1	(-31.5627379999999995,152.399874000000011)
1205	Wauchope	1	2446	'wauchop':1	(-31.4573539999999987,152.732269000000002)
1206	Macksville	1	2447	'macksvill':1	(-30.7064829999999986,152.920974000000001)
1208	Taylors Arm	1	2447	'arm':2 'taylor':1	(-30.7248260000000002,152.834980999999999)
1209	Thumb Creek	1	2447	'creek':2 'thumb':1	(-30.6870909999999988,152.619136999999995)
1210	Warrell Creek	1	2447	'creek':2 'warrel':1	(-30.770271000000001,152.892326999999995)
1212	Valla Beach	1	2448	'beach':2 'valla':1	(-30.5918050000000008,153.008478999999994)
1213	Argents Hill	1	2449	'argent':1 'hill':2	(-30.6219520000000003,152.74632600000001)
1214	Bowraville	1	2449	'bowravill':1	(-30.6418999999999997,152.854557)
1215	Missabotti	1	2449	'missabotti':1	(-30.5672780000000017,152.805912000000006)
1268	South Arm	1	2460	'arm':2 'south':1	(-29.5370050000000006,153.148196000000013)
1216	Boambee	1	2450	'boambe':1	(-30.3371859999999991,153.069748000000004)
1218	Coramba	1	2450	'coramba':1	(-30.2225150000000014,153.016086000000001)
1219	Glenreagh	1	2450	'glenreagh':1	(-30.0510599999999997,152.978971000000001)
1220	Karangi	1	2450	'karangi':1	(-30.254449000000001,153.048256000000009)
1221	Korora	1	2450	'korora':1	(-30.2571450000000013,153.129007999999999)
1223	Moonee Beach	1	2450	'beach':2 'moone':1	(-30.208120000000001,153.15541300000001)
1224	Nana Glen	1	2450	'glen':2 'nana':1	(-30.1361990000000013,153.004852999999997)
1225	Ulong	1	2450	'ulong':1	(-30.2461349999999989,152.888780999999994)
1227	Boambee East	1	2452	'boambe':1 'east':2	(-30.3406200000000013,153.084224000000006)
1228	Sawtell	1	2452	'sawtel':1	(-30.3698990000000002,153.099626999999998)
1229	Toormina	1	2452	'toormina':1	(-30.3526200000000017,153.090284999999994)
1230	Bostobrick	1	2453	'bostobrick':1	(-30.2771979999999985,152.627918999999991)
1231	Dorrigo	1	2453	'dorrigo':1	(-30.3401309999999995,152.711827)
1233	Ebor	1	2453	'ebor':1	(-30.3988179999999986,152.352082999999993)
1234	Hernani	1	2453	'hernani':1	(-30.3422090000000004,152.420977999999991)
1235	Megan	1	2453	'megan':1	(-30.2869540000000015,152.787386999999995)
1236	Tyringham	1	2453	'tyringham':1	(-30.2233809999999998,152.554394000000002)
1238	Fernmount	1	2454	'fernmount':1	(-30.4680670000000013,152.959264999999988)
1239	Kalang	1	2454	'kalang':1	(-30.5082850000000008,152.774243000000013)
1240	Mylestom	1	2454	'mylestom':1	(-30.4647620000000003,153.042817000000014)
1242	Repton	1	2454	'repton':1	(-30.4388879999999986,153.022415999999993)
1243	Thora	1	2454	'thora':1	(-30.4143720000000002,152.772525999999999)
1245	Urunga	1	2455	'urunga':1	(-30.4970749999999988,153.014882999999998)
1247	Corindi Beach	1	2456	'beach':2 'corindi':1	(-30.0288119999999985,153.200430000000011)
1248	Emerald Beach	1	2456	'beach':2 'emerald':1	(-30.1665969999999994,153.182458999999994)
1249	Red Rock	1	2456	'red':1 'rock':2	(-29.98339,153.229216000000008)
1250	Safety Beach	1	2456	'beach':2 'safeti':1	(-30.0966839999999998,153.192452000000003)
2467	Regents Park,Berala	1	1	\N	\N
1251	Sandy Beach	1	2456	'beach':2 'sandi':1	(-30.1479849999999985,153.192116999999996)
1252	Woolgoolga	1	2456	'woolgoolga':1	(-30.1131190000000011,153.193475000000007)
1253	Baryulgil	1	2460	'baryulgil':1	(-29.2192609999999995,152.60439199999999)
1254	Brushgrove	1	2460	'brushgrov':1	(-29.5661270000000016,153.080634000000003)
1255	Cangai	1	2460	'cangai':1	(-29.5084009999999992,152.479215000000011)
1256	Coaldale	1	2460	'coaldal':1	(-29.3879620000000017,152.790365000000008)
1258	Coutts Crossing	1	2460	'coutt':1 'cross':2	(-29.8310519999999997,152.891036000000014)
1259	Cowper	1	2460	'cowper':1	(-29.5785049999999998,153.062696999999986)
1260	Grafton	1	2460	'grafton':1	(-29.6912249999999993,152.933312000000001)
1261	Halfway Creek	1	2460	'creek':2 'halfway':1	(-29.9484859999999991,153.114127999999994)
1262	Jackadgery	1	2460	'jackadgeri':1	(-29.582180000000001,152.560932000000008)
1264	Kangaroo Creek	1	2460	'creek':2 'kangaroo':1	(-29.9460340000000009,152.840855000000005)
1265	Lawrence	1	2460	'lawrenc':1	(-29.4967289999999984,153.105535000000003)
1266	Nymboida	1	2460	'nymboida':1	(-29.926010999999999,152.747883999999999)
1267	Seelands	1	2460	'seeland':1	(-29.6151009999999992,152.91381899999999)
1270	Waterview Heights	1	2460	'height':2 'waterview':1	(-29.702380999999999,152.838233000000002)
1271	Winegrove	1	2460	'winegrov':1	(-29.5484170000000006,152.689208000000008)
1272	Pillar Valley	1	2462	'pillar':1 'valley':2	(-29.764050000000001,153.129989999999992)
1273	Tucabia	1	2462	'tucabia':1	(-29.6690359999999984,153.107274999999987)
1275	Wooli	1	2462	'wooli':1	(-29.8654720000000005,153.266263000000009)
1276	Brooms Head	1	2463	'broom':1 'head':2	(-29.6046680000000002,153.333139999999986)
1277	Maclean	1	2463	'maclean':1	(-29.4579629999999995,153.196868999999992)
1278	Tullymorgan	1	2463	'tullymorgan':1	(-29.3834799999999987,153.098360000000014)
1280	Yamba	1	2464	'yamba':1	(-29.4370639999999995,153.361445000000003)
1332	Dalwood	1	2477	'dalwood':1	(-28.8885460000000016,153.409839000000005)
1281	Harwood	1	2465	'harwood':1	(-29.4188329999999993,153.240867000000009)
1283	Bonalbo	1	2469	'bonalbo':1	(-28.7364700000000006,152.622831999999988)
1284	Chatsworth	1	2469	'chatsworth':1	(-29.3792380000000009,153.248610000000014)
1285	Mallanganee	1	2469	'mallangane':1	(-28.9064489999999985,152.720585)
1287	Rappville	1	2469	'rappvill':1	(-29.0848450000000014,152.953134000000006)
1288	Tabulam	1	2469	'tabulam':1	(-28.8871980000000015,152.568553000000009)
1289	Backmede	1	2470	'backmed':1	(-28.772590000000001,153.018770999999987)
1290	Baraimal	1	2470	'baraim':1	(-28.7226199999999992,152.996557999999993)
1291	Casino	1	2470	'casino':1	(-28.8638869999999983,153.046151000000009)
1293	Dobies Bight	1	2470	'bight':2 'dobi':1	(-28.8094469999999987,152.943493999999987)
1294	Doubtful Creek	1	2470	'creek':2 'doubt':1	(-28.7485970000000002,152.915051000000005)
1295	Dyraaba	1	2470	'dyraaba':1	(-28.8008610000000012,152.862775999999997)
1297	Fairy Hill	1	2470	'fairi':1 'hill':2	(-28.7629529999999995,152.986613000000006)
1298	Irvington	1	2470	'irvington':1	(-28.8686889999999998,153.10639900000001)
1299	Leeville	1	2470	'leevill':1	(-28.9477429999999991,152.977879999999999)
1301	Naughtons Gap	1	2470	'gap':2 'naughton':1	(-28.8018999999999998,153.107591000000014)
1302	Piora	1	2470	'piora':1	(-28.8503550000000004,152.914414999999991)
1303	Sextonville	1	2470	'sextonvill':1	(-28.6719580000000001,152.805479999999989)
1305	Spring Grove	1	2470	'grove':2 'spring':1	(-28.8330659999999988,153.155732999999998)
1306	Stratheden	1	2470	'stratheden':1	(-28.8027200000000008,152.95430300000001)
1307	Woodview	1	2470	'woodview':1	(-28.8606200000000008,152.950741999999991)
1308	Coraki	1	2471	'coraki':1	(-28.9899799999999992,153.289300999999995)
1310	Tatham	1	2471	'tatham':1	(-28.9289190000000005,153.158652999999987)
1312	Rileys Hill	1	2472	'hill':2 'riley':1	(-29.0138549999999995,153.406655999999998)
1313	Woodburn	1	2472	'woodburn':1	(-35.3755960000000016,150.378782999999999)
1314	Evans Head	1	2473	'evan':1 'head':2	(-29.1156800000000011,153.429065000000008)
1315	Cawongla	1	2474	'cawongla':1	(-28.5917530000000006,153.103104999999999)
1317	Geneva	1	2474	'geneva':1	(-28.6205810000000014,152.982292999999999)
1318	Grevillia	1	2474	'grevillia':1	(-28.4417319999999982,152.830732000000012)
1319	Kyogle	1	2474	'kyogl':1	(-28.6223840000000003,153.004111999999992)
1321	Rukenvale	1	2474	'rukenval':1	(-28.4695280000000004,152.895760999999993)
1322	The Risk	1	2474	'risk':2	(-28.4597659999999983,152.945109000000002)
1323	Toonumbar	1	2474	'toonumbar':1	(-28.5672350000000002,152.753095999999999)
1324	Wiangaree	1	2474	'wiangare':1	(-28.5057580000000002,152.967546999999996)
1325	Urbenville	1	2475	'urbenvill':1	(-28.4727589999999999,152.548088000000007)
1327	Legume	1	2476	'legum':1	(-28.4047249999999991,152.307580000000002)
1328	Old Koreelah	1	2476	'koreelah':2 'old':1	(-28.405384999999999,152.423334000000011)
1329	Woodenbong	1	2476	'woodenbong':1	(-28.3910440000000008,152.612034999999992)
1330	Alstonville	1	2477	'alstonvill':1	(-28.8421249999999993,153.440359999999998)
1333	Meerschaum Vale	1	2477	'meerschaum':1 'vale':2	(-28.9141939999999984,153.436069000000003)
1334	Rous	1	2477	'rous':1	(-28.8711230000000008,153.405709000000002)
1335	Rous Mill	1	2477	'mill':2 'rous':1	(-28.876258,153.389634000000001)
1336	Uralba	1	2477	'uralba':1	(-28.8736180000000004,153.471319999999992)
1337	Wardell	1	2477	'wardel':1	(-28.9527029999999996,153.464326)
1338	Wollongbar	1	2477	'wollongbar':1	(-28.8279619999999994,153.421077999999994)
1340	Empire Vale	1	2478	'empir':1 'vale':2	(-28.9155820000000006,153.503368999999992)
1341	Keith Hall	1	2478	'hall':2 'keith':1	(-28.8898389999999985,153.531950999999992)
1342	Lennox Head	1	2478	'head':2 'lennox':1	(-28.7957150000000013,153.593900999999988)
1344	Teven	1	2478	'teven':1	(-28.8104820000000004,153.488943000000006)
1345	Tintenbar	1	2478	'tintenbar':1	(-28.7965899999999984,153.513162999999992)
1346	Bangalow	1	2479	'bangalow':1	(-28.686356,153.524791999999991)
1348	Brooklet	1	2479	'brooklet':1	(-28.7307109999999994,153.515530000000012)
1349	Fernleigh	1	2479	'fernleigh':1	(-28.7603329999999993,153.497651999999988)
1350	Nashua	1	2479	'nashua':1	(-28.7298749999999998,153.467864999999989)
1351	Opossum Creek	1	2479	'creek':2 'opossum':1	(-28.6604400000000012,153.506729000000007)
1352	Bentley	1	2480	'bentley':1	(-28.7566109999999995,153.090422999999987)
1353	Bexhill	1	2480	'bexhil':1	(-28.7626890000000017,153.346496000000002)
1355	Corndale	1	2480	'corndal':1	(-28.6987109999999994,153.377820000000014)
1356	Dorroughby	1	2480	'dorroughbi':1	(-28.6617129999999989,153.354936000000009)
1357	Dunoon	1	2480	'dunoon':1	(-28.6819290000000002,153.318543000000005)
1359	Eureka	1	2480	'eureka':1	(-28.683762999999999,153.438375000000008)
1361	Georgica	1	2480	'georgica':1	(-28.6218579999999996,153.168113000000005)
1362	Goolmangar	1	2480	'goolmangar':1	(-28.747167000000001,153.225916000000012)
1364	Lismore	1	2480	'lismor':1	(-28.8127250000000004,153.27872099999999)
1365	Marom Creek	1	2480	'creek':2 'marom':1	(-28.9028980000000004,153.372557999999998)
1366	Mckees Hill	1	2480	'hill':2 'mckee':1	(-28.8807979999999986,153.196280000000002)
1367	Nimbin	1	2480	'nimbin':1	(-28.5967699999999994,153.222904)
1369	Numulgi	1	2480	'numulgi':1	(-28.7440120000000014,153.324937000000006)
1370	Richmond Hill	1	2480	'hill':2 'richmond':1	(-28.7890450000000016,153.35082700000001)
1371	Rock Valley	1	2480	'rock':1 'valley':2	(-28.7473589999999994,153.174403000000012)
1372	Rosebank	1	2480	'rosebank':1	(-28.663494,153.392176000000006)
1374	The Channon	1	2480	'channon':2	(-28.6732380000000013,153.278894000000008)
1375	Tregeagle	1	2480	'tregeagl':1	(-28.8469850000000001,153.353061999999994)
1376	Tuckurimba	1	2480	'tuckurimba':1	(-28.9567119999999996,153.314013999999986)
1377	Tuncester	1	2480	'tuncest':1	(-28.798013000000001,153.225379000000004)
1379	Wyrallah	1	2480	'wyrallah':1	(-28.8881720000000008,153.299755000000005)
1380	Broken Head	1	2481	'broken':1 'head':2	(-28.7172349999999987,153.592296000000005)
1381	Byron Bay	1	2481	'bay':2 'byron':1	(-28.6433870000000006,153.612223999999998)
1383	Tyagarah	1	2481	'tyagarah':1	(-28.6044429999999998,153.556171000000006)
1384	Goonengerry	1	2482	'goonengerri':1	(-28.6107900000000015,153.439673999999997)
1360	Federal	1	2480	'feder':1	(-28.7620000000000005,153.253999999999991)
1472	South Coast	1	2521	'coast':2 'south':1	\N
1386	Billinudgel	1	2483	'billinudgel':1	(-28.5041140000000013,153.52827400000001)
1387	Brunswick Heads	1	2483	'brunswick':1 'head':2	(-28.5389899999999983,153.548252999999988)
1388	Burringbar	1	2483	'burringbar':1	(-28.4343329999999987,153.471283999999997)
1389	Crabbes Creek	1	2483	'crabb':1 'creek':2	(-28.4567200000000007,153.496802000000002)
1390	Mooball	1	2483	'moobal':1	(-28.4418289999999985,153.484435999999988)
1392	Ocean Shores	1	2483	'ocean':1 'shore':2	(-28.5275229999999986,153.543921000000012)
1393	South Golden Beach	1	2483	'beach':3 'golden':2 'south':1	(-28.5012520000000009,153.543566999999996)
1394	Yelgun	1	2483	'yelgun':1	(-28.476032,153.512833999999998)
1397	Chillingham	1	2484	'chillingham':1	(-28.3141199999999991,153.277703000000002)
1398	Condong	1	2484	'condong':1	(-28.3167539999999995,153.433785)
1399	Crystal Creek	1	2484	'creek':2 'crystal':1	(-28.3179359999999996,153.331296000000009)
1400	Cudgera Creek	1	2484	'creek':2 'cudgera':1	(-28.3899560000000015,153.519524999999987)
1401	Doon Doon	1	2484	'doon':1,2	(-28.5039130000000007,153.305692999999991)
1403	Dungay	1	2484	'dungay':1	(-28.2762129999999985,153.369428999999997)
1404	Eungella	1	2484	'eungella':1	(-28.3537609999999987,153.311519000000004)
1405	Kunghur	1	2484	'kunghur':1	(-28.4702330000000003,153.253381999999988)
1407	Numinbah	1	2484	'numinbah':1	(-28.2768380000000015,153.253377)
1408	Palmvale	1	2484	'palmval':1	(-28.3750570000000018,153.481007000000005)
1409	Stokers Siding	1	2484	'side':2 'stoker':1	(-28.393502999999999,153.40363099999999)
1410	Tyalgum	1	2484	'tyalgum':1	(-28.3567530000000012,153.20728299999999)
1411	Uki	1	2484	'uki':1	(-28.4139079999999993,153.336648999999994)
1413	Tweed Heads West	1	2485	'head':2 'tweed':1 'west':3	(-28.1954029999999989,153.505049000000014)
1414	Banora Point	1	2486	'banora':1 'point':2	(-28.2133630000000011,153.535999000000004)
1415	Bilambil	1	2486	'bilambil':1	(-28.2271619999999999,153.467793999999998)
1416	Carool	1	2486	'carool':1	(-28.2302910000000011,153.419146000000012)
1418	Tweed Heads South	1	2486	'head':2 'south':3 'tweed':1	(-28.1984859999999991,153.543746999999996)
1419	Chinderah	1	2487	'chinderah':1	(-28.2377760000000002,153.561344999999989)
1420	Cudgen	1	2487	'cudgen':1	(-28.2627999999999986,153.557209999999998)
1422	Fingal Head	1	2487	'fingal':1 'head':2	(-28.2041560000000011,153.565708999999998)
1423	Kingscliff	1	2487	'kingscliff':1	(-28.2547190000000015,153.575637999999998)
1424	Stotts Creek	1	2487	'creek':2 'stott':1	(-28.2785159999999998,153.516165999999998)
1425	Bogangar	1	2488	'bogangar':1	(-28.3323810000000016,153.54224099999999)
1427	Hastings Point	1	2489	'hast':1 'point':2	(-28.3619659999999989,153.576245999999998)
1428	Pottsville	1	2489	'pottsvill':1	(-28.3790660000000017,153.568549999999988)
1429	Tumbulgum	1	2490	'tumbulgum':1	(-28.2743660000000006,153.461116000000004)
1430	Coniston	1	2500	'coniston':1	(-34.4365450000000024,150.885559000000001)
1433	Keiraville	1	2500	'keiravill':1	(-34.4146259999999984,150.87223800000001)
1432	Mangerton	1	2500	'mangerton':1	(-34.4317220000000006,150.871872999999994)
1434	Mount Keira	1	2500	'keira':2 'mount':1	(-34.395938000000001,150.845276000000013)
1436	North Wollongong	1	2500	'north':1 'wollongong':2	(-34.4143600000000021,150.895575000000008)
1437	Spring Hill	1	2500	'hill':2 'spring':1	(-33.3987059999999971,149.152350000000013)
1438	West Wollongong	1	2500	'west':1 'wollongong':2	(-34.4246490000000023,150.867207000000008)
1439	Wollongong	1	2500	'wollongong':1	(-33.9377890000000022,151.139593999999988)
1440	Cringila	1	2502	'cringila':1	(-34.4715750000000014,150.871375)
1441	Lake Heights	1	2502	'height':2 'lake':1	(-34.4815809999999985,150.872531000000009)
1442	Primbee	1	2502	'primbe':1	(-34.5006550000000018,150.881601999999987)
1443	Warrawong	1	2502	'warrawong':1	(-34.4843819999999965,150.887466999999987)
1444	Kemblawarra	1	2505	'kemblawarra':1	(-34.4932519999999982,150.892831999999999)
1446	Berkeley	1	2506	'berkeley':1	(-34.4814080000000018,150.844146999999992)
1447	Coalcliff	1	2508	'coalcliff':1	(-34.2434530000000024,150.976080999999994)
1448	Darkes Forest	1	2508	'dark':1 'forest':2	(-34.2143739999999994,150.950643000000014)
1449	Helensburgh	1	2508	'helensburgh':1	(-34.1906749999999988,150.981985000000009)
1450	Otford	1	2508	'otford':1	(-34.2132590000000008,151.003234999999989)
1452	Stanwell Tops	1	2508	'stanwel':1 'top':2	(-34.2207700000000017,150.976158999999996)
1453	Austinmer	1	2515	'austinm':1	(-34.3062830000000005,150.934562999999997)
1454	Clifton	1	2515	'clifton':1	(-34.2594070000000031,150.968883000000005)
1455	Coledale	1	2515	'coledal':1	(-34.2882820000000024,150.947401000000013)
1457	Thirroul	1	2515	'thirroul':1	(-34.314739000000003,150.923792999999989)
1458	Wombarra	1	2515	'wombarra':1	(-34.2778479999999988,150.954244999999986)
1459	Bulli	1	2516	'bulli':1	(-34.3338609999999989,150.913281000000012)
1461	Woonona	1	2517	'woonona':1	(-34.3409669999999991,150.906779)
1462	Bellambi	1	2518	'bellambi':1	(-34.365910999999997,150.910755999999992)
1463	Corrimal	1	2518	'corrim':1	(-34.3711509999999976,150.897239000000013)
1464	East Corrimal	1	2518	'corrim':2 'east':1	(-34.3763629999999978,150.911180000000002)
1465	Tarrawanna	1	2518	'tarrawanna':1	(-34.3818640000000002,150.887814999999989)
1467	Balgownie	1	2519	'balgowni':1	(-34.3885900000000007,150.877689000000004)
1468	Fairy Meadow	1	2519	'fairi':1 'meadow':2	(-34.3998789999999985,150.891874000000001)
1469	Mount Ousley	1	2519	'mount':1 'ousley':2	(-34.4023759999999967,150.886718999999999)
1473	University Of Wollongong	1	2522	'univers':1 'wollongong':3	(-34.4051029999999969,150.877804999999995)
1474	Figtree	1	2525	'figtre':1	(-34.4356859999999969,150.861241000000007)
1475	Cordeaux Heights	1	2526	'cordeaux':1 'height':2	(-34.4398010000000028,150.83839900000001)
1476	Farmborough Heights	1	2526	'farmborough':1 'height':2	(-34.4540039999999976,150.819943999999992)
1478	Mount Kembla	1	2526	'kembla':2 'mount':1	(-34.4327990000000028,150.820503000000002)
1479	Unanderra	1	2526	'unanderra':1	(-34.4546240000000026,150.845092999999991)
1480	Albion Park	1	2527	'albion':1 'park':2	(-34.5707220000000035,150.775031000000013)
1481	Albion Park Rail	1	2527	'albion':1 'park':2 'rail':3	(-34.5608379999999968,150.795749999999998)
1482	Barrack Heights	1	2528	'barrack':1 'height':2	(-34.5652029999999968,150.857066000000003)
1483	Barrack Point	1	2528	'barrack':1 'point':2	(-34.563248999999999,150.86737500000001)
1484	Lake Illawarra	1	2528	'illawarra':2 'lake':1	(-34.5464729999999989,150.856950000000012)
1486	Warilla	1	2528	'warilla':1	(-34.5525730000000024,150.859949999999998)
1487	Windang	1	2528	'windang':1	(-34.5299400000000034,150.869145000000003)
1488	Blackbutt	1	2529	'blackbutt':1	(-34.568959999999997,150.834695000000011)
1489	Dunmore	1	2529	'dunmor':1	(-34.606223,150.840676000000002)
1490	Flinders	1	2529	'flinder':1	(-34.5798360000000002,150.844828000000007)
1492	Shell Cove	1	2529	'cove':2 'shell':1	(-34.588200999999998,150.872593999999992)
1493	Shellharbour	1	2529	'shellharbour':1	(-34.5790349999999975,150.867929000000004)
1494	Brownsville	1	2530	'brownsvill':1	(-34.4856440000000006,150.80621099999999)
1495	Dapto	1	2530	'dapto':1	(-34.4940009999999972,150.793005999999991)
1497	Kanahooka	1	2530	'kanahooka':1	(-34.4944800000000029,150.808964000000003)
1498	Koonawarra	1	2530	'koonawarra':1	(-34.5021959999999979,150.807051999999999)
1499	Wongawilli	1	2530	'wongawilli':1	(-34.4800019999999989,150.758765000000011)
1500	Yallah	1	2530	'yallah':1	(-34.5377769999999984,150.780648000000014)
1502	Jamberoo	1	2533	'jamberoo':1	(-34.648418999999997,150.776594999999986)
1503	Kiama	1	2533	'kiama':1	(-34.6716759999999979,150.85670300000001)
1504	Minnamurra	1	2533	'minnamurra':1	(-34.627870999999999,150.855112999999989)
1506	Gerringong	1	2534	'gerringong':1	(-34.7455489999999969,150.827496999999994)
1507	Gerroa	1	2534	'gerroa':1	(-34.7701709999999977,150.81561099999999)
1508	Toolijooa	1	2534	'toolijooa':1	(-34.7555830000000014,150.780909000000008)
1510	Bellawongarah	1	2535	'bellawongarah':1	(-34.7638940000000005,150.626430999999997)
1511	Berry	1	2535	'berri':1	(-34.7754940000000019,150.696595000000002)
1512	Budderoo	1	2535	'budderoo':1	(-34.6622139999999987,150.662881999999996)
1513	Coolangatta	1	2535	'coolangatta':1	(-34.8542079999999999,150.726360999999997)
1515	Shoalhaven Heads	1	2535	'head':2 'shoalhaven':1	(-34.8514499999999998,150.745253999999989)
1516	Wattamolla	1	2535	'wattamolla':1	(-34.7359310000000008,150.622766000000013)
1517	Woodhill	1	2535	'woodhil':1	(-34.7261469999999974,150.675049999999999)
1518	Batehaven	1	2536	'batehaven':1	(-35.7321099999999987,150.199538999999987)
1519	Batemans Bay	1	2536	'bateman':1 'bay':2	(-35.7081519999999983,150.174703999999991)
1520	Benandarah	1	2536	'benandarah':1	(-35.6609359999999995,150.228251)
1522	Buckenbowra	1	2536	'buckenbowra':1	(-35.7694619999999972,150.065753999999998)
1523	Catalina	1	2536	'catalina':1	(-35.723475999999998,150.192552000000006)
1524	Currowan	1	2536	'currowan':1	(-35.5598230000000015,150.167187000000013)
1526	Durras North	1	2536	'durra':1 'north':2	(-35.6276989999999998,150.310957000000002)
1527	East Lynne	1	2536	'east':1 'lynn':2	(-35.5788170000000008,150.258877000000012)
1528	Guerilla Bay	1	2536	'bay':2 'guerilla':1	(-35.8263919999999985,150.218065999999993)
1529	Jeremadra	1	2536	'jeremadra':1	(-35.8091250000000016,150.13659899999999)
1532	Maloneys Beach	1	2536	'beach':2 'maloney':1	(-35.7059330000000017,150.247976999999992)
1533	Malua Bay	1	2536	'bay':2 'malua':1	(-35.7833340000000035,150.232070999999991)
1534	Mogo	1	2536	'mogo':1	(-32.265782999999999,150.011497999999989)
1535	Nelligen	1	2536	'nelligen':1	(-35.6474380000000011,150.141481999999996)
1537	Rosedale	1	2536	'rosedal':1	(-35.8186060000000026,150.219888999999995)
1538	Runnyford	1	2536	'runnyford':1	(-35.7169239999999988,150.113916999999987)
1539	South Durras	1	2536	'durra':2 'south':1	(-35.6509879999999981,150.295026000000007)
1540	Sunshine Bay	1	2536	'bay':2 'sunshin':1	(-35.7416059999999973,150.209090000000003)
1541	Surf Beach	1	2536	'beach':2 'surf':1	(-35.7613410000000016,150.210129999999992)
1542	Surfside	1	2536	'surfsid':1	(-35.7007880000000029,150.198313000000013)
1544	Bergalia	1	2537	'bergalia':1	(-35.9812610000000035,150.105175000000003)
1545	Bingie	1	2537	'bingi':1	(-36.0111300000000014,150.153153000000003)
1546	Broulee	1	2537	'broule':1	(-35.8549959999999999,150.174615999999986)
1547	Coila	1	2537	'coila':1	(-36.0222839999999991,150.102934000000005)
1549	Deua	1	2537	'deua':1	(-35.8176849999999973,149.794893999999999)
1551	Kiora	1	2537	'kiora':1	(-35.9228290000000001,150.038920999999988)
1552	Meringo	1	2537	'meringo':1	(-35.9838420000000028,150.147692000000006)
1553	Mogendoura	1	2537	'mogendoura':1	(-35.8722250000000003,150.058818000000002)
1554	Moruya	1	2537	'moruya':1	(-35.9117389999999972,150.078003999999993)
1555	Moruya Heads	1	2537	'head':2 'moruya':1	(-35.9136019999999974,150.13261700000001)
1556	Mossy Point	1	2537	'mossi':1 'point':2	(-35.8373909999999967,150.175923000000012)
1557	Tomakin	1	2537	'tomakin':1	(-35.8217670000000012,150.193026000000003)
1559	Tuross Head	1	2537	'head':2 'tuross':1	(-36.0607479999999967,150.137151999999986)
1560	Milton	1	2538	'milton':1	(-35.3150850000000034,150.434525000000008)
1561	Bawley Point	1	2539	'bawley':1 'point':2	(-35.5223870000000019,150.393202000000002)
1564	Burrill Lake	1	2539	'burril':1 'lake':2	(-35.3871889999999993,150.449602999999996)
1565	Conjola	1	2539	'conjola':1	(-35.2196309999999997,150.434869999999989)
1566	Conjola Park	1	2539	'conjola':1 'park':2	(-35.3715929999999972,150.452134999999998)
1568	Kioloa	1	2539	'kioloa':1	(-35.5444260000000014,150.383971000000003)
1569	Lake Conjola	1	2539	'conjola':2 'lake':1	(-35.2692910000000026,150.492741999999993)
1570	Lake Tabourie	1	2539	'lake':1 'tabouri':2	(-35.4437500000000014,150.398471000000001)
1571	Manyana	1	2539	'manyana':1	(-35.2584129999999973,150.513956000000007)
1572	Mollymook	1	2539	'mollymook':1	(-35.3393239999999977,150.474228000000011)
1573	Termeil	1	2539	'termeil':1	(-35.4871709999999965,150.339307999999988)
1576	Bamarang	1	2540	'bamarang':1	(-34.894362000000001,150.534464000000014)
1577	Basin View	1	2540	'basin':1 'view':2	(-35.0911029999999968,150.562281000000013)
1578	Berrara	1	2540	'berrara':1	(-35.2055819999999997,150.550410999999997)
1579	Bolong	1	2540	'bolong':1	(-34.8470060000000004,150.649574000000001)
1581	Burrier	1	2540	'burrier':1	(-34.8703810000000018,150.451136999999989)
1582	Callala Bay	1	2540	'bay':2 'callala':1	(-34.9876099999999965,150.718141000000003)
1563	Berringer Lake	1	2539	'berring':1 'lake':2	(-35.4040000000000035,150.402999999999992)
1584	Cambewarra	1	2540	'cambewarra':1	(-34.8207510000000013,150.542225999999999)
1585	Cudmirrah	1	2540	'cudmirrah':1	(-35.1980399999999989,150.557817999999997)
1587	Currarong	1	2540	'currarong':1	(-35.0187389999999965,150.824214000000012)
1588	Erowal Bay	1	2540	'bay':2 'erow':1	(-35.1024359999999973,150.653638999999998)
1589	Falls Creek	1	2540	'creek':2 'fall':1	(-34.9682320000000004,150.596928999999989)
1590	Greenwell Point	1	2540	'greenwel':1 'point':2	(-34.9079290000000029,150.729736000000003)
1591	Hmas Albatross	1	2540	'albatross':2 'hmas':1	(-34.9435980000000015,150.548423000000014)
1593	Huskisson	1	2540	'huskisson':1	(-35.0388499999999965,150.670942999999994)
1596	Meroo Meadow	1	2540	'meadow':2 'meroo':1	(-34.8098740000000006,150.618378000000007)
1597	Myola	1	2540	'myola':1	(-35.0271040000000013,150.673252999999988)
1598	Numbaa	1	2540	'numbaa':1	(-34.8734290000000016,150.678483999999997)
1600	Orient Point	1	2540	'orient':1 'point':2	(-34.9108000000000018,150.749658000000011)
1601	Pyree	1	2540	'pyre':1	(-34.9116690000000034,150.684687999999994)
1602	Sanctuary Point	1	2540	'point':2 'sanctuari':1	(-35.1041310000000024,150.626940999999988)
1603	St Georges Basin	1	2540	'basin':3 'georg':2 'st':1	(-35.0907880000000034,150.597814999999997)
1604	Sussex Inlet	1	2540	'inlet':2 'sussex':1	(-35.1570090000000022,150.596247000000005)
1606	Tapitallee	1	2540	'tapitalle':1	(-34.8295140000000032,150.540433000000007)
1607	Terara	1	2540	'terara':1	(-34.8654470000000032,150.627435999999989)
1608	Tomerong	1	2540	'tomerong':1	(-35.052033999999999,150.587067999999988)
1609	Vincentia	1	2540	'vincentia':1	(-35.0695369999999969,150.675177999999988)
1611	Woollamia	1	2540	'woollamia':1	(-35.0136729999999972,150.63761199999999)
1612	Worrigee	1	2540	'worrige':1	(-34.8903699999999972,150.626073999999988)
1613	Wrights Beach	1	2540	'beach':2 'wright':1	(-35.1120349999999988,150.66525200000001)
1614	Yalwal	1	2540	'yalwal':1	(-34.9169339999999977,150.424339000000003)
1616	Bomaderry	1	2541	'bomaderri':1	(-34.8554120000000012,150.608383000000003)
1617	North Nowra	1	2541	'north':1 'nowra':2	(-34.8607310000000012,150.591466999999994)
1618	Nowra	1	2541	'nowra':1	(-34.8726979999999998,150.60342)
1620	Bodalla	1	2545	'bodalla':1	(-36.0909090000000035,150.051740999999993)
1621	Nerrigundah	1	2545	'nerrigundah':1	(-36.1184780000000032,149.901129999999995)
1622	Barragga Bay	1	2546	'barragga':1 'bay':2	(-36.5026280000000014,150.053010999999998)
1623	Bermagui	1	2546	'bermagui':1	(-36.4227320000000034,150.064390000000003)
1624	Cuttagee	1	2546	'cuttage':1	(-36.4927569999999974,150.053494999999998)
1626	Dignams Creek	1	2546	'creek':2 'dignam':1	(-36.3474840000000015,150.010185000000007)
1627	Kianga	1	2546	'kianga':1	(-36.1960690000000014,150.131025999999991)
1628	Narooma	1	2546	'narooma':1	(-36.218319000000001,150.132246000000009)
1630	Tilba Tilba	1	2546	'tilba':1,2	(-36.3244219999999984,150.062667000000005)
1631	Tinpot	1	2546	'tinpot':1	(-36.2316700000000012,149.882894999999991)
1632	Wallaga Lake	1	2546	'lake':2 'wallaga':1	(-36.3566730000000007,150.066053000000011)
1633	Berrambool	1	2548	'berrambool':1	(-36.8787999999999982,149.91740200000001)
1634	Merimbula	1	2548	'merimbula':1	(-36.8877620000000022,149.910552999999993)
1637	Greigs Flat	1	2549	'flat':2 'greig':1	(-36.9683530000000005,149.866267999999991)
1638	Nethercote	1	2549	'nethercot':1	(-37.017789999999998,149.828722999999997)
1639	Pambula	1	2549	'pambula':1	(-36.9292469999999966,149.874617999999998)
1641	Bega	1	2550	'bega':1	(-36.6742619999999988,149.843240000000009)
1642	Bemboka	1	2550	'bemboka':1	(-36.6299169999999989,149.572964000000013)
1643	Bournda	1	2550	'bournda':1	(-36.8368010000000012,149.912997999999988)
1644	Brogo	1	2550	'brogo':1	(-36.5709930000000014,149.823508000000004)
1645	Burragate	1	2550	'burrag':1	(-37.0010830000000013,149.628928000000002)
1647	Cobargo	1	2550	'cobargo':1	(-36.3876100000000022,149.887772000000012)
1648	Doctor George Mountain	1	2550	'doctor':1 'georg':2 'mountain':3	(-36.665809000000003,149.892211000000003)
1650	Mogareeka	1	2550	'mogareeka':1	(-36.6984309999999994,149.975981999999988)
1652	Mumbulla Mountain	1	2550	'mountain':2 'mumbulla':1	(-36.5454450000000008,149.864644999999996)
1653	Nelson	1	2550	'nelson':1	(-33.6527949999999976,150.915684999999996)
1654	Quaama	1	2550	'quaama':1	(-36.464379000000001,149.870090000000005)
1655	Rocky Hall	1	2550	'hall':2 'rocki':1	(-36.9137229999999974,149.488004999999987)
1656	Tathra	1	2550	'tathra':1	(-36.7297280000000015,149.985917000000001)
1658	Wandella	1	2550	'wandella':1	(-36.2993990000000011,149.848665000000011)
1659	Wapengo	1	2550	'wapengo':1	(-36.5945449999999965,150.018275999999986)
1660	Wolumla	1	2550	'wolumla':1	(-36.8319949999999992,149.811442)
1662	Yowrie	1	2550	'yowri':1	(-36.2975860000000026,149.717827999999997)
1664	Kiah	1	2551	'kiah':1	(-37.1497230000000016,149.856898999999999)
1665	Wonboyn	1	2551	'wonboyn':1	(-37.2510460000000023,149.914952999999997)
1667	Badgerys Creek	1	2555	'badgeri':1 'creek':2	(-33.8833759999999984,150.741351000000009)
1668	Bringelly	1	2556	'bringelli':1	(-33.9457069999999987,150.725207000000012)
1669	Catherine Field	1	2557	'catherin':1 'field':2	(-33.9935449999999975,150.774857999999995)
1670	Rossmore	1	2557	'rossmor':1	(-33.9459650000000011,150.772762999999998)
1671	Eagle Vale	1	2558	'eagl':1 'vale':2	(-34.0378820000000033,150.814153000000005)
1673	Kearns	1	2558	'kearn':1	(-34.0213210000000004,150.803211000000005)
1674	Blairmount	1	2559	'blairmount':1	(-34.0494849999999971,150.799610999999999)
1675	Claymore	1	2559	'claymor':1	(-34.0455240000000003,150.810023999999999)
1676	Airds	1	2560	'aird':1	(-34.0844680000000011,150.829040999999989)
1678	Appin	1	2560	'appin':1	(-34.2008909999999986,150.78747899999999)
1680	Blair Athol	1	2560	'athol':2 'blair':1	(-34.0638349999999974,150.806006999999994)
1679	Bradbury	1	2560	'bradburi':1	(-34.0860059999999976,150.814016000000009)
1682	Englorie Park	1	2560	'englori':1 'park':2	(-34.0820519999999973,150.795130999999998)
1683	Gilead	1	2560	'gilead':1	(-34.1070350000000033,150.761815000000013)
1684	Glen Alpine	1	2560	'alpin':2 'glen':1	(-34.0841840000000005,150.775274999999993)
2468	Sydney Windsor	1	1	\N	\N
1685	Kentlyn	1	2560	'kentlyn':1	(-34.0731710000000021,150.857429999999994)
1661	Wyndham	1	2550	'wyndham':1	(-36.7509999999999977,149.703000000000003)
1714	Elderslie	1	2570	'eldersli':1	(-34.059038000000001,150.711426999999986)
1760	Penrose	1	2579	'penros':1	(-34.6700719999999976,150.228511999999995)
1686	Leumeah	1	2560	'leumeah':1	(-34.0522849999999977,150.833395999999993)
1687	Rosemeadow	1	2560	'rosemeadow':1	(-34.1017950000000027,150.800106)
1688	Ruse	1	2560	'ruse':1	(-34.0692829999999987,150.84406899999999)
1690	Wedderburn	1	2560	'wedderburn':1	(-34.127555000000001,150.812698000000012)
1691	Woodbine	1	2560	'woodbin':1	(-34.0498919999999998,150.818871999999999)
1692	Menangle Park	1	2563	'menangl':1 'park':2	(-34.1001210000000015,150.757015999999993)
1696	Denham Court	1	2565	'court':2 'denham':1	(-33.9900810000000035,150.844652999999994)
1695	Macquarie Links	1	2565	'link':2 'macquari':1	(-33.9821850000000012,150.867560999999995)
1698	Bow Bowing	1	2566	'bow':1,2	(-34.0153419999999969,150.836819999999989)
1699	Minto	1	2566	'minto':1	(-34.0320219999999978,150.848208)
1700	Raby	1	2566	'rabi':1	(-34.0210709999999992,150.811347000000012)
1702	Varroville	1	2566	'varrovill':1	(-34.0102550000000008,150.822979000000004)
1704	Harrington Park	1	2567	'harrington':1 'park':2	(-34.0232389999999967,150.742232000000001)
1705	Mount Annan	1	2567	'annan':2 'mount':1	(-34.054864000000002,150.764158000000009)
1706	Narellan	1	2567	'narellan':1	(-34.0405239999999978,150.735614999999996)
1707	Narellan Vale	1	2567	'narellan':1 'vale':2	(-34.0552709999999976,150.744079999999997)
1708	Menangle	1	2568	'menangl':1	(-34.1086540000000014,150.749148999999989)
1710	Camden	1	2570	'camden':1	(-34.0545990000000032,150.695677999999987)
1711	Camden Park	1	2570	'camden':1 'park':2	(-34.088673,150.721835999999996)
1712	Cawdor	1	2570	'cawdor':1	(-34.1086910000000003,150.671985000000006)
1713	Cobbitty	1	2570	'cobbitti':1	(-34.0158739999999966,150.691028999999986)
1716	Grasmere	1	2570	'grasmer':1	(-34.0562929999999966,150.673169999999999)
1717	Mount Hunter	1	2570	'hunter':2 'mount':1	(-34.0712479999999971,150.641381999999993)
1718	Nattai	1	2570	'nattai':1	(-34.0689350000000033,150.44568000000001)
1719	Oakdale	1	2570	'oakdal':1	(-34.0781739999999971,150.513639000000012)
1721	The Oaks	1	2570	'oak':2	(-34.0768729999999991,150.571086000000008)
1722	Werombi	1	2570	'werombi':1	(-33.9889179999999982,150.571740000000005)
1724	Buxton	1	2571	'buxton':1	(-34.2543679999999995,150.533906999999999)
1725	Couridjah	1	2571	'couridjah':1	(-34.2342179999999985,150.54756900000001)
1727	Razorback	1	2571	'razorback':1	(-33.0338029999999989,149.819230000000005)
1728	Wilton	1	2571	'wilton':1	(-34.2404340000000005,150.696426000000002)
1729	Lakesland	1	2572	'lakesland':1	(-34.1808699999999988,150.526834000000008)
1731	Tahmoor	1	2573	'tahmoor':1	(-34.2229099999999988,150.593446999999998)
1732	Bargo	1	2574	'bargo':1	(-34.2894429999999986,150.580103000000008)
1733	Pheasants Nest	1	2574	'nest':2 'pheasant':1	(-34.2559729999999973,150.635599000000013)
1734	Yanderra	1	2574	'yanderra':1	(-34.3241749999999968,150.569254000000001)
1736	Colo Vale	1	2575	'colo':1 'vale':2	(-34.4001340000000013,150.487968999999993)
1737	Hill Top	1	2575	'hill':1 'top':2	(-33.7962920000000011,151.272681000000006)
1738	Mittagong	1	2575	'mittagong':1	(-34.4508560000000017,150.448788000000008)
1739	Welby	1	2575	'welbi':1	(-34.4395329999999973,150.428080999999992)
1741	Bowral	1	2576	'bowral':1	(-34.477800000000002,150.418085999999988)
1742	Burradoo	1	2576	'burradoo':1	(-34.5063949999999977,150.404854)
1743	Kangaloon	1	2576	'kangaloon':1	(-34.5533659999999969,150.533848000000006)
1745	Barrengarry	1	2577	'barrengarri':1	(-34.7206830000000011,150.523542999999989)
1746	Beaumont	1	2577	'beaumont':1	(-34.7818049999999985,150.561629000000011)
1747	Berrima	1	2577	'berrima':1	(-34.4896439999999984,150.335815999999994)
1749	Fitzroy Falls	1	2577	'fall':2 'fitzroy':1	(-34.640976000000002,150.478477999999996)
1750	Kangaroo Valley	1	2577	'kangaroo':1 'valley':2	(-34.7378259999999983,150.536214999999999)
1751	Moss Vale	1	2577	'moss':1 'vale':2	(-34.5476079999999968,150.373096000000004)
1753	Robertson	1	2577	'robertson':1	(-34.5892369999999971,150.596418)
1754	Sutton Forest	1	2577	'forest':2 'sutton':1	(-34.568289,150.321035999999992)
1755	Wildes Meadow	1	2577	'meadow':2 'wild':1	(-34.618189000000001,150.530044000000004)
1756	Yarrunga	1	2577	'yarrunga':1	(-34.5906749999999974,150.439521000000013)
1757	Bundanoon	1	2578	'bundanoon':1	(-34.6325980000000015,150.321574999999996)
1759	Marulan	1	2579	'marulan':1	(-34.7119959999999992,150.005977999999999)
1761	Tallong	1	2579	'tallong':1	(-34.7185479999999984,150.08307099999999)
1762	Wingello	1	2579	'wingello':1	(-34.6917260000000027,150.156749999999988)
1764	Bungonia	1	2580	'bungonia':1	(-34.8292390000000012,149.869191999999998)
1765	Golspie	1	2580	'golspi':1	(-34.2908449999999974,149.662983999999994)
1766	Goulburn	1	2580	'goulburn':1	(-34.75535,149.717815999999999)
1767	Kingsdale	1	2580	'kingsdal':1	(-34.6633539999999982,149.661162999999988)
1769	Roslyn	1	2580	'roslyn':1	(-34.5029049999999984,149.607499999999987)
1770	Tarago	1	2580	'tarago':1	(-35.084502999999998,149.628735000000006)
1771	Taralga	1	2580	'taralga':1	(-34.4055669999999978,149.818682999999993)
1772	Towrang	1	2580	'towrang':1	(-34.6853079999999991,149.85994199999999)
1774	Woodhouselee	1	2580	'woodhousele':1	(-34.5704390000000004,149.631110000000007)
1775	Yalbraith	1	2580	'yalbraith':1	(-34.2416059999999973,149.773797999999999)
1776	Yarra	1	2580	'yarra':1	(-34.7627280000000027,149.623034999999987)
1777	Breadalbane	1	2581	'breadalban':1	(-34.8007959999999983,149.468173000000007)
1778	Collector	1	2581	'collector':1	(-34.9172900000000013,149.424331999999993)
1780	Gunning	1	2581	'gun':1	(-34.7822639999999978,149.26636400000001)
1781	Bookham	1	2582	'bookham':1	(-34.7894160000000028,148.637784000000011)
1782	Bowning	1	2582	'bown':1	(-34.7678999999999974,148.81469899999999)
1784	Murrumbateman	1	2582	'murrumbateman':1	(-34.9695520000000002,149.030349999999999)
1785	Wee Jasper	1	2582	'jasper':2 'wee':1	(-35.1157710000000023,148.673123000000004)
1786	Yass	1	2582	'yass':1	(-34.8421499999999966,148.911227999999994)
1787	Bigga	1	2583	'bigga':1	(-34.084775999999998,149.151361000000009)
1789	Blanket Flat	1	2583	'blanket':1 'flat':2	(-34.1287069999999986,149.196951000000013)
1701	St Andrews	1	2566	'andrew':2 'st':1	(-34.0189999999999984,150.841000000000008)
1790	Crooked Corner	1	2583	'corner':2 'crook':1	(-34.2284700000000015,149.248831999999993)
1791	Crookwell	1	2583	'crookwel':1	(-34.4580759999999984,149.470291000000003)
1792	Fullerton	1	2583	'fullerton':1	(-34.2106560000000002,149.514501999999993)
1794	Kialla	1	2583	'kialla':1	(-34.5443429999999978,149.46078399999999)
1795	Laggan	1	2583	'laggan':1	(-34.384408999999998,149.541447000000005)
1796	Limerick	1	2583	'limerick':1	(-34.2040840000000017,149.477510999999993)
1797	Peelwood	1	2583	'peelwood':1	(-34.1113610000000023,149.427223999999995)
1798	Rugby	1	2583	'rugbi':1	(-34.3672219999999982,149.032411999999994)
1799	Tuena	1	2583	'tuena':1	(-34.0164639999999991,149.327711999999991)
1801	Galong	1	2585	'galong':1	(-34.6015859999999975,148.556894999999997)
1802	Boorowa	1	2586	'boorowa':1	(-34.4385979999999989,148.716326000000009)
1803	Murringo	1	2586	'murringo':1	(-34.272866999999998,148.509952999999996)
1805	Rye Park	1	2586	'park':2 'rye':1	(-34.5195730000000012,148.90769499999999)
1806	Harden	1	2587	'harden':1	(-34.5550330000000017,148.369634999999988)
1807	Kingsvale	1	2587	'kingsval':1	(-34.4575639999999979,148.363623999999987)
1808	Murrumburrah	1	2587	'murrumburrah':1	(-34.5493290000000002,148.350182999999987)
1810	Wallendbeen	1	2588	'wallendbeen':1	(-34.5243189999999984,148.160159999999991)
1811	Bethungra	1	2590	'bethungra':1	(-34.7628940000000028,147.852564999999998)
1812	Cootamundra	1	2590	'cootamundra':1	(-34.6390889999999985,148.024671000000012)
1813	Illabo	1	2590	'illabo':1	(-34.8147980000000032,147.740661999999986)
1815	Milvale	1	2594	'milval':1	(-34.3149429999999995,147.875379000000009)
1816	Monteagle	1	2594	'monteagl':1	(-34.1932449999999974,148.342277999999993)
1817	Young	1	2594	'young':1	(-34.3134099999999975,148.297921000000002)
1820	Jerrabomberra	1	2619	'jerrabomberra':1	(-35.3844580000000022,149.199052999999992)
1821	Burra	1	2620	'burra':1	(-35.8294679999999985,148.068724000000003)
1822	Crestwood	1	2620	'crestwood':1	(-31.4722650000000002,152.904109000000005)
1823	Gundaroo	1	2620	'gundaroo':1	(-35.1277449999999973,149.209789999999998)
1825	Michelago	1	2620	'michelago':1	(-33.9423900000000032,150.86505600000001)
1826	Queanbeyan	1	2620	'queanbeyan':1	(-35.3544430000000034,149.232082999999989)
1827	Queanbeyan East	1	2620	'east':2 'queanbeyan':1	(-35.342807999999998,149.244392000000005)
1829	Royalla	1	2620	'royalla':1	(-35.5122270000000029,149.162689999999998)
1830	Sutton	1	2620	'sutton':1	(-35.1611990000000034,149.252970000000005)
1831	Wamboin	1	2620	'wamboin':1	(-31.713913999999999,148.660145999999997)
1832	Williamsdale	1	2620	'williamsdal':1	(-35.5750359999999972,149.187253999999996)
1833	Bungendore	1	2621	'bungendor':1	(-35.2560829999999967,149.440416999999997)
1835	Ballalaba	1	2622	'ballalaba':1	(-35.5726820000000004,149.666842000000003)
1836	Boro	1	2622	'boro':1	(-35.1428889999999967,149.661588999999992)
1837	Braidwood	1	2622	'braidwood':1	(-35.437700999999997,149.800868000000008)
1839	Jembaicumbene	1	2622	'jembaicumben':1	(-35.5296439999999976,149.798210000000012)
1840	Majors Creek	1	2622	'creek':2 'major':1	(-35.5705999999999989,149.738897000000009)
1841	Monga	1	2622	'monga':1	(-35.5502899999999968,149.899619000000001)
1842	Mongarlowe	1	2622	'mongarlow':1	(-35.4222180000000009,149.922832999999997)
1844	Reidsdale	1	2622	'reidsdal':1	(-35.5897089999999992,149.84544600000001)
1845	Captains Flat	1	2623	'captain':1 'flat':2	(-35.5528270000000006,149.445083000000011)
1846	Perisher Valley	1	2624	'perish':1 'valley':2	(-36.4098359999999985,148.404293999999993)
1848	Bredbo	1	2626	'bredbo':1	(-35.9591289999999972,149.150191000000007)
1849	Jindabyne	1	2627	'jindabyn':1	(-36.4150739999999971,148.618871000000013)
1850	Berridale	1	2628	'berridal':1	(-36.3695299999999975,148.830045000000013)
1852	Dalgety	1	2628	'dalgeti':1	(-36.5022670000000033,148.834562000000005)
1853	Eucumbene	1	2628	'eucumben':1	(-36.1405809999999974,148.634190999999987)
1855	Adaminaby	1	2629	'adaminabi':1	(-35.9973489999999998,148.769744000000003)
1856	Cabramurra	1	2629	'cabramurra':1	(-35.9395110000000031,148.385746000000012)
1857	Yaouk	1	2629	'yaouk':1	(-35.8223020000000005,148.809945999999997)
1858	Bungarby	1	2630	'bungarbi':1	(-36.6494399999999985,149.002848)
1860	Chakola	1	2630	'chakola':1	(-36.0725849999999966,149.159951000000007)
1861	Cooma	1	2630	'cooma':1	(-36.236578999999999,149.125456000000014)
1862	Jerangle	1	2630	'jerangl':1	(-35.8857309999999998,149.358866000000006)
1864	Peak View	1	2630	'peak':1 'view':2	(-36.0936149999999998,149.372138000000007)
1865	Rock Flat	1	2630	'flat':2 'rock':1	(-36.3484440000000006,149.211760999999996)
1867	Ando	1	2631	'ando':1	(-36.7399309999999986,149.261211000000003)
1868	Nimmitabel	1	2631	'nimmitabel':1	(-36.518225000000001,149.280424000000011)
1870	Bombala	1	2632	'bombala':1	(-36.9095439999999968,149.242198000000002)
1871	Cathcart	1	2632	'cathcart':1	(-36.8436990000000009,149.388335000000012)
1872	Craigie	1	2632	'craigi':1	(-37.0710270000000008,149.049329)
1873	Mila	1	2632	'mila':1	(-37.0553779999999975,149.170141000000001)
1875	Albury	1	2640	'alburi':1	(-36.082137000000003,146.910174000000012)
1876	East Albury	1	2640	'alburi':2 'east':1	(-36.0756170000000012,146.929104999999993)
1878	South Albury	1	2640	'alburi':2 'south':1	(-36.0970020000000034,146.915212999999994)
1879	Table Top	1	2640	'tabl':1 'top':2	(-35.9802699999999973,147.000325000000004)
1880	Talmalmo	1	2640	'talmalmo':1	(-35.9582070000000016,147.558379000000002)
1881	Thurgoona	1	2640	'thurgoona':1	(-36.0444749999999985,146.989960999999994)
1882	Lavington	1	2641	'lavington':1	(-36.050576999999997,146.933346)
1884	Burrumbuttock	1	2642	'burrumbuttock':1	(-35.8354289999999978,146.802861000000007)
1885	Gerogery	1	2642	'gerogeri':1	(-35.8342939999999999,146.99425500000001)
1886	Jindera	1	2642	'jindera':1	(-35.9500710000000012,146.88594599999999)
1887	Jingellic	1	2642	'jingel':1	(-35.9256099999999989,147.699939999999998)
1889	Rand	1	2642	'rand':1	(-35.5930469999999985,146.577718000000004)
1890	Tooma	1	2642	'tooma':1	(-35.9710800000000006,148.052594999999997)
1891	Walbundrie	1	2642	'walbundri':1	(-35.6901620000000008,146.721270000000004)
1893	Howlong	1	2643	'howlong':1	(-35.9585679999999996,146.605860000000007)
1894	Bowna	1	2644	'bowna':1	(-35.9649840000000012,147.130855999999994)
1895	Holbrook	1	2644	'holbrook':1	(-35.7294139999999985,147.309787999999998)
1819	Uriarra	1	2611	'uriarra':1	(-35.4159999999999968,148.837999999999994)
1931	Wagga Wagga Raaf	1	2651	'raaf':3 'wagga':1,2	\N
1994	Riverina	1	2678	'riverina':1	\N
1944	Rosewood	1	2652	'rosewood':1	(-35.6747500000000031,147.864040999999986)
1897	Woomargama	1	2644	'woomargama':1	(-35.8328539999999975,147.24756099999999)
1898	Urana	1	2645	'urana':1	(-35.3294470000000018,146.265683999999993)
1899	Balldale	1	2646	'balldal':1	(-35.845723999999997,146.518358000000006)
1900	Corowa	1	2646	'corowa':1	(-35.997951999999998,146.391213999999991)
1901	Daysdale	1	2646	'daysdal':1	(-35.6476200000000034,146.306627999999989)
1903	Oaklands	1	2646	'oakland':1	(-35.5578819999999993,146.167770999999988)
1904	Rennie	1	2646	'renni':1	(-35.8124970000000005,146.132862999999986)
1905	Savernake	1	2646	'savernak':1	(-35.7347859999999997,146.049317000000002)
1907	Cal Lal	1	2648	'cal':1 'lal':2	(-34.0064040000000034,141.115300999999988)
1908	Curlwaa	1	2648	'curlwaa':1	(-34.0928100000000001,141.965557999999987)
1909	Mourquong	1	2648	'mourquong':1	(-34.1387110000000007,142.162958000000003)
1910	Palinyewah	1	2648	'palinyewah':1	(-33.8247509999999991,142.155567999999988)
1912	Pooncarie	1	2648	'pooncari':1	(-33.3869949999999989,142.570537000000002)
1913	Rufus River	1	2648	'river':2 'rufus':1	(-34.0109220000000008,141.542087000000009)
1914	Wentworth	1	2648	'wentworth':1	(-34.1068679999999986,141.919215000000008)
1916	Ashmont	1	2650	'ashmont':1	(-35.1231799999999978,147.32995600000001)
1917	Carabost	1	2650	'carabost':1	(-35.5787219999999991,147.71714399999999)
1918	Collingullie	1	2650	'collingulli':1	(-35.0718450000000033,147.111459999999994)
1919	Cookardinia	1	2650	'cookardinia':1	(-35.5585220000000035,147.232617000000005)
1921	Glenfield Park	1	2650	'glenfield':1 'park':2	(-35.1389100000000028,147.334699000000001)
1922	Harefield	1	2650	'harefield':1	(-34.9697579999999988,147.566467999999986)
1923	Kooringal	1	2650	'kooring':1	(-35.1352469999999997,147.376283999999998)
1925	Mount Austin	1	2650	'austin':2 'mount':1	(-35.133028000000003,147.35840300000001)
1926	Tolland	1	2650	'tolland':1	(-35.1479149999999976,147.34997899999999)
1927	Turvey Park	1	2650	'park':2 'turvey':1	(-35.131926,147.358640000000008)
1928	Wagga Wagga	1	2650	'wagga':1,2	(-35.1098610000000022,147.370515000000012)
1929	Wagga Wagga South	1	2650	'south':3 'wagga':1,2	(-35.1208829999999992,147.355477000000008)
1930	Forest Hill	1	2651	'forest':1 'hill':2	(-32.7079809999999966,151.550009999999986)
1932	Boree Creek	1	2652	'bore':1 'creek':2	(-35.1061830000000015,146.614260000000002)
1933	Galore	1	2652	'galor':1	(-35.0064259999999976,146.893574000000001)
1935	Grong Grong	1	2652	'grong':1,2	(-34.7381799999999998,146.781264999999991)
1936	Gumly Gumly	1	2652	'gum':1,2	(-35.1237679999999983,147.421168999999992)
1937	Humula	1	2652	'humula':1	(-35.4830540000000028,147.764179000000013)
1938	Ladysmith	1	2652	'ladysmith':1	(-35.2078010000000035,147.513983999999994)
1940	Marrar	1	2652	'marrar':1	(-34.8236980000000003,147.350199000000003)
1941	Matong	1	2652	'matong':1	(-34.7678360000000026,146.919332999999995)
1942	Merriwagga	1	2652	'merriwagga':1	(-33.8202909999999974,145.622345999999993)
1945	Tabbita	1	2652	'tabbita':1	(-34.1056460000000001,145.847824000000003)
1946	Tarcutta	1	2652	'tarcutta':1	(-35.2756100000000004,147.738747999999987)
1947	Uranquinty	1	2652	'uranquinti':1	(-35.1947759999999974,147.243051000000008)
1948	Mannus	1	2653	'mannus':1	(-35.7991910000000004,147.937205000000006)
1949	Tumbarumba	1	2653	'tumbarumba':1	(-35.7774590000000003,148.012860999999987)
1951	The Rock	1	2655	'rock':2	(-35.2683650000000029,147.114843000000008)
1952	Lockhart	1	2656	'lockhart':1	(-35.2210850000000022,146.716342999999995)
1953	Milbrulong	1	2656	'milbrulong':1	(-35.2604899999999972,146.841971000000001)
1955	Henty	1	2658	'henti':1	(-35.5171860000000024,147.035780999999986)
1956	Pleasant Hills	1	2658	'hill':2 'pleasant':1	(-35.4670169999999985,146.797165000000007)
1957	Ryan	1	2658	'ryan':1	(-35.5634960000000007,146.866120999999993)
1958	Walla Walla	1	2659	'walla':1,2	(-35.7667339999999996,146.901018999999991)
1959	Culcairn	1	2660	'culcairn':1	(-35.6677660000000003,147.037170000000003)
1962	Junee	1	2663	'june':1	(-34.8709980000000002,147.584678999999994)
1963	Ardlethan	1	2665	'ardlethan':1	(-34.3573549999999983,146.903401000000002)
1964	Ariah Park	1	2665	'ariah':1 'park':2	(-34.3481049999999968,147.221222000000012)
1965	Barellan	1	2665	'barellan':1	(-34.2843400000000003,146.571256000000005)
1967	Binya	1	2665	'binya':1	(-34.2282969999999978,146.337827000000004)
1968	Kamarah	1	2665	'kamarah':1	(-34.3681210000000021,146.760960000000011)
1969	Mirrool	1	2665	'mirrool':1	(-34.2879569999999987,147.095065000000005)
1971	Grogan	1	2666	'grogan':1	(-34.2480230000000034,147.782067000000012)
1972	Reefton	1	2666	'reefton':1	(-34.2471209999999999,147.436969000000005)
1973	Sebastopol	1	2666	'sebastopol':1	(-34.580295999999997,147.517662999999999)
1974	Springdale	1	2666	'springdal':1	(-34.4657130000000009,147.717295000000007)
1976	Trungley Hall	1	2666	'hall':2 'trungley':1	(-34.2885180000000034,147.555937)
1977	Barmedman	1	2668	'barmedman':1	(-34.1846760000000032,147.406754000000006)
1978	Bygalorie	1	2669	'bygalori':1	(-33.4983709999999988,146.803615000000008)
1980	Girral	1	2669	'girral':1	(-33.7040270000000035,147.071818000000007)
1981	Naradhan	1	2669	'naradhan':1	(-33.6134830000000022,146.32506699999999)
1982	Rankins Springs	1	2669	'rankin':1 'spring':2	(-33.8401270000000025,146.265436999999991)
1983	Tallimba	1	2669	'tallimba':1	(-33.9944020000000009,146.879692000000006)
1985	Ungarie	1	2669	'ungari':1	(-33.6393410000000017,146.974678000000011)
1986	Weethalle	1	2669	'weethall':1	(-33.8754020000000011,146.625968999999998)
1987	Burcher	1	2671	'burcher':1	(-33.5152379999999965,147.250058999999993)
1989	Wyalong	1	2671	'wyalong':1	(-33.9258820000000014,147.243019000000004)
1990	Burgooney	1	2672	'burgooney':1	(-33.3875030000000024,146.579788000000008)
1991	Lake Cargelligo	1	2672	'cargelligo':2 'lake':1	(-33.2989079999999973,146.370321999999987)
1992	Hillston	1	2675	'hillston':1	(-33.4813649999999967,145.534656000000012)
1993	Roto	1	2675	'roto':1	(-33.0584970000000027,145.343021999999991)
1997	Benerembah	1	2680	'benerembah':1	(-34.4416939999999983,145.815266000000008)
1998	Bilbul	1	2680	'bilbul':1	(-34.2734060000000014,146.138175999999987)
1999	Griffith	1	2680	'griffith':1	(-34.2890450000000016,146.043670999999989)
2000	Hanwood	1	2680	'hanwood':1	(-34.3292920000000024,146.041303999999997)
2086	Kingswood	1	2747	'kingswood':1	(-33.7599670000000032,150.720460000000003)
2080	Greendale	1	2745	'greendal':1	(-33.9047920000000005,150.646794999999997)
2001	Lake Wyangan	1	2680	'lake':1 'wyangan':2	(-34.2475069999999988,146.032567)
2002	Tharbogang	1	2680	'tharbogang':1	(-34.2552220000000034,145.988691999999986)
2003	Widgelli	1	2680	'widgelli':1	(-34.3324649999999991,146.143812999999994)
2004	Willbriggie	1	2680	'willbriggi':1	(-34.4679730000000006,146.016037000000011)
2006	Yenda	1	2681	'yenda':1	(-34.2490700000000032,146.195555000000013)
2007	Corobimilla	1	2700	'corobimilla':1	(-34.8680820000000011,146.413618000000014)
2008	Morundah	1	2700	'morundah':1	(-34.946674999999999,146.295123999999987)
2010	Coolamon	1	2701	'coolamon':1	(-34.8155390000000011,147.200085000000001)
2011	Ganmain	1	2702	'ganmain':1	(-34.7948990000000009,147.038823000000008)
2012	Yanco	1	2703	'yanco':1	(-34.6308429999999987,146.403449999999992)
2014	Leeton	1	2705	'leeton':1	(-34.5521999999999991,146.406443999999993)
2015	Murrami	1	2705	'murrami':1	(-34.4261160000000004,146.300749999999994)
2016	Wamoon	1	2705	'wamoon':1	(-34.5349300000000028,146.331551999999988)
2017	Whitton	1	2705	'whitton':1	(-34.5179919999999996,146.185555999999991)
2019	Argoon	1	2707	'argoon':1	(-34.8582790000000031,145.674146000000007)
2020	Coleambally	1	2707	'coleamb':1	(-34.8056190000000001,145.882690999999994)
2022	Caldwell	1	2710	'caldwel':1	(-35.6302540000000008,144.502141999999992)
2023	Conargo	1	2710	'conargo':1	(-35.3023710000000008,145.181217000000004)
2024	Deniliquin	1	2710	'deniliquin':1	(-35.5285439999999966,144.958974000000012)
2025	Gulpa	1	2710	'gulpa':1	(-35.7616119999999995,144.900513999999987)
2027	Mayrung	1	2710	'mayrung':1	(-35.4649789999999996,145.320414999999997)
2028	Moira	1	2710	'moira':1	(-35.9271340000000023,144.847986999999989)
2029	Wakool	1	2710	'wakool':1	(-35.4706159999999997,144.395692999999994)
2031	Booligal	1	2711	'boolig':1	(-33.6794420000000017,144.749504000000002)
2032	Carrathool	1	2711	'carrathool':1	(-34.4071819999999988,145.430787000000009)
2033	Gunbar	1	2711	'gunbar':1	(-34.0088969999999975,145.31152800000001)
2034	Hay	1	2711	'hay':1	(-34.5005080000000035,144.845099000000005)
2036	Oxley	1	2711	'oxley':1	(-31.1171870000000013,147.570990999999992)
2037	Berrigan	1	2712	'berrigan':1	(-35.657429999999998,145.812641000000013)
2038	Blighty	1	2713	'blighti':1	(-35.5916870000000003,145.285730999999998)
2040	Tocumwal	1	2714	'tocumw':1	(-35.8121069999999975,145.567388999999991)
2041	Balranald	1	2715	'balranald':1	(-34.6380490000000023,143.561101000000008)
2042	Hatfield	1	2715	'hatfield':1	(-33.8664800000000028,143.738495)
2044	Mabins Well	1	2716	'mabin':1 'well':2	(-34.8565320000000014,145.552861000000007)
2045	Dareton	1	2717	'dareton':1	(-34.0916410000000027,142.042283999999995)
2046	Gilmore	1	2720	'gilmor':1	(-35.3281879999999973,148.163782999999995)
2047	Talbingo	1	2720	'talbingo':1	(-35.5816239999999979,148.303311000000008)
2049	Quandialla	1	2721	'quandialla':1	(-34.0095230000000015,147.793336000000011)
2050	Brungle	1	2722	'brungl':1	(-35.1391410000000022,148.223575000000011)
2051	Gundagai	1	2722	'gundagai':1	(-35.0655339999999995,148.107529)
2053	Nangus	1	2722	'nangus':1	(-35.0553540000000012,147.907046000000008)
2054	Stockinbingal	1	2725	'stockinbing':1	(-34.506022999999999,147.879961000000009)
2055	Jugiong	1	2726	'jugiong':1	(-34.8232989999999987,148.324894999999998)
2057	Coolac	1	2727	'coolac':1	(-34.9026130000000023,148.193499000000003)
2058	Adelong	1	2729	'adelong':1	(-35.3079469999999986,148.063682)
2059	Cooleys Creek	1	2729	'cooley':1 'creek':2	(-35.3384959999999992,148.078179000000006)
2060	Grahamstown	1	2729	'grahamstown':1	(-35.2647380000000013,148.035550999999998)
2062	Tumblong	1	2729	'tumblong':1	(-35.1366549999999975,148.009739999999994)
2063	Wondalga	1	2729	'wondalga':1	(-35.3954760000000022,148.110309000000001)
2064	Batlow	1	2730	'batlow':1	(-35.5220190000000002,148.144622999999996)
2066	Bunnaloo	1	2731	'bunnaloo':1	(-35.7911870000000008,144.62984800000001)
2067	Moama	1	2731	'moama':1	(-36.1126239999999967,144.755549000000002)
2069	Barham	1	2732	'barham':1	(-35.6304730000000021,144.130423000000008)
2070	Moulamein	1	2733	'moulamein':1	(-35.0891349999999989,144.036635999999987)
2071	Kyalite	1	2734	'kyalit':1	(-34.9516050000000007,143.484273000000002)
2074	Goodnight	1	2736	'goodnight':1	(-34.9586820000000031,143.337439999999987)
2075	Euston	1	2737	'euston':1	(-34.574976999999997,142.745125999999999)
2076	Gol Gol	1	2738	'gol':1,2	(-34.1800870000000003,142.219530999999989)
2077	Monak	1	2738	'monak':1	(-34.3014719999999969,142.532796999999988)
2079	Glenmore Park	1	2745	'glenmor':1 'park':2	(-33.7906830000000014,150.669299999999993)
2081	Luddenham	1	2745	'luddenham':1	(-33.8837249999999983,150.693079000000012)
2082	Mulgoa	1	2745	'mulgoa':1	(-33.8381669999999986,150.683370999999994)
2083	Regentville	1	2745	'regentvill':1	(-33.7736489999999989,150.669102000000009)
2085	Cambridge Park	1	2747	'cambridg':1 'park':2	(-33.7515199999999993,150.725438999999994)
2087	Llandilo	1	2747	'llandilo':1	(-33.7089039999999969,150.75677300000001)
2088	Shanes Park	1	2747	'park':2 'shane':1	(-33.711305000000003,150.783287000000001)
2090	Werrington County	1	2747	'counti':2 'werrington':1	(-33.7479390000000024,150.751155000000011)
2091	Werrington Downs	1	2747	'down':2 'werrington':1	(-33.7405860000000004,150.733755000000002)
2092	Orchard Hills	1	2748	'hill':2 'orchard':1	(-33.7793309999999991,150.716311999999988)
2093	Castlereagh	1	2749	'castlereagh':1	(-33.6687960000000004,150.676549999999992)
2095	Emu Plains	1	2750	'emu':1 'plain':2	(-33.7540970000000016,150.653268999999995)
2096	Leonay	1	2750	'leonay':1	(-33.7591559999999973,150.652318000000008)
2097	Penrith	1	2750	'penrith':1	(-33.7321269999999984,151.280351999999993)
2099	Silverdale	1	2752	'silverdal':1	(-33.9422119999999978,150.580102000000011)
2100	Warragamba	1	2752	'warragamba':1	(-33.8897270000000006,150.604818999999992)
2101	Bowen Mountain	1	2753	'bowen':1 'mountain':2	(-33.5738709999999969,150.627818999999988)
2102	Grose Vale	1	2753	'grose':1 'vale':2	(-33.5840889999999987,150.672944000000001)
2104	Hobartville	1	2753	'hobartvill':1	(-33.6015569999999997,150.735672999999991)
2105	Londonderry	1	2753	'londonderri':1	(-33.6451879999999974,150.736979999999988)
2106	Richmond	1	2753	'richmond':1	(-33.5977529999999973,150.752890000000008)
2072	Koraleigh	1	2735	'koraleigh':1	(-35.1280000000000001,143.436000000000007)
2131	St Clair	1	2759	'clair':2 'st':1	(-33.7943619999999996,150.790260999999987)
2187	Yellow Rock	1	2777	'rock':2 'yellow':1	(-33.6950649999999996,150.624083000000013)
2148	Nelson	1	2765	'nelson':1	(-33.6527949999999976,150.915684999999996)
2107	Yarramundi	1	2753	'yarramundi':1	(-33.6272590000000022,150.672695000000004)
2109	Tennyson	1	2754	'tennyson':1	(-33.5363880000000023,150.736945999999989)
2110	Richmond Raaf	1	2755	'raaf':2 'richmond':1	(-33.604377999999997,150.796233999999998)
2111	Bligh Park	1	2756	'bligh':1 'park':2	(-33.6376500000000007,150.794579999999996)
2112	Cattai	1	2756	'cattai':1	(-33.5558410000000009,150.909514999999999)
2113	Clarendon	1	2756	'clarendon':1	(-33.6147360000000006,150.781980000000004)
2114	Colo	1	2756	'colo':1	(-33.7881879999999981,149.259388000000001)
2116	Ebenezer	1	2756	'ebenez':1	(-33.5246599999999972,150.881371999999999)
2117	Freemans Reach	1	2756	'freeman':1 'reach':2	(-33.5454289999999986,150.794878000000011)
2118	Glossodia	1	2756	'glossodia':1	(-33.5356570000000005,150.765856000000014)
2120	Maroota	1	2756	'maroota':1	(-33.4730240000000023,150.970971999999989)
2121	Mcgraths Hill	1	2756	'hill':2 'mcgrath':1	(-33.6134350000000026,150.840222000000011)
2122	Mulgrave	1	2756	'mulgrav':1	(-33.6260529999999989,150.829912000000007)
2123	Pitt Town	1	2756	'pitt':1 'town':2	(-33.5861840000000029,150.860081000000008)
2125	Wilberforce	1	2756	'wilberforc':1	(-33.5581790000000026,150.84750600000001)
2126	Windsor	1	2756	'windsor':1	(-33.6088140000000024,150.817480999999987)
2469	Carnes Hill	1	1	\N	\N
2127	Kurmond	1	2757	'kurmond':1	(-33.5494520000000023,150.701116000000013)
2128	Bilpin	1	2758	'bilpin':1	(-33.4982529999999983,150.522195000000011)
2130	Kurrajong	1	2758	'kurrajong':1	(-33.5467489999999984,150.660685999999998)
2132	Erskine Park	1	2759	'erskin':1 'park':2	(-33.8076179999999979,150.789312999999993)
2133	Colyton	1	2760	'colyton':1	(-33.7766570000000002,150.793432999999993)
2134	Oxley Park	1	2760	'oxley':1 'park':2	(-33.7712610000000026,150.792640000000006)
2137	Glendenning	1	2761	'glenden':1	(-33.7390749999999997,150.855174000000005)
2138	Hassall Grove	1	2761	'grove':2 'hassal':1	(-33.7338129999999978,150.834276999999986)
2139	Oakhurst	1	2761	'oakhurst':1	(-33.7440479999999994,150.83481900000001)
2140	Plumpton	1	2761	'plumpton':1	(-33.7514320000000012,150.841204000000005)
2142	Acacia Gardens	1	2763	'acacia':1 'garden':2	(-33.7300770000000014,150.906501999999989)
2143	Quakers Hill	1	2763	'hill':2 'quaker':1	(-33.728355999999998,150.881177000000008)
2144	Berkshire Park	1	2765	'berkshir':1 'park':2	(-33.6722370000000026,150.795760000000001)
2145	Box Hill	1	2765	'box':1 'hill':2	(-33.6391149999999968,150.904696999999999)
2147	Marsden Park	1	2765	'marsden':1 'park':2	(-33.6975849999999966,150.832317999999987)
2149	Oakville	1	2765	'oakvill':1	(-33.6225620000000021,150.862154000000004)
2150	Riverstone	1	2765	'riverston':1	(-33.6793819999999968,150.861594999999994)
2153	Rooty Hill	1	2766	'hill':2 'rooti':1	(-33.7715499999999977,150.843921999999992)
2154	Doonside	1	2767	'doonsid':1	(-33.7650709999999989,150.869290000000007)
2155	Woodcroft	1	2767	'woodcroft':1	(-33.7549860000000024,150.879665999999986)
2156	Glenwood	1	2768	'glenwood':1	(-33.7378629999999973,150.922731999999996)
2157	Parklea	1	2768	'parklea':1	(-33.7281229999999965,150.923807000000011)
2159	The Ponds	1	2769	'pond':2	(-34.0543260000000032,150.753104000000008)
2160	Bidwill	1	2770	'bidwil':1	(-33.730240000000002,150.822765000000004)
2161	Blackett	1	2770	'blackett':1	(-33.7385069999999985,150.811205999999999)
2162	Dharruk	1	2770	'dharruk':1	(-33.743231999999999,150.816642000000002)
2163	Emerton	1	2770	'emerton':1	(-33.7428549999999987,150.808263000000011)
2165	Lethbridge Park	1	2770	'lethbridg':1 'park':2	(-33.7369380000000021,150.799824000000001)
2166	Minchinbury	1	2770	'minchinburi':1	(-33.7816729999999978,150.813667000000009)
2167	Mount Druitt	1	2770	'druitt':2 'mount':1	(-33.7664339999999967,150.816989000000007)
2169	Tregear	1	2770	'tregear':1	(-33.7510819999999967,150.795678000000009)
2170	Whalan	1	2770	'whalan':1	(-33.7601650000000006,150.809528)
2171	Willmot	1	2770	'willmot':1	(-33.7276209999999992,150.79156900000001)
2172	Glenbrook	1	2773	'glenbrook':1	(-33.7680239999999969,150.621692999999993)
2176	Blaxland	1	2774	'blaxland':1	(-33.7442629999999966,150.610075999999992)
2174	Mount Riverview	1	2774	'mount':1 'riverview':2	(-33.7342730000000017,150.631177000000008)
2175	Warrimoo	1	2774	'warrimoo':1	(-33.7229579999999984,150.604162000000002)
2178	Laughtondale	1	2775	'laughtondal':1	(-33.4102290000000011,151.024592000000013)
2179	Spencer	1	2775	'spencer':1	(-33.4594549999999984,151.14238499999999)
2180	St Albans	1	2775	'alban':2 'st':1	(-33.290934,150.970262999999989)
2181	Wisemans Ferry	1	2775	'ferri':2 'wiseman':1	(-33.4088789999999989,150.980048000000011)
2182	Faulconbridge	1	2776	'faulconbridg':1	(-33.6965050000000019,150.534998000000002)
2184	Springwood	1	2777	'springwood':1	(-33.7006450000000015,150.558750000000003)
2185	Valley Heights	1	2777	'height':2 'valley':1	(-33.705288000000003,150.584919000000014)
2186	Winmalee	1	2777	'winmale':1	(-33.6732760000000013,150.619110000000006)
2188	Linden	1	2778	'linden':1	(-33.7155289999999965,150.504477000000009)
2190	Hazelbrook	1	2779	'hazelbrook':1	(-33.7209920000000025,150.451628999999997)
2192	Leura	1	2780	'leura':1	(-33.714148999999999,150.330826999999999)
2193	Medlow Bath	1	2780	'bath':2 'medlow':1	(-33.6725259999999977,150.280742000000004)
2194	Wentworth Falls	1	2782	'fall':2 'wentworth':1	(-33.7098360000000028,150.376453999999995)
2195	Lawson	1	2783	'lawson':1	(-33.7189570000000032,150.430093999999997)
2197	Blackheath	1	2785	'blackheath':1	(-33.6355560000000011,150.284829999999999)
2198	Megalong	1	2785	'megalong':1	(-33.7041210000000007,150.246224000000012)
2199	Bell	1	2786	'bell':1	(-33.5137450000000001,150.279391000000004)
2200	Dargan	1	2786	'dargan':1	(-33.4892559999999975,150.263513999999986)
2202	Mount Victoria	1	2786	'mount':1 'victoria':2	(-33.5885609999999986,150.251160999999996)
2203	Mount Wilson	1	2786	'mount':1 'wilson':2	(-33.5031260000000017,150.388368000000014)
2204	Black Springs	1	2787	'black':1 'spring':2	(-33.8409660000000017,149.711027000000001)
2205	Duckmaloi	1	2787	'duckmaloi':1	(-33.6798980000000014,149.964206999999988)
2207	Gingkin	1	2787	'gingkin':1	(-33.8887879999999981,149.927470999999997)
2151	Vineyard	1	2765	'vineyard':1	(-33.6469999999999985,150.841000000000008)
2273	Barry	1	2799	'barri':1	(-33.6482930000000025,149.269544999999994)
2229	Woodstock	1	2793	'woodstock':1	(-33.7451799999999977,148.847958000000006)
2285	Spring Hill	1	2800	'hill':2 'spring':1	(-33.3987059999999971,149.152350000000013)
2208	Hazelgrove	1	2787	'hazelgrov':1	(-33.6500139999999988,149.893712999999991)
2209	Oberon	1	2787	'oberon':1	(-33.7038560000000018,149.85548399999999)
2211	Shooters Hill	1	2787	'hill':2 'shooter':1	(-33.8957880000000031,149.861765999999989)
2212	Tarana	1	2787	'tarana':1	(-33.5265720000000016,149.908188999999993)
2213	Bowenfels	1	2790	'bowenfel':1	(-33.4715959999999981,150.124111999999997)
2214	Clarence	1	2790	'clarenc':1	(-33.4793110000000027,150.215559000000013)
2216	Cullen Bullen	1	2790	'bullen':2 'cullen':1	(-33.3034019999999984,150.03251800000001)
2218	Hartley	1	2790	'hartley':1	(-33.5484760000000009,150.15458799999999)
2219	Lidsdale	1	2790	'lidsdal':1	(-33.3785349999999994,150.083775000000003)
2220	Lithgow	1	2790	'lithgow':1	(-33.4800680000000028,150.157986999999991)
2222	Lowther	1	2790	'lowther':1	(-33.6248530000000017,150.100331000000011)
2223	Marrangaroo	1	2790	'marrangaroo':1	(-33.4286779999999979,150.106224999999995)
2224	Rydal	1	2790	'rydal':1	(-33.4925300000000021,150.036914999999993)
2225	Sodwalls	1	2790	'sodwal':1	(-33.5164290000000022,150.007265999999987)
2226	Carcoar	1	2791	'carcoar':1	(-33.6096220000000017,149.140601000000004)
2228	Darbys Falls	1	2793	'darbi':1 'fall':2	(-33.9310959999999966,148.859104000000002)
2230	Bumbaldry	1	2794	'bumbaldri':1	(-33.9063390000000027,148.456385000000012)
2231	Cowra	1	2794	'cowra':1	(-33.8346799999999988,148.691192000000001)
2233	Wattamondara	1	2794	'wattamondara':1	(-33.9384680000000003,148.606067999999993)
2234	Bald Ridge	1	2795	'bald':1 'ridg':2	(-33.9346719999999991,149.428473999999994)
2235	Ballyroe	1	2795	'ballyro':1	(-34.0844049999999967,149.60429400000001)
2236	Brewongle	1	2795	'brewongl':1	(-33.4887799999999984,149.675409999999999)
2238	Dark Corner	1	2795	'corner':2 'dark':1	(-33.3067550000000026,149.877371000000011)
2239	Dunkeld	1	2795	'dunkeld':1	(-33.4065769999999986,149.485667000000007)
2240	Duramana	1	2795	'duramana':1	(-33.2675580000000011,149.532753000000014)
2242	Freemantle	1	2795	'freemantl':1	(-33.243662999999998,149.378570999999994)
2243	Gemalla	1	2795	'gemalla':1	(-33.5241290000000021,149.837333000000001)
2244	Georges Plains	1	2795	'georg':1 'plain':2	(-33.515628999999997,149.523181999999991)
2246	Isabella	1	2795	'isabella':1	(-33.9544179999999969,149.666899000000001)
2247	Judds Creek	1	2795	'creek':2 'judd':1	(-33.8337119999999985,149.55098799999999)
2248	Kelso	1	2795	'kelso':1	(-33.4191959999999995,149.61155500000001)
2249	Locksley	1	2795	'locksley':1	(-33.5158279999999991,149.776599000000004)
2250	Meadow Flat	1	2795	'flat':2 'meadow':1	(-33.4349190000000007,149.921281999999991)
2252	Newbridge	1	2795	'newbridg':1	(-33.5857310000000027,149.364825999999994)
2253	Peel	1	2795	'peel':1	(-33.2900059999999982,149.615645000000001)
2254	Perthville	1	2795	'perthvill':1	(-33.4859000000000009,149.546979999999991)
2255	Raglan	1	2795	'raglan':1	(-33.4222749999999991,149.649389000000014)
2256	Rockley	1	2795	'rockley':1	(-33.6925450000000026,149.569433000000004)
2258	Sunny Corner	1	2795	'corner':2 'sunni':1	(-33.3819250000000025,149.885190999999992)
2260	Trunkey Creek	1	2795	'creek':2 'trunkey':1	(-33.8247380000000035,149.36300700000001)
2261	Turondale	1	2795	'turondal':1	(-33.121541999999998,149.601111000000003)
2263	Wattle Flat	1	2795	'flat':2 'wattl':1	(-33.1405069999999995,149.693813000000006)
2264	West Bathurst	1	2795	'bathurst':2 'west':1	(-33.4126949999999994,149.564796999999999)
2265	Wimbledon	1	2795	'wimbledon':1	(-33.5468550000000008,149.428684000000004)
2267	Yetholme	1	2795	'yetholm':1	(-33.449582999999997,149.816692999999987)
2268	Garland	1	2797	'garland':1	(-33.7078729999999993,149.02580900000001)
2270	Forest Reefs	1	2798	'forest':1 'reef':2	(-33.453985000000003,149.10924)
2271	Millthorpe	1	2798	'millthorp':1	(-33.4458619999999982,149.185396999999995)
2272	Tallwood	1	2798	'tallwood':1	(-33.500866000000002,149.123535000000004)
2275	Browns Creek	1	2799	'brown':1 'creek':2	(-33.5256830000000008,149.149876000000006)
2276	Neville	1	2799	'nevill':1	(-33.7093980000000002,149.21507299999999)
2277	Vittoria	1	2799	'vittoria':1	(-33.4358939999999976,149.372966999999989)
2278	Borenore	1	2800	'borenor':1	(-33.2472920000000016,148.974504999999994)
2280	Lucknow	1	2800	'lucknow':1	(-33.3456619999999972,149.161068)
2281	March	1	2800	'march':1	(-33.2163510000000031,149.076540999999992)
2283	Nashdale	1	2800	'nashdal':1	(-33.2966959999999972,149.018299000000013)
2284	Orange	1	2800	'orang':1	(-33.2769479999999973,149.099774999999994)
2286	Bendick Murrell	1	2803	'bendick':1 'murrel':2	(-34.1628200000000035,148.449846000000008)
2287	Crowther	1	2803	'crowther':1	(-34.0966390000000033,148.507117999999991)
2288	Wirrimah	1	2803	'wirrimah':1	(-34.1290559999999985,148.424252999999993)
2290	Gooloogong	1	2805	'gooloogong':1	(-33.6508480000000034,148.413849999999996)
2291	Eugowra	1	2806	'eugowra':1	(-33.4271069999999995,148.371649999999988)
2292	Koorawatha	1	2807	'koorawatha':1	(-34.0398909999999972,148.553887000000003)
2294	Bimbi	1	2810	'bimbi':1	(-33.9852520000000027,147.927491000000003)
2295	Caragabal	1	2810	'caragab':1	(-33.8438289999999995,147.739256000000012)
2296	Grenfell	1	2810	'grenfel':1	(-33.8949849999999984,148.16115400000001)
2297	Pullabooka	1	2810	'pullabooka':1	(-33.7554239999999979,147.82531800000001)
2298	Arthurville	1	2820	'arthurvill':1	(-32.5548429999999982,148.742708999999991)
2300	Bodangora	1	2820	'bodangora':1	(-32.4502529999999965,149.032286999999997)
2301	Dripstone	1	2820	'dripston':1	(-32.6503289999999993,148.989515000000011)
2302	Farnham	1	2820	'farnham':1	(-32.8393599999999992,149.086436999999989)
2303	Maryvale	1	2820	'maryval':1	(-32.4641790000000015,148.899155000000007)
2304	Mumbil	1	2820	'mumbil':1	(-32.7255389999999977,149.049690999999996)
2306	Spicers Creek	1	2820	'creek':2 'spicer':1	(-32.3958420000000018,149.143044000000003)
2307	Stuart Town	1	2820	'stuart':1 'town':2	(-32.8056880000000035,149.077262999999988)
2308	Walmer	1	2820	'walmer':1	(-32.6629739999999984,148.719692000000009)
2310	Narromine	1	2821	'narromin':1	(-32.2319200000000023,148.239606000000009)
2311	Trangie	1	2823	'trangi':1	(-32.0318869999999976,147.983936999999997)
2217	Hampton	1	2790	'hampton':1	(-33.4840000000000018,150.260999999999996)
2316	Mullengudgery	1	2825	'mullengudgeri':1	(-31.7475489999999994,147.42891800000001)
2317	Nyngan	1	2825	'nyngan':1	(-31.5624870000000008,147.19235599999999)
2318	Collie	1	2827	'colli':1	(-31.6677269999999993,148.303490000000011)
2319	Curban	1	2827	'curban':1	(-31.5121360000000017,148.612070999999986)
2321	Gulargambone	1	2828	'gulargambon':1	(-31.3296920000000014,148.47118900000001)
2322	Warrumbungle	1	2828	'warrumbungl':1	(-31.2775539999999985,148.982041000000009)
2323	Combara	1	2829	'combara':1	(-31.1246930000000006,148.373410000000007)
2325	Ballimore	1	2830	'ballimor':1	(-32.1957260000000005,148.902064999999993)
2326	Brocklehurst	1	2830	'brocklehurst':1	(-32.1507349999999974,148.688876999999991)
2327	Dubbo	1	2830	'dubbo':1	(-32.245192000000003,148.60421199999999)
2328	Mogriguy	1	2830	'mogriguy':1	(-32.0663899999999984,148.660575999999992)
2330	Balladoran	1	2831	'balladoran':1	(-31.8521360000000016,148.626474999999999)
2331	Byrock	1	2831	'byrock':1	(-30.6618600000000008,146.403969999999987)
2332	Carinda	1	2831	'carinda':1	(-30.4611979999999996,147.691172999999992)
2334	Elong Elong	1	2831	'elong':1,2	(-32.1160119999999978,149.026202000000012)
2335	Eumungerie	1	2831	'eumungeri':1	(-31.9511119999999984,148.626362999999998)
2336	Geurie	1	2831	'geuri':1	(-32.3990319999999983,148.828531999999996)
2337	Girilambone	1	2831	'girilambon':1	(-31.2484450000000002,146.904868999999991)
2339	Hermidale	1	2831	'hermidal':1	(-31.6388479999999994,146.689583999999996)
2340	Merrygoen	1	2831	'merrygoen':1	(-31.824228999999999,149.230644000000012)
2341	Neilrex	1	2831	'neilrex':1	(-31.7206319999999984,149.307062000000002)
2342	Nevertire	1	2831	'nevertir':1	(-31.8388540000000013,147.718723000000011)
2344	Quambone	1	2831	'quambon':1	(-30.9293820000000004,147.869963000000013)
2345	Tooraweenah	1	2831	'tooraweenah':1	(-31.4394039999999997,148.910427999999996)
2346	Wongarbon	1	2831	'wongarbon':1	(-32.334144000000002,148.756921000000006)
2348	Cryon	1	2832	'cryon':1	(-30.1277240000000006,148.611680000000007)
2349	Cumborah	1	2832	'cumborah':1	(-29.7425250000000005,147.767955999999998)
2350	Walgett	1	2832	'walgett':1	(-30.0215579999999989,148.116683999999992)
2351	Collarenebri	1	2833	'collarenebri':1	(-29.5458099999999995,148.576548000000003)
2353	Cobar	1	2835	'cobar':1	(-31.4982180000000014,145.840726999999987)
2354	White Cliffs	1	2836	'cliff':2 'white':1	(-30.8504439999999995,143.083843999999999)
2355	Wilcannia	1	2836	'wilcannia':1	(-31.5585589999999989,143.37797599999999)
2356	Brewarrina	1	2839	'brewarrina':1	(-29.9615189999999991,146.858999000000011)
2358	Barringun	1	2840	'barringun':1	(-29.1892500000000013,145.881589999999989)
2359	Bourke	1	2840	'bourk':1	(-30.0888470000000012,145.937741999999986)
2360	Enngonia	1	2840	'enngonia':1	(-29.3181229999999999,145.846170000000001)
2361	Fords Bridge	1	2840	'bridg':2 'ford':1	(-29.7525230000000001,145.424979000000008)
2362	Louth	1	2840	'louth':1	(-30.5338360000000009,145.115334999999988)
2364	Urisino	1	2840	'urisino':1	(-29.7080400000000004,143.730397000000011)
2365	Wanaaring	1	2840	'wanaar':1	(-29.7062740000000005,144.147343000000006)
2366	Yantabulla	1	2840	'yantabulla':1	(-29.338394000000001,145.002750999999989)
2368	Coolah	1	2843	'coolah':1	(-31.7744180000000007,149.611621000000014)
2369	Birriwa	1	2844	'birriwa':1	(-32.1222319999999968,149.465064000000012)
2370	Dunedoo	1	2844	'dunedoo':1	(-32.0161840000000026,149.395837999999998)
2372	Wallerawang	1	2845	'wallerawang':1	(-33.4106179999999995,150.062597000000011)
2373	Capertee	1	2846	'caperte':1	(-33.148969000000001,149.990010000000012)
2374	Glen Davis	1	2846	'davi':2 'glen':1	(-33.134332999999998,150.147648000000004)
2375	Portland	1	2847	'portland':1	(-33.3531240000000011,149.98227)
2377	Clandulla	1	2848	'clandulla':1	(-32.9065209999999979,149.950771000000003)
2378	Kandos	1	2848	'kando':1	(-32.8574950000000001,149.969459999999998)
2379	Bylong	1	2849	'bylong':1	(-32.417309000000003,150.114058)
2380	Rylstone	1	2849	'rylston':1	(-32.7993689999999987,149.970441999999991)
2382	Havilah	1	2850	'havilah':1	(-32.6206760000000031,149.764364999999998)
2383	Hill End	1	2850	'end':2 'hill':1	(-33.0312470000000005,149.417013999999995)
2384	Ilford	1	2850	'ilford':1	(-32.9422089999999983,149.859657999999996)
2385	Lue	1	2850	'lue':1	(-32.6541399999999982,149.842171000000008)
2387	Running Stream	1	2850	'run':1 'stream':2	(-33.0201100000000025,149.911201000000005)
2388	Turill	1	2850	'turil':1	(-32.1569450000000003,149.879274000000009)
2390	Ulan	1	2850	'ulan':1	(-32.2828730000000022,149.73643899999999)
2391	Wilbetree	1	2850	'wilbetre':1	(-32.4795829999999981,149.56804600000001)
2392	Windeyer	1	2850	'windey':1	(-32.7763199999999983,149.545299999999997)
2393	Wollar	1	2850	'wollar':1	(-32.3613380000000035,149.948759999999993)
2395	Goolma	1	2852	'goolma':1	(-32.3461440000000024,149.256868999999995)
2396	Gulgong	1	2852	'gulgong':1	(-32.3625869999999978,149.53352799999999)
2397	Cudal	1	2864	'cudal':1	(-33.2867040000000003,148.738898000000006)
2398	Murga	1	2864	'murga':1	(-33.3699879999999993,148.545277999999996)
2400	Manildra	1	2865	'manildra':1	(-33.1865779999999972,148.696347000000003)
2401	Euchareena	1	2866	'euchareena':1	(-32.9390059999999991,149.067204000000004)
2402	Garra	1	2866	'garra':1	(-33.114373999999998,148.756259999999997)
2404	Molong	1	2866	'molong':1	(-33.0919700000000034,148.868772000000007)
2405	Baldry	1	2867	'baldri':1	(-32.8654480000000007,148.500123000000002)
2406	Cumnock	1	2867	'cumnock':1	(-32.927818000000002,148.754509000000013)
2407	Yeoval	1	2868	'yeoval':1	(-32.7518290000000007,148.649032000000005)
2409	Tomingley	1	2869	'tomingley':1	(-32.5568540000000013,148.217991000000012)
2410	Trewilga	1	2869	'trewilga':1	(-32.7913629999999969,148.219646000000012)
2411	Alectown	1	2870	'alectown':1	(-32.9330750000000023,148.257653000000005)
2412	Cookamidgera	1	2870	'cookamidgera':1	(-33.2248999999999981,148.324968000000013)
2413	Daroobalgie	1	2870	'daroobalgi':1	(-33.3211110000000019,148.063141999999999)
2415	Mandagery	1	2870	'mandageri':1	(-33.2242770000000007,148.401610000000005)
2416	Parkes	1	2870	'park':1	(-33.1383259999999993,148.174166000000014)
2417	Tichborne	1	2870	'tichborn':1	(-33.2318509999999989,148.117190999999991)
2419	Forbes	1	2871	'forb':1	(-33.3853429999999989,148.007904999999994)
2420	Garema	1	2871	'garema':1	(-33.5669049999999984,147.991043999999988)
2421	Wirrinya	1	2871	'wirrinya':1	(-33.6840929999999972,147.747489999999999)
2445	Mildura	1	3500	'mildura':1	\N
2444	Waterloo	1	2899	'waterloo':1	(-33.9003999999999976,151.206143999999995)
2423	Tottenham	1	2873	'tottenham':1	(-32.2440420000000003,147.356028000000009)
2424	Tullamore	1	2874	'tullamor':1	(-32.6314629999999966,147.564026000000013)
2425	Fifield	1	2875	'fifield':1	(-32.8079770000000011,147.458805000000012)
2426	Ootha	1	2875	'ootha':1	(-33.1293459999999982,147.434597999999994)
2427	Trundle	1	2875	'trundl':1	(-32.9228870000000029,147.709903999999995)
2428	Bogan Gate	1	2876	'bogan':1 'gate':2	(-33.106228999999999,147.802354000000008)
2429	Gunningbland	1	2876	'gunningbland':1	(-33.1380470000000003,147.922418999999991)
2430	Nelungaloo	1	2876	'nelungaloo':1	(-33.1440160000000006,147.998224999999991)
2431	Condobolin	1	2877	'condobolin':1	(-33.0890950000000004,147.152179999999987)
2432	Derriwong	1	2877	'derriwong':1	(-33.1196709999999968,147.364777000000004)
2433	Euabalong	1	2877	'euabalong':1	(-33.1125150000000019,146.472714999999994)
2434	Mount Hope	1	2877	'hope':2 'mount':1	(-32.8245270000000033,145.883029999999991)
2435	Conoble	1	2878	'conobl':1	(-32.7247449999999986,144.551874999999995)
2436	Ivanhoe	1	2878	'ivanho':1	(-32.8997770000000003,144.300441000000006)
2437	Mossgiel	1	2878	'mossgiel':1	(-33.2517989999999983,144.566949999999991)
2438	Trida	1	2878	'trida':1	(-33.0208730000000017,145.015118999999999)
2439	Menindee	1	2879	'meninde':1	(-32.3920529999999971,142.417612999999989)
2440	Silverton	1	2880	'silverton':1	(-31.8859229999999982,141.232907000000012)
2441	Tibooburra	1	2880	'tibooburra':1	(-29.4342590000000008,142.01007899999999)
2442	Lord Howe Island	1	2890	'howe':2 'island':3 'lord':1	(-31.5524699999999996,159.081217000000009)
2443	Lord Howe Island	1	2898	'howe':2 'island':3 'lord':1	(-31.5524699999999996,159.081217000000009)
2446	Barooga	1	3644	'barooga':1	(-35.913566000000003,145.688502999999997)
2447	Corryong	1	3707	'corryong':1	(-36.3950000000000031,147.99799999999999)
2449	CBD	1	1	\N	\N
2450	Darling Harbour	1	1	\N	\N
2451	Bondi Beach	1	1	\N	\N
2452	Sydney Olympic Park	1	1	\N	\N
2453	Gledswood Hills	1	1	\N	\N
2454	Sydney Airport	1	1	\N	\N
2455	Pittwater	1	1	\N	\N
2456	Barangaroo	1	1	\N	\N
2457	Botany Bay	1	1	\N	\N
2458	Circular Quay	1	1	\N	\N
2459	Surry Hulls	1	1	\N	\N
2460	191 Clarence Street	1	1	\N	\N
2461	Brighton-Le-Sands	1	1	\N	\N
2462	Freshwater	1	1	\N	\N
2463	Wentworth Point	1	1	\N	\N
2464	McMahons Point	1	1	\N	\N
2466	St. Peters	1	1	\N	\N
2471	Oran Park	1	1	\N	\N
2472	The Hills	1	1	\N	\N
2474	Wolloomoollo	1	1	\N	\N
2473	Glenorie,Dural	1	1	\N	\N
2475	CBD CBD	1	1	\N	\N
2476	Pyrmont Pyrmont	1	1	\N	\N
2477	2-8 Pine Avenue	1	1	\N	\N
2478	20 Bank Street	1	1	\N	\N
2479	Wolli Creek Wolli Creek NSW	1	1	\N	\N
2480	Eastwood Eastwood	1	1	\N	\N
2481	Surry Hills Surry Hills	1	1	\N	\N
2482	Hurstville Hurstville	1	1	\N	\N
2483	Corner Of Bunn Street & Pyrmont Pyrmont	1	1	\N	\N
2484	Dee Why NSW 2099	1	1	\N	\N
2485	Randwick Randwick	1	1	\N	\N
2486	Beverly Hills NSW Beverly Hills NSW	1	1	\N	\N
2487	1 Burroway Road	1	1	\N	\N
2488	North Sydney North Sydney	1	1	\N	\N
2489	Steam Mill Lane	1	1	\N	\N
2490	250 Old Northern Road	1	1	\N	\N
2491	Waterloo Waterloo	1	1	\N	\N
2492	Mascot Mascot	1	1	\N	\N
2493	Haymarket Haymarket NSW	1	1	\N	\N
2494	1 Market Street	1	1	\N	\N
2495	141 York Street	1	1	\N	\N
2496	50 Holt Street	1	1	\N	\N
2497	Waterloo NSW 2017 Waterloo	1	1	\N	\N
2498	Lower Ground Floor 28 Broadway	1	1	\N	\N
2499	Cabramatta NSW 2166 Cabramatta	1	1	\N	\N
2500	280 Elizabeth Street	1	1	\N	\N
2501	The Avenue	1	1	\N	\N
2502	Ultimo Ultimo NSW	1	1	\N	\N
2503	Haymarket NSW 2000 Haymarket NSW	1	1	\N	\N
2504	Ultimo Ultimo	1	1	\N	\N
2505	NSW 2220 Hurstville	1	1	\N	\N
2506	Sydney NSW 2000	1	1	\N	\N
2507	560 West Pennant Hills Road	1	1	\N	\N
2508	2	1	1	\N	\N
2509	1-5 Bourke Street	1	1	\N	\N
2510	202 Clarence Street	1	1	\N	\N
2511	135 Harris Street	1	1	\N	\N
2512	Bankstown NSW 2200	1	1	\N	\N
2513	83 Mount Street. North Sydney North Sydney	1	1	\N	\N
2514	Macquarie Centre	1	1	\N	\N
2515	1-5 Railway Street Chatswood Chatswood	1	1	\N	\N
2516	Pirrama Park Cafe Ultimo Ultimo NSW	1	1	\N	\N
2517	Darling Park 201 Sussex Street	1	1	\N	\N
2518	Mandarin Centre	1	1	\N	\N
2519	Castle Hill Castle Hill	1	1	\N	\N
2520	Waterloo NSW Waterloo	1	1	\N	\N
2521	239 Canley Vale Road	1	1	\N	\N
2522	University of New South Wales	1	1	\N	\N
2523	238 Forest Road	1	1	\N	\N
2524	Summer Hill Summer Hill	1	1	\N	\N
2525	North Strathfield North Strathfield NSW	1	1	\N	\N
2526	Rosebery Rosebery	1	1	\N	\N
2527	19-33 Kent Road	1	1	\N	\N
2528	19-21 Terminus Street	1	1	\N	\N
2529	Sydney Burwood	1	1	\N	\N
2530	Chifley NSW 2036 Chifley	1	1	\N	\N
2531	207-215 Edensor Road	1	1	\N	\N
2532	209 Harris Street	1	1	\N	\N
2533	23 Terminus Street	1	1	\N	\N
2534	4-16 Terminus Street	1	1	\N	\N
2535	Sydney Newtown	1	1	\N	\N
2536	19-29 Marco Ave	1	1	\N	\N
2537	Penrith. Sydney Penrith	1	1	\N	\N
2538	Homebush Homebush	1	1	\N	\N
2539	Quaker's Hill	1	1	\N	\N
2540	93 Mulga Road	1	1	\N	\N
2541	Gregory Hills Dr	1	1	\N	\N
2542	Mortdale Mortdale	1	1	\N	\N
2543	4 -16 Terminus Street	1	1	\N	\N
2544	Carlingford Court	1	1	\N	\N
2545	Mount Pritchard Mount Pritchard	1	1	\N	\N
2546	Mc Mahons Point	1	1	\N	\N
2547	Homebush West West Homebush West NSW	1	1	\N	\N
2548	Kingsford Kingsford	1	1	\N	\N
2549	Maroubra NSW 2035	1	1	\N	\N
2550	Rooty Hill NSW 2766 Rooty Hill	1	1	\N	\N
2551	Illawong Shopping Village	1	1	\N	\N
2552	105-152 Miller Street	1	1	\N	\N
2553	Rozelle NSW 2039 Rozelle	1	1	\N	\N
2554	Bondi Beach Bondi Beach	1	1	\N	\N
2555	Burwood NSW 2134	1	1	\N	\N
2556	185-211 Broadway	1	1	\N	\N
2557	Bella Vista NSW 2153	1	1	\N	\N
2558	Rooty Hill Rooty Hill NSW	1	1	\N	\N
2559	Frenchmans Road	1	1	\N	\N
2560	New South Wales Bankstown	1	1	\N	\N
2561	Mulgoa NSW	1	1	\N	\N
2562	63-69 Dixon Street	1	1	\N	\N
2563	271 Military Road	1	1	\N	\N
2564	100 Miller Street	1	1	\N	\N
2565	Good Luck Plaza	1	1	\N	\N
2566	Eastwood NSW Eastwood	1	1	\N	\N
2567	330 Forest Road	1	1	\N	\N
2568	Eastlakes Shopping Centre	1	1	\N	\N
2569	Kingsford NSW 2032 Kingsford	1	1	\N	\N
2570	60A Mountain Street	1	1	\N	\N
2571	Bossley Park Bossley Park	1	1	\N	\N
2572	Sydney Minto	1	1	\N	\N
2573	Bondi Junction Junction Bondi Junction	1	1	\N	\N
2574	Canley Heights NSW 2166	1	1	\N	\N
2575	94 Beamish Street	1	1	\N	\N
2576	Croydon NSW 2132 Croydon	1	1	\N	\N
2577	Blacktown NSW 2148 Blacktown	1	1	\N	\N
2578	Lower Victoria Plaza	1	1	\N	\N
2579	Glenfield Sydney Glenfield	1	1	\N	\N
2580	1 The Avenue	1	1	\N	\N
2581	Bondi Junction NSW 2022 Bondi Junction	1	1	\N	\N
2582	9 Hollinsworth Road	1	1	\N	\N
2583	Wentworth Point NSW 2127	1	1	\N	\N
2584	Telopea Telopea	1	1	\N	\N
2585	Mount Druitt Mount Druitt	1	1	\N	\N
2586	North St Marys	1	1	\N	\N
2587	Chatswood Interchange	1	1	\N	\N
2588	Bankstown Bankstown	1	1	\N	\N
2589	Miranda Miranda	1	1	\N	\N
2590	Redfern Redfern	1	1	\N	\N
2591	Cherrybrook Village Shopping Centre Cherrybrook	1	1	\N	\N
2592	Pyrmont NSW Pyrmont	1	1	\N	\N
2593	Burwood Burwood	1	1	\N	\N
2594	Shop 425	1	1	\N	\N
2595	Rouse Hill Rouse Hill	1	1	\N	\N
2596	Jordan Springs	1	1	\N	\N
2597	Shop 9	1	1	\N	\N
2598	Newport 	1	1	\N	\N
2599	8 Bourke Street	1	1	\N	\N
2600	Pirrama Park Cafe Pyrmont Pyrmont	1	1	\N	\N
2601	74 Mountain Street	1	1	\N	\N
2602	424 Oxford Street	1	1	\N	\N
2603	Surry Hills NSW Surry Hills	1	1	\N	\N
2604	Sydney CBD CBD	1	1	\N	\N
2605	Sydney NSW	1	1	\N	\N
2606	North Bondi	1	1	\N	\N
2607	Jones Bay Warf	1	1	\N	\N
2608	4-16 Castle Street	1	1	\N	\N
2609	CBD CBD NSW	1	1	\N	\N
2610	Pirrama Park Cafe	1	1	\N	\N
2611	Bondi Beach Bondi Beach NSW	1	1	\N	\N
2612	455 George Street	1	1	\N	\N
2613	Jamieson Street	1	1	\N	\N
2614	180 – 186 Campbell Parade Bondi Beach NSW Bondi Beach	1	1	\N	\N
2615	Glebe Glebe NSW	1	1	\N	\N
2616	Darling Harbour NSW 2000 Darling Harbour NSW	1	1	\N	\N
2617	Glenhaven,Dural	1	1	\N	\N
2618	161 Sussex St	1	1	\N	\N
2619	183 Alison Road 	1	1	\N	\N
2620	Ryde Ryde NSW	1	1	\N	\N
2621	Woollahra Woollahra	1	1	\N	\N
2622	70 Norton Street	1	1	\N	\N
2623	26 Bridge Road	1	1	\N	\N
2624	paddington	1	1	\N	\N
2625	Surry Hills Surry Hills NSW	1	1	\N	\N
2626	La Perouse La Perouse	1	1	\N	\N
2627	QVB	1	1	\N	\N
2628	365 Crown Street	1	1	\N	\N
2629	Randwick Randwick NSW	1	1	\N	\N
2630	Clovelly Beach	1	1	\N	\N
2631	Marrickville Marrickville	1	1	\N	\N
2632	19 The Northern Rd	1	1	\N	\N
2633	Bobbin Head	1	1	\N	\N
2634	62 Foster Street	1	1	\N	\N
2635	Tamarama	1	1	\N	\N
2636	Waverly	1	1	\N	\N
2637	1 Gauthorpe Street	1	1	\N	\N
2638	Collaroy Sydney Collaroy NSW	1	1	\N	\N
2639	Royal National Park	1	1	\N	\N
2640	99 Jones Street	1	1	\N	\N
2641	Sydney Mortdale	1	1	\N	\N
2642	Art Gallery Road	1	1	\N	\N
2643	186 Church Street Parramatta	1	1	\N	\N
2644	Paddington Paddington	1	1	\N	\N
2645	Airport Drive	1	1	\N	\N
2646	191 O'Riordan Street	1	1	\N	\N
2647	Wooloware	1	1	\N	\N
2648	CIRCULAR QUAY NSW 2000 NSW	1	1	\N	\N
2649	Flemington	1	1	\N	\N
2650	Sydney Belmore	1	1	\N	\N
2651	Level 3	1	1	\N	\N
2652	120-122 Jones Bay Wharf	1	1	\N	\N
2653	225 Burns Bay Road	1	1	\N	\N
2654	Broadway	1	1	\N	\N
2655	54 McLaren Street North Sydney North Sydney	1	1	\N	\N
2656	28/14 Ultimo Road	1	1	\N	\N
2657	Jenolan	1	1	\N	\N
2658	NSW 2151 North Rocks	1	1	\N	\N
2659	Darling Park	1	1	\N	\N
2660	12 Oatley Parade Oatley	1	1	\N	\N
2661	Tamarama Beach	1	1	\N	\N
2662	105 Miller Street	1	1	\N	\N
2663	646 Harris Street	1	1	\N	\N
2664	York Street	1	1	\N	\N
2665	Kellyville Kellyville	1	1	\N	\N
2666	92 Parramatta Road Lidcombe	1	1	\N	\N
2667	Newtown Newtown	1	1	\N	\N
2668	Stanmore NSW 2048 Stanmore	1	1	\N	\N
2669	10 Dawn Fraser Avenue	1	1	\N	\N
2670	Barangaroo Barangaroo	1	1	\N	\N
2671	South Curl Curl	1	1	\N	\N
2672	225 Forest Road	1	1	\N	\N
2673	97 Greenwich Road	1	1	\N	\N
2674	Canley Heights Canley Heights	1	1	\N	\N
2675	7 Bourke Street	1	1	\N	\N
2676	Olympic Boulevard	1	1	\N	\N
2677	8 Edwin Flack Avenue	1	1	\N	\N
2678	6 Kable Street	1	1	\N	\N
2679	Balgowlah Heights Heights	1	1	\N	\N
2680	Mount Kuring-Gai	1	1	\N	\N
2681	Food Court	1	1	\N	\N
2682	188 Forest Road	1	1	\N	\N
2683	Strathfield Strathfield	1	1	\N	\N
2684	60 Union Street	1	1	\N	\N
2685	Central Station	1	1	\N	\N
2686	20 Gymea Bay Road Gymea	1	1	\N	\N
2687	10 Barrack Street	1	1	\N	\N
2688	71 Jones Street	1	1	\N	\N
2689	Sydney Hurlstone Park NSW	1	1	\N	\N
2690	37 York Street	1	1	\N	\N
2691	5 Brodie Spark Drive	1	1	\N	\N
2692	CBD Sydney	1	1	\N	\N
2693	St Leonards NSW	1	1	\N	\N
2694	82 Mary Street	1	1	\N	\N
2695	Berambing	1	1	\N	\N
2696	Foyer of Library	1	1	\N	\N
2697	Balmain NSW Balmain	1	1	\N	\N
2698	Blacktown Blacktown	1	1	\N	\N
2699	Jamisontown	1	1	\N	\N
2700	Mount Colah Mount Colah NSW	1	1	\N	\N
2701	Mount Tomah	1	1	\N	\N
2702	Danks Street Shopping Plaza	1	1	\N	\N
2703	14 Hassall Street	1	1	\N	\N
2704	289 Old Northern Road	1	1	\N	\N
2705	Collaroy 	1	1	\N	\N
2706	612 Crown Street	1	1	\N	\N
2707	26-32 Pirrama Road	1	1	\N	\N
2708	323 Castlereagh Street	1	1	\N	\N
2709	Westfield Sydney Level 5 Food Court NSW	1	1	\N	\N
2710	Penrith Whitewater Stadium	1	1	\N	\N
2711	35 Coonara Avenue West Pennant Hills	1	1	\N	\N
2712	Sydney Medlow Bath NSW	1	1	\N	\N
2713	Epping Epping	1	1	\N	\N
2714	Prestons Prestons NSW	1	1	\N	\N
2715	North Sydney NSW 2060	1	1	\N	\N
2716	500 Wattle Street	1	1	\N	\N
2717	Level 1/52 Martin Place	1	1	\N	\N
2718	60 Margaret Street	1	1	\N	\N
2719	4-6 Wandella Road	1	1	\N	\N
2720	Wattle Grove Wattle Grove NSW	1	1	\N	\N
2721	Cammperdown	1	1	\N	\N
2722	Kiora Road	1	1	\N	\N
2723	101 Miller Street	1	1	\N	\N
2724	Mascot 2020 NSW Mascot	1	1	\N	\N
2725	North North Narrabeen	1	1	\N	\N
2726	14 Queen Street	1	1	\N	\N
2727	8 Arrivals Court	1	1	\N	\N
2728	Corner of Mackenzie Blvd and Best Road	1	1	\N	\N
2729	Kingswood Kingswood NSW	1	1	\N	\N
2730	Carrs Park	1	1	\N	\N
2731	Cronulla Beach	1	1	\N	\N
2738	23-27 Eton St	1	1	\N	\N
2739	T1 Sydney International Airport (Before Customs)	1	1	\N	\N
2732	20 Berry St	1	1	\N	\N
2737	Castlecrag Castlecrag NSW	1	1	\N	\N
2733	Caringbah Caringbah	1	1	\N	\N
2735	Sydney Riverwood NSW	1	1	\N	\N
2736	Sutherland NSW 2232	1	1	\N	\N
2740	Sydney Eastwood	1	1	\N	\N
2743	South Riverwood	1	1	\N	\N
2734	243-371 Pyrmont Street	1	1	\N	\N
2741	Allambie	1	1	\N	\N
2742	Kirawee	1	1	\N	\N
2744	Macquarie Park Macquarie Park	1	1	\N	\N
2745	Allambie Heights Allambie Heights	1	1	\N	\N
2746	Rosebery Rosebery NSW	1	1	\N	\N
2747	Liverpool NSW 2170 Liverpool	1	1	\N	\N
2748	Shop 03	1	1	\N	\N
2749	Canley Vale Canley Vale NSW	1	1	\N	\N
2750	61-63 Watergum Drive	1	1	\N	\N
2751	West West Pennant Hills	1	1	\N	\N
2752	Sydney Fairfield	1	1	\N	\N
2753	165-191 Macquarie Street Liverpool	1	1	\N	\N
2754	Grafton St	1	1	\N	\N
2755	Greenfield Park Greenfield Park NSW	1	1	\N	\N
2756	1 Olympic Boulevard	1	1	\N	\N
2757	NSW 2000	1	1	\N	\N
2758	St Leonards NSW 2065	1	1	\N	\N
2759	12 Church Avenue	1	1	\N	\N
2760	Neutral Bay 2089 Neutral Bay	1	1	\N	\N
2761	Queen Victoria Building	1	1	\N	\N
2762	Gregory Hills NSW	1	1	\N	\N
2763	31 Market Street	1	1	\N	\N
2764	252 George Street	1	1	\N	\N
2765	17 Hollinsworth Road	1	1	\N	\N
2766	AIrport Drive	1	1	\N	\N
2767	205 O'Riordan Street	1	1	\N	\N
2768	7 Murry Rose Avenue	1	1	\N	\N
2769	Avalon Avalon NSW	1	1	\N	\N
2770	Metro Aspire Hotel Sydney	1	1	\N	\N
2771	Glebe Glebe	1	1	\N	\N
2772	Annandale. Sydney Annandale	1	1	\N	\N
2773	50 Carrington Street	1	1	\N	\N
2774	Dawn Fraser Avenue	1	1	\N	\N
2775	Carlingford Sydney Carlingford NSW	1	1	\N	\N
2776	103 Quarry Street	1	1	\N	\N
2777	11 Australia Avenue	1	1	\N	\N
2778	Gate 2 High Street	1	1	\N	\N
2779	2 Chifley Square	1	1	\N	\N
2780	827-839 George Street	1	1	\N	\N
2781	King Street Wharf	1	1	\N	\N
2782	Condell park	1	1	\N	\N
2783	71 National Ave	1	1	\N	\N
2784	51 Berry Street	1	1	\N	\N
2785	Lane Cove NSW 2066 Lane Cove	1	1	\N	\N
2786	Pyrmont NSW 2009 Pyrmont	1	1	\N	\N
2787	Hurstville NSW 2220	1	1	\N	\N
2788	77 Archer Street	1	1	\N	\N
2789	Kirrawee Kirrawee	1	1	\N	\N
2790	Ultimo NSW 2007 Ultimo	1	1	\N	\N
2791	South Windsor	1	1	\N	\N
2792	208 Belmore Road NSW	1	1	\N	\N
2793	Sydney Castle Hill	1	1	\N	\N
2794	Mayfair Plaza Parramatta	1	1	\N	\N
2795	Sydney Hornsby	1	1	\N	\N
2796	183B Forest Road	1	1	\N	\N
2797	South Penrith	1	1	\N	\N
2798	Sydney South Windsor NSW	1	1	\N	\N
2799	Cartlon	1	1	\N	\N
2800	The Rocks NSW 2000 The Rocks	1	1	\N	\N
2801	13/17 Woodville Street	1	1	\N	\N
2802	Wynyard Station CBD CBD NSW	1	1	\N	\N
2803	98A-114 Burwood Road	1	1	\N	\N
2804	Old Toongabbie NSW 2146 Old Toongabbie	1	1	\N	\N
2805	177 Pacific Highway	1	1	\N	\N
2806	Gymea NSW 2227 Gymea	1	1	\N	\N
2807	Balmain Balmain	1	1	\N	\N
2808	Toongabbie Toongabbie	1	1	\N	\N
2809	Kingsgrove NSW	1	1	\N	\N
2810	Lawson NSW	1	1	\N	\N
2811	7 Barratt Street	1	1	\N	\N
2812	Rooty Hill Rooty Hill	1	1	\N	\N
2813	Earlwood Earlwood	1	1	\N	\N
2814	South Hurstville South Hurstville	1	1	\N	\N
2815	Neutral Bay NSW Neutral Bay	1	1	\N	\N
2816	77-79 York Street	1	1	\N	\N
2817	Sydney West Pennant Hills	1	1	\N	\N
2818	Sydney Pyrmont NSW	1	1	\N	\N
2819	500 Crown Street	1	1	\N	\N
2820	Cockle Bay Wharf	1	1	\N	\N
2821	56-58 York Street	1	1	\N	\N
2822	275 Clarence Street	1	1	\N	\N
2823	49 York Street	1	1	\N	\N
2824	24/9 Hollinsworth Road	1	1	\N	\N
2825	King St Wharf	1	1	\N	\N
2826	Rozelle NSW	1	1	\N	\N
2827	324A King Street	1	1	\N	\N
2828	Sydney Milsons Point NSW	1	1	\N	\N
2829	Woollahra NSW 2025 Woollahra	1	1	\N	\N
2830	Sydney Annandale NSW	1	1	\N	\N
2831	NSW NSW	1	1	\N	\N
2832	Clareville	1	1	\N	\N
2833	200 Sussex Street	1	1	\N	\N
2834	Entrance via News Direct Road	1	1	\N	\N
2835	Cote D’Azur Building	1	1	\N	\N
2836	445 George Street	1	1	\N	\N
2837	46-67 Mulga Road	1	1	\N	\N
2838	Darling Point Darling Point NSW	1	1	\N	\N
2839	Darlinghurst NSW Darlinghurst NSW	1	1	\N	\N
2840	Sydney Crows Nest	1	1	\N	\N
2841	Gregory Hills	1	1	\N	\N
2842	Corner of King and York Streets	1	1	\N	\N
2843	116-132 Maroubra Road	1	1	\N	\N
2844	Ramsgate Sydney Ramsgate NSW	1	1	\N	\N
2845	Caringbah 2229	1	1	\N	\N
2846	Sutherland Sutherland	1	1	\N	\N
2847	35 Cremona Road Como NSW	1	1	\N	\N
2848	Austral Austral NSW	1	1	\N	\N
2849	Mooney Mooney NSW	1	1	\N	\N
2850	Corner Moore & Melville Roads	1	1	\N	\N
2851	Sydney Opera House NSW	1	1	\N	\N
2852	43 York Street	1	1	\N	\N
2853	Sydney Camden	1	1	\N	\N
2854	442-444 Bunnerong Road	1	1	\N	\N
2855	Darlington NSW Darlington	1	1	\N	\N
2856	Sydney Campsie NSW	1	1	\N	\N
2857	Milsons Point Milsons Point	1	1	\N	\N
2858	Wetherill Park Wetherill Park	1	1	\N	\N
2859	Gledswood Hills Gledswood Hills NSW	1	1	\N	\N
2860	86 Chalmers Street	1	1	\N	\N
2861	Kogarah Kogarah	1	1	\N	\N
2862	Marsden Park Marsden Park NSW	1	1	\N	\N
2863	New South Wales	1	1	\N	\N
2864	Sydney Waverley	1	1	\N	\N
2865	Bidwell	1	1	\N	\N
2866	300 Elizabeth Street. Surry Hills Surry Hills	1	1	\N	\N
2867	Casula Mall	1	1	\N	\N
2868	The Centre	1	1	\N	\N
2869	Mt Annan NSW	1	1	\N	\N
2871	Freshwater Freshwater	1	1	\N	\N
2872	Smithfield Smithfield NSW	1	1	\N	\N
2875	Sydney Avalon	1	1	\N	\N
2870	1 Rooty Hill Road North	1	1	\N	\N
2874	Darlinghurst NSW 2010	1	1	\N	\N
2878	Fairfield NSW 2165 Fairfield NSW	1	1	\N	\N
2873	Warragamba NSW	1	1	\N	\N
2876	San Souci	1	1	\N	\N
2877	Avalon Beach Avalon	1	1	\N	\N
2879	Sydney Chatswood NSW	1	1	\N	\N
2880	Sydney Darling Harbour NSW	1	1	\N	\N
2881	Sydney Bankstown	1	1	\N	\N
2882	Sydney Strathfield	1	1	\N	\N
2883	Sydney CBD NSW	1	1	\N	\N
2884	Westfield	1	1	\N	\N
2885	Sydney Newington	1	1	\N	\N
2886	Haymafket	1	1	\N	\N
2887	Sydney Manly	1	1	\N	\N
2888	143A Raglan Street	1	1	\N	\N
2889	Sydney NSW NSW	1	1	\N	\N
2890	Sydney Dee Why	1	1	\N	\N
2891	Sydney Chatswood	1	1	\N	\N
2892	Sydney Strathfield NSW	1	1	\N	\N
2893	Century Circuit	1	1	\N	\N
2894	1 Rider Boulevard Rhodes	1	1	\N	\N
2895	Sydney Camperdown NSW	1	1	\N	\N
2896	Sydney Newington NSW	1	1	\N	\N
2897	Sydney Dee Why NSW	1	1	\N	\N
2898	Sydney Baulkham Hills	1	1	\N	\N
2899	Sydney Manly NSW	1	1	\N	\N
2900	Sydney Leppington	1	1	\N	\N
2901	Sydney Ashfield	1	1	\N	\N
2902	4 Century Circuit	1	1	\N	\N
2903	Sydney Wollstonecraft NSW	1	1	\N	\N
2904	Sydney Mount Druitt NSW	1	1	\N	\N
2905	Sydney Forestville NSW	1	1	\N	\N
2906	Sydney Camden NSW	1	1	\N	\N
2907	Sydney Doonside NSW	1	1	\N	\N
2908	Sydney Harris Park NSW	1	1	\N	\N
2909	Sydney Rooty Hill	1	1	\N	\N
2910	Sydney Redfern NSW	1	1	\N	\N
2911	Sydney Potts Point	1	1	\N	\N
2912	Australia Riverstone	1	1	\N	\N
2913	Sydney Mount Druitt	1	1	\N	\N
2914	NSW	1	1	\N	\N
2915	Sydney Prestons NSW	1	1	\N	\N
2916	Sydney Gladesville NSW	1	1	\N	\N
2917	Sydney Kensington	1	1	\N	\N
2918	Sydney Cabramatta	1	1	\N	\N
2919	Sydney Emu Plains	1	1	\N	\N
2920	Sydney Harris Park	1	1	\N	\N
2921	Sydney Palm Beach NSW	1	1	\N	\N
2922	Sydney Circular Quay NSW	1	1	\N	\N
2923	Sydney Ryde NSW	1	1	\N	\N
2924	Sydney Cronulla	1	1	\N	\N
2925	Sydney Glebe	1	1	\N	\N
2926	Sydney Kingsgrove	1	1	\N	\N
2927	Sydney Woolloomooloo NSW	1	1	\N	\N
2928	Sydney Macquarie Park	1	1	\N	\N
2929	Hornsby Hornsby	1	1	\N	\N
2930	Sydney Woolloomooloo	1	1	\N	\N
2931	Sydney Darlington NSW	1	1	\N	\N
2932	Sydney Potts Point NSW	1	1	\N	\N
2933	Sydney West Pymble	1	1	\N	\N
2934	Sydney Ermington	1	1	\N	\N
2935	Sydney Forestville	1	1	\N	\N
2936	Sydney Warwick Farm	1	1	\N	\N
2937	Sydney Penrith	1	1	\N	\N
2938	Sydney Bondi Junction NSW	1	1	\N	\N
2939	Carrington Street Entrance	1	1	\N	\N
2940	Sydney Gordon	1	1	\N	\N
2941	Sydney Miranda	1	1	\N	\N
2942	Sydney Blacktown nsw	1	1	\N	\N
2943	Sydney Auburn NSW	1	1	\N	\N
2944	Sydney Bella Vista NSW	1	1	\N	\N
2945	Sydney Camperdown Camperdown NSW	1	1	\N	\N
2946	Sydney Fairfield Heights	1	1	\N	\N
2947	Sydney Lidcombe	1	1	\N	\N
2948	Sydney Winston Hills	1	1	\N	\N
2949	Sydney Haymarket	1	1	\N	\N
2950	15 Carrington Street Entrance	1	1	\N	\N
2951	Sydney Gladesville	1	1	\N	\N
2952	Sydney Macquarie Park NSW	1	1	\N	\N
2953	Campsie Campsie	1	1	\N	\N
2954	Sydney Rockdale	1	1	\N	\N
2955	T1 Sydney International Airport 	1	1	\N	\N
2956	Sydney Old Toongabbie	1	1	\N	\N
2957	Sydney Bilgola Beach	1	1	\N	\N
2958	Wentworth point	1	1	\N	\N
2959	French's Forest	1	1	\N	\N
2960	Sydney Mosman	1	1	\N	\N
2961	Sydney Brookvale	1	1	\N	\N
2962	NSW Rhodes	1	1	\N	\N
2963	Cromer Heights	1	1	\N	\N
2964	Sydney Lalor Park	1	1	\N	\N
2965	NSW Strathfield NSW	1	1	\N	\N
2966	Croydon park	1	1	\N	\N
2967	Sydney Westleigh	1	1	\N	\N
2968	Sydney Menai	1	1	\N	\N
2969	Sydney Kings Langley NSW	1	1	\N	\N
2970	61 Macquarie Street	1	1	\N	\N
2971	Wooloomooloo	1	1	\N	\N
2972	Circular Quay West	1	1	\N	\N
2973	1-25 Harbour Street	1	1	\N	\N
2974	Sydney Enmore	1	1	\N	\N
2975	Sydney Wolli Creek NSW	1	1	\N	\N
2976	Sydney Emu Plains NSW	1	1	\N	\N
2977	Sydney Baulkham Hills NSW	1	1	\N	\N
2978	Just off 389 George street	1	1	\N	\N
2979	Arnell Park	1	1	\N	\N
2980	Sydney Rouse Hill	1	1	\N	\N
2981	Hurstville South Hurstville	1	1	\N	\N
2982	Sydney Lakemba	1	1	\N	\N
2983	Sydney Doonside	1	1	\N	\N
2984	9-11 Australia Avenue	1	1	\N	\N
2985	Sydney Pennant Hills	1	1	\N	\N
2986	Chippendale Chippendale	1	1	\N	\N
2987	Sydney Gregory Hills	1	1	\N	\N
2988	South	1	1	\N	\N
2989	Sydney Camperdown	1	1	\N	\N
2990	Sydney Parramatta	1	1	\N	\N
2991	E.	1	1	\N	\N
2992	North	1	1	\N	\N
2993	Canley	1	1	\N	\N
2994	Summer	1	1	\N	\N
2995	Potts	1	1	\N	\N
2996	Macquarie	1	1	\N	\N
2997	Cafe	1	1	\N	\N
2998	66 Talavera Road	1	1	\N	\N
2999	180-186 Campbell Parade	1	1	\N	\N
3000	Forest Road Entrance via The Eatery Hurstville	1	1	\N	\N
\.


--
-- Data for Name: system_errors; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.system_errors (id, error_type, description, occurred_at) FROM stdin;
1	Update Store	Could not update store 1	2019-09-26 07:22:52.64+00
2	Validate Reward	Could not parse userReward: null	2019-09-26 09:17:18.32+00
3	Validate Reward	Could not parse userReward: null	2019-09-26 09:17:29.84+00
4	Validate Reward	Could not parse userReward: null	2019-09-26 09:20:30.058+00
5	Validate Reward	Could not parse userReward: null	2019-09-26 09:21:40.644+00
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.tags (id, name) FROM stdin;
1	sweet
2	bubble
3	cheap
4	fancy
5	coffee
6	brunch
\.


--
-- Data for Name: user_accounts; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_accounts (id, email) FROM stdin;
1	psyneia@gmail.com
36	Kurt14242@kurt.com
38	Kurt14aa242@kurt.com
39	Kurt14aa233342@kurt.com
42	Kurt14aa233a342@kurt.com
50	psyneiaaa@gmail.com
45	151452@424.com
2745	psyneidda@gmail.com
43	psyneiaazza@gmail.com
2751	aafefeze@fefe.com
49	151aa4ss52@424.com
51	fefee@fefe.com
52	fefeze@fefe.com
2752	aafefeze@fefe.com
2753	psyneia@gmail.com
2754	psyneia@gmail.com
2755	psyneia@gmail.com
2756	psyneia@gmail.com
2757	psyneia@gmail.com
2758	fefeze@fefe.com
2759	psyanite@gmail.com
2763	psyanite@gmail.com
4	leia-the-slayer@gmail.com
2	c.c.chloe@gmail.com
3	annika_b@gmail.com
37	moefinef@gmail.com
2764	eddie-huang@gmail.com
5	hello-meow-meow@gmail.com
2765	sophia_king@gmail.com
2766	psyanite@gmail.com
2767	psyanite@gmail.com
2768	psyanite@gmail.com
2769	pzyneia@gmail.com
2770	test-meow@gmail.com
2771	another-test-meow@gmeow.com
2772	supermeow@gmeow.com
2775	1234@meow.com
2780	meow@meow.com
2781	red@meow.com
\.


--
-- Data for Name: user_claims; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_claims (user_id, type, value) FROM stdin;
\.


--
-- Data for Name: user_favorite_posts; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_favorite_posts (user_id, post_id) FROM stdin;
2	222
2	220
2	223
\.


--
-- Data for Name: user_favorite_rewards; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_favorite_rewards (user_id, reward_id) FROM stdin;
1	3
1	1
2	3
2	5
2	2
2	8
2	12
\.


--
-- Data for Name: user_favorite_stores; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_favorite_stores (user_id, store_id) FROM stdin;
1	2
1	3
1	1
2	1
2	8
2	22
2	21
2	6
2	7
2	4
2	32
2	31
2	29
\.


--
-- Data for Name: user_follows; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_follows (user_id, follower_id) FROM stdin;
2	1
3	1
1	2
3	2
4	2
2	2765
\.


--
-- Data for Name: user_logins; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_logins (social_type, social_id, user_id) FROM stdin;
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
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_profiles (user_id, username, preferred_name, profile_picture, gender, first_name, last_name, tagline, follower_count, store_count, fcm_token, admin_id) FROM stdin;
2764	perrilicious	Eddie	https://i.imgur.com/hHXy2u8.jpg	male	Edward	Perry	\N	0	0	\N	\N
1	nyatella	Luna	https://imgur.com/DAdLVwp.jpg	female	Luna	Lytele	Avid traveller, big foodie. Ramen or die! 🍜	1	3	\N	\N
3	annika_b	Annika	https://imgur.com/18N6fV3.jpg	female	Annika	McIntyre	🏹 Sagittarius\r\n🍜 Big Foodie\r\n📍 Tokyo, Amsterdam, Brooklyn	2	2	\N	\N
5	evalicious	Eva	https://imgur.com/fFa9R1o.jpg	female	Eva	Seacrest	\N	0	1	\N	\N
4	miss.leia	Leia	https://imgur.com/CUVkwzY.jpg	female	Leia	Rochford	When a poet digs himself into a hole, he doesn't climb out. He digs deeper, enjoys the scenery, and comes out the other side enlightened.	1	2	\N	\N
2770	donutcat	\N	\N	\N	\N	\N	\N	0	0	\N	3
2781	redcat	\N	\N	\N	\N	\N	\N	0	0	dkbMFj9ncp8:APA91bGIWcLje9UJANmBO1MDhryeIFMvQ_AHbT5UXY429J68AwmkdmoFMet7hEa675CTFBVfXUzq6AcFRKyIRxzF3tg42-6PABlhACvwyNcIYqamSC8CUIzXGRqfzz38-D-A1bQKYUeE	9
2772	bobacat	\N	\N	\N	\N	\N	\N	0	0	dkbMFj9ncp8:APA91bGIWcLje9UJANmBO1MDhryeIFMvQ_AHbT5UXY429J68AwmkdmoFMet7hEa675CTFBVfXUzq6AcFRKyIRxzF3tg42-6PABlhACvwyNcIYqamSC8CUIzXGRqfzz38-D-A1bQKYUeE	1
2771	cinnamoncat	\N	\N	\N	\N	\N	\N	0	0	dkbMFj9ncp8:APA91bGIWcLje9UJANmBO1MDhryeIFMvQ_AHbT5UXY429J68AwmkdmoFMet7hEa675CTFBVfXUzq6AcFRKyIRxzF3tg42-6PABlhACvwyNcIYqamSC8CUIzXGRqfzz38-D-A1bQKYUeE	2
2780	aquacat	\N	\N	\N	\N	\N	\N	0	0	fxcVSEQgDck:APA91bEzhe5P3ltToqMwwN3Pthxe6ma2I_-II4VrkhxLS-_Djj5C_6knmPE5Z3SvkqAef4PXo3YmQi5_t2_Z3S9gwGqXxqoAJZlJ-RlBdq5PKe-lFhf8Chp4m3a4T1lf-ZQUTFxoKY2s	8
2765	goldcoast.sophia	Sophia	https://imgur.com/ejg9ziF.jpg	female	Sophia	King	When a poet digs himself into a hole, he doesn't climb out. He digs deeper, enjoys the scenery, and comes out the other side enlightened.	0	0	fq258jQyPPg:APA91bHBjkmWVTTUfI9mVOurHe8d9wMnQguZ_8XvDDCQ6sNm-Ipw4CV7Yr32zMEgFiLOEuS4hplJ8XbiHXSTnxiz41zNHx_ST0I3M4q-uVGuvmSiwy9U12TRTo2oJ4mHn0nWCd5bGH04	\N
2	curious_chloe	Chloe	https://imgur.com/AwS5vPC.jpg	female	Chloe	Lee	🏹 Saggitarius\n✈ Tokyo, Amsterdam, and Brooklyn\n🏠 Living in Sydney\n🍜 Ramen, Pad Thai, and Boba is Lyf	2	5	cUqlxXufPGA:APA91bE3fEUc4YJA-BozdQhBURLTRRgjndtvbodkM-WC-00Z8kELIgCjWWdYmC5m0h3cCNeCASJva18eoQndFMwy3Xfv4pheexdDbgNx9l6gnfIiSo46dfMOSiWCNc-Ow-tH1taXdQB0	\N
\.


--
-- Data for Name: user_rewards; Type: TABLE DATA; Schema: croissant; Owner: -
--

COPY croissant.user_rewards (user_id, reward_id, unique_code, last_redeemed_at, redeemed_count) FROM stdin;
2	18	MN6K	2019-10-02 11:00:37.644+00	5
2	19	Z7Z7	\N	0
2	17	9MNW	2019-10-02 11:00:06.265+00	3
2765	2	Y8Z2	2019-09-18 21:35:34.959+00	1
1	1	CX1P	2019-09-18 21:35:34.959+00	1
2	9	0MYD	2019-09-18 21:35:34.959+00	1
2	3	IODE	2019-09-18 21:35:34.959+00	1
2	7	N4CE	2019-09-18 21:35:34.959+00	1
2	8	OK1O	2019-09-18 21:35:34.959+00	1
2	12	5KK5	\N	0
2	1	5GVY	2019-09-18 21:35:34.959+00	5
2	5	NYKD	\N	0
2	15	GCDQ	\N	0
2	2	PLPZ	\N	0
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.admins_id_seq', 11, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.cities_id_seq', 2, true);


--
-- Name: comment_likes_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.comment_likes_id_seq', 28, true);


--
-- Name: comment_replies_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.comment_replies_id_seq', 302, true);


--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.comment_reply_likes_id_seq', 44, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.countries_id_seq', 240, true);


--
-- Name: cuisines_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.cuisines_id_seq', 146, true);


--
-- Name: cuisines_search_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.cuisines_search_id_seq', 1, false);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.districts_id_seq', 1, true);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.location_id_seq', 17, true);


--
-- Name: post_comments_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.post_comments_id_seq', 233, true);


--
-- Name: post_likes_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.post_likes_id_seq', 4, true);


--
-- Name: post_photos_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.post_photos_id_seq', 405, true);


--
-- Name: post_reviews_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.post_reviews_id_seq', 243, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.posts_id_seq', 252, true);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.rewards_id_seq', 19, true);


--
-- Name: store_addresses_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.store_addresses_id_seq', 73993, true);


--
-- Name: store_groups_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.store_groups_id_seq', 4, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.stores_id_seq', 74194, true);


--
-- Name: suburbs_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.suburbs_id_seq', 3000, true);


--
-- Name: system_errors_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.system_errors_id_seq', 5, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.tags_id_seq', 6, true);


--
-- Name: user_accounts_id_seq; Type: SEQUENCE SET; Schema: croissant; Owner: -
--

SELECT pg_catalog.setval('croissant.user_accounts_id_seq', 2783, true);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: city_locations; Type: MATERIALIZED VIEW; Schema: croissant; Owner: -
--

CREATE MATERIALIZED VIEW croissant.city_locations AS
 SELECT view.id,
    view.name,
    array_append(array_cat(view.suburbs, view.locations), view.name) AS locations
   FROM ( SELECT c.id,
            c.name,
            array_agg(DISTINCT s.name) AS suburbs,
            array_agg(DISTINCT l.name) AS locations
           FROM ((croissant.cities c
             JOIN croissant.suburbs s ON ((c.id = s.city_id)))
             JOIN croissant.locations l ON ((s.id = l.suburb_id)))
          GROUP BY c.id) view
  WITH NO DATA;


--
-- Name: stores stores_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.stores
    ADD CONSTRAINT stores_id_pk PRIMARY KEY (id);


--
-- Name: store_search; Type: MATERIALIZED VIEW; Schema: croissant; Owner: -
--

CREATE MATERIALIZED VIEW croissant.store_search AS
 SELECT stores.id,
    stores.name,
    stores.phone_country,
    stores.phone_number,
    stores.location_id,
    stores.suburb_id,
    stores.city_id,
    stores.cover_image,
    stores.coords,
    ((((((((setweight(to_tsvector('english'::regconfig, public.unaccent(regexp_replace((stores.name)::text, '[^\w]+'::text, ''::text))), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(locations.name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_first_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_second_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, public.unaccent(COALESCE(string_agg((cuisines.name)::text, ' '::text), ''::text))), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_number, ''::character varying))::text), 'C'::"char")) AS document
   FROM ((((((croissant.stores
     LEFT JOIN croissant.locations ON ((stores.location_id = locations.id)))
     LEFT JOIN croissant.suburbs ON ((stores.suburb_id = suburbs.id)))
     LEFT JOIN croissant.cities ON ((stores.city_id = cities.id)))
     LEFT JOIN croissant.store_cuisines ON ((store_cuisines.store_id = stores.id)))
     LEFT JOIN croissant.cuisines ON ((store_cuisines.cuisine_id = cuisines.id)))
     LEFT JOIN croissant.store_addresses ON ((store_addresses.store_id = stores.id)))
  GROUP BY stores.id, locations.name, suburbs.name, cities.name, stores.cover_image, store_addresses.address_first_line, store_addresses.address_second_line, store_addresses.address_street_name, store_addresses.address_street_number
  WITH NO DATA;


--
-- Name: comment_likes comment_likes_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_likes
    ADD CONSTRAINT comment_likes_pk PRIMARY KEY (id);


--
-- Name: comment_replies comment_replies_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies
    ADD CONSTRAINT comment_replies_pk PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: cuisines cuisines_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cuisines
    ADD CONSTRAINT cuisines_id_pk PRIMARY KEY (id);


--
-- Name: cuisines_search cuisines_search_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cuisines_search
    ADD CONSTRAINT cuisines_search_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: comments post_comments_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comments
    ADD CONSTRAINT post_comments_pk PRIMARY KEY (id);


--
-- Name: post_likes post_likes_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_likes
    ADD CONSTRAINT post_likes_pk PRIMARY KEY (id);


--
-- Name: post_photos post_photos_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_photos
    ADD CONSTRAINT post_photos_id_pk PRIMARY KEY (id);


--
-- Name: post_reviews post_reviews_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_reviews
    ADD CONSTRAINT post_reviews_id_pk PRIMARY KEY (id);


--
-- Name: posts posts_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.posts
    ADD CONSTRAINT posts_pk PRIMARY KEY (id);


--
-- Name: comment_reply_likes reply_likes_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_reply_likes
    ADD CONSTRAINT reply_likes_pkey UNIQUE (user_id, reply_id);


--
-- Name: rewards rewards_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.rewards
    ADD CONSTRAINT rewards_pkey PRIMARY KEY (id);


--
-- Name: store_addresses store_addresses_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_addresses
    ADD CONSTRAINT store_addresses_id_pk PRIMARY KEY (id);


--
-- Name: store_cuisines store_cuisines_store_id_cuisine_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_cuisines
    ADD CONSTRAINT store_cuisines_store_id_cuisine_id_pk UNIQUE (store_id, cuisine_id);


--
-- Name: store_group_stores store_group_stores_unique; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_group_stores
    ADD CONSTRAINT store_group_stores_unique UNIQUE (group_id, store_id);


--
-- Name: store_groups store_groups_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_groups
    ADD CONSTRAINT store_groups_pkey PRIMARY KEY (id);


--
-- Name: store_tags store_tags_store_id_tag_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_tags
    ADD CONSTRAINT store_tags_store_id_tag_id_pk UNIQUE (store_id, tag_id);


--
-- Name: suburbs suburbs_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.suburbs
    ADD CONSTRAINT suburbs_pkey PRIMARY KEY (id);


--
-- Name: system_errors system_errors_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.system_errors
    ADD CONSTRAINT system_errors_pk PRIMARY KEY (id);


--
-- Name: tags tags_id_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.tags
    ADD CONSTRAINT tags_id_pk PRIMARY KEY (id);


--
-- Name: user_accounts user_accounts_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_accounts
    ADD CONSTRAINT user_accounts_pkey PRIMARY KEY (id);


--
-- Name: user_claims user_claims_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_claims
    ADD CONSTRAINT user_claims_pkey PRIMARY KEY (user_id);


--
-- Name: user_favorite_posts user_favorite_posts_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_pkey PRIMARY KEY (user_id, post_id);


--
-- Name: user_favorite_stores user_favorite_stores_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_pk PRIMARY KEY (user_id, store_id);


--
-- Name: user_logins user_logins_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_logins
    ADD CONSTRAINT user_logins_pkey PRIMARY KEY (social_type, social_id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: user_rewards user_rewards_pk; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_rewards
    ADD CONSTRAINT user_rewards_pk PRIMARY KEY (user_id, reward_id);


--
-- Name: user_favorite_rewards user_rewards_pkey; Type: CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_rewards
    ADD CONSTRAINT user_rewards_pkey PRIMARY KEY (user_id, reward_id);


--
-- Name: admins_user_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX admins_user_id_uindex ON croissant.admins USING btree (id);


--
-- Name: cities_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX cities_name ON croissant.cities USING btree (name);


--
-- Name: comment_likes_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX comment_likes_id_uindex ON croissant.comment_likes USING btree (id);


--
-- Name: comment_replies_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX comment_replies_id_uindex ON croissant.comment_replies USING btree (id);


--
-- Name: comment_replies_replied_at_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX comment_replies_replied_at_index ON croissant.comment_replies USING btree (replied_at);


--
-- Name: countries_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX countries_name ON croissant.countries USING btree (name);


--
-- Name: cuisine_search_document_idx; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX cuisine_search_document_idx ON croissant.cuisine_search USING btree (document);


--
-- Name: districts_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX districts_name ON croissant.districts USING btree (name);


--
-- Name: errors_error_type_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX errors_error_type_index ON croissant.system_errors USING btree (error_type);


--
-- Name: location_search_document_idx; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX location_search_document_idx ON croissant.location_search USING btree (document);


--
-- Name: locations_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX locations_name ON croissant.locations USING btree (name);


--
-- Name: post_comments_commented_at_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX post_comments_commented_at_index ON croissant.comments USING btree (commented_at);


--
-- Name: post_comments_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX post_comments_id_uindex ON croissant.comments USING btree (id);


--
-- Name: post_photos_photo_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX post_photos_photo_index ON croissant.post_photos USING btree (url);


--
-- Name: post_photos_post_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX post_photos_post_id_index ON croissant.post_photos USING btree (post_id);


--
-- Name: post_reviews_post_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX post_reviews_post_id_index ON croissant.post_reviews USING btree (post_id);


--
-- Name: posts_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX posts_id_uindex ON croissant.posts USING btree (id);


--
-- Name: posts_posted_at_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX posts_posted_at_index ON croissant.posts USING btree (posted_at);


--
-- Name: posts_posted_by_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX posts_posted_by_id_index ON croissant.posts USING btree (posted_by);


--
-- Name: posts_secret_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX posts_secret_index ON croissant.posts USING btree (hidden);


--
-- Name: posts_store_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX posts_store_id_index ON croissant.posts USING btree (store_id);


--
-- Name: posts_type_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX posts_type_index ON croissant.posts USING btree (type);


--
-- Name: reward_rankings_reward_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX reward_rankings_reward_id_uindex ON croissant.reward_rankings USING btree (reward_id);


--
-- Name: reward_search_document_idx; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX reward_search_document_idx ON croissant.reward_search USING btree (document);


--
-- Name: rewards_code_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX rewards_code_uindex ON croissant.rewards USING btree (code);


--
-- Name: store_follows_store_id_follower_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX store_follows_store_id_follower_uindex ON croissant.store_follows USING btree (store_id, follower_id);


--
-- Name: store_rankings_store_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX store_rankings_store_id_uindex ON croissant.store_rankings USING btree (store_id);


--
-- Name: store_ratings_cache_store_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX store_ratings_cache_store_id_uindex ON croissant.store_ratings_cache USING btree (store_id);


--
-- Name: stores_city_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX stores_city_id_index ON croissant.stores USING btree (city_id);


--
-- Name: stores_location_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX stores_location_id_index ON croissant.stores USING btree (location_id);


--
-- Name: stores_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX stores_name ON croissant.stores USING btree (name);


--
-- Name: stores_suburb_id_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX stores_suburb_id_index ON croissant.stores USING btree (suburb_id);


--
-- Name: stores_z_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX stores_z_id_uindex ON croissant.stores USING btree (z_id);


--
-- Name: suburbs_document_idx; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX suburbs_document_idx ON croissant.suburbs USING btree (document);


--
-- Name: suburbs_name; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX suburbs_name ON croissant.suburbs USING btree (name);


--
-- Name: system_errors_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX system_errors_id_uindex ON croissant.system_errors USING btree (id);


--
-- Name: user_follows_user_id_follower_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX user_follows_user_id_follower_uindex ON croissant.user_follows USING btree (user_id, follower_id);


--
-- Name: user_profiles_admin_id_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX user_profiles_admin_id_uindex ON croissant.user_profiles USING btree (admin_id);


--
-- Name: user_profiles_username_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX user_profiles_username_uindex ON croissant.user_profiles USING btree (username);


--
-- Name: user_rewards_redeemed_at_index; Type: INDEX; Schema: croissant; Owner: -
--

CREATE INDEX user_rewards_redeemed_at_index ON croissant.user_rewards USING btree (last_redeemed_at);


--
-- Name: user_rewards_unique_code_uindex; Type: INDEX; Schema: croissant; Owner: -
--

CREATE UNIQUE INDEX user_rewards_unique_code_uindex ON croissant.user_rewards USING btree (unique_code);


--
-- Name: admins admins_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.admins
    ADD CONSTRAINT admins_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: cities cities_district_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.cities
    ADD CONSTRAINT cities_district_id_fkey FOREIGN KEY (district_id) REFERENCES croissant.districts(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_comments_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_likes
    ADD CONSTRAINT comment_likes_comments_id_fk FOREIGN KEY (comment_id) REFERENCES croissant.comments(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_likes
    ADD CONSTRAINT comment_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_likes
    ADD CONSTRAINT comment_likes_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_comments_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies
    ADD CONSTRAINT comment_replies_comments_id_fk FOREIGN KEY (comment_id) REFERENCES croissant.comments(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies
    ADD CONSTRAINT comment_replies_stores_id_fk FOREIGN KEY (replied_by_store) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies
    ADD CONSTRAINT comment_replies_user_profiles_user_id_fk FOREIGN KEY (replied_by) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_user_profiles_user_id_fk_2; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_replies
    ADD CONSTRAINT comment_replies_user_profiles_user_id_fk_2 FOREIGN KEY (reply_to) REFERENCES croissant.user_profiles(user_id) ON DELETE SET NULL;


--
-- Name: comment_reply_likes comment_reply_likes_comment_replies_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_comment_replies_id_fk FOREIGN KEY (reply_id) REFERENCES croissant.comment_replies(id) ON DELETE CASCADE;


--
-- Name: comment_reply_likes comment_reply_likes_reply_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES croissant.comment_replies(id) ON DELETE CASCADE;


--
-- Name: comment_reply_likes comment_reply_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: comments comments_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comments
    ADD CONSTRAINT comments_stores_id_fk FOREIGN KEY (commented_by_store) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: districts districts_country_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.districts
    ADD CONSTRAINT districts_country_id_fkey FOREIGN KEY (country_id) REFERENCES croissant.countries(id) ON DELETE CASCADE;


--
-- Name: locations locations_suburb_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.locations
    ADD CONSTRAINT locations_suburb_id_fkey FOREIGN KEY (suburb_id) REFERENCES croissant.suburbs(id) ON DELETE CASCADE;


--
-- Name: comments post_comments_posts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comments
    ADD CONSTRAINT post_comments_posts_id_fk FOREIGN KEY (post_id) REFERENCES croissant.posts(id) ON DELETE CASCADE;


--
-- Name: comments post_comments_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.comments
    ADD CONSTRAINT post_comments_user_accounts_id_fk FOREIGN KEY (commented_by) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_posts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_likes
    ADD CONSTRAINT post_likes_posts_id_fk FOREIGN KEY (post_id) REFERENCES croissant.posts(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_likes
    ADD CONSTRAINT post_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_likes
    ADD CONSTRAINT post_likes_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: post_photos post_photos_posts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_photos
    ADD CONSTRAINT post_photos_posts_id_fk FOREIGN KEY (post_id) REFERENCES croissant.posts(id) ON DELETE CASCADE;


--
-- Name: post_reviews post_reviews_post_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.post_reviews
    ADD CONSTRAINT post_reviews_post_id_fkey FOREIGN KEY (post_id) REFERENCES croissant.posts(id) ON DELETE CASCADE;


--
-- Name: posts posts_posted_by_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.posts
    ADD CONSTRAINT posts_posted_by_id_fkey FOREIGN KEY (posted_by) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: posts posts_store_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.posts
    ADD CONSTRAINT posts_store_id_fkey FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: reward_rankings reward_rankings_rewards_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.reward_rankings
    ADD CONSTRAINT reward_rankings_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES croissant.rewards(id) ON DELETE CASCADE;


--
-- Name: rewards rewards_store_group_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.rewards
    ADD CONSTRAINT rewards_store_group_id_fkey FOREIGN KEY (store_group_id) REFERENCES croissant.store_groups(id) ON DELETE CASCADE;


--
-- Name: rewards rewards_store_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.rewards
    ADD CONSTRAINT rewards_store_id_fkey FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_addresses store_addresses_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_addresses
    ADD CONSTRAINT store_addresses_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_cuisines store_cuisines_cuisines_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_cuisines
    ADD CONSTRAINT store_cuisines_cuisines_id_fk FOREIGN KEY (cuisine_id) REFERENCES croissant.cuisines(id) ON DELETE CASCADE;


--
-- Name: store_cuisines store_cuisines_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_cuisines
    ADD CONSTRAINT store_cuisines_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_follows store_follows_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_follows
    ADD CONSTRAINT store_follows_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_follows store_follows_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_follows
    ADD CONSTRAINT store_follows_user_profiles_user_id_fk FOREIGN KEY (follower_id) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: store_group_stores store_group_stores_group_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_group_stores
    ADD CONSTRAINT store_group_stores_group_id_fkey FOREIGN KEY (group_id) REFERENCES croissant.store_groups(id) ON DELETE CASCADE;


--
-- Name: store_group_stores store_group_stores_store_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_group_stores
    ADD CONSTRAINT store_group_stores_store_id_fkey FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_hours store_hours_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_hours
    ADD CONSTRAINT store_hours_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_rankings store_rankings_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_rankings
    ADD CONSTRAINT store_rankings_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_ratings_cache store_ratings_cache_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_ratings_cache
    ADD CONSTRAINT store_ratings_cache_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_tags store_tags_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_tags
    ADD CONSTRAINT store_tags_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: store_tags store_tags_tag_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.store_tags
    ADD CONSTRAINT store_tags_tag_id_fk FOREIGN KEY (tag_id) REFERENCES croissant.tags(id) ON DELETE CASCADE;


--
-- Name: suburbs suburbs_city_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.suburbs
    ADD CONSTRAINT suburbs_city_id_fkey FOREIGN KEY (city_id) REFERENCES croissant.cities(id) ON DELETE CASCADE;


--
-- Name: user_claims user_claims_user_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_claims
    ADD CONSTRAINT user_claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_posts user_favorite_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES croissant.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_favorite_posts user_favorite_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_favorite_stores user_favorite_stores_stores_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_stores_id_fk FOREIGN KEY (store_id) REFERENCES croissant.stores(id) ON DELETE CASCADE;


--
-- Name: user_favorite_stores user_favorite_stores_user_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_user_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_follows user_follows_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_follows user_follows_user_profiles_user_id_fk_2; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk_2 FOREIGN KEY (follower_id) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_logins user_logins_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_logins
    ADD CONSTRAINT user_logins_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_profiles user_profiles_admins_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_profiles
    ADD CONSTRAINT user_profiles_admins_id_fk FOREIGN KEY (admin_id) REFERENCES croissant.admins(id);


--
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_rewards user_rewards_reward_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_rewards
    ADD CONSTRAINT user_rewards_reward_id_fkey FOREIGN KEY (reward_id) REFERENCES croissant.rewards(id) ON DELETE CASCADE;


--
-- Name: user_rewards user_rewards_rewards_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_rewards
    ADD CONSTRAINT user_rewards_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES croissant.rewards(id) ON DELETE CASCADE;


--
-- Name: user_rewards user_rewards_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_rewards
    ADD CONSTRAINT user_rewards_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES croissant.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_rewards user_rewards_user_id_fkey; Type: FK CONSTRAINT; Schema: croissant; Owner: -
--

ALTER TABLE ONLY croissant.user_favorite_rewards
    ADD CONSTRAINT user_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES croissant.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM cloudsqladmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO cloudsqlsuperuser;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: city_locations; Type: MATERIALIZED VIEW DATA; Schema: croissant; Owner: -
--

REFRESH MATERIALIZED VIEW croissant.city_locations;


--
-- Name: cuisine_search; Type: MATERIALIZED VIEW DATA; Schema: croissant; Owner: -
--

REFRESH MATERIALIZED VIEW croissant.cuisine_search;


--
-- Name: location_search; Type: MATERIALIZED VIEW DATA; Schema: croissant; Owner: -
--

REFRESH MATERIALIZED VIEW croissant.location_search;


--
-- Name: reward_search; Type: MATERIALIZED VIEW DATA; Schema: croissant; Owner: -
--

REFRESH MATERIALIZED VIEW croissant.reward_search;


--
-- Name: store_search; Type: MATERIALIZED VIEW DATA; Schema: croissant; Owner: -
--

REFRESH MATERIALIZED VIEW croissant.store_search;


--
-- PostgreSQL database dump complete
--

