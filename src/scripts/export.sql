--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10
-- Dumped by pg_dump version 10.10

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
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: address_standardizer_data_us; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer_data_us; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer_data_us IS 'Address Standardizer US dataset example';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_sfcgal; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_sfcgal WITH SCHEMA public;


--
-- Name: EXTENSION postgis_sfcgal; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_sfcgal IS 'PostGIS SFCGAL functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


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
    'unlimited',
    'loyalty'
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

--
-- Name: hashpoint(point); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hashpoint(point) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT hashfloat8($1[0]) # hashfloat8($1[1])$_$;


ALTER FUNCTION public.hashpoint(point) OWNER TO postgres;

--
-- Name: mini(anyarray); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mini(anyarray) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select min($1[i]) from generate_series(array_lower($1,1),
array_upper($1,1)) g(i);
$_$;


ALTER FUNCTION public.mini(anyarray) OWNER TO postgres;

--
-- Name: to_distance(point[], double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.to_distance(point[], double precision, double precision) RETURNS double precision[]
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
  points ALIAS FOR $1;
  lat ALIAS FOR $2;
  lng ALIAS FOR $3;
  p point;
  distances float[];
BEGIN
  FOR I IN array_lower(points, 1)..array_upper(points, 1)
    LOOP
      p := points[I];
      distances[I] := 6371 * acos(
              cos(radians(lat)) * cos(radians(p[0])) * cos(radians(lng) - radians(p[1])) +
              sin(radians(lat)) * sin(radians(p[0])));
    END LOOP;
  RETURN distances;
END;
$_$;


ALTER FUNCTION public.to_distance(point[], double precision, double precision) OWNER TO postgres;

--
-- Name: to_distance(point, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.to_distance(p point, lat double precision, lng double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  RETURN 6371 * acos(cos(radians(p[0])) * cos(radians(lat)) * cos(radians(p[1]) - radians(lng)) + sin(radians(p[0])) * sin(radians(lat)));
END
$$;


ALTER FUNCTION public.to_distance(p point, lat double precision, lng double precision) OWNER TO postgres;

--
-- Name: point_hash_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY public.point_hash_ops USING hash;


ALTER OPERATOR FAMILY public.point_hash_ops USING hash OWNER TO postgres;

--
-- Name: point_hash_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS public.point_hash_ops
    DEFAULT FOR TYPE point USING hash FAMILY public.point_hash_ops AS
    OPERATOR 1 ~=(point,point) ,
    FUNCTION 1 (point, point) public.hashpoint(point);


ALTER OPERATOR CLASS public.point_hash_ops USING hash OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    username character varying(64),
    store_id integer,
    created_at timestamp with time zone NOT NULL,
    hash character varying(255) NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    district_id integer NOT NULL,
    coords point
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
-- Name: comment_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_likes (
    user_id integer,
    comment_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


ALTER TABLE public.comment_likes OWNER TO postgres;

--
-- Name: comment_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_likes_id_seq OWNER TO postgres;

--
-- Name: comment_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_likes_id_seq OWNED BY public.comment_likes.id;


--
-- Name: comment_replies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_replies (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    body text,
    replied_by integer,
    replied_at timestamp with time zone NOT NULL,
    replied_by_store integer
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
-- Name: comment_reply_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_reply_likes (
    user_id integer,
    reply_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


ALTER TABLE public.comment_reply_likes OWNER TO postgres;

--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_reply_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_reply_likes_id_seq OWNER TO postgres;

--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_reply_likes_id_seq OWNED BY public.comment_reply_likes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    body text NOT NULL,
    commented_by integer,
    commented_at timestamp with time zone NOT NULL,
    commented_by_store integer
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
    city_id integer DEFAULT 1 NOT NULL,
    postcode integer DEFAULT 1 NOT NULL,
    document tsvector,
    coords point
);


ALTER TABLE public.suburbs OWNER TO postgres;

--
-- Name: location_search; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.location_search AS
 SELECT view.name,
    view.description,
    view.coords,
    to_tsvector('english'::regconfig, public.unaccent((view.name)::text)) AS document
   FROM ( SELECT c.name,
            d.name AS description,
            c.coords
           FROM (public.cities c
             LEFT JOIN public.districts d ON ((c.district_id = d.id)))
        UNION
         SELECT s.name,
            c.name AS description,
            s.coords
           FROM (public.suburbs s
             LEFT JOIN public.cities c ON ((s.city_id = c.id)))
        UNION
         SELECT l.name,
            concat_ws(', '::text, s.name, c.name) AS description,
            s.coords
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
-- Name: post_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_likes (
    user_id integer,
    post_id integer NOT NULL,
    id integer NOT NULL,
    store_id integer
);


ALTER TABLE public.post_likes OWNER TO postgres;

--
-- Name: post_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_likes_id_seq OWNER TO postgres;

--
-- Name: post_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_likes_id_seq OWNED BY public.post_likes.id;


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
    overall_score public.score_type,
    taste_score public.score_type,
    service_score public.score_type,
    value_score public.score_type,
    ambience_score public.score_type,
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
    posted_at timestamp with time zone,
    posted_by_admin integer
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
    rank integer DEFAULT 99 NOT NULL,
    tags character varying(255),
    coords point[]
);


ALTER TABLE public.rewards OWNER TO postgres;

--
-- Name: store_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.store_groups OWNER TO postgres;

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
    avg_cost integer,
    coords point
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: reward_search; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.reward_search AS
 SELECT rewards.id,
    (((setweight(to_tsvector('english'::regconfig, public.unaccent((rewards.name)::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(rewards.tags, ''::character varying))::text), 'A'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(s.name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(sg.name, ''::character varying))::text), 'B'::"char")) AS document
   FROM ((public.rewards
     LEFT JOIN public.stores s ON ((rewards.store_id = s.id)))
     LEFT JOIN public.store_groups sg ON ((rewards.store_group_id = sg.id)))
  WITH NO DATA;


ALTER TABLE public.reward_search OWNER TO postgres;

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
-- Name: system_errors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_errors (
    id integer NOT NULL,
    error_type character varying(64) NOT NULL,
    description character varying(255) NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.system_errors OWNER TO postgres;

--
-- Name: system_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_errors_id_seq OWNER TO postgres;

--
-- Name: system_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_errors_id_seq OWNED BY public.system_errors.id;


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
-- Name: user_favorite_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_favorite_posts (
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.user_favorite_posts OWNER TO postgres;

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
    last_redeemed_at timestamp with time zone,
    redeemed_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_rewards OWNER TO postgres;

--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: comment_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes ALTER COLUMN id SET DEFAULT nextval('public.comment_likes_id_seq'::regclass);


--
-- Name: comment_replies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies ALTER COLUMN id SET DEFAULT nextval('public.comment_replies_id_seq'::regclass);


--
-- Name: comment_reply_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_reply_likes ALTER COLUMN id SET DEFAULT nextval('public.comment_reply_likes_id_seq'::regclass);


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
-- Name: post_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes ALTER COLUMN id SET DEFAULT nextval('public.post_likes_id_seq'::regclass);


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
-- Name: system_errors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_errors ALTER COLUMN id SET DEFAULT nextval('public.system_errors_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, username, store_id, created_at, hash) FROM stdin;
9	donutcat	8	2019-09-24 20:50:21.47+10	$2b$10$96c0pL7AwM6H51wP5XJodOBa2VM32jFN5xhtdP3tED6GBYg4c2Pw6
8	cinnamoncat	3	2019-09-15 18:43:32.443+10	$2b$10$96c0pL7AwM6H51wP5XJodOBa2VM32jFN5xhtdP3tED6GBYg4c2Pw6
10	bobacat	\N	2019-10-02 20:11:32.012+10	$2b$10$GNkNdIcO132ajWMeBgTbyOhTNrp2T1ijm4KnjCOTgPzZUer7u..qK
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, name, district_id, coords) FROM stdin;
1	Sydney	1	(-33.794882999999999,151.26807099999999)
\.


--
-- Data for Name: comment_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_likes (user_id, comment_id, id, store_id) FROM stdin;
2	2	1	\N
2	3	2	\N
2	1	3	\N
2	29	4	\N
2	47	5	\N
\.


--
-- Data for Name: comment_replies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_replies (id, comment_id, body, replied_by, replied_at, replied_by_store) FROM stdin;
1	1	This is lit!!!	3	2019-07-10 07:25:47.16+10	\N
2	1	Totally.	1	2019-07-10 07:26:41.436+10	\N
7	1	meow meow	2	2019-07-20 16:48:18.956+10	\N
10	1	meow	2	2019-07-20 17:01:33.864+10	\N
11	1	Unilever	2	2019-07-20 17:04:02.375+10	\N
19	1	@curious_chloe that's so true	2	2019-07-21 16:16:10.225+10	\N
20	1	@curious_chloe so true	2	2019-07-21 16:36:43.647+10	\N
21	1	@curious_chloe hello kitty	2	2019-07-21 16:37:27.432+10	\N
24	53	@curious_chloe super meow meow	2	2019-07-28 15:36:16.436+10	\N
45	58	@curious_chloe a	2	2019-07-28 17:22:07.529+10	\N
46	58	@curious_chloe b	2	2019-07-28 17:22:15.68+10	\N
\.


--
-- Data for Name: comment_reply_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_reply_likes (user_id, reply_id, id, store_id) FROM stdin;
2	2	1	\N
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, body, commented_by, commented_at, commented_by_store) FROM stdin;
4	133	that's one cute melon	2	2019-07-14 04:22:52.803+10	\N
1	1	this is brill, we are totally coming here next week, how about we go together after our seminar at the beach where we will have a fantastic time? I can't wait for the seminar it's going to be interactive and so full-on, I think I'm going to be knackered afterwards.	3	2019-07-11 06:31:33.937+10	\N
3	1	how much did this all cost???	1	2019-07-14 06:31:44.507+10	\N
2	1	omg this looks amaze	2	2019-07-15 05:31:21.677+10	\N
5	1	hello	2	2019-07-20 13:38:27.893+10	\N
7	1	meow meow 	2	2019-07-20 13:39:08.21+10	\N
8	1	super	2	2019-07-20 14:29:54.154+10	\N
9	1	hello	2	2019-07-20 14:32:07.247+10	\N
10	1	hello	2	2019-07-20 14:44:38.498+10	\N
11	1	kitty	2	2019-07-20 14:45:06.082+10	\N
12	1	kitty	2	2019-07-20 14:47:26.688+10	\N
13	1	kitty katw	2	2019-07-20 14:48:34.264+10	\N
14	1	hello meow meow	2	2019-07-20 14:48:52.294+10	\N
15	1	hello meow meow	2	2019-07-20 14:53:32.182+10	\N
16	1	super duper	2	2019-07-20 14:53:40.964+10	\N
17	1	pork bun	2	2019-07-20 15:27:25.675+10	\N
18	1	boiiii	2	2019-07-20 15:29:17.278+10	\N
19	1	hhh	2	2019-07-20 15:51:43.249+10	\N
20	1	super	2	2019-07-20 15:51:55.931+10	\N
21	1	hhhhhh	2	2019-07-20 15:52:48.822+10	\N
22	1	jello	2	2019-07-20 15:58:29.606+10	\N
24	1	cake	2	2019-07-20 16:00:46.821+10	\N
25	1	pizza	2	2019-07-20 16:00:50.511+10	\N
26	1	Mona Lisa	2	2019-07-20 16:02:39.831+10	\N
28	1	Cheesecake	2	2019-07-20 16:03:44.592+10	\N
29	1	Cheesey	2	2019-07-20 16:03:50.858+10	\N
30	1	super	2	2019-07-20 16:03:57.596+10	\N
36	1	super duper!	2	2019-07-20 20:02:50.236+10	\N
37	1	test	2	2019-07-21 15:56:38.581+10	\N
38	1	super	2	2019-07-21 15:58:39.51+10	\N
39	1	. Hello	2	2019-07-21 16:00:59.515+10	\N
40	1	hehe	2	2019-07-21 16:01:37.143+10	\N
41	1	Vaseline	2	2019-07-21 16:05:31.905+10	\N
42	1	rosy	2	2019-07-21 16:05:41.395+10	\N
43	1	lip therapy	2	2019-07-21 16:07:26.228+10	\N
44	1	a moment ago	2	2019-07-21 16:07:32.083+10	\N
46	1	super	2	2019-07-21 16:08:46.043+10	\N
47	1	mafia 	2	2019-07-21 16:29:28.469+10	\N
48	1	robert	2	2019-07-21 16:30:43.893+10	\N
49	1	the list	2	2019-07-21 16:32:03.093+10	\N
50	134	meow meow	1	2019-07-21 19:47:43.955+10	\N
52	134	ccc meow	1	2019-07-21 19:52:03.98+10	\N
53	133	hello kitty	2	2019-07-28 15:36:11.085+10	\N
57	2	hello kitty	2	2019-07-28 16:31:14.732+10	\N
58	2	a	2	2019-07-28 17:20:58.86+10	\N
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
-- Data for Name: post_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_likes (user_id, post_id, id, store_id) FROM stdin;
2	3	3	\N
2	139	4	\N
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
383	216	https://firebasestorage.googleapis.com/v0/b/burntbutter-fix.appspot.com/o/reviews%2Fpost-photos%2F1570703668147-971.jpg?alt=media&token=757bb0c3-c246-4b8c-b872-a26b716a2574
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
202	211	good	okay	good	okay	good	Great service. Great coffee. I now visit here every weekend. Dog-friendly cafe with drinking bowls near the front door. I bring my cute puppies here and they love it too.
207	216	\N	\N	\N	\N	\N	if you could count the skeletons in my closet.
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, type, store_id, posted_by, like_count, comment_count, hidden, posted_at, posted_by_admin) FROM stdin;
5	photo	3	1	0	0	f	2018-05-06 17:58:09.777+10	\N
4	review	3	2	0	0	f	2018-02-18 09:22:02.385+11	\N
6	photo	2	3	0	0	f	2018-06-07 06:40:00.804+10	\N
8	review	3	4	0	0	f	2018-08-08 12:33:21.072+10	\N
7	photo	2	4	0	0	f	2018-07-12 22:12:23.453+10	\N
137	review	3	5	0	0	f	2019-07-24 19:48:06.909+10	\N
136	review	3	3	0	0	f	2019-07-24 19:46:49.818+10	\N
142	review	4	\N	0	0	f	2019-08-04 16:50:14.116+10	\N
143	review	4	\N	0	0	f	2019-08-04 17:18:08.668+10	\N
146	review	3	\N	0	0	f	2019-08-18 15:53:54.409+10	\N
147	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
148	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
149	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
150	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
151	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
152	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
153	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
154	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
155	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
156	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
157	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
158	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
159	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
160	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
161	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
162	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
163	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
164	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
165	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
166	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
167	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
168	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
169	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
170	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
171	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
172	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
173	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
174	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
175	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
176	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
177	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
178	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
179	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
180	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
181	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
182	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
183	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
184	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
185	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
186	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
187	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
188	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
189	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
190	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
191	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
192	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
193	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
194	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
195	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
196	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
197	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
198	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
199	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
200	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
201	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
202	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
203	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
204	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
205	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
206	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
207	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
208	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
209	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
210	review	3	2	0	0	f	2019-08-18 15:53:54.409+10	\N
211	review	8	2	0	0	f	2019-09-11 20:29:48.866+10	\N
3	photo	2	1	1	0	f	2019-02-07 23:54:38.249+11	\N
139	review	4	2	1	0	f	2019-07-28 15:13:56.516+10	\N
134	review	4	2	0	2	f	2019-07-07 21:39:08.342+10	\N
1	review	1	1	0	39	f	2019-01-20 02:04:20+11	\N
133	review	23	2	0	2	f	2019-07-07 16:03:48.854+10	\N
2	review	1	2	0	2	f	2018-01-25 20:10:55+11	\N
216	review	8	\N	0	0	f	2019-10-10 21:33:51.937+11	9
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

COPY public.rewards (id, name, description, type, store_id, store_group_id, valid_from, valid_until, promo_image, terms_and_conditions, active, hidden, redeem_limit, code, rank, tags, coords) FROM stdin;
14	$1 off Mondays ☕	Pick me up Monday, get $1 off for any large drink, smoothie, and ice drinks.	one_time	25	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/9/16567979/91f31c5f267624ef8cf2ec31916fcefb.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	Jjjk2	99	coffe,cafe	{"(-33.882722000000001,151.21450300000001)"}
12	Bring Your Own Cup Discount ☕	Take 50c off your coffee whenever you come to Mecca and bring your own cup or mug.	one_time	30	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/reviews_photos/cbb/9405cae7439688208e7028157cffccbb_1541840677.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	QQ9WR	99	coffee,cafe	{"(-33.782896000000001,151.26756599999999)"}
13	Free Upsize 🍵	Feelin' chilly this winter? Visit Bean Code and pick up a limited edition hot taro bean milk. Free upsize available on any drink on the menu from medium to large.	one_time	34	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/6/17742416/42bdf07396559691b7c687382fa8b2cb.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	QQjk2	99	bean,drink,milk tea,bubble tea	{"(-33.796928000000001,151.18362400000001)"}
15	$20 Pizza 🍕	Come in on Wednesday night and pick up any medium pizza for $20 from our classic range.	one_time	22	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/reviews_photos/28b/dc5c64e51622552c5312ded510ad028b_1556783562.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	jk92z	99	coffe,cafe	{"(-33.828257000000001,151.14623599999999)"}
6	$20 off $40 spend 💸	Enjoy our delicious wood-fired authentic Italian pizzas and hand-crafted pastas. Get $20 off when you spend over $40.	one_time	22	\N	2018-12-02	2020-05-05	https://imgur.com/tSE2cXf.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	9WRjf	1	italian,pizza,pasta	{"(-33.828257000000001,151.14623599999999)"}
7	Free Coffee ☕	Purchase one of our finest authentic Kurtosh and receive any large coffee for free.	one_time	20	\N	2019-01-01	2019-12-01	https://imgur.com/9ydUqpJ.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	c9VXr	1	coffee,cafe	{"(-33.874538000000001,151.20067700000001)"}
11	Free Size Upgrade 🍦	Free size upgrade whenever you purchase a soft serve. All our products are a work of art.	one_time	29	\N	2018-12-02	2020-05-05	https://b.zmtcdn.com/data/pictures/chains/4/16570514/ee9842022e181961c1f1b909b63ae303.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	PP9WR	99	ice cream,soft serve,dessert,sweet	{"(-33.874670999999999,151.20650900000001)"}
2	Free Toppings! 🍮	Come enjoy our mouth-watering tasty teas, enjoy a free topping of your choice when you purchase any large drink.	one_time	\N	3	2018-11-01	2020-08-23	https://imgur.com/KMzxoYx.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	WhCDD	1	milk tea,bubble tea	{"(-33.795578999999996,151.185439)","(-33.873831000000003,151.20563799999999)","(-33.881093,151.204746)","(-33.877578999999997,151.20545999999999)","(-33.859076999999999,151.20815099999999)","(-33.884374000000001,151.19529600000001)","(-33.794479000000003,151.185959)"}
1	Double Mex Tuesday 🌯	Buy two regular or naked burritos and get the cheaper one for free. Add two drinks for only $2! Hurry, only available this Tuesday.	unlimited	\N	4	2018-11-01	2020-05-05	https://imgur.com/tR1bD1v.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	W6JVB	1	burrito,mexican	{"(-33.865963000000001,151.20821699999999)","(-33.871730999999997,151.19897499999999)","(-33.862026999999998,151.20987500000001)"}
8	Tea Latte Tuesday ☕	Get together for Tea Latte Tuesday. Buy a Teavana Tea Latte & score another one for FREE to share!	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/o4bRN3i.jpg	Every Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend!\r\n\r\nFree beverage must be of equal or lesser value.\r\n\r\nFrappuccino® blended beverages are excluded.\r\n\r\nEnds 26 August 2019.	t	t	1	4pPfr	99	tea,latte,coffee,cafe	{"(-33.839401000000002,151.20946599999999)"}
5	Half Price Soup Dumplings 🥟	To celebrate our grand opening, order our signature soup dumplings for only half price when you spend over $25. Available both lunch and dinner.	one_time	21	\N	2018-12-25	2020-07-09	https://imgur.com/bjJ3S72.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	JbgQP	99	chinese,dumplings	{"(-33.870510000000003,151.208923)"}
9	$3 Bagel 🥯	Nothing's better than a delicious bagel for a brighter start to the day, top it off with your favourite spread.	one_time	3	\N	2019-01-01	2019-12-01	https://imgur.com/yYaJYSI.jpg	Offer only available before 10am. \r\n\r\nEvery Tuesday, buy any size Teavana™ Tea Latte (Green Tea Latte, Chai Tea Latte, Vanilla Black Tea Latte, Peach Black Tea Latte or Full Leaf Tea Latte) and score another one for FREE to surprise a friend! \r\n\r\nFree beverage must be of equal or lesser value. \r\n\r\nFrappuccino® blended beverages are excluded. \r\n\r\nOffer ends 26 August 2019.\r\n	t	t	1	BKKWL	99	cafe,bagel,coffee	{"(-33.839401000000002,151.20946599999999)"}
17	Buy 3 get 1 free 🍵	It's simple, buy a coffee, get a star, collect 3 stars and get a free medium coffee on the house! Come talk to our friendly staff for more info. A loyalty card you can't lose.	loyalty	8	\N	2018-11-01	2020-11-05	https://b.zmtcdn.com/data/reviews_photos/d2c/a40be30a1b16c34457b2eab1490aed2c_1526978870.jpg	Offer only applies medium or large drinks.\r\nNot to be used in conjunction with any other offer.	t	f	3	9J99Q	99	coffee,cafe	{"(-33.880653000000002,151.20675199999999)"}
16	Bingsoo Tuesday 🍦	Bingsoo Bingtwo, buy two for the price of one every Tuesday. Come into any of our participating stores, offer ends when summer is over!	unlimited	36	\N	2018-11-01	2020-11-05	https://b.zmtcdn.com/data/reviews_photos/741/b77fbeea14a19205042456a45e037741_1536399624.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	PL9Zz	99	bingsoo,sweet,ice cream,dessert, soft serve	{"(-33.878081999999999,151.20494099999999)"}
18	$3 Bagel 🥯	Pay $1 for a bagel when you purchase a coffee. Offer applies one per person.	unlimited	8	\N	2018-11-01	2020-11-05	https://i.imgur.com/hVS4Sb1.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	\N	9J9KM	99	cafe,bagel,coffee	{"(-33.880653000000002,151.20675199999999)"}
19	Get $5 off Macarons 🎂	Get $5 off your purchase when you purchase a 12 or 18 box of Macarons of assorted flavours. Offer applies one per person.	one_time	8	\N	2018-11-01	2020-11-05	https://i.imgur.com/b4FTcEP.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	ZJ6JJ	99	cafe,bagel,coffee,sweets,macarons	{"(-33.880653000000002,151.20675199999999)"}
3	Free Loaded Fries 🍟	8bit is all about the good times, with its wickedly delicious take on classic burgers, hotdogs, epic loaded fries and shakes. Come try one of our delicious burgers or hotdogs and get an epic loaded fries for free.	one_time	9	\N	2018-11-01	2018-05-05	https://imgur.com/3woCfTC.jpg	Offer only applies to full price items.\r\nNot to be used in conjunction with any other offer.	t	f	1	RRW2h	1	fries,burger,fast-food	{"(-33.872760999999997,151.20533800000001)"}
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
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

COPY public.stores (id, name, phone_country, phone_number, location_id, suburb_id, city_id, cover_image, "order", rank, follower_count, review_count, store_count, z_id, z_url, more_info, avg_cost, coords) FROM stdin;
6	Cié Lest	+61	291111089	\N	4	1	https://imgur.com/euQ3uUf.jpg	5	99	0	0	0	\N	\N	\N	\N	(-33.877929999999999,151.21312)
7	Pablo & Rusty's Sydney CBD	+61	281898789	\N	4	1	https://imgur.com/H7hHQe6.jpg	7	99	0	0	0	\N	\N	\N	\N	(-33.872311000000003,151.20906099999999)
9	8bit	+61	295511312	6	5	1	https://imgur.com/bmvua2K.jpg	9	99	0	0	0	\N	\N	\N	\N	(-33.872760999999997,151.20533800000001)
8	Maximus Cafe	+61	281565555	4	1	1	https://imgur.com/B3NiiYR.jpg	8	99	0	0	0	\N	\N	\N	\N	(-33.880653000000002,151.20675199999999)
10	CoCo Fresh Tea & Juice	+61	295511312	7	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.795578999999996,151.185439)
12	CoCo Fresh Tea & Juice	+61	295511312	10	1	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.873831000000003,151.20563799999999)
11	CoCo Fresh Tea & Juice	+61	295511312	9	9	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.881093,151.204746)
2	Sokyo	+61	295258017	\N	1	1	https://imgur.com/9zJ9GvA.jpg	2	1	1	3	0	\N	\N	\N	\N	(-33.869546,151.19551799999999)
1	Dumplings & Co.	+61	296992235	5	2	1	https://imgur.com/9aGBDLY.jpg	1	1	1	2	0	\N	\N	\N	\N	(-33.796928000000001,151.18362400000001)
4	The Walrus Cafe	+61	289910090	\N	3	1	https://imgur.com/rxOxA57.jpg	4	1	1	4	0	\N	\N	\N	\N	(-33.874001,151.20836199999999)
5	Frankie's Pizza	+61	298810099	\N	3	1	https://imgur.com/q9978qK.jpg	6	1	1	0	0	\N	\N	\N	\N	(-33.865898000000001,151.209641)
3	Workshop Meowpresso	+61	288819222	4	1	1	https://i.imgur.com/sLPotj2.jpg	3	1	1	5	0	\N	\N	\N	\N	(-33.839401000000002,151.20946599999999)
13	CoCo Fresh Tea & Juice	+61	295511312	11	2	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.877578999999997,151.20545999999999)
16	CoCo Fresh Tea & Juice	+61	295511312	\N	10	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.859076999999999,151.20815099999999)
14	CoCo Fresh Tea & Juice	+61	295511312	\N	7	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.884374000000001,151.19529600000001)
15	CoCo Fresh Tea & Juice	+61	295511312	\N	8	1	https://imgur.com/KMzxoYx.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.794479000000003,151.185959)
18	Mad Mex	+61	295511312	13	12	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.865963000000001,151.20821699999999)
17	Mad Mex	+61	295511312	12	1	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.871730999999997,151.19897499999999)
19	Mad Mex	+61	295511312	14	11	1	https://imgur.com/tR1bD1v.jpg	14	99	0	0	0	\N	\N	\N	\N	(-33.862026999999998,151.20987500000001)
20	Kürtősh	+61	93562436	\N	12	1	https://imgur.com/q6gqaXm.jpg	10	99	0	0	0	\N	\N	\N	\N	(-33.874538000000001,151.20067700000001)
21	New Shanghai	+61	926761888	15	2	1	https://imgur.com/RVrwxN7.jpg	11	99	0	0	0	\N	\N	\N	\N	(-33.870510000000003,151.208923)
23	Anastasia Café and Eatery	+61	281565511	4	1	1	https://imgur.com/7xdUPm4.jpg	13	99	0	1	0	\N	\N	\N	\N	(-33.815316000000003,151.15152599999999)
25	Bills	+61	998997123	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/c28/5af30180b449cff001d2d41eb5cd2c28_1544341757.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.882722000000001,151.21450300000001)
26	Lorraine's Patisserie	+61	977551355	\N	13	1	https://b.zmtcdn.com/data/pictures/5/16566535/6f55afcd0e5c7b30645c4edae6303efc.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.866321999999997,151.20765700000001)
27	Flour & Stone	+61	291191111	\N	12	1	https://b.zmtcdn.com/data/pictures/6/16564656/4ded590717ab792f34cff33c9fde11e3.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.874122,151.21542099999999)
29	Aqua S	+61	298897771	\N	13	1	https://b.zmtcdn.com/data/reviews_photos/dd9/6e036069be9cb6f5f230c17f0cfcadd9_1552339233.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.874670999999999,151.20650900000001)
31	Bubble Nini	+61	295258017	4	1	1	https://b.zmtcdn.com/data/pictures/3/17745593/2a0d941a5c71cc9e6b1a67b336dfe2a6.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.814349999999997,151.170197)
30	Mecca Coffee Specialists	+61	298897771	\N	9	1	https://b.zmtcdn.com/data/reviews_photos/885/9275c0ec1e2ef00f4b0cd92852abc885_1477301450.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.782896000000001,151.26756599999999)
33	Mr. Tea	+61	93562436	\N	12	1	https://b.zmtcdn.com/data/pictures/4/15547454/1a52ca1626e3070bfebb32d9ca568e2d.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.878269000000003,151.203293)
32	The Moment	+61	281898789	14	11	1	http://b.zmtcdn.com/data/reviews_photos/45e/9909395d1ccafe5e637890950810645e_1521863198.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.796137000000002,151.182298)
34	Bean Code	+61	281898789	\N	4	1	https://b.zmtcdn.com/data/pictures/6/17742416/677976c7ecb967c9632e5e9005912994_featured_v2.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.796928000000001,151.18362400000001)
36	Koomi	+61	291111089	\N	7	1	https://b.zmtcdn.com/data/pictures/chains/6/17747176/a5738e150615432b80bcfbdb9e83f0f5.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.878081999999999,151.20494099999999)
37	Chapayum	+61	288819222	\N	13	1	https://b.zmtcdn.com/data/pictures/7/19018017/7c2119e91ec0f4e8c8bbb7302fa23e27.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.873683999999997,151.207336)
38	Choux Love	+61	93562436	\N	1	1	https://b.zmtcdn.com/data/reviews_photos/372/13299ecd4b16d6b896a09836b1628372_1522897753.jpg	1	99	0	0	0	\N	\N	\N	\N	(-33.87677,151.20422400000001)
60	Le Meow	+61	(02) 9211 3568	17	13	1	https://b.zmtcdn.com/data/reviews_photos/21e/cc0377b2af177b44aade56e1ed7eb21e_1542718407.jpg	1	99	0	0	0	sydney/le-meow-surry-hills	https://www.zomato.com/sydney/le-meow-surry-hills	Breakfast,Takeaway Available,No Alcohol Available	40	(-33.859780999999998,151.20852600000001)
22	Zapparellis Pizza	+61	965511555	\N	120	1	https://imgur.com/mCuCc8p.jpg	12	99	0	0	0	\N	\N	\N	\N	(-33.828257000000001,151.14623599999999)
\.


--
-- Data for Name: suburbs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suburbs (id, name, city_id, postcode, document, coords) FROM stdin;
5	Haymarket	1	2000	'haymarket':1	(-33.880777000000002,151.20279600000001)
8	Ultimo	1	2007	'ultimo':1	(-33.878416000000001,151.197272)
9	Glebe	1	2037	'glebe':1	(-33.880814999999998,151.187791)
4	Bathurst	1	2795	'bathurst':1	(-33.419780000000003,149.57425799999999)
3	Broken Hill	1	2880	'broken':1 'hill':2	(-31.959192999999999,141.46661399999999)
1	Sydney CBD	1	2000	'cbd':2 'sydney':1	(-33.794882999999999,151.26807099999999)
6	Town Hall	1	2000	'hall':2 'town':1	(-33.794882999999999,151.26807099999999)
7	Chinatown	1	2000	'chinatown':1	(-33.794882999999999,151.26807099999999)
102	Camperdown	1	2050	'camperdown':1	(-33.888660000000002,151.177188)
98	Drummoyne	1	2047	'drummoyn':1	(-33.851056,151.15454199999999)
423	Marrickville	1	2204	'marrickvill':1	(-33.910922999999997,151.15718699999999)
433	Kingsgrove	1	2208	'kingsgrov':1	(-33.939481000000001,151.098941)
482	Miranda	1	2228	'miranda':1	(-34.034013999999999,151.10042799999999)
484	Caringbah	1	2229	'caringbah':1	(-34.04316,151.12310199999999)
117	St Leonards	1	2065	'leonard':2 'st':1	(-33.823248,151.195504)
184	Manly	1	2095	'man':1	(-33.797144000000003,151.28804)
203	Mona Vale	1	2103	'mona':1 'vale':2	(-33.677070000000001,151.30031600000001)
250	Epping	1	2121	'ep':1	(-33.772548999999998,151.08236500000001)
304	Seven Hills	1	2147	'hill':2 'seven':1	(-33.775477000000002,150.934257)
255	Parramatta	1	2124	'parramatta':1	(-33.816957000000002,151.00345100000001)
314	Parramatta	1	2150	'parramatta':1	(-33.816957000000002,151.00345100000001)
2135	St Marys	1	2760	'mari':2 'st':1	(-33.766759999999998,150.77401499999999)
625	Silverwater	1	2264	'silverwat':1	(-33.101384000000003,151.56199000000001)
292	Auburn	1	2144	'auburn':1	(-33.849322000000001,151.033421)
374	Moorebank	1	2170	'moorebank':1	(-33.933805,150.95360199999999)
1697	Ingleburn	1	2565	'ingleburn':1	(-33.998717999999997,150.866344)
2259	The Rocks	1	2795	'rock':2	(-33.425080000000001,149.42487199999999)
83	Balmain East	1	2041	'balmain':1 'east':2	(-33.857832999999999,151.19059799999999)
955	Enmore	1	2350	'enmor':1	(-30.721540999999998,151.73161899999999)
979	Enmore	1	2358	'enmor':1	(-30.721540999999998,151.73161899999999)
89	Tempe	1	2044	'temp':1	(-33.924776999999999,151.16074699999999)
92	Canada Bay	1	2046	'bay':2 'canada':1	(-33.863194,151.116398)
99	Stanmore	1	2048	'stanmor':1	(-33.897351,151.16534999999999)
108	North Sydney	1	2060	'north':1 'sydney':2	(-33.838265,151.206481)
111	Cammeray	1	2062	'cammeray':1	(-33.821953000000001,151.21043)
118	Wollstonecraft	1	2065	'wollstonecraft':1	(-33.828158000000002,151.19662099999999)
124	Northwood	1	2066	'northwood':1	(-33.829732,151.177751)
129	North Willoughby	1	2068	'north':1 'willoughbi':2	(-33.793089000000002,151.195787)
134	Roseville Chase	1	2069	'chase':2 'rosevill':1	(-33.778902000000002,151.19519500000001)
142	West Pymble	1	2073	'pymbl':2 'west':1	(-33.760382999999997,151.12603799999999)
146	Warrawee	1	2074	'warrawe':1	(-33.722839,151.12613400000001)
151	North Wahroonga	1	2076	'north':1 'wahroonga':2	(-33.702703999999997,151.12317899999999)
157	Mount Kuring-gai	1	2080	'gai':4 'kure':3 'kuring-gai':2 'mount':1	(-33.628729,151.22679199999999)
164	Milsons Passage	1	2083	'milson':1 'passag':2	(-33.518967000000004,151.17654099999999)
171	Forestville	1	2087	'forestvill':1	(-33.762011000000001,151.21405999999999)
176	Cremorne Point	1	2090	'cremorn':1 'point':2	(-33.844470000000001,151.22823099999999)
182	Manly Vale	1	2093	'man':1 'vale':2	(-33.784036,151.267315)
185	Queenscliff	1	2096	'queenscliff':1	(-33.784595000000003,151.28781699999999)
192	North Curl Curl	1	2099	'curl':2,3 'north':1	(-33.761651999999998,151.29569100000001)
196	Oxford Falls	1	2100	'fall':2 'oxford':1	(-33.730196999999997,151.24821800000001)
199	North Narrabeen	1	2101	'narrabeen':2 'north':1	(-33.702660999999999,151.293622)
209	Newport	1	2106	'newport':1	(-33.659896000000003,151.30931200000001)
211	Whale Beach	1	2107	'beach':2 'whale':1	(-33.614274000000002,151.33043799999999)
219	Woolwich	1	2110	'woolwich':1	(-33.838393000000003,151.17253500000001)
225	Tennyson Point	1	2111	'point':2 'tennyson':1	(-33.831448000000002,151.11728600000001)
229	Denistone East	1	2113	'deniston':1 'east':2	(-33.797176999999998,151.09754599999999)
241	Dundas	1	2117	'dunda':1	(-33.799405,151.04418899999999)
244	Carlingford	1	2118	'carlingford':1	(-33.782958999999998,151.047707)
251	North Epping	1	2121	'ep':2 'north':1	(-33.759777,151.08774199999999)
258	Homebush Bay	1	2127	'bay':2 'homebush':1	(-33.852829999999997,151.07618600000001)
688	Summer Hill	1	2287	'hill':2 'summer':1	(-32.478428000000001,151.51941299999999)
265	Croydon Park	1	2133	'croydon':1 'park':2	(-33.895299000000001,151.10858099999999)
272	Concord	1	2137	'concord':1	(-33.857857000000003,151.10350199999999)
276	Liberty Grove	1	2138	'grove':2 'liberti':1	(-33.841664999999999,151.083609)
281	Lidcombe	1	2141	'lidcomb':1	(-33.865217999999999,151.043519)
283	Rosehill	1	2142	'rosehil':1	(-33.819991999999999,151.02455800000001)
291	Regents Park	1	2143	'park':2 'regent':1	(-33.883927999999997,151.023796)
300	South Wentworthville	1	2145	'south':1 'wentworthvill':2	(-33.823892000000001,150.96937600000001)
307	Lalor Park	1	2147	'lalor':1 'park':2	(-33.761339,150.93033700000001)
311	Marayong	1	2148	'marayong':1	(-33.746167999999997,150.898338)
320	Bella Vista	1	2153	'bella':1 'vista':2	(-33.737344999999998,150.95500999999999)
324	Kellyville Ridge	1	2155	'kellyvill':1 'ridg':2	(-33.700104000000003,150.92865)
868	Dural	1	2330	'dural':1	(-32.568857999999999,150.84364199999999)
331	Middle Dural	1	2158	'dural':2 'middl':1	(-33.648471000000001,151.021276)
337	Merrylands West	1	2160	'merryland':1 'west':2	(-33.832864000000001,150.972036)
343	Chester Hill	1	2162	'chester':1 'hill':2	(-33.883156999999997,151.00118499999999)
1137	Lansdowne	1	2430	'lansdown':1	(-31.782989000000001,152.53457900000001)
348	Wetherill Park	1	2164	'park':2 'wetheril':1	(-33.847512000000002,150.91320400000001)
355	Cabramatta West	1	2166	'cabramatta':1 'west':2	(-33.899135999999999,150.91751400000001)
360	Ashcroft	1	2168	'ashcroft':1	(-33.917586999999997,150.89909499999999)
365	Hinchinbrook	1	2168	'hinchinbrook':1	(-33.916611000000003,150.86386300000001)
370	Hammondville	1	2170	'hammondvill':1	(-33.948112999999999,150.95372699999999)
377	Warwick Farm	1	2170	'farm':2 'warwick':1	(-33.913423000000002,150.93275199999999)
381	Middleton Grange	1	2171	'grang':2 'middleton':1	(-33.914093000000001,150.843547)
389	Horsley Park	1	2175	'horsley':1 'park':2	(-33.845033999999998,150.84819200000001)
395	St Johns Park	1	2176	'john':2 'park':3 'st':1	(-33.885824,150.90540300000001)
401	Mount Vernon	1	2178	'mount':1 'vernon':2	(-33.862377000000002,150.80788699999999)
406	Mount Lewis	1	2190	'lewi':2 'mount':1	(-33.917157000000003,151.04783800000001)
411	Hurlstone Park	1	2193	'hurlston':1 'park':2	(-33.909964000000002,151.13224)
417	Bass Hill	1	2197	'bass':1 'hill':2	(-33.900607999999998,150.99288799999999)
422	Dulwich Hill	1	2203	'dulwich':1 'hill':2	(-33.904688999999998,151.13877400000001)
429	Bardwell Park	1	2207	'bardwel':1 'park':2	(-33.932070000000003,151.12559400000001)
439	Lugarno	1	2210	'lugarno':1	(-33.982956000000001,151.046942)
440	Padstow	1	2211	'padstow':1	(-33.953915000000002,151.038163)
444	East Hills	1	2213	'east':1 'hill':2	(-33.963358999999997,150.986695)
449	Brighton-le-sands	1	2216	'brighton':2 'brighton-le-sand':1 'le':3 'sand':4	(-33.960538,151.155362)
457	Ramsgate Beach	1	2217	'beach':2 'ramsgat':1	(-33.981113999999998,151.14830000000001)
464	Hurstville Grove	1	2220	'grove':2 'hurstvill':1	(-33.980652999999997,151.09113600000001)
466	South Hurstville	1	2221	'hurstvill':2 'south':1	(-33.977595000000001,151.10490899999999)
475	Sylvania Waters	1	2224	'sylvania':1 'water':2	(-34.019801999999999,151.115847)
481	Gymea Bay	1	2227	'bay':2 'gymea':1	(-34.048155999999999,151.08608699999999)
1530	Lilli Pilli	1	2536	'lilli':1 'pilli':2	(-35.773316999999999,150.225056)
487	Port Hacking	1	2229	'hack':2 'port':1	(-34.067503000000002,151.12244899999999)
493	Woolooware	1	2230	'wooloowar':1	(-34.048276000000001,151.14143100000001)
498	Kirrawee	1	2232	'kirrawe':1	(-34.033743000000001,151.07119599999999)
503	Heathcote	1	2233	'heathcot':1	(-34.079112000000002,151.00861900000001)
507	Alfords Point	1	2234	'alford':1 'point':2	(-33.993302999999997,151.02475100000001)
515	East Gosford	1	2250	'east':1 'gosford':2	(-33.438533999999997,151.35416699999999)
521	Lisarow	1	2250	'lisarow':1	(-33.380842999999999,151.37128300000001)
525	Mount White	1	2250	'mount':1 'white':2	(-33.461404000000002,151.19061199999999)
529	Point Clare	1	2250	'clare':2 'point':1	(-33.436771999999998,151.32095200000001)
517	West Gosford	1	2250	'gosford':2 'west':1	(-33.420828999999998,151.321753)
539	Green Point	1	2251	'green':1 'point':2	(-32.251759,152.516738)
545	Koolewong	1	2256	'koolewong':1	(-33.466320000000003,151.31816000000001)
550	Booker Bay	1	2257	'bay':2 'booker':1	(-33.511566000000002,151.34477999999999)
554	Hardys Bay	1	2257	'bay':2 'hardi':1	(-33.525157,151.35744)
559	Kangy Angy	1	2258	'angi':2 'kangi':1	(-33.322397000000002,151.39506299999999)
564	Gwandalan	1	2259	'gwandalan':1	(-33.139561,151.58757199999999)
569	Lake Munmorah	1	2259	'lake':1 'munmorah':2	(-33.194147999999998,151.57042000000001)
574	Summerland Point	1	2259	'point':2 'summerland':1	(-33.139085000000001,151.56543099999999)
580	Watanobbi	1	2259	'watanobbi':1	(-33.269072000000001,151.431783)
584	Wyongah	1	2259	'wyongah':1	(-33.274858999999999,151.49037999999999)
588	North Avoca	1	2260	'avoca':2 'north':1	(-33.459007,151.435833)
594	Chittaway Bay	1	2261	'bay':2 'chittaway':1	(-33.327759999999998,151.429428)
600	Shelly Beach	1	2261	'beach':2 'shelli':1	(-33.368675000000003,151.48568700000001)
605	Blue Haven	1	2262	'blue':1 'haven':2	(-33.207351000000003,151.492751)
610	San Remo	1	2262	'remo':2 'san':1	(-33.209738000000002,151.51616000000001)
615	Norah Head	1	2263	'head':2 'norah':1	(-33.279786000000001,151.55505299999999)
620	Dora Creek	1	2264	'creek':2 'dora':1	(-33.083587000000001,151.50180700000001)
627	Yarrawonga Park	1	2264	'park':2 'yarrawonga':1	(-33.100921999999997,151.544375)
632	Killingworth	1	2278	'killingworth':1	(-32.934544000000002,151.56084100000001)
637	Croudace Bay	1	2280	'bay':2 'croudac':1	(-33.004919999999998,151.64348799999999)
643	Cams Wharf	1	2281	'cam':1 'wharf':2	(-33.127823999999997,151.62158500000001)
648	Swansea	1	2281	'swansea':1	(-33.089429000000003,151.637046)
652	Arcadia Vale	1	2283	'arcadia':1 'vale':2	(-33.060343000000003,151.57581500000001)
658	Carey Bay	1	2283	'bay':2 'carey':1	(-33.027126000000003,151.60583600000001)
662	Fishing Point	1	2283	'fish':1 'point':2	(-33.050651999999999,151.590191)
668	Booragul	1	2284	'booragul':1	(-32.976125000000003,151.60588999999999)
672	Woodrising	1	2284	'woodris':1	(-32.982483000000002,151.60519199999999)
676	Cardiff South	1	2285	'cardiff':1 'south':2	(-32.957742000000003,151.66144700000001)
682	Birmingham Gardens	1	2287	'birmingham':1 'garden':2	(-32.890844000000001,151.69082900000001)
689	Wallsend	1	2287	'wallsend':1	(-32.904102999999999,151.667396)
694	Kotara	1	2289	'kotara':1	(-32.939950000000003,151.694692)
698	Dudley	1	2290	'dudley':1	(-32.989683999999997,151.71958000000001)
775	Hillsborough	1	2320	'hillsborough':1	(-32.636820999999998,151.46775600000001)
702	Mount Hutton	1	2290	'hutton':2 'mount':1	(-32.985365000000002,151.67074700000001)
707	Merewether Heights	1	2291	'height':2 'mereweth':1	(-32.948242,151.736231)
713	Carrington	1	2294	'carrington':1	(-32.664341999999998,152.018722)
718	Georgetown	1	2298	'georgetown':1	(-32.907814000000002,151.7286)
723	North Lambton	1	2299	'lambton':2 'north':1	(-32.905389999999997,151.70627999999999)
727	Newcastle East	1	2300	'east':2 'newcastl':1	(-32.927880999999999,151.788039)
744	Hamilton	1	2309	'hamilton':1	(-32.924042,151.74687399999999)
737	Warabrook	1	2304	'warabrook':1	(-32.887886000000002,151.71995699999999)
742	Callaghan	1	2308	'callaghan':1	(-35.125235000000004,147.32235700000001)
750	Lostock	1	2311	'lostock':1	(-32.326259999999998,151.45968300000001)
754	Fingal Bay	1	2315	'bay':2 'fingal':1	(-32.748112999999996,152.170141)
758	Boat Harbour	1	2316	'boat':1 'harbour':2	(-28.780311000000001,153.364249)
763	Fullerton Cove	1	2318	'cove':2 'fullerton':1	(-32.841048999999998,151.83796799999999)
769	Lemon Tree Passage	1	2319	'lemon':1 'passag':3 'tree':2	(-32.730927000000001,152.03955099999999)
773	Bolwarra Heights	1	2320	'bolwarra':1 'height':2	(-32.700578999999998,151.58470800000001)
781	Rothbury	1	2320	'rothburi':1	(-32.737997,151.33170000000001)
784	Clarence Town	1	2321	'clarenc':1 'town':2	(-32.583660999999999,151.779596)
790	Lochinvar	1	2321	'lochinvar':1	(-32.699038999999999,151.45479)
794	Beresfield	1	2322	'beresfield':1	(-32.801093999999999,151.657881)
799	Thornton	1	2322	'thornton':1	(-32.776904999999999,151.638803)
803	Brunkerville	1	2323	'brunkervill':1	(-32.948838000000002,151.478758)
2065	Green Hills	1	2730	'green':1 'hill':2	(-35.443992999999999,148.07287400000001)
808	Mount Vincent	1	2323	'mount':1 'vincent':2	(-32.984059000000002,149.904293)
815	Cells River	1	2324	'cell':1 'river':2	(-31.553042999999999,152.062941)
820	Limeburners Creek	1	2324	'creek':2 'limeburn':1	(-31.345129,152.86581000000001)
826	Raymond Terrace	1	2324	'raymond':1 'terrac':2	(-32.765051,151.74302299999999)
1309	Swan Bay	1	2471	'bay':2 'swan':1	(-29.059864999999999,153.31361699999999)
831	Twelve Mile Creek	1	2324	'creek':3 'mile':2 'twelv':1	(-32.635385999999997,151.87146200000001)
837	Ellalong	1	2325	'ellalong':1	(-32.912261000000001,151.31129100000001)
842	Millfield	1	2325	'millfield':1	(-32.888506,151.264273)
846	Paynes Crossing	1	2325	'cross':2 'payn':1	(-32.885781999999999,151.102746)
851	Bishops Bridge	1	2326	'bishop':1 'bridg':2	(-32.746391000000003,151.46706399999999)
856	Stanford Merthyr	1	2327	'merthyr':2 'stanford':1	(-32.825065000000002,151.493709)
863	Uarbry	1	2329	'uarbri':1	(-32.047263000000001,149.76503400000001)
867	Carrowbrook	1	2330	'carrowbrook':1	(-32.270899,151.30628400000001)
872	Howes Valley	1	2330	'how':1 'valley':2	(-32.844284000000002,150.835756)
1693	Long Point	1	2564	'long':1 'point':2	(-33.046998000000002,149.21251899999999)
878	Ravensworth	1	2330	'ravensworth':1	(-32.443258,151.05496099999999)
884	Baerami Creek	1	2333	'baerami':1 'creek':2	(-32.520217000000002,150.45438100000001)
888	Mccullys Gap	1	2333	'gap':2 'mcculli':1	(-32.202913000000002,150.97870399999999)
894	Belford	1	2335	'belford':1	(-32.653433999999997,151.27521200000001)
898	North Rothbury	1	2335	'north':1 'rothburi':2	(-32.697479999999999,151.34101100000001)
904	Upper Rouchel	1	2336	'rouchel':2 'upper':1	(-32.123533000000002,151.090225)
909	Moonan Brook	1	2337	'brook':2 'moonan':1	(-31.935400000000001,151.262562)
914	Stewarts Brook	1	2337	'brook':2 'stewart':1	(-32.001384000000002,151.270253)
920	Warrah Creek	1	2339	'creek':2 'warrah':1	(-31.71574,150.65120400000001)
927	Kingswood	1	2340	'kingswood':1	(-33.759967000000003,150.72046)
1649	Kingswood	1	2550	'kingswood':1	(-33.759967000000003,150.72046)
932	South Tamworth	1	2340	'south':1 'tamworth':2	(-31.110969999999998,150.91677899999999)
953	Tamworth	1	2348	'tamworth':1	(-31.091743000000001,150.93082100000001)
941	Colly Blue	1	2343	'blue':2 'colli':1	(-31.459596999999999,150.20008100000001)
946	Duri	1	2344	'duri':1	(-31.219024000000001,150.819076)
950	Barraba	1	2347	'barraba':1	(-30.378339,150.61064200000001)
956	Hillgrove	1	2350	'hillgrov':1	(-35.043233000000001,147.349886)
2269	Lyndhurst	1	2797	'lyndhurst':1	(-33.674888000000003,149.04519300000001)
961	University Of New England	1	2351	'england':4 'new':3 'univers':1	(-30.492989999999999,151.639714)
968	Walcha	1	2354	'walcha':1	(-30.992066000000001,151.592052)
972	Watsons Creek	1	2355	'creek':2 'watson':1	(-30.718586999999999,151.010763)
974	Bugaldie	1	2357	'bugaldi':1	(-31.122204,149.110038)
980	Kingstown	1	2358	'kingstown':1	(-30.505548999999998,151.11752300000001)
985	Gilgai	1	2360	'gilgai':1	(-29.852315999999998,151.117347)
988	Inverell	1	2360	'inverel':1	(-29.775666999999999,151.11292800000001)
993	Ashford	1	2361	'ashford':1	(-29.321245000000001,151.096081)
998	Guyra	1	2365	'guyra':1	(-30.217184,151.67311900000001)
1002	Tingha	1	2369	'tingha':1	(-29.955586,151.212232)
1006	Matheson	1	2370	'matheson':1	(-29.720184,151.58963199999999)
1960	Morven	1	2660	'morven':1	(-35.659128000000003,147.12041400000001)
1011	Emmaville	1	2371	'emmavill':1	(-29.443987,151.59863200000001)
1395	Back Creek	1	2484	'back':1 'creek':2	(-33.828896999999998,147.446045)
1014	Black Swamp	1	2372	'black':1 'swamp':2	(-28.990487000000002,152.13734400000001)
1020	Tenterfield	1	2372	'tenterfield':1	(-29.041657000000001,152.02133499999999)
1025	Orange Grove	1	2380	'grove':2 'orang':1	(-30.969685999999999,150.393835)
1031	Burren Junction	1	2386	'burren':1 'junction':2	(-30.105176,148.96567400000001)
1036	Baan Baa	1	2390	'baa':2 'baan':1	(-30.601379999999999,149.96615299999999)
1041	Weetaliba	1	2395	'weetaliba':1	(-31.643630999999999,149.586456)
1046	Pallamallawa	1	2399	'pallamallawa':1	(-29.475107999999999,150.13697500000001)
1050	Terry Hie Hie	1	2400	'hie':2,3 'terri':1	(-29.795597999999998,150.15107499999999)
1057	Boomi	1	2405	'boomi':1	(-28.725411999999999,149.57915)
1060	North Star	1	2408	'north':1 'star':2	(-28.932590000000001,150.391368)
1065	Stroud Road	1	2415	'road':2 'stroud':1	(-32.344759000000003,151.929068)
1071	Wallarobba	1	2420	'wallarobba':1	(-32.497236999999998,151.69748300000001)
1075	Belbora	1	2422	'belbora':1	(-32.003281999999999,152.15765200000001)
1083	Upper Bowman	1	2422	'bowman':2 'upper':1	(-31.922744000000002,151.78076799999999)
1088	Coolongolook	1	2423	'coolongolook':1	(-32.218679999999999,152.321932)
1092	Upper Myall	1	2423	'myall':2 'upper':1	(-32.251961999999999,152.17228800000001)
1098	Mount George	1	2424	'georg':2 'mount':1	(-31.884444999999999,152.181488)
1104	Washpool	1	2425	'washpool':1	(-29.296914000000001,152.448464)
1108	Harrington	1	2427	'harrington':1	(-31.872153000000001,152.68981099999999)
1113	Tarbuck Bay	1	2428	'bay':2 'tarbuck':1	(-32.368487999999999,152.47814700000001)
1119	Comboyne	1	2429	'comboyn':1	(-31.605468999999999,152.46788900000001)
1124	Kimbriki	1	2429	'kimbriki':1	(-31.922826000000001,152.26706300000001)
1128	Wherrol Flat	1	2429	'flat':2 'wherrol':1	(-31.783211000000001,152.22765899999999)
1134	Ghinni Ghinni	1	2430	'ghinni':1,2	(-31.880545000000001,152.551827)
1140	Purfleet	1	2430	'purfleet':1	(-31.944179999999999,152.46883700000001)
1145	South West Rocks	1	2431	'rock':3 'south':1 'west':2	(-30.884423000000002,153.04045199999999)
1150	Bellimbopinni	1	2440	'bellimbopinni':1	(-31.015929,152.90340900000001)
1155	Crescent Head	1	2440	'crescent':1 'head':2	(-31.189516999999999,152.9768)
1160	Hickeys Creek	1	2440	'creek':2 'hickey':1	(-30.874838,152.59829099999999)
1165	South Kempsey	1	2440	'kempsey':2 'south':1	(-31.094228000000001,152.83255)
1171	Eungai Creek	1	2441	'creek':2 'eungai':1	(-30.831585,152.88169400000001)
1176	Rollands Plains	1	2441	'plain':2 'rolland':1	(-31.278699,152.67806100000001)
1180	Camden Head	1	2443	'camden':1 'head':2	(-31.646864000000001,152.83456000000001)
1182	Hannam Vale	1	2443	'hannam':1 'vale':2	(-31.712975,152.59129799999999)
1188	North Haven	1	2443	'haven':2 'north':1	(-31.640001999999999,152.81733)
1192	Lake Cathie	1	2445	'cathi':2 'lake':1	(-31.552287,152.85492500000001)
1197	Ellenborough	1	2446	'ellenborough':1	(-31.444561,152.45667299999999)
1202	Pappinbarra	1	2446	'pappinbarra':1	(-31.380364,152.50152600000001)
1207	Scotts Head	1	2447	'head':2 'scott':1	(-30.746665,152.99272400000001)
1211	Nambucca Heads	1	2448	'head':2 'nambucca':1	(-30.642441999999999,153.00288599999999)
1217	Coffs Harbour	1	2450	'coff':1 'harbour':2	(-30.282278999999999,153.128593)
1222	Lowanna	1	2450	'lowanna':1	(-30.212389999999999,152.90052600000001)
1226	Upper Orara	1	2450	'orara':2 'upper':1	(-30.284821999999998,153.00951000000001)
1232	Dundurrabin	1	2453	'dundurrabin':1	(-30.188780999999999,152.54736399999999)
1237	Bellingen	1	2454	'bellingen':1	(-30.452387999999999,152.89814699999999)
1241	Raleigh	1	2454	'raleigh':1	(-30.480737999999999,152.99487400000001)
1244	Arrawarra Headland	1	2455	'arrawarra':1 'headland':2	(-30.059771000000001,153.20273800000001)
1246	Arrawarra Headland	1	2456	'arrawarra':1 'headland':2	(-30.059771000000001,153.20273800000001)
1257	Copmanhurst	1	2460	'copmanhurst':1	(-29.586237000000001,152.77639400000001)
1263	Junction Hill	1	2460	'hill':2 'junction':1	(-29.641369999999998,152.925803)
1269	South Grafton	1	2460	'grafton':2 'south':1	(-29.703241999999999,152.934605)
1274	Ulmarra	1	2462	'ulmarra':1	(-29.630579000000001,153.02811199999999)
1279	Woodford	1	2463	'woodford':1	(-33.735174000000001,150.47914900000001)
2189	Woodford	1	2778	'woodford':1	(-33.735174000000001,150.47914900000001)
1282	Iluka	1	2466	'iluka':1	(-29.407475000000002,153.350886)
1286	Old Bonalbo	1	2469	'bonalbo':2 'old':1	(-28.653950999999999,152.596341)
1292	Coombell	1	2470	'coombel':1	(-29.015288999999999,152.97356199999999)
1296	Ellangowan	1	2470	'ellangowan':1	(-29.049762000000001,153.03951900000001)
1300	Mongogarie	1	2470	'mongogari':1	(-28.947827,152.90191200000001)
1304	Shannon Brook	1	2470	'brook':2 'shannon':1	(-28.896274999999999,152.95750699999999)
1311	Broadwater	1	2472	'broadwat':1	(-36.982577999999997,149.88726399999999)
1636	Broadwater	1	2549	'broadwat':1	(-36.982577999999997,149.88726399999999)
1316	Ettrick	1	2474	'ettrick':1	(-28.665037000000002,152.921436)
1320	Lynchs Creek	1	2474	'creek':2 'lynch':1	(-28.450334999999999,152.997434)
1326	Acacia Plateau	1	2476	'acacia':1 'plateau':2	(-28.381072,152.368571)
1331	Cabbage Tree Island	1	2477	'cabbag':1 'island':3 'tree':2	(-28.983995,153.45688899999999)
1339	Ballina	1	2478	'ballina':1	(-28.869983999999999,153.559167)
1343	Pimlico	1	2478	'pimlico':1	(-28.889412,153.49421899999999)
1347	Binna Burra	1	2479	'binna':1 'burra':2	(-28.709652999999999,153.49029899999999)
1354	Clunes	1	2480	'clune':1	(-28.729987999999999,153.40559300000001)
1358	Eltham	1	2480	'eltham':1	(-28.754287000000001,153.40952899999999)
1363	Goonellabah	1	2480	'goonellabah':1	(-28.819841,153.31770399999999)
1368	North Lismore	1	2480	'lismor':2 'north':1	(-28.788139999999999,153.27744200000001)
1373	Ruthven	1	2480	'ruthven':1	(-28.932388,153.27883800000001)
1378	Whian Whian	1	2480	'whian':1,2	(-28.635197000000002,153.31623099999999)
1382	Suffolk Park	1	2481	'park':2 'suffolk':1	(-28.689841999999999,153.61015900000001)
1385	Mullumbimby	1	2482	'mullumbimbi':1	(-28.553160999999999,153.49963700000001)
1391	New Brighton	1	2483	'brighton':2 'new':1	(-28.509357999999999,153.549644)
1396	Bray Park	1	2484	'bray':1 'park':2	(-28.343530999999999,153.375835)
1402	Dunbible	1	2484	'dunbibl':1	(-28.382536000000002,153.40183400000001)
1406	Murwillumbah	1	2484	'murwillumbah':1	(-28.326409999999999,153.39597499999999)
1412	Tweed Heads	1	2485	'head':2 'tweed':1	(-28.177537000000001,153.53853799999999)
1417	Terranora	1	2486	'terranora':1	(-28.240724,153.50279499999999)
1421	Duranbah	1	2487	'duranbah':1	(-28.307575,153.518474)
1426	Cabarita Beach	1	2488	'beach':2 'cabarita':1	(-28.332149000000001,153.569695)
1431	Gwynneville	1	2500	'gwynnevill':1	(-34.416505999999998,150.885131)
1435	Mount Saint Thomas	1	2500	'mount':1 'saint':2 'thoma':3	(-34.442905000000003,150.87392)
1471	Wollongong	1	2520	'wollongong':1	(-33.937789000000002,151.13959399999999)
1445	Port Kembla	1	2505	'kembla':2 'port':1	(-34.479472999999999,150.90165099999999)
1451	Stanwell Park	1	2508	'park':2 'stanwel':1	(-34.226019000000001,150.98614799999999)
1456	Scarborough	1	2515	'scarborough':1	(-34.268351000000003,150.962389)
1460	Russell Vale	1	2517	'russel':1 'vale':2	(-34.358092999999997,150.90078299999999)
1466	Towradgi	1	2518	'towradgi':1	(-34.384433000000001,150.90675999999999)
1470	Mount Pleasant	1	2519	'mount':1 'pleasant':2	(-34.396659999999997,150.863798)
1477	Kembla Grange	1	2526	'grang':2 'kembla':1	(-34.470779999999998,150.80891199999999)
1485	Mount Warrigal	1	2528	'mount':1 'warrig':2	(-34.551856000000001,150.843468)
1491	Oak Flats	1	2529	'flat':2 'oak':1	(-34.564933000000003,150.819334)
1496	Horsley	1	2530	'horsley':1	(-34.489604999999997,150.766762)
1501	Bombo	1	2533	'bombo':1	(-34.656396000000001,150.854028)
1505	Foxground	1	2534	'foxground':1	(-34.727083999999998,150.768404)
1866	Rose Valley	1	2630	'rose':1 'valley':2	(-36.124127000000001,149.25796800000001)
1509	Werri Beach	1	2534	'beach':2 'werri':1	(-34.734082999999998,150.83254700000001)
1514	Jaspers Brush	1	2535	'brush':2 'jasper':1	(-34.803322999999999,150.65759199999999)
1521	Bimbimbie	1	2536	'bimbimbi':1	(-35.815395000000002,150.12874500000001)
1525	Denhams Beach	1	2536	'beach':2 'denham':1	(-35.747722000000003,150.21323100000001)
1531	Long Beach	1	2536	'beach':2 'long':1	(-35.698892000000001,150.23442900000001)
1536	North Batemans Bay	1	2536	'bateman':2 'bay':3 'north':1	(-35.700315000000003,150.18319099999999)
1543	Woodlands	1	2536	'woodland':1	(-34.422184999999999,150.38321400000001)
1548	Congo	1	2537	'congo':1	(-35.956184999999998,150.15366900000001)
1550	Deua River Valley	1	2537	'deua':1 'river':2 'valley':3	(-35.825901000000002,149.97594100000001)
1558	Turlinjah	1	2537	'turlinjah':1	(-36.033268,150.090191)
1562	Bendalong	1	2539	'bendalong':1	(-35.246777000000002,150.529888)
1567	Cunjurong Point	1	2539	'cunjurong':1 'point':2	(-35.259759000000003,150.504909)
1574	Ulladulla	1	2539	'ulladulla':1	(-35.357093999999996,150.474301)
1580	Brundee	1	2540	'brunde':1	(-34.892094,150.65130400000001)
1583	Callala Beach	1	2540	'beach':2 'callala':1	(-35.009084000000001,150.69652400000001)
1586	Culburra Beach	1	2540	'beach':2 'culburra':1	(-34.930304999999997,150.758745)
1594	Hyams Beach	1	2540	'beach':2 'hyam':1	(-35.101725999999999,150.681004)
1599	Old Erowal Bay	1	2540	'bay':3 'erow':2 'old':1	(-35.084367,150.646501)
1605	Swanhaven	1	2540	'swanhaven':1	(-35.180764000000003,150.57481200000001)
1610	Wandandian	1	2540	'wandandian':1	(-35.089066000000003,150.50996699999999)
1615	Bangalee	1	2541	'bangale':1	(-34.843975999999998,150.570381)
1619	South Nowra	1	2541	'nowra':2 'south':1	(-34.898363000000003,150.60221000000001)
1625	Dalmeny	1	2546	'dalmeni':1	(-36.171033999999999,150.13143400000001)
1629	North Narooma	1	2546	'narooma':2 'north':1	(-36.202677999999999,150.11908600000001)
1635	Tura Beach	1	2548	'beach':2 'tura':1	(-36.86533,149.91771399999999)
1640	South Pambula	1	2549	'pambula':2 'south':1	(-36.943446999999999,149.86217600000001)
1646	Candelo	1	2550	'candelo':1	(-36.767310999999999,149.695188)
1651	Morans Crossing	1	2550	'cross':2 'moran':1	(-36.663756999999997,149.64706699999999)
1657	Towamba	1	2550	'towamba':1	(-37.087978,149.652672)
1663	Eden	1	2551	'eden':1	(-37.063189999999999,149.90370200000001)
1666	Wonboyn Lake	1	2551	'lake':2 'wonboyn':1	(-37.251046000000002,149.914953)
1672	Eschol Park	1	2558	'eschol':1 'park':2	(-34.031357,150.80967999999999)
1677	Ambarvale	1	2560	'ambarval':1	(-34.080466999999999,150.80364399999999)
1681	Campbelltown	1	2560	'campbelltown':1	(-34.067441000000002,150.812522)
1689	St Helens Park	1	2560	'helen':2 'park':3 'st':1	(-34.112264000000003,150.79812100000001)
1694	Macquarie Fields	1	2564	'field':2 'macquari':1	(-33.989471000000002,150.88262599999999)
1703	Currans Hill	1	2567	'curran':1 'hill':2	(-34.045178999999997,150.76400699999999)
1709	Douglas Park	1	2569	'dougla':1 'park':2	(-34.193696000000003,150.71287799999999)
1715	Ellis Lane	1	2570	'elli':1 'lane':2	(-34.040061000000001,150.67200600000001)
1720	Orangeville	1	2570	'orangevill':1	(-34.042789999999997,150.573125)
1726	Picton	1	2571	'picton':1	(-34.185524000000001,150.60645400000001)
1730	Thirlmere	1	2572	'thirlmer':1	(-34.204087999999999,150.571102)
1735	Aylmerton	1	2575	'aylmerton':1	(-34.419069,150.49273700000001)
1851	Braemar	1	2628	'braemar':1	(-36.103116,148.65275199999999)
1740	Yerrinbool	1	2575	'yerrinbool':1	(-34.375908000000003,150.53813199999999)
1744	Avoca	1	2577	'avoca':1	(-34.613522000000003,150.47932299999999)
1748	Burrawang	1	2577	'burrawang':1	(-34.593302000000001,150.51826399999999)
1752	New Berrima	1	2577	'berrima':2 'new':1	(-34.504395000000002,150.33239399999999)
1758	Exeter	1	2579	'exet':1	(-34.613160999999998,150.31739200000001)
1763	Bannister	1	2580	'bannist':1	(-34.595404000000002,149.490386)
1768	Lake Bathurst	1	2580	'bathurst':2 'lake':1	(-35.012656999999997,149.71450400000001)
1773	Wombeyan Caves	1	2580	'cave':2 'wombeyan':1	(-34.329633999999999,150.02274700000001)
1779	Dalton	1	2581	'dalton':1	(-34.721910000000001,149.18102400000001)
1783	Burrinjuck	1	2582	'burrinjuck':1	(-34.976658,148.62331)
1788	Binda	1	2583	'binda':1	(-34.328831999999998,149.365499)
1793	Grabben Gullen	1	2583	'grabben':1 'gullen':2	(-34.545473999999999,149.41091599999999)
1800	Binalong	1	2584	'binalong':1	(-34.670932000000001,148.628209)
1804	Reids Flat	1	2586	'flat':2 'reid':1	(-34.146638000000003,148.96137999999999)
1809	Wombat	1	2587	'wombat':1	(-34.423482,148.24444)
1814	Bribbaree	1	2594	'bribbare':1	(-34.121251999999998,147.87372099999999)
1818	Brindabella	1	2611	'brindabella':1	(-35.349502999999999,148.724491)
1824	Karabar	1	2620	'karabar':1	(-35.362898999999999,149.21638799999999)
1828	Queanbeyan West	1	2620	'queanbeyan':1 'west':2	(-35.358297999999998,149.228993)
1834	Araluen	1	2622	'araluen':1	(-35.646929999999998,149.81214900000001)
1838	Gundillion	1	2622	'gundillion':1	(-35.758794999999999,149.63818000000001)
1843	Nerriga	1	2622	'nerriga':1	(-35.113182000000002,150.08870400000001)
1847	Thredbo Village	1	2625	'thredbo':1 'villag':2	(-36.506610000000002,148.301005)
1854	Numbla Vale	1	2628	'numbla':1 'vale':2	(-36.636685,148.81793099999999)
1859	Bunyan	1	2630	'bunyan':1	(-36.169629999999998,149.15375299999999)
1863	Numeralla	1	2630	'numeralla':1	(-36.177222999999998,149.34066799999999)
1869	Bibbenluke	1	2632	'bibbenluk':1	(-36.815804999999997,149.28340800000001)
1874	Delegate	1	2633	'deleg':1	(-37.044027999999997,148.94173499999999)
1877	North Albury	1	2640	'alburi':2 'north':1	(-36.062952000000003,146.93155200000001)
2021	Lavington	1	2708	'lavington':1	(-36.050576999999997,146.933346)
1883	Brocklesby	1	2642	'brocklesbi':1	(-35.822589000000001,146.680117)
1888	Khancoban	1	2642	'khancoban':1	(-36.218086999999997,148.12939800000001)
1892	Yerong Creek	1	2642	'creek':2 'yerong':1	(-35.387447000000002,147.06123099999999)
1896	Mullengandra	1	2644	'mullengandra':1	(-35.877119999999998,147.180565)
1902	Lowesdale	1	2646	'lowesdal':1	(-35.842556000000002,146.36564200000001)
1906	Mulwala	1	2647	'mulwala':1	(-35.954158999999997,145.963942)
1911	Pomona	1	2648	'pomona':1	(-34.020625000000003,141.894926)
1915	Laurel Hill	1	2649	'hill':2 'laurel':1	(-35.600389999999997,148.09309999999999)
1920	Downside	1	2650	'downsid':1	(-34.976629000000003,147.344314)
1924	Lake Albert	1	2650	'albert':2 'lake':1	(-35.166085000000002,147.38181599999999)
1995	Wagga Wagga	1	2678	'wagga':1,2	(-35.109861000000002,147.37051500000001)
1934	Goolgowi	1	2652	'goolgowi':1	(-33.983547000000002,145.70808199999999)
1939	Mangoplah	1	2652	'mangoplah':1	(-35.375169,147.25305599999999)
1943	Old Junee	1	2652	'june':2 'old':1	(-34.836390999999999,147.51478599999999)
1950	French Park	1	2655	'french':1 'park':2	(-35.267046000000001,146.926513)
1954	Urangeline East	1	2656	'east':2 'urangelin':1	(-35.482877999999999,146.694289)
1961	Kapooka	1	2661	'kapooka':1	(-35.147790000000001,147.295748)
1966	Beckom	1	2665	'beckom':1	(-34.327309999999997,146.95997399999999)
1970	Moombooldool	1	2665	'moombooldool':1	(-34.301732000000001,146.67802499999999)
1975	Temora	1	2666	'temora':1	(-34.446857999999999,147.53374199999999)
1979	Erigolia	1	2669	'erigolia':1	(-33.856208000000002,146.353487)
1984	Tullibigeal	1	2669	'tullibig':1	(-33.420093000000001,146.728083)
1988	West Wyalong	1	2671	'west':1 'wyalong':2	(-33.923496,147.20520099999999)
1996	Beelbangera	1	2680	'beelbangera':1	(-34.257097000000002,146.10009199999999)
2005	Yoogali	1	2680	'yoogali':1	(-34.301180000000002,146.084633)
2009	Narrandera	1	2700	'narrandera':1	(-34.744608999999997,146.55696)
2013	Corbie Hill	1	2705	'corbi':1 'hill':2	(-34.571537999999997,146.45638500000001)
2018	Darlington Point	1	2706	'darlington':1 'point':2	(-34.557729000000002,146.01049599999999)
2026	Mathoura	1	2710	'mathoura':1	(-35.812620000000003,144.90260000000001)
2030	Wanganella	1	2710	'wanganella':1	(-35.211334999999998,144.81536800000001)
2035	Maude	1	2711	'maud':1	(-34.467858999999997,144.30316300000001)
2039	Finley	1	2713	'finley':1	(-35.645434000000002,145.575436)
2043	Jerilderie	1	2716	'jerilderi':1	(-35.356448,145.72927999999999)
2048	Tumut	1	2720	'tumut':1	(-35.300634000000002,148.22496100000001)
2052	Muttama	1	2722	'muttama':1	(-34.802773999999999,148.11690100000001)
2056	Adjungbilly	1	2727	'adjungbilli':1	(-35.081462999999999,148.40992)
2061	Mount Horeb	1	2729	'horeb':2 'mount':1	(-35.210262999999998,148.03350499999999)
2068	Womboota	1	2731	'womboota':1	(-35.957189999999997,144.588651)
2073	Tooleybuc	1	2736	'tooleybuc':1	(-35.027890999999997,143.33827500000001)
2078	Buronga	1	2739	'buronga':1	(-34.171442999999996,142.182794)
2084	Wallacia	1	2745	'wallacia':1	(-33.865178999999998,150.64041800000001)
2089	Werrington	1	2747	'werrington':1	(-33.757725000000001,150.739982)
2094	Cranebrook	1	2749	'cranebrook':1	(-33.714309999999998,150.70998599999999)
2098	Penrith	1	2751	'penrith':1	(-33.732126999999998,151.28035199999999)
2103	Grose Wold	1	2753	'grose':1 'wold':2	(-33.602392000000002,150.68862799999999)
2108	North Richmond	1	2754	'north':1 'richmond':2	(-33.582355,150.721891)
2115	Cornwallis	1	2756	'cornwal':1	(-33.592374999999997,150.81221600000001)
2119	Lower Portland	1	2756	'lower':1 'portland':2	(-33.451408999999998,150.865871)
2124	Scheyville	1	2756	'scheyvill':1	(-33.610689999999998,150.88031000000001)
2129	Blaxlands Ridge	1	2758	'blaxland':1 'ridg':2	(-33.502253000000003,150.712367)
2136	Dean Park	1	2761	'dean':1 'park':2	(-33.736159999999998,150.860027)
2141	Schofields	1	2762	'schofield':1	(-33.697217000000002,150.888428)
2146	Maraylya	1	2765	'maraylya':1	(-33.581980000000001,150.90694999999999)
2152	Eastern Creek	1	2766	'creek':2 'eastern':1	(-33.803114000000001,150.852192)
2158	Stanhope Gardens	1	2768	'garden':2 'stanhop':1	(-33.711215000000003,150.93362099999999)
2164	Hebersham	1	2770	'hebersham':1	(-33.743504000000001,150.82268199999999)
2168	Shalvey	1	2770	'shalvey':1	(-33.729373000000002,150.80837500000001)
2173	Lapstone	1	2773	'lapston':1	(-33.774112000000002,150.63665700000001)
2177	Central Macdonald	1	2775	'central':1 'macdonald':2	(-33.331657999999997,150.97549799999999)
2183	Hawkesbury Heights	1	2777	'hawkesburi':1 'height':2	(-33.665114000000003,150.650802)
2191	Katoomba	1	2780	'katoomba':1	(-33.714042999999997,150.311589)
2196	Bullaburra	1	2784	'bullaburra':1	(-33.722751000000002,150.41363999999999)
2201	Mount Irvine	1	2786	'irvin':2 'mount':1	(-33.492148,150.44529600000001)
2206	Edith	1	2787	'edith':1	(-33.800213999999997,149.922383)
2210	Porters Retreat	1	2787	'porter':1 'retreat':2	(-33.988815000000002,149.760628)
2215	Cobar Park	1	2790	'cobar':1 'park':2	(-33.469948000000002,150.154968)
2221	Little Hartley	1	2790	'hartley':2 'littl':1	(-33.571700999999997,150.208607)
2227	Mandurama	1	2792	'mandurama':1	(-33.648854999999998,149.07527300000001)
2232	Noonbinna	1	2794	'noonbinna':1	(-33.887663000000003,148.64369600000001)
2237	Burraga	1	2795	'burraga':1	(-33.947963999999999,149.53013000000001)
2241	Eglinton	1	2795	'eglinton':1	(-33.374597000000001,149.558662)
2245	Hobbys Yards	1	2795	'hobbi':1 'yard':2	(-33.700136000000001,149.327338)
2251	Mount David	1	2795	'david':2 'mount':1	(-33.860821000000001,149.604108)
2257	Sofala	1	2795	'sofala':1	(-33.080697999999998,149.689626)
2262	Wambool	1	2795	'wambool':1	(-33.507576,149.76325499999999)
2266	Wisemans Creek	1	2795	'creek':2 'wiseman':1	(-33.618977999999998,149.71831900000001)
2274	Blayney	1	2799	'blayney':1	(-33.532319000000001,149.25526300000001)
2279	Cargo	1	2800	'cargo':1	(-33.423633000000002,148.80892900000001)
2282	Mullion Creek	1	2800	'creek':2 'mullion':1	(-33.140703999999999,149.12066300000001)
2289	Canowindra	1	2804	'canowindra':1	(-33.562223000000003,148.66490999999999)
2293	Greenethorpe	1	2809	'greenethorp':1	(-34.041955000000002,148.39500100000001)
2299	Bakers Swamp	1	2820	'baker':1 'swamp':2	(-32.778925000000001,148.923303)
2305	Neurea	1	2820	'neurea':1	(-32.708193000000001,148.94781499999999)
2309	Wellington	1	2820	'wellington':1	(-32.555880000000002,148.94479699999999)
2314	Canonba	1	2825	'canonba':1	(-31.347072000000001,147.34555599999999)
2315	Miandetta	1	2825	'miandetta':1	(-31.566220999999999,146.97079299999999)
2320	Gilgandra	1	2827	'gilgandra':1	(-31.711715000000002,148.66313099999999)
2324	Coonamble	1	2829	'coonambl':1	(-30.954311000000001,148.38844800000001)
2329	Armatree	1	2831	'armatre':1	(-31.453726,148.40769499999999)
2333	Coolabah	1	2831	'coolabah':1	(-31.027985999999999,146.71426399999999)
2338	Goodooga	1	2831	'goodooga':1	(-29.113036999999998,147.45213899999999)
2343	Nymagee	1	2831	'nymage':1	(-32.163806000000001,146.29953)
2347	Come By Chance	1	2832	'chanc':3 'come':1	(-30.361591000000001,148.46736100000001)
2352	Lightning Ridge	1	2834	'lightn':1 'ridg':2	(-29.425723999999999,147.97923599999999)
2357	Weilmoringle	1	2839	'weilmoringl':1	(-29.218812,146.867097)
2363	Tilpa	1	2840	'tilpa':1	(-30.940579,144.421865)
2367	Mendooran	1	2842	'mendooran':1	(-31.822488,149.118008)
2371	Leadville	1	2844	'leadvill':1	(-32.017507000000002,149.544871)
2376	Charbon	1	2848	'charbon':1	(-32.881264999999999,149.96511899999999)
2381	Hargraves	1	2850	'hargrav':1	(-32.78886,149.465034)
2386	Mudgee	1	2850	'mudge':1	(-32.590719999999997,149.58612600000001)
2389	Twelve Mile	1	2850	'mile':2 'twelv':1	(-32.493014000000002,149.27045000000001)
2394	Yarrawonga	1	2850	'yarrawonga':1	(-32.356620999999997,149.65882999999999)
2399	Toogong	1	2864	'toogong':1	(-33.351419,148.62491700000001)
2403	Larras Lee	1	2866	'larra':1 'lee':2	(-32.970376999999999,148.88170700000001)
2408	Peak Hill	1	2869	'hill':2 'peak':1	(-32.725327999999998,148.18518800000001)
2414	Goonumbla	1	2870	'goonumbla':1	(-32.998671999999999,148.16101)
2418	Bedgerebong	1	2871	'bedgerebong':1	(-33.360914999999999,147.69617299999999)
103	University Of New South Wales	1	2052	'new':3 'south':4 'univers':1 'wale':5	(-33.917999999999999,151.23099999999999)
293	Constitution Hill	1	2145	'constitut':1 'hill':2	(-33.816000000000003,150.95599999999999)
1592	Hmas Creswell	1	2540	'creswel':2 'hmas':1	(-34.265000000000001,150.69200000000001)
1595	Jervis Bay	1	2540	'bay':2 'jervi':1	(-34.265000000000001,150.69200000000001)
385	Voyager	1	2172	'voyag':1	(-33.966999999999999,150.98099999999999)
1723	Balmoral Village	1	2571	'balmor':1 'villag':2	(-34.243000000000002,150.58099999999999)
1575	Yatte Yattah	1	2539	'yatt':1 'yattah':2	(-35.404000000000003,150.40299999999999)
17	Sydney	1	2001	'sydney':1	(-33.794882999999999,151.26807099999999)
12	Darlinghurst	1	2010	'darlinghurst':1	(-33.879824999999997,151.21956)
26	Potts Point	1	2011	'point':2 'pott':1	(-33.869025999999998,151.22560300000001)
44	Bondi Junction	1	2022	'bondi':1 'junction':2	(-33.892324000000002,151.24733000000001)
53	Double Bay	1	2028	'bay':2 'doubl':1	(-33.879060000000003,151.24309500000001)
28	Strawberry Hills	1	2012	'hill':2 'strawberri':1	(-33.726098,150.931838)
31	Eveleigh	1	2015	'eveleigh':1	(-33.897075000000001,151.19112999999999)
29	Alexandria	1	2015	'alexandria':1	(-33.897570999999999,151.19556700000001)
33	Waterloo	1	2017	'waterloo':1	(-33.900399999999998,151.20614399999999)
36	Rosebery	1	2018	'roseberi':1	(-33.920411999999999,151.20310699999999)
38	Botany	1	2019	'botani':1	(-33.944769999999998,151.196528)
39	Mascot	1	2020	'mascot':1	(-33.931189000000003,151.19431)
62	Kensington	1	2033	'kensington':1	(-33.912996999999997,151.21901700000001)
10	Burwood	1	2134	'burwood':1	(-33.877423,151.10368199999999)
14	Dawes Point	1	2000	'daw':1 'point':2	(-33.855601,151.20822000000001)
15	Millers Point	1	2000	'miller':1 'point':2	(-33.858314999999997,151.203519)
16	The Rocks	1	2000	'rock':2	(-33.425080000000001,149.42487199999999)
18	World Square	1	2002	'squar':2 'world':1	(-35.974434000000002,146.40505999999999)
21	Chippendale	1	2008	'chippendal':1	(-33.886844000000004,151.20171500000001)
22	Darlington	1	2008	'darlington':1	(-32.558283000000003,151.15955600000001)
23	Pyrmont	1	2009	'pyrmont':1	(-33.869709,151.19392999999999)
13	Surry Hills	1	2010	'hill':2 'surri':1	(-33.888821,151.21332799999999)
25	Elizabeth Bay	1	2011	'bay':2 'elizabeth':1	(-33.872829000000003,151.22659300000001)
27	Rushcutters Bay	1	2011	'bay':2 'rushcutt':1	(-33.876240000000003,151.22861399999999)
24	Woolloomooloo	1	2011	'woolloomooloo':1	(-33.869283000000003,151.22041200000001)
30	Beaconsfield	1	2015	'beaconsfield':1	(-33.911613000000003,151.20188999999999)
32	Redfern	1	2016	'redfern':1	(-33.892778,151.203901)
34	Zetland	1	2017	'zetland':1	(-33.909937999999997,151.20623399999999)
35	Eastlakes	1	2018	'eastlak':1	(-33.925133000000002,151.213199)
37	Banksmeadow	1	2019	'banksmeadow':1	(-33.957419999999999,151.206715)
40	Moore Park	1	2021	'moor':1 'park':2	(-33.893631999999997,151.219357)
41	Paddington	1	2021	'paddington':1	(-33.885032000000002,151.22647499999999)
43	Queens Park	1	2022	'park':2 'queen':1	(-33.903188,151.24720500000001)
45	Bellevue Hill	1	2023	'bellevu':1 'hill':2	(-33.887188999999999,151.25893500000001)
46	Bronte	1	2024	'bront':1	(-33.902327999999997,151.26383799999999)
47	Waverley	1	2024	'waverley':1	(-33.897955000000003,151.252059)
48	Woollahra	1	2025	'woollahra':1	(-33.885795000000002,151.24413000000001)
49	Bondi	1	2026	'bondi':1	(-33.893738999999997,151.26250200000001)
50	Darling Point	1	2027	'darl':1 'point':2	(-33.873807999999997,151.236683)
51	Edgecliff	1	2027	'edgecliff':1	(-33.878585999999999,151.235106)
52	Point Piper	1	2027	'piper':2 'point':1	(-33.870083000000001,151.252329)
54	Rose Bay	1	2029	'bay':2 'rose':1	(-33.866554999999998,151.28045599999999)
57	Dover Heights	1	2030	'dover':1 'height':2	(-33.874405000000003,151.280416)
55	Vaucluse	1	2030	'vauclus':1	(-33.859046999999997,151.278434)
56	Watsons Bay	1	2030	'bay':2 'watson':1	(-33.844805999999998,151.28236799999999)
58	Clovelly	1	2031	'clovelli':1	(-33.912638999999999,151.262021)
59	Randwick	1	2031	'randwick':1	(-33.913164000000002,151.24199300000001)
60	Daceyville	1	2032	'daceyvill':1	(-33.928043000000002,151.22513000000001)
61	Kingsford	1	2032	'kingsford':1	(-33.924922000000002,151.227811)
63	Coogee	1	2034	'cooge':1	(-33.920490999999998,151.254401)
64	South Coogee	1	2034	'cooge':2 'south':1	(-33.931292999999997,151.256089)
65	Maroubra	1	2035	'maroubra':1	(-33.946123,151.242818)
66	Pagewood	1	2035	'pagewood':1	(-33.940108000000002,151.22841099999999)
67	Chifley	1	2036	'chifley':1	(-33.976545999999999,151.24024800000001)
68	Eastgardens	1	2036	'eastgarden':1	(-33.946043000000003,151.22330099999999)
69	Hillsdale	1	2036	'hillsdal':1	(-33.952685000000002,151.23134099999999)
70	La Perouse	1	2036	'la':1 'perous':2	(-33.989634000000002,151.23150699999999)
71	Little Bay	1	2036	'bay':2 'littl':1	(-33.981177000000002,151.24320599999999)
72	Malabar	1	2036	'malabar':1	(-33.965375999999999,151.245969)
73	Matraville	1	2036	'matravill':1	(-33.957549,151.23084600000001)
74	Phillip Bay	1	2036	'bay':2 'phillip':1	(-33.980556,151.23669200000001)
75	Port Botany	1	2036	'botani':2 'port':1	(-33.966245000000001,151.22501299999999)
76	Forest Lodge	1	2037	'forest':1 'lodg':2	(-33.881214999999997,151.181127)
77	Annandale	1	2038	'annandal':1	(-33.881435000000003,151.170681)
78	Rozelle	1	2039	'rozell':1	(-33.863062999999997,151.17057299999999)
79	Leichhardt	1	2040	'leichhardt':1	(-33.883792999999997,151.15705700000001)
80	Lilyfield	1	2040	'lilyfield':1	(-33.872990999999999,151.16578799999999)
81	Birchgrove	1	2040	'birchgrov':1	(-33.853386,151.180609)
2	Chatswood	1	2057	'chatswood':1	(-33.795617,151.185329)
11	Central Tilba	1	2546	'central':1 'tilba':2	(-36.311773000000002,150.08481699999999)
19	Eastern Suburbs	1	2004	'eastern':1 'suburb':2	(-32.831000000000003,150.13900000000001)
20	University Of Sydney	1	2006	'sydney':3 'univers':1	(-33.887999999999998,151.18700000000001)
42	Centennial Park	1	2021	'centenni':1 'park':2	(-33.890999999999998,151.22800000000001)
110	Milsons Point	1	2061	'milson':1 'point':2	(-33.847526000000002,151.211568)
113	Artarmon	1	2064	'artarmon':1	(-33.807664000000003,151.189662)
114	Crows Nest	1	2065	'crow':1 'nest':2	(-33.826090000000001,151.19919200000001)
119	Lane Cove	1	2066	'cove':2 'lane':1	(-33.814599000000001,151.168722)
154	Hornsby	1	2077	'hornsbi':1	(-33.704748000000002,151.09869599999999)
170	Frenchs Forest	1	2086	'forest':2 'french':1	(-33.750964000000003,151.22603599999999)
82	Balmain	1	2041	'balmain':1	(-33.856498000000002,151.178009)
84	Enmore	1	2042	'enmor':1	(-30.721540999999998,151.73161899999999)
85	Newtown	1	2042	'newtown':1	(-33.896448999999997,151.180013)
86	Erskineville	1	2043	'erskinevill':1	(-33.902234,151.18619200000001)
87	St Peters	1	2044	'peter':2 'st':1	(-33.911062000000001,151.180126)
88	Sydenham	1	2044	'sydenham':1	(-33.915222,151.16610399999999)
90	Haberfield	1	2045	'haberfield':1	(-33.880496000000001,151.13883899999999)
91	Abbotsford	1	2046	'abbotsford':1	(-33.852468999999999,151.12945300000001)
93	Chiswick	1	2046	'chiswick':1	(-33.851436999999997,151.135954)
94	Five Dock	1	2046	'dock':2 'five':1	(-33.866368000000001,151.13013599999999)
95	Rodd Point	1	2046	'point':2 'rodd':1	(-33.868208000000003,151.14165199999999)
96	Russell Lea	1	2046	'lea':2 'russel':1	(-33.860720000000001,151.14071100000001)
97	Wareemba	1	2046	'wareemba':1	(-33.856828,151.130728)
100	Lewisham	1	2049	'lewisham':1	(-33.894902000000002,151.14441299999999)
101	Petersham	1	2049	'petersham':1	(-33.896242000000001,151.15413599999999)
104	North Sydney	1	2059	'north':1 'sydney':2	(-33.838265,151.206481)
126	Chatswood	1	2067	'chatswood':1	(-33.795617,151.185329)
106	Lavender Bay	1	2060	'bay':2 'lavend':1	(-33.843069999999997,151.20801499999999)
107	Mcmahons Point	1	2060	'mcmahon':1 'point':2	(-33.844639999999998,151.20425)
105	Waverton	1	2060	'waverton':1	(-33.839969000000004,151.195808)
109	Kirribilli	1	2061	'kirribilli':1	(-33.846274999999999,151.212705)
112	Northbridge	1	2063	'northbridg':1	(-33.815027999999998,151.22226599999999)
115	Greenwich	1	2065	'greenwich':1	(-33.831958,151.18612899999999)
116	Naremburn	1	2065	'naremburn':1	(-33.817298999999998,151.20115999999999)
120	Lane Cove North	1	2066	'cove':2 'lane':1 'north':3	(-33.807555999999998,151.17091199999999)
121	Lane Cove West	1	2066	'cove':2 'lane':1 'west':3	(-33.806246000000002,151.15328099999999)
122	Linley Point	1	2066	'linley':1 'point':2	(-33.826777,151.14825099999999)
123	Longueville	1	2066	'longuevill':1	(-33.833095999999998,151.16534200000001)
125	Riverview	1	2066	'riverview':1	(-29.904643,150.687307)
127	Chatswood West	1	2067	'chatswood':1 'west':2	(-33.796332,151.16714200000001)
132	Castlecrag	1	2068	'castlecrag':1	(-33.802402999999998,151.21264300000001)
128	Middle Cove	1	2068	'cove':2 'middl':1	(-33.794086999999998,151.207975)
130	Willoughby	1	2068	'willoughbi':1	(-33.801482999999998,151.1986)
131	Willoughby East	1	2068	'east':2 'willoughbi':1	(-33.802534000000001,151.20350500000001)
135	Castle Cove	1	2069	'castl':1 'cove':2	(-33.784165000000002,151.19994800000001)
133	Roseville	1	2069	'rosevill':1	(-33.784635000000002,151.177111)
136	East Lindfield	1	2070	'east':1 'lindfield':2	(-33.766415000000002,151.18609499999999)
137	Lindfield	1	2070	'lindfield':1	(-33.776440999999998,151.168736)
139	East Killara	1	2071	'east':1 'killara':2	(-33.753498,151.17000300000001)
138	Killara	1	2071	'killara':1	(-33.766376000000001,151.162047)
140	Gordon	1	2072	'gordon':1	(-33.757348999999998,151.15567799999999)
141	Pymble	1	2073	'pymbl':1	(-33.744140000000002,151.14110299999999)
145	North Turramurra	1	2074	'north':1 'turramurra':2	(-33.713419000000002,151.14714599999999)
144	South Turramurra	1	2074	'south':1 'turramurra':2	(-33.746026999999998,151.11344099999999)
143	Turramurra	1	2074	'turramurra':1	(-33.733243999999999,151.12980899999999)
147	St Ives	1	2075	'ive':2 'st':1	(-33.730601,151.15855099999999)
148	St Ives Chase	1	2075	'chase':3 'ive':2 'st':1	(-33.707895000000001,151.16344599999999)
149	Normanhurst	1	2076	'normanhurst':1	(-33.720998999999999,151.097331)
150	Wahroonga	1	2076	'wahroonga':1	(-33.716405000000002,151.11811900000001)
153	Asquith	1	2077	'asquith':1	(-33.687483999999998,151.10868500000001)
155	Hornsby Heights	1	2077	'height':2 'hornsbi':1	(-33.670085999999998,151.09550300000001)
152	Waitara	1	2077	'waitara':1	(-33.709541000000002,151.10413600000001)
156	Mount Colah	1	2079	'colah':2 'mount':1	(-33.664816999999999,151.11716100000001)
158	Berowra	1	2081	'berowra':1	(-33.623581000000001,151.15011699999999)
159	Cowan	1	2081	'cowan':1	(-33.589491000000002,151.17101500000001)
160	Berowra Heights	1	2082	'berowra':1 'height':2	(-33.610968,151.13682900000001)
161	Berowra Waters	1	2082	'berowra':1 'water':2	(-33.601652999999999,151.11837)
162	Brooklyn	1	2083	'brooklyn':1	(-33.548006000000001,151.22519)
163	Dangar Island	1	2083	'dangar':1 'island':2	(-33.539357000000003,151.24176199999999)
165	Mooney Mooney	1	2083	'mooney':1,2	(-33.490355999999998,151.18617900000001)
166	Duffys Forest	1	2084	'duffi':1 'forest':2	(-33.676774999999999,151.19987900000001)
167	Terrey Hills	1	2084	'hill':2 'terrey':1	(-33.683644000000001,151.22846999999999)
168	Belrose	1	2085	'belros':1	(-33.739288000000002,151.21143900000001)
169	Davidson	1	2085	'davidson':1	(-33.738731000000001,151.194197)
172	Killarney Heights	1	2087	'height':2 'killarney':1	(-33.773727999999998,151.21612500000001)
173	Mosman	1	2088	'mosman':1	(-33.829076999999998,151.24409)
174	Neutral Bay	1	2089	'bay':2 'neutral':1	(-33.831119999999999,151.22123199999999)
175	Cremorne	1	2090	'cremorn':1	(-33.828130999999999,151.230233)
177	Seaforth	1	2092	'seaforth':1	(-33.797105999999999,151.25114600000001)
178	Balgowlah	1	2093	'balgowlah':1	(-33.794120999999997,151.26267999999999)
277	Rhodes	1	2138	'rhode':1	(-33.830764000000002,151.08810500000001)
221	Gladesville	1	2111	'gladesvill':1	(-33.832894000000003,151.12696399999999)
227	Ryde	1	2112	'ryde':1	(-33.812953,151.10494199999999)
237	West Ryde	1	2114	'ryde':2 'west':1	(-33.807712000000002,151.08872400000001)
238	Ermington	1	2115	'ermington':1	(-33.814143999999999,151.054495)
247	Pennant Hills	1	2120	'hill':2 'pennant':1	(-33.738681,151.07143300000001)
254	Parramatta	1	2123	'parramatta':1	(-33.816957000000002,151.00345100000001)
263	Ashfield	1	2131	'ashfield':1	(-33.889498000000003,151.127444)
260	Silverwater	1	2128	'silverwat':1	(-33.101384000000003,151.56199000000001)
266	Strathfield	1	2135	'strathfield':1	(-33.873913000000002,151.09399300000001)
180	Balgowlah Heights	1	2093	'balgowlah':1 'height':2	(-33.800553000000001,151.25740099999999)
181	Clontarf	1	2093	'clontarf':1	(-33.808238000000003,151.25509500000001)
179	North Balgowlah	1	2093	'balgowlah':2 'north':1	(-33.787073999999997,151.251721)
183	Fairlight	1	2094	'fairlight':1	(-33.794162999999998,151.273978)
186	Curl Curl	1	2096	'curl':1,2	(-33.768937000000001,151.29403500000001)
187	Harbord	1	2096	'harbord':1	(-33.778663000000002,151.28577200000001)
188	Collaroy	1	2097	'collaroy':1	(-33.740969,151.303133)
189	Cromer	1	2099	'cromer':1	(-33.740352999999999,151.27852300000001)
190	Dee Why	1	2099	'dee':1	(-33.753450999999998,151.28554)
191	Narraweena	1	2099	'narraweena':1	(-33.749912000000002,151.274687)
197	Allambie Heights	1	2100	'allambi':1 'height':2	(-33.765076000000001,151.248864)
193	Beacon Hill	1	2100	'beacon':1 'hill':2	(-33.752406000000001,151.26127199999999)
194	Brookvale	1	2100	'brookval':1	(-33.766629000000002,151.27382399999999)
195	North Manly	1	2100	'man':2 'north':1	(-33.775702000000003,151.269339)
200	Elanora Heights	1	2101	'elanora':1 'height':2	(-33.695014999999998,151.28015600000001)
201	Ingleside	1	2101	'inglesid':1	(-33.683176000000003,151.26232200000001)
198	Narrabeen	1	2101	'narrabeen':1	(-33.723126999999998,151.28736599999999)
202	Warriewood	1	2102	'warriewood':1	(-33.686264999999999,151.29908)
204	Bayview	1	2104	'bayview':1	(-33.664450000000002,151.298945)
205	Church Point	1	2105	'church':1 'point':2	(-33.644872999999997,151.28435200000001)
206	Elvina Bay	1	2105	'bay':2 'elvina':1	(-33.642010999999997,151.27610899999999)
207	Lovett Bay	1	2105	'bay':2 'lovett':1	(-33.637405000000001,151.27842899999999)
208	Scotland Island	1	2105	'island':2 'scotland':1	(-33.641751999999997,151.29011600000001)
210	Newport Beach	1	2106	'beach':2 'newport':1	(-33.652484999999999,151.322776)
213	Avalon Beach	1	2107	'avalon':1 'beach':2	(-33.636324999999999,151.33059600000001)
214	Bilgola	1	2107	'bilgola':1	(-33.645561999999998,151.323857)
215	Careel Bay	1	2107	'bay':2 'careel':1	(-33.623134999999998,151.327046)
216	Palm Beach	1	2108	'beach':2 'palm':1	(-33.604281999999998,151.32141899999999)
217	The Basin	1	2108	'basin':2	(-30.220773999999999,151.28503599999999)
218	Macquarie University	1	2109	'macquari':1 'univers':2	(-33.774321,151.111988)
220	Hunters Hill	1	2110	'hill':2 'hunter':1	(-33.83484,151.15419600000001)
222	Henley	1	2111	'henley':1	(-33.842216000000001,151.135943)
223	Huntleys Cove	1	2111	'cove':2 'huntley':1	(-33.839798000000002,151.144587)
224	Huntleys Point	1	2111	'huntley':1 'point':2	(-33.840088000000002,151.14596800000001)
228	Denistone East	1	2112	'deniston':1 'east':2	(-33.797176999999998,151.09754599999999)
226	Putney	1	2112	'putney':1	(-33.824734999999997,151.112549)
230	East Ryde	1	2113	'east':1 'ryde':2	(-33.813769000000001,151.140289)
231	Macquarie Park	1	2113	'macquari':1 'park':2	(-33.779795,151.134041)
232	North Ryde	1	2113	'north':1 'ryde':2	(-33.796770000000002,151.12435500000001)
233	Denistone	1	2114	'deniston':1	(-33.799441000000002,151.07959)
234	Denistone West	1	2114	'deniston':1 'west':2	(-33.802382000000001,151.06608499999999)
235	Meadowbank	1	2114	'meadowbank':1	(-33.815911999999997,151.09071499999999)
236	Melrose Park	1	2114	'melros':1 'park':2	(-33.816575,151.076089)
239	Rydalmere	1	2116	'rydalmer':1	(-33.811244000000002,151.03446400000001)
242	Dundas Valley	1	2117	'dunda':1 'valley':2	(-33.787239999999997,151.06118499999999)
243	Oatlands	1	2117	'oatland':1	(-33.796298,151.02631400000001)
240	Telopea	1	2117	'telopea':1	(-33.795985999999999,151.045106)
246	Beecroft	1	2119	'beecroft':1	(-33.749498000000003,151.06453300000001)
245	Cheltenham	1	2119	'cheltenham':1	(-33.761690000000002,151.079364)
248	Thornleigh	1	2120	'thornleigh':1	(-33.730815999999997,151.08122599999999)
249	Westleigh	1	2120	'westleigh':1	(-33.711956000000001,151.072836)
253	Eastwood	1	2122	'eastwood':1	(-33.789985999999999,151.08091400000001)
252	Marsfield	1	2122	'marsfield':1	(-33.783971000000001,151.09424100000001)
256	West Pennant Hills	1	2125	'hill':3 'pennant':2 'west':1	(-33.753675999999999,151.03911299999999)
257	Cherrybrook	1	2126	'cherrybrook':1	(-33.722019000000003,151.04180600000001)
259	Newington	1	2127	'newington':1	(-33.839275999999998,151.05482799999999)
261	Sydney Markets	1	2129	'market':2 'sydney':1	(-33.871209,151.19188399999999)
262	Summer Hill	1	2130	'hill':2 'summer':1	(-32.478428000000001,151.51941299999999)
264	Croydon	1	2132	'croydon':1	(-33.883163000000003,151.11477099999999)
268	Burwood Heights	1	2136	'burwood':1 'height':2	(-33.888328000000001,151.10341199999999)
269	Enfield	1	2136	'enfield':1	(-33.886854,151.09242499999999)
267	Strathfield South	1	2136	'south':2 'strathfield':1	(-33.891711000000001,151.08299199999999)
270	Breakfast Point	1	2137	'breakfast':1 'point':2	(-33.841583,151.10750200000001)
271	Cabarita	1	2137	'cabarita':1	(-33.849080999999998,151.113765)
273	Mortlake	1	2137	'mortlak':1	(-33.843434999999999,151.10697999999999)
274	North Strathfield	1	2137	'north':1 'strathfield':2	(-33.857460000000003,151.09195399999999)
275	Concord West	1	2138	'concord':1 'west':2	(-33.848041000000002,151.08732599999999)
212	Avalon	1	2107	'avalon':1	(-33.628999999999998,151.32400000000001)
315	North Parramatta	1	2151	'north':1 'parramatta':2	(-33.798043,151.010707)
319	Baulkham Hills	1	2153	'baulkham':1 'hill':2	(-33.758600999999999,150.992887)
321	Castle Hill	1	2154	'castl':1 'hill':2	(-33.732306999999999,151.005616)
284	Granville	1	2142	'granvill':1	(-33.835887,151.01064)
338	Guildford	1	2161	'guildford':1	(-33.853983999999997,150.98595800000001)
350	Fairfield	1	2165	'fairfield':1	(-33.868529000000002,150.955512)
371	Liverpool	1	2170	'liverpool':1	(-33.925049999999999,150.924429)
278	Concord Repatriation Hospital	1	2139	'concord':1 'hospit':3 'repatri':2	(-33.837702,151.095046)
279	Homebush	1	2140	'homebush':1	(-33.859653999999999,151.08184700000001)
280	Homebush West	1	2140	'homebush':1 'west':2	(-33.866788,151.06936899999999)
282	Berala	1	2141	'berala':1	(-33.871904000000001,151.03103300000001)
286	Camellia	1	2142	'camellia':1	(-33.816871999999996,151.02219099999999)
287	Clyde	1	2142	'clyde':1	(-33.832321999999998,151.01941400000001)
288	Holroyd	1	2142	'holroyd':1	(-33.829836,150.993334)
285	South Granville	1	2142	'granvill':2 'south':1	(-33.863022000000001,151.006224)
289	Birrong	1	2143	'birrong':1	(-33.890219999999999,151.02239800000001)
290	Potts Hill	1	2143	'hill':2 'pott':1	(-33.898246999999998,151.03108700000001)
294	Girraween	1	2145	'girraween':1	(-33.799843000000003,150.94727599999999)
295	Greystanes	1	2145	'greystan':1	(-33.829667000000001,150.95145199999999)
296	Mays Hill	1	2145	'hill':2 'may':1	(-33.820659999999997,150.990511)
297	Pemulwuy	1	2145	'pemulwuy':1	(-33.821944000000002,150.92375200000001)
298	Pendle Hill	1	2145	'hill':2 'pendl':1	(-33.801912000000002,150.955614)
299	Wentworthville	1	2145	'wentworthvill':1	(-33.805922000000002,150.97018299999999)
301	Westmead	1	2145	'westmead':1	(-33.805332,150.98660799999999)
303	Old Toongabbie	1	2146	'old':1 'toongabbi':2	(-33.792712999999999,150.974108)
302	Toongabbie	1	2146	'toongabbi':1	(-33.788941999999999,150.95064400000001)
306	Kings Langley	1	2147	'king':1 'langley':2	(-33.742078999999997,150.92271099999999)
305	Seven Hills West	1	2147	'hill':2 'seven':1 'west':3	(-33.771047000000003,150.92387099999999)
308	Arndell Park	1	2148	'arndel':1 'park':2	(-33.787266000000002,150.871959)
309	Blacktown	1	2148	'blacktown':1	(-33.770184,150.908501)
310	Kings Park	1	2148	'king':1 'park':2	(-33.745736000000001,150.90459799999999)
312	Prospect	1	2148	'prospect':1	(-33.801552999999998,150.91619800000001)
313	Harris Park	1	2150	'harri':1 'park':2	(-33.822426999999998,151.008961)
316	North Rocks	1	2151	'north':1 'rock':2	(-33.768118999999999,151.02853999999999)
317	Northmead	1	2152	'northmead':1	(-33.783848999999996,150.994336)
318	Winston Hills	1	2153	'hill':2 'winston':1	(-33.776054000000002,150.98779500000001)
322	Beaumont Hills	1	2155	'beaumont':1 'hill':2	(-33.703415999999997,150.94687500000001)
323	Kellyville	1	2155	'kellyvill':1	(-33.712415,150.958009)
325	Rouse Hill	1	2155	'hill':2 'rous':1	(-33.682068000000001,150.91539700000001)
327	Annangrove	1	2156	'annangrov':1	(-33.657772000000001,150.94350499999999)
328	Glenhaven	1	2156	'glenhaven':1	(-33.703218,151.006899)
326	Kenthurst	1	2156	'kenthurst':1	(-33.661023,151.00503399999999)
329	Glenorie	1	2157	'glenori':1	(-33.620010999999998,151.02303499999999)
330	Dural	1	2158	'dural':1	(-32.568857999999999,150.84364199999999)
332	Arcadia	1	2159	'arcadia':1	(-33.623100999999998,151.05272600000001)
333	Berrilee	1	2159	'berrile':1	(-33.61497,151.095573)
334	Fiddletown	1	2159	'fiddletown':1	(-33.602321000000003,151.055702)
335	Galston	1	2159	'galston':1	(-33.652661000000002,151.043059)
336	Merrylands	1	2160	'merryland':1	(-33.836381000000003,150.98921899999999)
339	Guildford West	1	2161	'guildford':1 'west':2	(-33.851098999999998,150.97229899999999)
340	Old Guildford	1	2161	'guildford':2 'old':1	(-33.867083999999998,150.98807300000001)
341	Yennora	1	2161	'yennora':1	(-33.860889,150.969356)
342	Sefton	1	2162	'sefton':1	(-33.885500999999998,151.01146900000001)
344	Carramar	1	2163	'carramar':1	(-33.884557999999998,150.961884)
345	Lansdowne	1	2163	'lansdown':1	(-31.782989000000001,152.53457900000001)
346	Villawood	1	2163	'villawood':1	(-33.883679000000001,150.97646800000001)
347	Smithfield	1	2164	'smithfield':1	(-33.853546000000001,150.94043099999999)
349	Woodpark	1	2164	'woodpark':1	(-33.840629999999997,150.961859)
351	Fairfield East	1	2165	'east':2 'fairfield':1	(-33.869449000000003,150.97752800000001)
352	Fairfield Heights	1	2165	'fairfield':1 'height':2	(-33.864603000000002,150.93845099999999)
353	Fairfield West	1	2165	'fairfield':1 'west':2	(-33.868955,150.922057)
354	Cabramatta	1	2166	'cabramatta':1	(-33.895069999999997,150.935889)
356	Canley Heights	1	2166	'canley':1 'height':2	(-33.883633000000003,150.92389499999999)
357	Canley Vale	1	2166	'canley':1 'vale':2	(-33.887290999999998,150.943275)
358	Lansvale	1	2166	'lansval':1	(-33.897329999999997,150.952786)
359	Glenfield	1	2167	'glenfield':1	(-33.971305000000001,150.89451700000001)
361	Busby	1	2168	'busbi':1	(-33.910896000000001,150.87515500000001)
362	Cartwright	1	2168	'cartwright':1	(-33.926577000000002,150.890356)
363	Green Valley	1	2168	'green':1 'valley':2	(-33.903525999999999,150.86635999999999)
364	Heckenberg	1	2168	'heckenberg':1	(-33.911082999999998,150.88992099999999)
367	Sadleir	1	2168	'sadleir':1	(-33.920628999999998,150.89021199999999)
368	Casula	1	2170	'casula':1	(-33.94735,150.90775300000001)
369	Chipping Norton	1	2170	'chip':1 'norton':2	(-33.916829,150.96166199999999)
372	Liverpool South	1	2170	'liverpool':1 'south':2	(-33.933376000000003,150.90660800000001)
373	Lurnea	1	2170	'lurnea':1	(-33.931947000000001,150.89610500000001)
375	Mount Pritchard	1	2170	'mount':1 'pritchard':2	(-33.894817000000003,150.90304)
2312	Warren	1	2824	'warren':1	(-31.699379,147.83731)
366	Miller	1	2168	'miller':1	(-33.911000000000001,150.87799999999999)
463	Hurstville	1	2220	'hurstvill':1	(-33.965922999999997,151.10118399999999)
420	Bankstown	1	2200	'bankstown':1	(-33.919539,151.034909)
447	Milperra	1	2214	'milperra':1	(-33.937834000000002,150.98926299999999)
376	Prestons	1	2170	'preston':1	(-33.942903000000001,150.87214499999999)
378	Cecil Hills	1	2171	'cecil':1 'hill':2	(-33.883696,150.853171)
379	Horningsea Park	1	2171	'horningsea':1 'park':2	(-33.945087999999998,150.842975)
380	Hoxton Park	1	2171	'hoxton':1 'park':2	(-33.926780000000001,150.857888)
382	West Hoxton	1	2171	'hoxton':2 'west':1	(-33.922272,150.839967)
383	Pleasure Point	1	2172	'pleasur':1 'point':2	(-33.966909000000001,150.98764)
384	Sandy Point	1	2172	'point':2 'sandi':1	(-33.975419000000002,150.993967)
386	Holsworthy	1	2173	'holsworthi':1	(-33.950403000000001,150.949972)
387	Wattle Grove	1	2173	'grove':2 'wattl':1	(-33.963315999999999,150.93640300000001)
390	Abbotsbury	1	2176	'abbotsburi':1	(-33.877538000000001,150.86776800000001)
391	Bossley Park	1	2176	'bossley':1 'park':2	(-33.866259999999997,150.88415000000001)
499	Loftus	1	2232	'loftus':1	(-34.048074999999997,151.051176)
392	Edensor Park	1	2176	'edensor':1 'park':2	(-33.877057000000001,150.875292)
393	Greenfield Park	1	2176	'greenfield':1 'park':2	(-33.872186999999997,150.889408)
394	Prairiewood	1	2176	'prairiewood':1	(-33.867342000000001,150.90213)
396	Wakeley	1	2176	'wakeley':1	(-33.873966000000003,150.90888000000001)
397	Bonnyrigg	1	2177	'bonnyrigg':1	(-33.888801000000001,150.886505)
398	Bonnyrigg Heights	1	2177	'bonnyrigg':1 'height':2	(-33.892667000000003,150.868448)
399	Cecil Park	1	2178	'cecil':1 'park':2	(-33.874780000000001,150.83822499999999)
400	Kemps Creek	1	2178	'creek':2 'kemp':1	(-33.880130000000001,150.79048499999999)
402	Austral	1	2179	'austral':1	(-33.933109000000002,150.81203099999999)
403	Leppington	1	2179	'leppington':1	(-33.964333000000003,150.81727000000001)
404	Chullora	1	2190	'chullora':1	(-33.892440999999998,151.05589800000001)
405	Greenacre	1	2190	'greenacr':1	(-33.906744000000003,151.05727099999999)
407	Belfield	1	2191	'belfield':1	(-33.902107000000001,151.08355299999999)
408	Belmore	1	2192	'belmor':1	(-33.916035000000001,151.08750000000001)
409	Ashbury	1	2193	'ashburi':1	(-33.901896999999998,151.11931999999999)
410	Canterbury	1	2193	'canterburi':1	(-33.910848000000001,151.12114500000001)
412	Campsie	1	2194	'campsi':1	(-33.914372999999998,151.103465)
413	Lakemba	1	2195	'lakemba':1	(-33.920456999999999,151.07592099999999)
414	Wiley Park	1	2195	'park':2 'wiley':1	(-33.922463999999998,151.06819400000001)
415	Punchbowl	1	2196	'punchbowl':1	(-29.494599000000001,152.795221)
416	Roselands	1	2196	'roseland':1	(-33.933166999999997,151.07319699999999)
418	Georges Hall	1	2198	'georg':1 'hall':2	(-33.912851000000003,150.98246900000001)
419	Yagoona	1	2199	'yagoona':1	(-33.907724999999999,151.02610799999999)
421	Condell Park	1	2200	'condel':1 'park':2	(-33.922033999999996,151.011619)
424	Arncliffe	1	2205	'arncliff':1	(-33.936591999999997,151.146805)
425	Turrella	1	2205	'turrella':1	(-33.929963000000001,151.14064300000001)
426	Wolli Creek	1	2205	'creek':2 'wolli':1	(-33.930743999999997,151.155272)
427	Clemton Park	1	2206	'clemton':1 'park':2	(-33.925356999999998,151.10328200000001)
428	Earlwood	1	2206	'earlwood':1	(-33.92651,151.12647999999999)
430	Bardwell Valley	1	2207	'bardwel':1 'valley':2	(-33.935082999999999,151.13468599999999)
431	Bexley	1	2207	'bexley':1	(-33.949134999999998,151.12720999999999)
432	Bexley North	1	2207	'bexley':1 'north':2	(-33.938305999999997,151.11418599999999)
434	Beverly Hills	1	2209	'bever':1 'hill':2	(-33.954217999999997,151.07636400000001)
435	Narwee	1	2209	'narwe':1	(-33.948608999999998,151.06962799999999)
436	Peakhurst	1	2210	'peakhurst':1	(-33.959715000000003,151.06218699999999)
437	Peakhurst Heights	1	2210	'height':2 'peakhurst':1	(-33.968127000000003,151.05759599999999)
438	Riverwood	1	2210	'riverwood':1	(-33.949858999999996,151.052469)
441	Padstow Heights	1	2211	'height':2 'padstow':1	(-33.971072999999997,151.03095500000001)
442	Revesby	1	2212	'revesbi':1	(-33.951506999999999,151.017247)
443	Revesby Heights	1	2212	'height':2 'revesbi':1	(-33.968801999999997,151.015063)
445	Panania	1	2213	'panania':1	(-33.956130000000002,150.99804700000001)
446	Picnic Point	1	2213	'picnic':1 'point':2	(-33.979303000000002,151.000056)
448	Banksia	1	2216	'banksia':1	(-33.945236999999999,151.14016100000001)
450	Kyeemagh	1	2216	'kyeemagh':1	(-33.951452000000003,151.159943)
451	Rockdale	1	2216	'rockdal':1	(-33.952747000000002,151.13762399999999)
452	Beverley Park	1	2217	'beverley':1 'park':2	(-33.975135000000002,151.13134500000001)
453	Kogarah	1	2217	'kogarah':1	(-33.963107000000001,151.13346200000001)
454	Kogarah Bay	1	2217	'bay':2 'kogarah':1	(-33.979117000000002,151.12329600000001)
455	Monterey	1	2217	'monterey':1	(-33.973067999999998,151.150983)
456	Ramsgate	1	2217	'ramsgat':1	(-33.984682999999997,151.139847)
458	Allawah	1	2218	'allawah':1	(-33.970018000000003,151.11451700000001)
459	Carlton	1	2218	'carlton':1	(-33.968522999999998,151.124528)
460	Dolls Point	1	2219	'doll':1 'point':2	(-33.993495000000003,151.14680100000001)
461	Sandringham	1	2219	'sandringham':1	(-33.998762999999997,151.139252)
462	Sans Souci	1	2219	'san':1 'souci':2	(-33.990614000000001,151.13307399999999)
467	Blakehurst	1	2221	'blakehurst':1	(-33.988742999999999,151.112314)
468	Carss Park	1	2221	'carss':1 'park':2	(-33.986556,151.11904100000001)
469	Connells Point	1	2221	'connel':1 'point':2	(-33.991871000000003,151.089495)
465	Kyle Bay	1	2221	'bay':2 'kyle':1	(-33.991238000000003,151.09830099999999)
470	Penshurst	1	2222	'penshurst':1	(-33.963346000000001,151.08674400000001)
471	Mortdale	1	2223	'mortdal':1	(-33.972239000000002,151.075391)
472	Oatley	1	2223	'oatley':1	(-33.981428000000001,151.08276499999999)
2313	Bogan	1	2825	'bogan':1	(-30.198141,146.53819999999999)
388	Edmondson Park	1	2174	'edmondson':1 'park':2	(-33.960999999999999,150.858)
500	Sutherland	1	2232	'sutherland':1	(-34.031432000000002,151.057965)
473	Kangaroo Point	1	2224	'kangaroo':1 'point':2	(-33.997971999999997,151.09623500000001)
474	Sylvania	1	2224	'sylvania':1	(-34.008074999999998,151.10510400000001)
476	Oyster Bay	1	2225	'bay':2 'oyster':1	(-34.006894000000003,151.08106699999999)
477	Bonnet Bay	1	2226	'bay':2 'bonnet':1	(-34.009518,151.05425199999999)
478	Como	1	2226	'como':1	(-34.004185999999997,151.068288)
479	Jannali	1	2226	'jannali':1	(-34.017074000000001,151.06508099999999)
480	Gymea	1	2227	'gymea':1	(-34.033141999999998,151.085421)
483	Yowie Bay	1	2228	'bay':2 'yowi':1	(-34.049866000000002,151.10432499999999)
485	Dolans Bay	1	2229	'bay':2 'dolan':1	(-34.05968,151.126746)
486	Lilli Pilli	1	2229	'lilli':1 'pilli':2	(-35.773316999999999,150.225056)
488	Taren Point	1	2229	'point':2 'taren':1	(-34.012545000000003,151.12545600000001)
489	Bundeena	1	2230	'bundeena':1	(-34.085064000000003,151.15125900000001)
490	Burraneer	1	2230	'burran':1	(-34.065063000000002,151.137171)
491	Cronulla	1	2230	'cronulla':1	(-34.051971999999999,151.153662)
492	Maianbar	1	2230	'maianbar':1	(-34.081826,151.12978799999999)
494	Kurnell	1	2231	'kurnel':1	(-34.008487000000002,151.20487900000001)
495	Audley	1	2232	'audley':1	(-34.075294999999997,151.05651900000001)
496	Grays Point	1	2232	'gray':1 'point':2	(-34.058839999999996,151.08165199999999)
497	Kareela	1	2232	'kareela':1	(-34.014668,151.08273299999999)
501	Woronora	1	2232	'woronora':1	(-34.020654,151.047946)
502	Engadine	1	2233	'engadin':1	(-34.065716000000002,151.012663)
504	Waterfall	1	2233	'waterfal':1	(-34.135199999999998,150.994957)
505	Woronora Heights	1	2233	'height':2 'woronora':1	(-34.034835999999999,151.02765600000001)
506	Yarrawarrah	1	2233	'yarrawarrah':1	(-34.058461999999999,151.03279000000001)
508	Bangor	1	2234	'bangor':1	(-34.018875999999999,151.030057)
509	Barden Ridge	1	2234	'barden':1 'ridg':2	(-34.032851000000001,151.00539599999999)
510	Illawong	1	2234	'illawong':1	(-33.998018000000002,151.04259099999999)
511	Lucas Heights	1	2234	'height':2 'luca':1	(-34.047984999999997,150.98836900000001)
512	Menai	1	2234	'menai':1	(-34.012563999999998,151.014645)
513	Calga	1	2250	'calga':1	(-33.43835,151.236467)
518	Erina	1	2250	'erina':1	(-33.437893000000003,151.38364799999999)
514	Gosford	1	2250	'gosford':1	(-33.426938,151.34184300000001)
519	Kariong	1	2250	'kariong':1	(-33.439732999999997,151.29333299999999)
520	Kulnura	1	2250	'kulnura':1	(-33.225923999999999,151.22210100000001)
522	Lower Mangrove	1	2250	'lower':1 'mangrov':2	(-33.412044999999999,151.150688)
523	Mangrove Mountain	1	2250	'mangrov':1 'mountain':2	(-33.300846999999997,151.19166100000001)
524	Matcham	1	2250	'matcham':1	(-33.417003999999999,151.42083400000001)
526	Narara	1	2250	'narara':1	(-33.395806999999998,151.346114)
527	Niagara Park	1	2250	'niagara':1 'park':2	(-33.381996000000001,151.355782)
516	North Gosford	1	2250	'gosford':2 'north':1	(-33.416840000000001,151.34882099999999)
528	Peats Ridge	1	2250	'peat':1 'ridg':2	(-33.351199000000001,151.229736)
530	Somersby	1	2250	'somersbi':1	(-33.360992000000003,151.29105300000001)
531	Springfield	1	2250	'springfield':1	(-36.542350999999996,149.076874)
532	Tascott	1	2250	'tascott':1	(-33.450817999999998,151.31944200000001)
533	Wendoree Park	1	2250	'park':2 'wendore':1	(-33.455551999999997,151.155631)
534	Wyoming	1	2250	'wyom':1	(-33.404850000000003,151.350776)
535	Avoca Beach	1	2251	'avoca':1 'beach':2	(-33.464936999999999,151.43238700000001)
536	Bensville	1	2251	'bensvill':1	(-33.498578999999999,151.381089)
537	Copacabana	1	2251	'copacabana':1	(-33.489939999999997,151.43055799999999)
538	Davistown	1	2251	'davistown':1	(-33.485684999999997,151.36052100000001)
540	Kincumber	1	2251	'kincumb':1	(-33.467737999999997,151.382147)
541	Macmasters Beach	1	2251	'beach':2 'macmast':1	(-33.492820999999999,151.41647900000001)
542	Saratoga	1	2251	'saratoga':1	(-33.475692000000002,151.35414900000001)
543	Yattalunga	1	2251	'yattalunga':1	(-33.470568,151.360536)
544	Blackwall	1	2256	'blackwal':1	(-33.503433999999999,151.32763199999999)
546	Patonga	1	2256	'patonga':1	(-33.546452000000002,151.27118999999999)
547	Pearl Beach	1	2256	'beach':2 'pearl':1	(-33.538915000000003,151.30281299999999)
548	Phegans Bay	1	2256	'bay':2 'phegan':1	(-33.488590000000002,151.30845299999999)
549	Woy Woy	1	2256	'woy':1,2	(-33.485855000000001,151.32477499999999)
551	Daleys Point	1	2257	'daley':1 'point':2	(-33.505690000000001,151.34818100000001)
552	Empire Bay	1	2257	'bay':2 'empir':1	(-33.494185999999999,151.362188)
553	Ettalong Beach	1	2257	'beach':2 'ettalong':1	(-33.513696000000003,151.33528899999999)
555	Killcare	1	2257	'killcar':1	(-33.525978000000002,151.36265700000001)
556	Pretty Beach	1	2257	'beach':2 'pretti':1	(-35.564463000000003,150.379514)
557	St Huberts Island	1	2257	'hubert':2 'island':3 'st':1	(-33.495721000000003,151.34444099999999)
558	Umina Beach	1	2257	'beach':2 'umina':1	(-33.528745999999998,151.307503)
560	Ourimbah	1	2258	'ourimbah':1	(-33.359703000000003,151.36965000000001)
561	Chain Valley Bay	1	2259	'bay':3 'chain':1 'valley':2	(-33.174101999999998,151.580195)
562	Dooralong	1	2259	'dooralong':1	(-33.189383999999997,151.35021499999999)
563	Durren Durren	1	2259	'durren':1,2	(-33.171430999999998,151.38228799999999)
565	Halloran	1	2259	'halloran':1	(-33.239446000000001,151.43951799999999)
566	Hamlyn Terrace	1	2259	'hamlyn':1 'terrac':2	(-33.250574,151.46987200000001)
567	Jilliby	1	2259	'jillibi':1	(-33.230854000000001,151.39186900000001)
568	Kanwal	1	2259	'kanwal':1	(-33.263412000000002,151.47965300000001)
570	Lemon Tree	1	2259	'lemon':1 'tree':2	(-33.146101999999999,151.36480299999999)
571	Mannering Park	1	2259	'manner':1 'park':2	(-33.150537999999997,151.53760299999999)
572	Mardi	1	2259	'mardi':1	(-33.28342,151.404775)
573	Ravensdale	1	2259	'ravensdal':1	(-33.147469999999998,151.28858399999999)
575	Tacoma	1	2259	'tacoma':1	(-33.285488999999998,151.453689)
576	Tuggerah	1	2259	'tuggerah':1	(-33.307009999999998,151.41590099999999)
577	Tuggerawong	1	2259	'tuggerawong':1	(-33.280656999999998,151.47631200000001)
578	Wallarah	1	2259	'wallarah':1	(-33.241850999999997,151.45652200000001)
579	Warnervale	1	2259	'warnerval':1	(-33.242434000000003,151.45978600000001)
581	Woongarrah	1	2259	'woongarrah':1	(-33.246082000000001,151.477239)
582	Wyee	1	2259	'wyee':1	(-33.175843999999998,151.48495800000001)
583	Wyong	1	2259	'wyong':1	(-33.283479999999997,151.422404)
585	Yarramalong	1	2259	'yarramalong':1	(-33.222529000000002,151.27749499999999)
586	Erina Heights	1	2260	'erina':1 'height':2	(-33.426949,151.41321099999999)
587	Forresters Beach	1	2260	'beach':2 'forrest':1	(-33.407108000000001,151.46388400000001)
589	Terrigal	1	2260	'terrig':1	(-33.448011000000001,151.44446099999999)
590	Wamberal	1	2260	'wamber':1	(-33.418298,151.44619299999999)
591	Bateau Bay	1	2261	'bateau':1 'bay':2	(-33.381213000000002,151.47910400000001)
592	Berkeley Vale	1	2261	'berkeley':1 'vale':2	(-33.341788000000001,151.43163000000001)
593	Blue Bay	1	2261	'bay':2 'blue':1	(-33.357183999999997,151.50004799999999)
595	Chittaway Point	1	2261	'chittaway':1 'point':2	(-33.326616000000001,151.463661)
596	Glenning Valley	1	2261	'glen':1 'valley':2	(-33.353709000000002,151.425996)
597	Killarney Vale	1	2261	'killarney':1 'vale':2	(-33.369601000000003,151.45978299999999)
598	Long Jetty	1	2261	'jetti':2 'long':1	(-33.359163000000002,151.48417800000001)
599	Magenta	1	2261	'magenta':1	(-33.313335000000002,151.51951700000001)
601	The Entrance	1	2261	'entranc':2	(-33.344647999999999,151.49639400000001)
602	The Entrance North	1	2261	'entranc':2 'north':3	(-33.326253999999999,151.51124899999999)
603	Toowoon Bay	1	2261	'bay':2 'toowoon':1	(-33.358020000000003,151.49659199999999)
604	Tumbi Umbi	1	2261	'tumbi':1 'umbi':2	(-33.362679,151.44730200000001)
606	Budgewoi	1	2262	'budgewoi':1	(-33.234349000000002,151.55475300000001)
607	Buff Point	1	2262	'buff':1 'point':2	(-33.238196000000002,151.53526600000001)
608	Doyalson	1	2262	'doyalson':1	(-33.197167999999998,151.52111600000001)
609	Halekulani	1	2262	'halekulani':1	(-33.223483999999999,151.550635)
611	Canton Beach	1	2263	'beach':2 'canton':1	(-33.271922000000004,151.54404500000001)
612	Charmhaven	1	2263	'charmhaven':1	(-33.229911999999999,151.50291200000001)
613	Gorokan	1	2263	'gorokan':1	(-33.257544000000003,151.51039900000001)
614	Lake Haven	1	2263	'haven':2 'lake':1	(-33.240091999999997,151.50192799999999)
616	Noraville	1	2263	'noravill':1	(-33.265942000000003,151.55991399999999)
617	Toukley	1	2263	'toukley':1	(-33.265459,151.540695)
618	Bonnells Bay	1	2264	'bay':2 'bonnel':1	(-33.107405,151.51826299999999)
619	Brightwaters	1	2264	'brightwat':1	(-33.114455,151.54592500000001)
621	Eraring	1	2264	'erar':1	(-33.071249000000002,151.52294599999999)
622	Mandalong	1	2264	'mandalong':1	(-33.145240999999999,151.414627)
623	Mirrabooka	1	2264	'mirrabooka':1	(-33.108634000000002,151.55500599999999)
624	Morisset	1	2264	'morisset':1	(-33.108336000000001,151.48775800000001)
628	Cooranbong	1	2265	'cooranbong':1	(-33.076608999999998,151.45398900000001)
629	Martinsville	1	2265	'martinsvill':1	(-33.055785,151.40624299999999)
630	Wangi Wangi	1	2267	'wangi':1,2	(-33.071491000000002,151.58436599999999)
631	Barnsley	1	2278	'barnsley':1	(-32.932411999999999,151.59041500000001)
633	Wakefield	1	2278	'wakefield':1	(-32.956583999999999,151.56050400000001)
634	Belmont	1	2280	'belmont':1	(-33.036057,151.660563)
635	Belmont North	1	2280	'belmont':1 'north':2	(-33.022227999999998,151.67202800000001)
636	Belmont South	1	2280	'belmont':1 'south':2	(-33.053170000000001,151.654854)
638	Floraville	1	2280	'floravill':1	(-33.009036000000002,151.66465400000001)
639	Jewells	1	2280	'jewel':1	(-33.014125,151.68317400000001)
640	Marks Point	1	2280	'mark':1 'point':2	(-33.055211999999997,151.64609799999999)
641	Valentine	1	2280	'valentin':1	(-33.008885999999997,151.635155)
642	Blacksmiths	1	2281	'blacksmith':1	(-33.077160999999997,151.65230500000001)
644	Catherine Hill Bay	1	2281	'bay':3 'catherin':1 'hill':2	(-33.161794999999998,151.626395)
645	Caves Beach	1	2281	'beach':2 'cave':1	(-33.108212000000002,151.64014700000001)
646	Middle Camp	1	2281	'camp':2 'middl':1	(-33.13447,151.626476)
647	Nords Wharf	1	2281	'nord':1 'wharf':2	(-33.135174999999997,151.603972)
649	Eleebana	1	2282	'eleebana':1	(-32.993625999999999,151.635401)
650	Lakelands	1	2282	'lakeland':1	(-32.961483000000001,151.65087600000001)
651	Warners Bay	1	2282	'bay':2 'warner':1	(-32.975417999999998,151.64468199999999)
653	Awaba	1	2283	'awaba':1	(-33.007739000000001,151.543407)
654	Balmoral	1	2283	'balmor':1	(-34.294421999999997,150.52525900000001)
655	Blackalls Park	1	2283	'blackal':1 'park':2	(-33.000441000000002,151.58463499999999)
656	Bolton Point	1	2283	'bolton':1 'point':2	(-33.000416999999999,151.610354)
657	Buttaba	1	2283	'buttaba':1	(-33.050936,151.57193699999999)
659	Coal Point	1	2283	'coal':1 'point':2	(-33.041296000000003,151.61217199999999)
660	Fassifern	1	2283	'fassifern':1	(-32.988368000000001,151.58324400000001)
661	Fennell Bay	1	2283	'bay':2 'fennel':1	(-32.992103999999998,151.60009299999999)
663	Kilaben Bay	1	2283	'bay':2 'kilaben':1	(-33.024534000000003,151.58729400000001)
664	Rathmines	1	2283	'rathmin':1	(-33.045785000000002,151.59415000000001)
665	Toronto	1	2283	'toronto':1	(-33.013289999999998,151.59316200000001)
666	Argenton	1	2284	'argenton':1	(-32.934812999999998,151.63087899999999)
667	Boolaroo	1	2284	'boolaroo':1	(-32.955269000000001,151.622332)
669	Marmong Point	1	2284	'marmong':1 'point':2	(-32.983018999999999,151.61811499999999)
670	Speers Point	1	2284	'point':2 'speer':1	(-32.973542999999999,151.63136600000001)
671	Teralba	1	2284	'teralba':1	(-32.963726999999999,151.60503499999999)
626	Sunshine	1	2264	'sunshin':1	(-33.107999999999997,151.47200000000001)
745	Hunter Region	1	2310	'hunter':1 'region':2	\N
673	Cameron Park	1	2285	'cameron':1 'park':2	(-32.933951999999998,151.655731)
674	Cardiff	1	2285	'cardiff':1	(-32.939704999999996,151.65934300000001)
675	Cardiff Heights	1	2285	'cardiff':1 'height':2	(-32.936219000000001,151.67225300000001)
677	Edgeworth	1	2285	'edgeworth':1	(-32.923766000000001,151.62224900000001)
678	Glendale	1	2285	'glendal':1	(-32.926822999999999,151.65018900000001)
679	Macquarie Hills	1	2285	'hill':2 'macquari':1	(-32.953150999999998,151.64711600000001)
680	Holmesville	1	2286	'holmesvill':1	(-32.913660999999998,151.57684699999999)
681	West Wallsend	1	2286	'wallsend':2 'west':1	(-32.902476,151.58284599999999)
683	Elermore Vale	1	2287	'elermor':1 'vale':2	(-32.916279000000003,151.675532)
684	Fletcher	1	2287	'fletcher':1	(-32.876573,151.637463)
685	Maryland	1	2287	'maryland':1	(-32.879832999999998,151.66045299999999)
686	Minmi	1	2287	'minmi':1	(-32.877152000000002,151.61778899999999)
687	Rankin Park	1	2287	'park':2 'rankin':1	(-32.928387999999998,151.682894)
690	Adamstown	1	2289	'adamstown':1	(-32.932538000000001,151.72624999999999)
691	Adamstown Heights	1	2289	'adamstown':1 'height':2	(-32.950983999999998,151.71769499999999)
692	Garden Suburb	1	2289	'garden':1 'suburb':2	(-32.948354999999999,151.68336500000001)
693	Highfields	1	2289	'highfield':1	(-32.955758000000003,151.71266800000001)
695	Kotara South	1	2289	'kotara':1 'south':2	(-32.950811000000002,151.694264)
696	Bennetts Green	1	2290	'bennett':1 'green':2	(-32.995468000000002,151.68908400000001)
697	Charlestown	1	2290	'charlestown':1	(-32.965671,151.69545400000001)
699	Gateshead	1	2290	'gateshead':1	(-32.989024999999998,151.693851)
700	Hillsborough	1	2290	'hillsborough':1	(-32.636820999999998,151.46775600000001)
701	Kahibah	1	2290	'kahibah':1	(-32.961795000000002,151.71235100000001)
703	Redhead	1	2290	'redhead':1	(-33.013486999999998,151.71438499999999)
704	Tingira Heights	1	2290	'height':2 'tingira':1	(-32.997186999999997,151.66971899999999)
705	Whitebridge	1	2290	'whitebridg':1	(-32.981226999999997,151.711319)
706	Merewether	1	2291	'mereweth':1	(-32.942236999999999,151.751451)
708	The Junction	1	2291	'junction':2	(-32.937528,151.759625)
709	Broadmeadow	1	2292	'broadmeadow':1	(-32.924165000000002,151.737829)
710	Hamilton North	1	2292	'hamilton':1 'north':2	(-32.912413000000001,151.73778999999999)
711	Maryville	1	2293	'maryvill':1	(-32.911844000000002,151.75366199999999)
712	Wickham	1	2293	'wickham':1	(-32.920972999999996,151.76003)
714	Fern Bay	1	2295	'bay':2 'fern':1	(-32.854436,151.81034600000001)
715	Stockton	1	2295	'stockton':1	(-32.916119999999999,151.78438)
716	Islington	1	2296	'islington':1	(-32.911915,151.745721)
717	Tighes Hill	1	2297	'hill':2 'tigh':1	(-32.908014000000001,151.751115)
719	Waratah	1	2298	'waratah':1	(-32.908152000000001,151.72721999999999)
720	Waratah West	1	2298	'waratah':1 'west':2	(-32.898789999999998,151.71176199999999)
721	Jesmond	1	2299	'jesmond':1	(-32.903131000000002,151.69085799999999)
722	Lambton	1	2299	'lambton':1	(-32.911447000000003,151.707393)
724	Bar Beach	1	2300	'bar':1 'beach':2	(-32.939962000000001,151.768383)
725	Cooks Hill	1	2300	'cook':1 'hill':2	(-32.934130000000003,151.76924399999999)
726	Newcastle	1	2300	'newcastl':1	(-32.926357000000003,151.78121999999999)
728	The Hill	1	2300	'hill':2	(-32.929808000000001,151.77738199999999)
729	Newcastle West	1	2302	'newcastl':1 'west':2	(-32.924908000000002,151.76114100000001)
730	Hamilton	1	2303	'hamilton':1	(-32.924042,151.74687399999999)
731	Kooragang	1	2304	'kooragang':1	(-32.875728000000002,151.74598)
732	Mayfield	1	2304	'mayfield':1	(-33.663290000000003,149.78020900000001)
733	Mayfield East	1	2304	'east':2 'mayfield':1	(-32.900016999999998,151.750102)
734	Mayfield North	1	2304	'mayfield':1 'north':2	(-32.883840999999997,151.73928900000001)
735	Mayfield West	1	2304	'mayfield':1 'west':2	(-32.890538999999997,151.72550000000001)
736	Sandgate	1	2304	'sandgat':1	(-32.867845000000003,151.708214)
738	New Lambton	1	2305	'lambton':2 'new':1	(-32.923932000000001,151.71317400000001)
739	New Lambton Heights	1	2305	'height':3 'lambton':2 'new':1	(-32.932574000000002,151.69055299999999)
740	Windale	1	2306	'windal':1	(-32.997694000000003,151.68105299999999)
741	Shortland	1	2307	'shortland':1	(-32.880873000000001,151.69153299999999)
746	Allynbrook	1	2311	'allynbrook':1	(-32.363343,151.53622899999999)
748	East Gresford	1	2311	'east':1 'gresford':2	(-32.428615999999998,151.55322699999999)
747	Gresford	1	2311	'gresford':1	(-32.427030999999999,151.53778399999999)
749	Halton	1	2311	'halton':1	(-32.315134999999998,151.51413299999999)
751	Nabiac	1	2312	'nabiac':1	(-32.098694000000002,152.377769)
752	Williamtown Raaf	1	2314	'raaf':2 'williamtown':1	(-32.797364999999999,151.83698999999999)
753	Corlette	1	2315	'corlett':1	(-32.721158000000003,152.10678200000001)
755	Nelson Bay	1	2315	'bay':2 'nelson':1	(-32.717075000000001,152.15486300000001)
756	Shoal Bay	1	2315	'bay':2 'shoal':1	(-32.724136000000001,152.17497900000001)
757	Anna Bay	1	2316	'anna':1 'bay':2	(-32.776918999999999,152.08327399999999)
759	Bobs Farm	1	2316	'bob':1 'farm':2	(-32.767544000000001,152.01273900000001)
760	Salamander Bay	1	2317	'bay':2 'salamand':1	(-32.720936999999999,152.07639900000001)
761	Soldiers Point	1	2317	'point':2 'soldier':1	(-32.710492000000002,152.06475800000001)
762	Campvale	1	2318	'campval':1	(-32.769905999999999,151.85189700000001)
764	Medowie	1	2318	'medowi':1	(-32.741486000000002,151.86757)
765	Oyster Cove	1	2318	'cove':2 'oyster':1	(-32.735351999999999,151.952662)
766	Salt Ash	1	2318	'ash':2 'salt':1	(-32.788739999999997,151.90723800000001)
767	Williamtown	1	2318	'williamtown':1	(-32.806831000000003,151.844224)
768	Tanilba Bay	1	2319	'bay':2 'tanilba':1	(-32.732588999999997,152.00238899999999)
743	University Of Newcastle	1	2308	'newcastl':3 'univers':1	(-32.890000000000001,151.70400000000001)
814	Carrington	1	2324	'carrington':1	(-32.664341999999998,152.018722)
770	Mallabula	1	2319	'mallabula':1	(-32.72898,152.01174800000001)
771	Aberglasslyn	1	2320	'aberglasslyn':1	(-32.694656000000002,151.53460699999999)
772	Bolwarra	1	2320	'bolwarra':1	(-32.712817000000001,151.572048)
774	Farley	1	2320	'farley':1	(-32.729062999999996,151.51218499999999)
776	Largs	1	2320	'larg':1	(-32.702528000000001,151.60241500000001)
777	Lorn	1	2320	'lorn':1	(-32.728577999999999,151.557064)
778	Maitland	1	2320	'maitland':1	(-32.734713999999997,151.558573)
780	Pokolbin	1	2320	'pokolbin':1	(-32.771323000000002,151.29097300000001)
782	Rutherford	1	2320	'rutherford':1	(-32.716413000000003,151.52792099999999)
779	South Maitland	1	2320	'maitland':2 'south':1	(-32.742294000000001,151.566213)
783	Telarah	1	2320	'telarah':1	(-32.729498999999997,151.536856)
785	Duns Creek	1	2321	'creek':2 'dun':1	(-32.580312999999997,151.78274999999999)
786	Gillieston Heights	1	2321	'gillieston':1 'height':2	(-32.766353000000002,151.527365)
787	Glen William	1	2321	'glen':1 'william':2	(-32.521507999999997,151.79757000000001)
788	Heddon Greta	1	2321	'greta':2 'heddon':1	(-32.804507000000001,151.50956500000001)
789	Hinton	1	2321	'hinton':1	(-32.716588000000002,151.651388)
791	Morpeth	1	2321	'morpeth':1	(-32.724882000000001,151.62666300000001)
792	Raworth	1	2321	'raworth':1	(-32.735981000000002,151.60706400000001)
793	Woodville	1	2321	'woodvill':1	(-32.676183000000002,151.60995)
795	Black Hill	1	2322	'black':1 'hill':2	(-32.823597999999997,151.58365499999999)
796	Hexham	1	2322	'hexham':1	(-32.830649000000001,151.685483)
797	Lenaghan	1	2322	'lenaghan':1	(-32.849201000000001,151.62728200000001)
798	Tarro	1	2322	'tarro':1	(-32.808847,151.668182)
800	Tomago	1	2322	'tomago':1	(-32.818382999999997,151.757485)
801	Woodberry	1	2322	'woodberri':1	(-32.793692,151.66539499999999)
802	Ashtonfield	1	2323	'ashtonfield':1	(-32.773820000000001,151.601)
804	East Maitland	1	2323	'east':1 'maitland':2	(-32.75112,151.58996300000001)
805	Freemans Waterhole	1	2323	'freeman':1 'waterhol':2	(-32.981679,151.483971)
806	Green Hills	1	2323	'green':1 'hill':2	(-35.443992999999999,148.07287400000001)
807	Metford	1	2323	'metford':1	(-32.765912999999998,151.60919999999999)
809	Mulbring	1	2323	'mulbr':1	(-32.900376999999999,151.483)
810	Tenambit	1	2323	'tenambit':1	(-32.743257,151.60432499999999)
811	Balickera	1	2324	'balickera':1	(-32.673022000000003,151.80536699999999)
812	Brandy Hill	1	2324	'brandi':1 'hill':2	(-32.693797000000004,151.69417100000001)
813	Bundabah	1	2324	'bundabah':1	(-32.662213000000001,152.074063)
816	Eagleton	1	2324	'eagleton':1	(-32.698008000000002,151.75642099999999)
817	East Seaham	1	2324	'east':1 'seaham':2	(-32.665424000000002,151.74145799999999)
818	Heatherbrae	1	2324	'heatherbra':1	(-32.787426000000004,151.73238599999999)
819	Karuah	1	2324	'karuah':1	(-32.654063999999998,151.961443)
821	Millers Forest	1	2324	'forest':2 'miller':1	(-32.763539000000002,151.702595)
822	Nelsons Plains	1	2324	'nelson':1 'plain':2	(-32.702328999999999,151.71058400000001)
823	North Arm Cove	1	2324	'arm':2 'cove':3 'north':1	(-32.659120000000001,152.03758300000001)
824	Osterley	1	2324	'osterley':1	(-32.724755999999999,151.70084600000001)
825	Pindimar	1	2324	'pindimar':1	(-32.684153000000002,152.09813800000001)
827	Seaham	1	2324	'seaham':1	(-32.657671999999998,151.721912)
828	Swan Bay	1	2324	'bay':2 'swan':1	(-29.059864999999999,153.31361699999999)
829	Tahlee	1	2324	'tahle':1	(-32.667510999999998,152.00479200000001)
830	Tea Gardens	1	2324	'garden':2 'tea':1	(-32.667386,152.160372)
832	Aberdare	1	2325	'aberdar':1	(-32.844200000000001,151.37651399999999)
833	Abernethy	1	2325	'abernethi':1	(-32.883242000000003,151.39667700000001)
834	Bellbird	1	2325	'bellbird':1	(-32.859960999999998,151.31766099999999)
835	Cessnock	1	2325	'cessnock':1	(-32.832943,151.353993)
836	Congewai	1	2325	'congewai':1	(-32.996509000000003,151.30184299999999)
838	Elrington	1	2325	'elrington':1	(-32.869858999999998,151.42509200000001)
839	Kearsley	1	2325	'kearsley':1	(-32.858649,151.395667)
840	Kitchener	1	2325	'kitchen':1	(-32.879601999999998,151.36667)
841	Laguna	1	2325	'laguna':1	(-32.994585000000001,151.12778800000001)
843	Mount View	1	2325	'mount':1 'view':2	(-32.852431000000003,151.270297)
844	Nulkaba	1	2325	'nulkaba':1	(-32.809621999999997,151.34964099999999)
845	Paxton	1	2325	'paxton':1	(-32.902045000000001,151.27966900000001)
847	Pelton	1	2325	'pelton':1	(-32.879520999999997,151.30133900000001)
848	Quorrobolong	1	2325	'quorrobolong':1	(-32.922469999999997,151.363966)
849	Wollombi	1	2325	'wollombi':1	(-32.937600000000003,151.14266499999999)
850	Abermain	1	2326	'abermain':1	(-32.810814999999998,151.42866799999999)
852	Loxford	1	2326	'loxford':1	(-32.797773999999997,151.482992)
853	Weston	1	2326	'weston':1	(-32.813898999999999,151.45901799999999)
854	Kurri Kurri	1	2327	'kurri':1,2	(-32.817312000000001,151.48295200000001)
855	Pelaw Main	1	2327	'main':2 'pelaw':1	(-32.833663999999999,151.48039800000001)
857	Denman	1	2328	'denman':1	(-32.389403000000001,150.68642199999999)
858	Hollydeen	1	2328	'hollydeen':1	(-32.332810000000002,150.61859899999999)
859	Kerrabee	1	2328	'kerrabe':1	(-32.424076999999997,150.30904799999999)
860	Borambil	1	2329	'borambil':1	(-31.506430000000002,150.642146)
861	Cassilis	1	2329	'cassili':1	(-32.007883,149.980435)
862	Merriwa	1	2329	'merriwa':1	(-32.139418999999997,150.35571899999999)
864	Broke	1	2330	'broke':1	(-32.751221999999999,151.10347400000001)
865	Bulga	1	2330	'bulga':1	(-32.644624,151.03792000000001)
866	Camberwell	1	2330	'camberwel':1	(-32.479700999999999,151.09200200000001)
869	Glennies Creek	1	2330	'creek':2 'glenni':1	(-32.457424000000003,151.111864)
870	Greenlands	1	2330	'greenland':1	(-36.500889000000001,149.42869899999999)
871	Hebden	1	2330	'hebden':1	(-32.385722999999999,151.06480400000001)
2422	Albert	1	2873	'albert':1	(-32.415860000000002,147.50811100000001)
926	Gowrie	1	2340	'gowri':1	(-31.333017000000002,150.85839300000001)
873	Jerrys Plains	1	2330	'jerri':1 'plain':2	(-32.491864,150.90492499999999)
874	Mirannie	1	2330	'miranni':1	(-32.396608000000001,151.37757500000001)
875	Mitchells Flat	1	2330	'flat':2 'mitchel':1	(-32.558245999999997,151.28874099999999)
876	Mount Olive	1	2330	'mount':1 'oliv':2	(-33.598187000000003,149.917271)
877	Putty	1	2330	'putti':1	(-32.969802999999999,150.67417699999999)
879	Reedy Creek	1	2330	'creek':2 'reedi':1	(-32.729382000000001,149.993111)
880	Singleton	1	2330	'singleton':1	(-32.564025000000001,151.16836699999999)
881	St Clair	1	2330	'clair':2 'st':1	(-33.794362,150.79026099999999)
882	Warkworth	1	2330	'warkworth':1	(-32.548788000000002,151.01084700000001)
885	Edderton	1	2333	'edderton':1	(-32.380997999999998,150.822205)
886	Gungal	1	2333	'gungal':1	(-32.225912000000001,150.46925400000001)
887	Liddell	1	2333	'liddel':1	(-32.402763999999998,151.01832300000001)
889	Muscle Creek	1	2333	'creek':2 'muscl':1	(-32.270448999999999,150.99775399999999)
890	Muswellbrook	1	2333	'muswellbrook':1	(-32.263323,150.88882100000001)
891	Sandy Hollow	1	2333	'hollow':2 'sandi':1	(-32.33475,150.56679199999999)
892	Wybong	1	2333	'wybong':1	(-32.277754000000002,150.65722600000001)
893	Greta	1	2334	'greta':1	(-32.677442999999997,151.38874100000001)
895	Branxton	1	2335	'branxton':1	(-32.658245999999998,151.352048)
896	Dalwood	1	2335	'dalwood':1	(-28.888546000000002,153.40983900000001)
897	Elderslie	1	2335	'eldersli':1	(-34.059038000000001,150.71142699999999)
899	Stanhope	1	2335	'stanhop':1	(-32.607337999999999,151.38882100000001)
900	Aberdeen	1	2336	'aberdeen':1	(-29.996058000000001,151.08055400000001)
901	Dartbrook	1	2336	'dartbrook':1	(-32.149399000000003,150.849591)
902	Davis Creek	1	2336	'creek':2 'davi':1	(-32.152417,151.12251900000001)
903	Rouchel	1	2336	'rouchel':1	(-32.148375999999999,151.061442)
905	Bunnan	1	2337	'bunnan':1	(-32.068680000000001,150.60215600000001)
906	Ellerston	1	2337	'ellerston':1	(-31.821731,151.30337)
907	Gundy	1	2337	'gundi':1	(-32.014474999999997,150.99674899999999)
908	Kars Springs	1	2337	'kar':1 'spring':2	(-31.928566,150.54748000000001)
910	Moonan Flat	1	2337	'flat':2 'moonan':1	(-31.926434,151.23546200000001)
911	Owens Gap	1	2337	'gap':2 'owen':1	(-32.025551,150.71809400000001)
912	Parkville	1	2337	'parkvill':1	(-31.981159000000002,150.86540400000001)
913	Scone	1	2337	'scone':1	(-32.050707000000003,150.867527)
915	Wingen	1	2337	'wingen':1	(-31.894214999999999,150.88009500000001)
916	Woolooma	1	2337	'woolooma':1	(-31.994327999999999,151.21960100000001)
917	Ardglen	1	2338	'ardglen':1	(-31.734504999999999,150.78558799999999)
918	Blandford	1	2338	'blandford':1	(-31.793098000000001,150.928753)
919	Murrurundi	1	2338	'murrurundi':1	(-31.763687000000001,150.834935)
921	Willow Tree	1	2339	'tree':2 'willow':1	(-31.648589000000001,150.72621599999999)
922	Bowling Alley Point	1	2340	'alley':2 'bowl':1 'point':3	(-31.397894999999998,151.14526599999999)
923	Calala	1	2340	'calala':1	(-31.129764000000002,150.946878)
924	Carroll	1	2340	'carrol':1	(-30.986643000000001,150.44492)
925	Dungowan	1	2340	'dungowan':1	(-31.214552000000001,151.12011999999999)
928	Nemingha	1	2340	'nemingha':1	(-31.123653999999998,150.99041199999999)
929	Nundle	1	2340	'nundl':1	(-31.462548000000002,151.12704400000001)
930	Oxley Vale	1	2340	'oxley':1 'vale':2	(-31.06203,150.90014199999999)
931	Somerton	1	2340	'somerton':1	(-30.938654,150.63712200000001)
933	Tamworth	1	2340	'tamworth':1	(-31.091743000000001,150.93082100000001)
934	West Tamworth	1	2340	'tamworth':2 'west':1	(-31.105378999999999,150.898483)
935	Westdale	1	2340	'westdal':1	(-35.560499999999998,147.908455)
936	Woolomin	1	2340	'woolomin':1	(-31.284859000000001,151.14899)
937	Werris Creek	1	2341	'creek':2 'werri':1	(-31.345921000000001,150.61991499999999)
938	Currabubula	1	2342	'currabubula':1	(-31.262722,150.73425599999999)
939	Blackville	1	2343	'blackvill':1	(-31.65821,150.30280999999999)
940	Caroona	1	2343	'caroona':1	(-31.399114000000001,150.42794599999999)
942	Pine Ridge	1	2343	'pine':1 'ridg':2	(-31.479800000000001,150.512227)
943	Quirindi	1	2343	'quirindi':1	(-31.508146,150.68005199999999)
944	Spring Ridge	1	2343	'ridg':2 'spring':1	(-31.498483,150.68375800000001)
945	Wallabadah	1	2343	'wallabadah':1	(-31.523266,150.758768)
947	Attunga	1	2345	'attunga':1	(-30.930990999999999,150.84793300000001)
948	Garthowen	1	2345	'garthowen':1	(-33.596772000000001,149.622184)
949	Manilla	1	2346	'manilla':1	(-30.747752999999999,150.72024999999999)
951	Cobbadah	1	2347	'cobbadah':1	(-30.23171,150.57814500000001)
952	Upper Horton	1	2347	'horton':2 'upper':1	(-30.140940000000001,150.44710000000001)
954	Armidale	1	2350	'armidal':1	(-30.514165999999999,151.66898599999999)
957	Invergowrie	1	2350	'invergowri':1	(-30.497561000000001,151.49819600000001)
958	Jeogla	1	2350	'jeogla':1	(-30.571894,152.11082200000001)
959	West Armidale	1	2350	'armidal':2 'west':1	(-30.502956999999999,151.650203)
960	Wollomombi	1	2350	'wollomombi':1	(-30.511340000000001,152.045007)
962	Kootingal	1	2352	'kooting':1	(-31.057413,151.054338)
963	Limbri	1	2352	'limbri':1	(-31.039192,151.154777)
964	Moonbi	1	2353	'moonbi':1	(-30.951430999999999,151.045963)
965	Kentucky	1	2354	'kentucki':1	(-30.757842,151.45129)
966	Niangala	1	2354	'niangala':1	(-31.342381,151.36524499999999)
967	Nowendoc	1	2354	'nowendoc':1	(-31.515203,151.71954099999999)
969	Wollun	1	2354	'wollun':1	(-30.84132,151.42983699999999)
970	Woolbrook	1	2354	'woolbrook':1	(-30.944911000000001,151.342556)
971	Bendemeer	1	2355	'bendem':1	(-30.878399000000002,151.15990500000001)
973	Gwabegar	1	2356	'gwabegar':1	(-30.619797999999999,148.96949000000001)
883	Singleton Milpo	1	2331	'milpo':2 'singleton':1	(-32.689,151.18000000000001)
975	Coonabarabran	1	2357	'coonabarabran':1	(-31.273439,149.27727200000001)
976	Purlewaugh	1	2357	'purlewaugh':1	(-31.379731,149.640953)
977	Rocky Glen	1	2357	'glen':2 'rocki':1	(-31.115131000000002,149.56642199999999)
978	Ulamambri	1	2357	'ulamambri':1	(-31.332232000000001,149.384556)
981	Uralla	1	2358	'uralla':1	(-30.642828999999999,151.502566)
982	Bundarra	1	2359	'bundarra':1	(-30.17137,151.07583600000001)
983	Bukkulla	1	2360	'bukkulla':1	(-29.503136999999999,151.12903399999999)
984	Elsmore	1	2360	'elsmor':1	(-29.803303,151.27089899999999)
986	Graman	1	2360	'graman':1	(-29.467465000000001,150.92667900000001)
987	Gum Flat	1	2360	'flat':2 'gum':1	(-29.794333999999999,150.929554)
989	Little Plain	1	2360	'littl':1 'plain':2	(-29.729067000000001,150.950762)
990	Mount Russell	1	2360	'mount':1 'russel':2	(-29.678007000000001,150.930115)
991	Nullamanna	1	2360	'nullamanna':1	(-29.671264999999998,151.22238999999999)
992	Wallangra	1	2360	'wallangra':1	(-29.158463999999999,150.88386800000001)
994	Bonshaw	1	2361	'bonshaw':1	(-29.050295999999999,151.27534399999999)
995	Ben Lomond	1	2365	'ben':1 'lomond':2	(-30.017361000000001,151.65799999999999)
996	Black Mountain	1	2365	'black':1 'mountain':2	(-30.308042,151.65034199999999)
997	Glencoe	1	2365	'glenco':1	(-29.925888,151.72675699999999)
999	Llangothlin	1	2365	'llangothlin':1	(-30.123004000000002,151.68670599999999)
1000	Wandsworth	1	2365	'wandsworth':1	(-30.055997999999999,151.51369399999999)
1001	Stannifer	1	2369	'stannif':1	(-29.865293000000001,151.226372)
1003	Dundee	1	2370	'dunde':1	(-29.566687000000002,151.865748)
1004	Furracabad	1	2370	'furracabad':1	(-29.778195,151.64958100000001)
1005	Glen Innes	1	2370	'glen':1 'inn':2	(-29.735655000000001,151.73852600000001)
1007	Newton Boyd	1	2370	'boyd':2 'newton':1	(-29.752009999999999,152.24443199999999)
1008	Red Range	1	2370	'rang':2 'red':1	(-29.794136000000002,151.83238499999999)
1009	Swan Vale	1	2370	'swan':1 'vale':2	(-29.769753000000001,151.484701)
1010	Deepwater	1	2371	'deepwat':1	(-29.442319999999999,151.847464)
1012	Stannum	1	2371	'stannum':1	(-29.325075999999999,151.790639)
1013	Torrington	1	2371	'torrington':1	(-29.311986999999998,151.69657900000001)
1015	Bolivia	1	2372	'bolivia':1	(-29.299434000000002,151.950188)
1016	Boonoo Boonoo	1	2372	'boonoo':1,2	(-28.874075000000001,152.10228699999999)
1017	Bungulla	1	2372	'bungulla':1	(-29.121120999999999,151.99717100000001)
1018	Liston	1	2372	'liston':1	(-28.647746999999999,152.08629199999999)
1019	Sandy Flat	1	2372	'flat':2 'sandi':1	(-29.233737999999999,152.00560400000001)
1021	Wylie Creek	1	2372	'creek':2 'wyli':1	(-28.541481000000001,152.152444)
1022	Mullaley	1	2379	'mullaley':1	(-31.098523,149.90846300000001)
1023	Gunnedah	1	2380	'gunnedah':1	(-30.978588999999999,150.25541200000001)
1024	Kelvin	1	2380	'kelvin':1	(-30.792245999999999,150.35467)
1026	Breeza	1	2381	'breeza':1	(-31.244174999999998,150.45790099999999)
1027	Curlewis	1	2381	'curlewi':1	(-31.117342000000001,150.264679)
1028	Premer	1	2381	'premer':1	(-31.452597999999998,149.90214700000001)
1029	Tambar Springs	1	2381	'spring':2 'tambar':1	(-31.345202,149.82918000000001)
1030	Boggabri	1	2382	'boggabri':1	(-30.704727999999999,150.042508)
1032	Rowena	1	2387	'rowena':1	(-29.796578,148.93590499999999)
1033	Cuttabri	1	2388	'cuttabri':1	(-30.329854000000001,149.22112100000001)
1034	Pilliga	1	2388	'pilliga':1	(-30.351861,148.89083299999999)
1035	Wee Waa	1	2388	'waa':2 'wee':1	(-30.224868000000001,149.44442100000001)
1037	Edgeroi	1	2390	'edgeroi':1	(-30.117398000000001,149.799587)
1038	Narrabri	1	2390	'narrabri':1	(-30.324835,149.78283300000001)
1039	Turrawan	1	2390	'turrawan':1	(-30.456477,149.88574800000001)
1040	Binnaway	1	2395	'binnaway':1	(-31.552115000000001,149.37849700000001)
1042	Baradine	1	2396	'baradin':1	(-30.943207000000001,149.06581499999999)
1043	Kenebri	1	2396	'kenebri':1	(-30.748118000000002,148.923272)
1044	Bellata	1	2397	'bellata':1	(-29.919623999999999,149.790978)
1045	Gurley	1	2398	'gurley':1	(-29.735600999999999,149.79988)
1047	Ashley	1	2400	'ashley':1	(-29.317772000000001,149.808064)
1048	Crooble	1	2400	'croobl':1	(-29.269206000000001,150.252228)
1049	Moree	1	2400	'more':1	(-29.462975,149.84158099999999)
1051	Gravesend	1	2401	'gravesend':1	(-29.582339000000001,150.33760899999999)
1052	Coolatai	1	2402	'coolatai':1	(-29.268259,150.73449099999999)
1053	Warialda	1	2402	'warialda':1	(-29.541176,150.576165)
1054	Delungra	1	2403	'delungra':1	(-29.652484999999999,150.83094800000001)
1055	Bingara	1	2404	'bingara':1	(-29.868713,150.57178300000001)
1056	Dinoga	1	2404	'dinoga':1	(-29.913543000000001,150.639454)
1058	Garah	1	2405	'garah':1	(-29.075482000000001,149.63639800000001)
1059	Mungindi	1	2406	'mungindi':1	(-28.999013000000001,149.100731)
1061	Boggabilla	1	2409	'boggabilla':1	(-28.744821000000002,150.415347)
1062	Yetman	1	2410	'yetman':1	(-28.902557000000002,150.780675)
1063	Croppa Creek	1	2411	'creek':2 'croppa':1	(-29.129441,150.381167)
1064	Monkerai	1	2415	'monkerai':1	(-32.292335999999999,151.85978399999999)
1066	Bandon Grove	1	2420	'bandon':1 'grove':2	(-32.299861999999997,151.71589)
1067	Dungog	1	2420	'dungog':1	(-32.403866999999998,151.757171)
1068	Hilldale	1	2420	'hilldal':1	(-32.503221000000003,151.65007)
1069	Marshdale	1	2420	'marshdal':1	(-32.444217999999999,151.78923599999999)
1070	Salisbury	1	2420	'salisburi':1	(-32.214984000000001,151.55944600000001)
1072	Paterson	1	2421	'paterson':1	(-32.599153000000001,151.61829299999999)
1073	Vacy	1	2421	'vaci':1	(-32.543458000000001,151.57714999999999)
1074	Barrington	1	2422	'barrington':1	(-31.973631000000001,151.91049100000001)
1076	Bretti	1	2422	'bretti':1	(-31.786843999999999,151.92344900000001)
1077	Bundook	1	2422	'bundook':1	(-31.907461000000001,152.13652400000001)
1078	Copeland	1	2422	'copeland':1	(-31.985892,151.80591200000001)
1079	Craven	1	2422	'craven':1	(-32.151072999999997,151.944997)
1111	Green Point	1	2428	'green':1 'point':2	(-32.251759,152.516738)
1080	Gloucester	1	2422	'gloucest':1	(-32.007035999999999,151.95836199999999)
1081	Rawdon Vale	1	2422	'rawdon':1 'vale':2	(-31.995837999999999,151.70918599999999)
1082	Stratford	1	2422	'stratford':1	(-32.119278999999999,151.937941)
1084	Wards River	1	2422	'river':2 'ward':1	(-32.223466999999999,151.935901)
1085	Boolambayte	1	2423	'boolambayt':1	(-32.406627,152.27120600000001)
1086	Bulahdelah	1	2423	'bulahdelah':1	(-32.413376,152.20798099999999)
1087	Bungwahl	1	2423	'bungwahl':1	(-32.387264999999999,152.44415100000001)
1089	Markwell	1	2423	'markwel':1	(-32.320298000000001,152.18181100000001)
1090	Nerong	1	2423	'nerong':1	(-32.523533,152.19824299999999)
1091	Seal Rocks	1	2423	'rock':2 'seal':1	(-32.435312000000003,152.528898)
1093	Wang Wauk	1	2423	'wang':1 'wauk':2	(-32.159965,152.29193799999999)
1094	Willina	1	2423	'willina':1	(-32.170872000000003,152.283469)
1095	Wootton	1	2423	'wootton':1	(-32.325336,152.27947599999999)
1096	Cundle Flat	1	2424	'cundl':1 'flat':2	(-31.827106000000001,152.023798)
1097	Knorrit Flat	1	2424	'flat':2 'knorrit':1	(-31.842994999999998,152.12467699999999)
1099	Number One	1	2424	'number':1 'one':2	(-31.721121,152.06475699999999)
1100	Allworth	1	2425	'allworth':1	(-32.541688000000001,151.960927)
1101	Booral	1	2425	'booral':1	(-32.479751,152.00175200000001)
1102	Girvan	1	2425	'girvan':1	(-32.467866999999998,152.068465)
1103	Stroud	1	2425	'stroud':1	(-32.402363999999999,151.96660700000001)
1105	Coopernook	1	2426	'coopernook':1	(-31.826246000000001,152.60989599999999)
1106	Langley Vale	1	2426	'langley':1 'vale':2	(-31.790417000000001,152.56540799999999)
1107	Crowdy Head	1	2427	'crowdi':1 'head':2	(-31.844821,152.738877)
1109	Charlotte Bay	1	2428	'bay':2 'charlott':1	(-32.355226999999999,152.50578300000001)
1110	Forster	1	2428	'forster':1	(-32.179597999999999,152.511775)
1112	Smiths Lake	1	2428	'lake':2 'smith':1	(-32.382379,152.501878)
1114	Tuncurry	1	2428	'tuncurri':1	(-32.174624000000001,152.499268)
1115	Bobin	1	2429	'bobin':1	(-31.726020999999999,152.28388200000001)
1116	Bunyah	1	2429	'bunyah':1	(-32.164248000000001,152.21920399999999)
1117	Burrell Creek	1	2429	'burrel':1 'creek':2	(-31.951999000000001,152.29568699999999)
1118	Caparra	1	2429	'caparra':1	(-31.730732,152.24847700000001)
1120	Dyers Crossing	1	2429	'cross':2 'dyer':1	(-32.091732,152.30083300000001)
1121	Elands	1	2429	'eland':1	(-31.634609000000001,152.29721900000001)
1122	Firefly	1	2429	'firefli':1	(-32.082568999999999,152.244923)
1123	Killabakh	1	2429	'killabakh':1	(-31.735516000000001,152.39988700000001)
1125	Krambach	1	2429	'krambach':1	(-32.048174000000003,152.25024400000001)
1126	Marlee	1	2429	'marle':1	(-31.798881000000002,152.31914699999999)
1127	Mooral Creek	1	2429	'creek':2 'mooral':1	(-31.720375000000001,152.35565299999999)
1129	Wingham	1	2429	'wingham':1	(-31.869046000000001,152.37424200000001)
1130	Bohnock	1	2430	'bohnock':1	(-31.945995,152.56780900000001)
1131	Cundletown	1	2430	'cundletown':1	(-31.897697000000001,152.51666599999999)
1132	Diamond Beach	1	2430	'beach':2 'diamond':1	(-32.043993999999998,152.53443200000001)
1133	Failford	1	2430	'failford':1	(-32.091920999999999,152.45466200000001)
1135	Hallidays Point	1	2430	'halliday':1 'point':2	(-32.069775,152.488055)
1136	Koorainghat	1	2430	'koorainghat':1	(-31.985800999999999,152.47009700000001)
1138	Manning Point	1	2430	'man':1 'point':2	(-31.895140999999999,152.66151199999999)
1139	Old Bar	1	2430	'bar':2 'old':1	(-31.969037,152.58516299999999)
1141	Taree	1	2430	'tare':1	(-31.911714,152.46387100000001)
1142	Tinonee	1	2430	'tinone':1	(-31.93777,152.41382400000001)
1143	Upper Lansdowne	1	2430	'lansdown':2 'upper':1	(-31.702432999999999,152.47486000000001)
1144	Jerseyville	1	2431	'jerseyvill':1	(-30.935099999999998,153.03533100000001)
1146	Kendall	1	2439	'kendal':1	(-31.632031999999999,152.705558)
1147	Kew	1	2439	'kew':1	(-31.634853,152.722927)
1148	Lorne	1	2439	'lorn':1	(-31.657554999999999,152.591668)
1149	Bellbrook	1	2440	'bellbrook':1	(-30.818180000000002,152.50834900000001)
1151	Carrai	1	2440	'carrai':1	(-30.899756,152.24855700000001)
1152	Clybucca	1	2440	'clybucca':1	(-30.954388999999999,152.96554499999999)
1153	Collombatti	1	2440	'collombatti':1	(-30.992826000000001,152.84153800000001)
1154	Comara	1	2440	'comara':1	(-30.753004000000001,152.39986400000001)
1156	Frederickton	1	2440	'frederickton':1	(-31.037762000000001,152.87893299999999)
1157	Gladstone	1	2440	'gladston':1	(-31.022072999999999,152.94899000000001)
1158	Greenhill	1	2440	'greenhil':1	(-31.060154000000001,152.80001300000001)
1159	Hat Head	1	2440	'hat':1 'head':2	(-31.054490999999999,153.04996299999999)
1161	Kempsey	1	2440	'kempsey':1	(-31.080621000000001,152.84199000000001)
1179	Kempsey	1	2442	'kempsey':1	(-31.080621000000001,152.84199000000001)
1162	Lower Creek	1	2440	'creek':2 'lower':1	(-30.743584999999999,152.27898999999999)
1163	Millbank	1	2440	'millbank':1	(-30.846108999999998,152.64997099999999)
1164	Smithtown	1	2440	'smithtown':1	(-31.015176,152.943995)
1166	Toorooka	1	2440	'toorooka':1	(-30.912949999999999,152.587524)
1167	Verges Creek	1	2440	'creek':2 'verg':1	(-31.087755000000001,152.89971)
1168	Willawarrin	1	2440	'willawarrin':1	(-30.929995000000002,152.62787399999999)
1169	Ballengarra	1	2441	'ballengarra':1	(-31.318479,152.70968500000001)
1170	Bonville	1	2441	'bonvill':1	(-30.376052000000001,153.03486699999999)
1172	Eungai Rail	1	2441	'eungai':1 'rail':2	(-30.846274000000001,152.90057400000001)
1173	Grassy Head	1	2441	'grassi':1 'head':2	(-30.793913,152.99233100000001)
1174	Gum Scrub	1	2441	'gum':1 'scrub':2	(-31.271045999999998,152.726685)
1175	Kundabung	1	2441	'kundabung':1	(-31.208615000000002,152.82301200000001)
1177	Stuarts Point	1	2441	'point':2 'stuart':1	(-30.821107999999999,152.99398299999999)
1178	Telegraph Point	1	2441	'point':2 'telegraph':1	(-31.321632000000001,152.79968)
1181	Dunbogan	1	2443	'dunbogan':1	(-31.649381000000002,152.80722)
1184	Herons Creek	1	2443	'creek':2 'heron':1	(-31.587978,152.72671)
1185	Johns River	1	2443	'john':1 'river':2	(-31.733491999999998,152.69514699999999)
1186	Laurieton	1	2443	'laurieton':1	(-31.650229,152.798179)
1187	Moorland	1	2443	'moorland':1	(-31.772227999999998,152.65234799999999)
1183	West Haven	1	2443	'haven':2 'west':1	(-31.634395999999999,152.782454)
1189	Blackmans Point	1	2444	'blackman':1 'point':2	(-31.400666000000001,152.85183599999999)
1190	Port Macquarie	1	2444	'macquari':2 'port':1	(-31.434259000000001,152.90848099999999)
1191	Bonny Hills	1	2445	'bonni':1 'hill':2	(-31.594981000000001,152.84060500000001)
1193	Bagnoo	1	2446	'bagnoo':1	(-31.463639000000001,152.533221)
1194	Beechwood	1	2446	'beechwood':1	(-31.436805,152.67840799999999)
1195	Bellangry	1	2446	'bellangri':1	(-31.327475,152.60785200000001)
1196	Byabarra	1	2446	'byabarra':1	(-31.53435,152.52823900000001)
1198	Hollisdale	1	2446	'hollisdal':1	(-31.395009999999999,152.548686)
1199	Huntingdon	1	2446	'huntingdon':1	(-31.474350000000001,152.660392)
1200	King Creek	1	2446	'creek':2 'king':1	(-31.482454000000001,152.75192000000001)
1201	Long Flat	1	2446	'flat':2 'long':1	(-31.437083999999999,152.48875699999999)
1203	Pembrooke	1	2446	'pembrook':1	(-31.388110000000001,152.75348700000001)
1204	Toms Creek	1	2446	'creek':2 'tom':1	(-31.562738,152.39987400000001)
1205	Wauchope	1	2446	'wauchop':1	(-31.457353999999999,152.732269)
1206	Macksville	1	2447	'macksvill':1	(-30.706482999999999,152.920974)
1208	Taylors Arm	1	2447	'arm':2 'taylor':1	(-30.724826,152.834981)
1209	Thumb Creek	1	2447	'creek':2 'thumb':1	(-30.687090999999999,152.61913699999999)
1210	Warrell Creek	1	2447	'creek':2 'warrel':1	(-30.770271000000001,152.89232699999999)
1212	Valla Beach	1	2448	'beach':2 'valla':1	(-30.591805000000001,153.00847899999999)
1213	Argents Hill	1	2449	'argent':1 'hill':2	(-30.621952,152.74632600000001)
1214	Bowraville	1	2449	'bowravill':1	(-30.6419,152.854557)
1215	Missabotti	1	2449	'missabotti':1	(-30.567278000000002,152.80591200000001)
1268	South Arm	1	2460	'arm':2 'south':1	(-29.537005000000001,153.14819600000001)
1216	Boambee	1	2450	'boambe':1	(-30.337185999999999,153.069748)
1218	Coramba	1	2450	'coramba':1	(-30.222515000000001,153.016086)
1219	Glenreagh	1	2450	'glenreagh':1	(-30.05106,152.978971)
1220	Karangi	1	2450	'karangi':1	(-30.254449000000001,153.04825600000001)
1221	Korora	1	2450	'korora':1	(-30.257145000000001,153.129008)
1223	Moonee Beach	1	2450	'beach':2 'moone':1	(-30.208120000000001,153.15541300000001)
1224	Nana Glen	1	2450	'glen':2 'nana':1	(-30.136199000000001,153.004853)
1225	Ulong	1	2450	'ulong':1	(-30.246134999999999,152.88878099999999)
1227	Boambee East	1	2452	'boambe':1 'east':2	(-30.340620000000001,153.08422400000001)
1228	Sawtell	1	2452	'sawtel':1	(-30.369899,153.099627)
1229	Toormina	1	2452	'toormina':1	(-30.352620000000002,153.09028499999999)
1230	Bostobrick	1	2453	'bostobrick':1	(-30.277197999999999,152.62791899999999)
1231	Dorrigo	1	2453	'dorrigo':1	(-30.340131,152.711827)
1233	Ebor	1	2453	'ebor':1	(-30.398817999999999,152.35208299999999)
1234	Hernani	1	2453	'hernani':1	(-30.342209,152.42097799999999)
1235	Megan	1	2453	'megan':1	(-30.286954000000001,152.787387)
1236	Tyringham	1	2453	'tyringham':1	(-30.223381,152.554394)
1238	Fernmount	1	2454	'fernmount':1	(-30.468067000000001,152.95926499999999)
1239	Kalang	1	2454	'kalang':1	(-30.508285000000001,152.77424300000001)
1240	Mylestom	1	2454	'mylestom':1	(-30.464762,153.04281700000001)
1242	Repton	1	2454	'repton':1	(-30.438887999999999,153.02241599999999)
1243	Thora	1	2454	'thora':1	(-30.414372,152.772526)
1245	Urunga	1	2455	'urunga':1	(-30.497074999999999,153.014883)
1247	Corindi Beach	1	2456	'beach':2 'corindi':1	(-30.028811999999999,153.20043000000001)
1248	Emerald Beach	1	2456	'beach':2 'emerald':1	(-30.166596999999999,153.18245899999999)
1249	Red Rock	1	2456	'red':1 'rock':2	(-29.98339,153.22921600000001)
1250	Safety Beach	1	2456	'beach':2 'safeti':1	(-30.096684,153.192452)
1251	Sandy Beach	1	2456	'beach':2 'sandi':1	(-30.147984999999998,153.192117)
1252	Woolgoolga	1	2456	'woolgoolga':1	(-30.113119000000001,153.19347500000001)
1253	Baryulgil	1	2460	'baryulgil':1	(-29.219260999999999,152.60439199999999)
1254	Brushgrove	1	2460	'brushgrov':1	(-29.566127000000002,153.080634)
1255	Cangai	1	2460	'cangai':1	(-29.508400999999999,152.47921500000001)
1256	Coaldale	1	2460	'coaldal':1	(-29.387962000000002,152.79036500000001)
1258	Coutts Crossing	1	2460	'coutt':1 'cross':2	(-29.831052,152.89103600000001)
1259	Cowper	1	2460	'cowper':1	(-29.578505,153.06269699999999)
1260	Grafton	1	2460	'grafton':1	(-29.691224999999999,152.933312)
1261	Halfway Creek	1	2460	'creek':2 'halfway':1	(-29.948485999999999,153.11412799999999)
1262	Jackadgery	1	2460	'jackadgeri':1	(-29.582180000000001,152.56093200000001)
1264	Kangaroo Creek	1	2460	'creek':2 'kangaroo':1	(-29.946034000000001,152.840855)
1265	Lawrence	1	2460	'lawrenc':1	(-29.496728999999998,153.105535)
1266	Nymboida	1	2460	'nymboida':1	(-29.926010999999999,152.747884)
1267	Seelands	1	2460	'seeland':1	(-29.615100999999999,152.91381899999999)
1270	Waterview Heights	1	2460	'height':2 'waterview':1	(-29.702380999999999,152.838233)
1271	Winegrove	1	2460	'winegrov':1	(-29.548417000000001,152.68920800000001)
1272	Pillar Valley	1	2462	'pillar':1 'valley':2	(-29.764050000000001,153.12998999999999)
1273	Tucabia	1	2462	'tucabia':1	(-29.669035999999998,153.10727499999999)
1275	Wooli	1	2462	'wooli':1	(-29.865472,153.26626300000001)
1276	Brooms Head	1	2463	'broom':1 'head':2	(-29.604668,153.33313999999999)
1277	Maclean	1	2463	'maclean':1	(-29.457962999999999,153.19686899999999)
1278	Tullymorgan	1	2463	'tullymorgan':1	(-29.383479999999999,153.09836000000001)
1280	Yamba	1	2464	'yamba':1	(-29.437063999999999,153.361445)
1332	Dalwood	1	2477	'dalwood':1	(-28.888546000000002,153.40983900000001)
1281	Harwood	1	2465	'harwood':1	(-29.418832999999999,153.24086700000001)
1283	Bonalbo	1	2469	'bonalbo':1	(-28.736470000000001,152.62283199999999)
1284	Chatsworth	1	2469	'chatsworth':1	(-29.379238000000001,153.24861000000001)
1285	Mallanganee	1	2469	'mallangane':1	(-28.906448999999999,152.720585)
1287	Rappville	1	2469	'rappvill':1	(-29.084845000000001,152.95313400000001)
1288	Tabulam	1	2469	'tabulam':1	(-28.887198000000001,152.56855300000001)
1289	Backmede	1	2470	'backmed':1	(-28.772590000000001,153.01877099999999)
1290	Baraimal	1	2470	'baraim':1	(-28.722619999999999,152.99655799999999)
1291	Casino	1	2470	'casino':1	(-28.863886999999998,153.04615100000001)
1293	Dobies Bight	1	2470	'bight':2 'dobi':1	(-28.809446999999999,152.94349399999999)
1294	Doubtful Creek	1	2470	'creek':2 'doubt':1	(-28.748597,152.91505100000001)
1295	Dyraaba	1	2470	'dyraaba':1	(-28.800861000000001,152.862776)
1297	Fairy Hill	1	2470	'fairi':1 'hill':2	(-28.762953,152.98661300000001)
1298	Irvington	1	2470	'irvington':1	(-28.868689,153.10639900000001)
1299	Leeville	1	2470	'leevill':1	(-28.947742999999999,152.97788)
1301	Naughtons Gap	1	2470	'gap':2 'naughton':1	(-28.8019,153.10759100000001)
1302	Piora	1	2470	'piora':1	(-28.850355,152.91441499999999)
1303	Sextonville	1	2470	'sextonvill':1	(-28.671958,152.80547999999999)
1305	Spring Grove	1	2470	'grove':2 'spring':1	(-28.833065999999999,153.155733)
1306	Stratheden	1	2470	'stratheden':1	(-28.802720000000001,152.95430300000001)
1307	Woodview	1	2470	'woodview':1	(-28.860620000000001,152.95074199999999)
1308	Coraki	1	2471	'coraki':1	(-28.989979999999999,153.28930099999999)
1310	Tatham	1	2471	'tatham':1	(-28.928919,153.15865299999999)
1312	Rileys Hill	1	2472	'hill':2 'riley':1	(-29.013855,153.406656)
1313	Woodburn	1	2472	'woodburn':1	(-35.375596000000002,150.378783)
1314	Evans Head	1	2473	'evan':1 'head':2	(-29.115680000000001,153.42906500000001)
1315	Cawongla	1	2474	'cawongla':1	(-28.591753000000001,153.103105)
1317	Geneva	1	2474	'geneva':1	(-28.620581000000001,152.982293)
1318	Grevillia	1	2474	'grevillia':1	(-28.441731999999998,152.83073200000001)
1319	Kyogle	1	2474	'kyogl':1	(-28.622384,153.00411199999999)
1321	Rukenvale	1	2474	'rukenval':1	(-28.469528,152.89576099999999)
1322	The Risk	1	2474	'risk':2	(-28.459765999999998,152.945109)
1323	Toonumbar	1	2474	'toonumbar':1	(-28.567235,152.753096)
1324	Wiangaree	1	2474	'wiangare':1	(-28.505758,152.967547)
1325	Urbenville	1	2475	'urbenvill':1	(-28.472759,152.54808800000001)
1327	Legume	1	2476	'legum':1	(-28.404724999999999,152.30758)
1328	Old Koreelah	1	2476	'koreelah':2 'old':1	(-28.405384999999999,152.42333400000001)
1329	Woodenbong	1	2476	'woodenbong':1	(-28.391044000000001,152.61203499999999)
1330	Alstonville	1	2477	'alstonvill':1	(-28.842124999999999,153.44036)
1333	Meerschaum Vale	1	2477	'meerschaum':1 'vale':2	(-28.914193999999998,153.436069)
1334	Rous	1	2477	'rous':1	(-28.871123000000001,153.405709)
1335	Rous Mill	1	2477	'mill':2 'rous':1	(-28.876258,153.389634)
1336	Uralba	1	2477	'uralba':1	(-28.873618,153.47131999999999)
1337	Wardell	1	2477	'wardel':1	(-28.952703,153.464326)
1338	Wollongbar	1	2477	'wollongbar':1	(-28.827961999999999,153.42107799999999)
1340	Empire Vale	1	2478	'empir':1 'vale':2	(-28.915582000000001,153.50336899999999)
1341	Keith Hall	1	2478	'hall':2 'keith':1	(-28.889838999999998,153.53195099999999)
1342	Lennox Head	1	2478	'head':2 'lennox':1	(-28.795715000000001,153.59390099999999)
1344	Teven	1	2478	'teven':1	(-28.810482,153.48894300000001)
1345	Tintenbar	1	2478	'tintenbar':1	(-28.796589999999998,153.51316299999999)
1346	Bangalow	1	2479	'bangalow':1	(-28.686356,153.52479199999999)
1348	Brooklet	1	2479	'brooklet':1	(-28.730710999999999,153.51553000000001)
1349	Fernleigh	1	2479	'fernleigh':1	(-28.760332999999999,153.49765199999999)
1350	Nashua	1	2479	'nashua':1	(-28.729875,153.46786499999999)
1351	Opossum Creek	1	2479	'creek':2 'opossum':1	(-28.660440000000001,153.50672900000001)
1352	Bentley	1	2480	'bentley':1	(-28.756610999999999,153.09042299999999)
1353	Bexhill	1	2480	'bexhil':1	(-28.762689000000002,153.346496)
1355	Corndale	1	2480	'corndal':1	(-28.698710999999999,153.37782000000001)
1356	Dorroughby	1	2480	'dorroughbi':1	(-28.661712999999999,153.35493600000001)
1357	Dunoon	1	2480	'dunoon':1	(-28.681929,153.31854300000001)
1359	Eureka	1	2480	'eureka':1	(-28.683762999999999,153.43837500000001)
1361	Georgica	1	2480	'georgica':1	(-28.621858,153.16811300000001)
1362	Goolmangar	1	2480	'goolmangar':1	(-28.747167000000001,153.22591600000001)
1364	Lismore	1	2480	'lismor':1	(-28.812725,153.27872099999999)
1365	Marom Creek	1	2480	'creek':2 'marom':1	(-28.902898,153.372558)
1366	Mckees Hill	1	2480	'hill':2 'mckee':1	(-28.880797999999999,153.19628)
1367	Nimbin	1	2480	'nimbin':1	(-28.596769999999999,153.222904)
1369	Numulgi	1	2480	'numulgi':1	(-28.744012000000001,153.32493700000001)
1370	Richmond Hill	1	2480	'hill':2 'richmond':1	(-28.789045000000002,153.35082700000001)
1371	Rock Valley	1	2480	'rock':1 'valley':2	(-28.747358999999999,153.17440300000001)
1372	Rosebank	1	2480	'rosebank':1	(-28.663494,153.39217600000001)
1374	The Channon	1	2480	'channon':2	(-28.673238000000001,153.27889400000001)
1375	Tregeagle	1	2480	'tregeagl':1	(-28.846985,153.35306199999999)
1376	Tuckurimba	1	2480	'tuckurimba':1	(-28.956712,153.31401399999999)
1377	Tuncester	1	2480	'tuncest':1	(-28.798013000000001,153.225379)
1379	Wyrallah	1	2480	'wyrallah':1	(-28.888172000000001,153.299755)
1380	Broken Head	1	2481	'broken':1 'head':2	(-28.717234999999999,153.592296)
1381	Byron Bay	1	2481	'bay':2 'byron':1	(-28.643387000000001,153.612224)
1383	Tyagarah	1	2481	'tyagarah':1	(-28.604443,153.55617100000001)
1384	Goonengerry	1	2482	'goonengerri':1	(-28.610790000000001,153.439674)
1360	Federal	1	2480	'feder':1	(-28.762,153.25399999999999)
1472	South Coast	1	2521	'coast':2 'south':1	\N
1386	Billinudgel	1	2483	'billinudgel':1	(-28.504114000000001,153.52827400000001)
1387	Brunswick Heads	1	2483	'brunswick':1 'head':2	(-28.538989999999998,153.54825299999999)
1388	Burringbar	1	2483	'burringbar':1	(-28.434332999999999,153.471284)
1389	Crabbes Creek	1	2483	'crabb':1 'creek':2	(-28.456720000000001,153.496802)
1390	Mooball	1	2483	'moobal':1	(-28.441828999999998,153.48443599999999)
1392	Ocean Shores	1	2483	'ocean':1 'shore':2	(-28.527522999999999,153.54392100000001)
1393	South Golden Beach	1	2483	'beach':3 'golden':2 'south':1	(-28.501252000000001,153.543567)
1394	Yelgun	1	2483	'yelgun':1	(-28.476032,153.512834)
1397	Chillingham	1	2484	'chillingham':1	(-28.314119999999999,153.277703)
1398	Condong	1	2484	'condong':1	(-28.316754,153.433785)
1399	Crystal Creek	1	2484	'creek':2 'crystal':1	(-28.317936,153.33129600000001)
1400	Cudgera Creek	1	2484	'creek':2 'cudgera':1	(-28.389956000000002,153.51952499999999)
1401	Doon Doon	1	2484	'doon':1,2	(-28.503913000000001,153.30569299999999)
1403	Dungay	1	2484	'dungay':1	(-28.276212999999998,153.369429)
1404	Eungella	1	2484	'eungella':1	(-28.353760999999999,153.311519)
1405	Kunghur	1	2484	'kunghur':1	(-28.470233,153.25338199999999)
1407	Numinbah	1	2484	'numinbah':1	(-28.276838000000001,153.253377)
1408	Palmvale	1	2484	'palmval':1	(-28.375057000000002,153.48100700000001)
1409	Stokers Siding	1	2484	'side':2 'stoker':1	(-28.393502999999999,153.40363099999999)
1410	Tyalgum	1	2484	'tyalgum':1	(-28.356753000000001,153.20728299999999)
1411	Uki	1	2484	'uki':1	(-28.413907999999999,153.33664899999999)
1413	Tweed Heads West	1	2485	'head':2 'tweed':1 'west':3	(-28.195402999999999,153.50504900000001)
1414	Banora Point	1	2486	'banora':1 'point':2	(-28.213363000000001,153.535999)
1415	Bilambil	1	2486	'bilambil':1	(-28.227162,153.467794)
1416	Carool	1	2486	'carool':1	(-28.230291000000001,153.41914600000001)
1418	Tweed Heads South	1	2486	'head':2 'south':3 'tweed':1	(-28.198485999999999,153.543747)
1419	Chinderah	1	2487	'chinderah':1	(-28.237776,153.56134499999999)
1420	Cudgen	1	2487	'cudgen':1	(-28.262799999999999,153.55721)
1422	Fingal Head	1	2487	'fingal':1 'head':2	(-28.204156000000001,153.565709)
1423	Kingscliff	1	2487	'kingscliff':1	(-28.254719000000001,153.575638)
1424	Stotts Creek	1	2487	'creek':2 'stott':1	(-28.278516,153.516166)
1425	Bogangar	1	2488	'bogangar':1	(-28.332381000000002,153.54224099999999)
1427	Hastings Point	1	2489	'hast':1 'point':2	(-28.361965999999999,153.576246)
1428	Pottsville	1	2489	'pottsvill':1	(-28.379066000000002,153.56854999999999)
1429	Tumbulgum	1	2490	'tumbulgum':1	(-28.274366000000001,153.461116)
1430	Coniston	1	2500	'coniston':1	(-34.436545000000002,150.885559)
1433	Keiraville	1	2500	'keiravill':1	(-34.414625999999998,150.87223800000001)
1432	Mangerton	1	2500	'mangerton':1	(-34.431722000000001,150.87187299999999)
1434	Mount Keira	1	2500	'keira':2 'mount':1	(-34.395938000000001,150.84527600000001)
1436	North Wollongong	1	2500	'north':1 'wollongong':2	(-34.414360000000002,150.89557500000001)
1437	Spring Hill	1	2500	'hill':2 'spring':1	(-33.398705999999997,149.15235000000001)
1438	West Wollongong	1	2500	'west':1 'wollongong':2	(-34.424649000000002,150.86720700000001)
1439	Wollongong	1	2500	'wollongong':1	(-33.937789000000002,151.13959399999999)
1440	Cringila	1	2502	'cringila':1	(-34.471575000000001,150.871375)
1441	Lake Heights	1	2502	'height':2 'lake':1	(-34.481580999999998,150.87253100000001)
1442	Primbee	1	2502	'primbe':1	(-34.500655000000002,150.88160199999999)
1443	Warrawong	1	2502	'warrawong':1	(-34.484381999999997,150.88746699999999)
1444	Kemblawarra	1	2505	'kemblawarra':1	(-34.493251999999998,150.892832)
1446	Berkeley	1	2506	'berkeley':1	(-34.481408000000002,150.84414699999999)
1447	Coalcliff	1	2508	'coalcliff':1	(-34.243453000000002,150.97608099999999)
1448	Darkes Forest	1	2508	'dark':1 'forest':2	(-34.214373999999999,150.95064300000001)
1449	Helensburgh	1	2508	'helensburgh':1	(-34.190674999999999,150.98198500000001)
1450	Otford	1	2508	'otford':1	(-34.213259000000001,151.00323499999999)
1452	Stanwell Tops	1	2508	'stanwel':1 'top':2	(-34.220770000000002,150.976159)
1453	Austinmer	1	2515	'austinm':1	(-34.306283000000001,150.934563)
1454	Clifton	1	2515	'clifton':1	(-34.259407000000003,150.96888300000001)
1455	Coledale	1	2515	'coledal':1	(-34.288282000000002,150.94740100000001)
1457	Thirroul	1	2515	'thirroul':1	(-34.314739000000003,150.92379299999999)
1458	Wombarra	1	2515	'wombarra':1	(-34.277847999999999,150.95424499999999)
1459	Bulli	1	2516	'bulli':1	(-34.333860999999999,150.91328100000001)
1461	Woonona	1	2517	'woonona':1	(-34.340966999999999,150.906779)
1462	Bellambi	1	2518	'bellambi':1	(-34.365910999999997,150.91075599999999)
1463	Corrimal	1	2518	'corrim':1	(-34.371150999999998,150.89723900000001)
1464	East Corrimal	1	2518	'corrim':2 'east':1	(-34.376362999999998,150.91118)
1465	Tarrawanna	1	2518	'tarrawanna':1	(-34.381864,150.88781499999999)
1467	Balgownie	1	2519	'balgowni':1	(-34.388590000000001,150.877689)
1468	Fairy Meadow	1	2519	'fairi':1 'meadow':2	(-34.399878999999999,150.891874)
1469	Mount Ousley	1	2519	'mount':1 'ousley':2	(-34.402375999999997,150.886719)
1473	University Of Wollongong	1	2522	'univers':1 'wollongong':3	(-34.405102999999997,150.877805)
1474	Figtree	1	2525	'figtre':1	(-34.435685999999997,150.86124100000001)
1475	Cordeaux Heights	1	2526	'cordeaux':1 'height':2	(-34.439801000000003,150.83839900000001)
1476	Farmborough Heights	1	2526	'farmborough':1 'height':2	(-34.454003999999998,150.81994399999999)
1478	Mount Kembla	1	2526	'kembla':2 'mount':1	(-34.432799000000003,150.820503)
1479	Unanderra	1	2526	'unanderra':1	(-34.454624000000003,150.84509299999999)
1480	Albion Park	1	2527	'albion':1 'park':2	(-34.570722000000004,150.77503100000001)
1481	Albion Park Rail	1	2527	'albion':1 'park':2 'rail':3	(-34.560837999999997,150.79575)
1482	Barrack Heights	1	2528	'barrack':1 'height':2	(-34.565202999999997,150.857066)
1483	Barrack Point	1	2528	'barrack':1 'point':2	(-34.563248999999999,150.86737500000001)
1484	Lake Illawarra	1	2528	'illawarra':2 'lake':1	(-34.546472999999999,150.85695000000001)
1486	Warilla	1	2528	'warilla':1	(-34.552573000000002,150.85995)
1487	Windang	1	2528	'windang':1	(-34.529940000000003,150.869145)
1488	Blackbutt	1	2529	'blackbutt':1	(-34.568959999999997,150.83469500000001)
1489	Dunmore	1	2529	'dunmor':1	(-34.606223,150.840676)
1490	Flinders	1	2529	'flinder':1	(-34.579836,150.84482800000001)
1492	Shell Cove	1	2529	'cove':2 'shell':1	(-34.588200999999998,150.87259399999999)
1493	Shellharbour	1	2529	'shellharbour':1	(-34.579034999999998,150.867929)
1494	Brownsville	1	2530	'brownsvill':1	(-34.485644000000001,150.80621099999999)
1495	Dapto	1	2530	'dapto':1	(-34.494000999999997,150.79300599999999)
1497	Kanahooka	1	2530	'kanahooka':1	(-34.494480000000003,150.808964)
1498	Koonawarra	1	2530	'koonawarra':1	(-34.502195999999998,150.807052)
1499	Wongawilli	1	2530	'wongawilli':1	(-34.480001999999999,150.75876500000001)
1500	Yallah	1	2530	'yallah':1	(-34.537776999999998,150.78064800000001)
1502	Jamberoo	1	2533	'jamberoo':1	(-34.648418999999997,150.77659499999999)
1503	Kiama	1	2533	'kiama':1	(-34.671675999999998,150.85670300000001)
1504	Minnamurra	1	2533	'minnamurra':1	(-34.627870999999999,150.85511299999999)
1506	Gerringong	1	2534	'gerringong':1	(-34.745548999999997,150.82749699999999)
1507	Gerroa	1	2534	'gerroa':1	(-34.770170999999998,150.81561099999999)
1508	Toolijooa	1	2534	'toolijooa':1	(-34.755583000000001,150.78090900000001)
1510	Bellawongarah	1	2535	'bellawongarah':1	(-34.763894000000001,150.626431)
1511	Berry	1	2535	'berri':1	(-34.775494000000002,150.696595)
1512	Budderoo	1	2535	'budderoo':1	(-34.662213999999999,150.662882)
1513	Coolangatta	1	2535	'coolangatta':1	(-34.854208,150.726361)
1515	Shoalhaven Heads	1	2535	'head':2 'shoalhaven':1	(-34.85145,150.74525399999999)
1516	Wattamolla	1	2535	'wattamolla':1	(-34.735931000000001,150.62276600000001)
1517	Woodhill	1	2535	'woodhil':1	(-34.726146999999997,150.67505)
1518	Batehaven	1	2536	'batehaven':1	(-35.732109999999999,150.19953899999999)
1519	Batemans Bay	1	2536	'bateman':1 'bay':2	(-35.708151999999998,150.17470399999999)
1520	Benandarah	1	2536	'benandarah':1	(-35.660936,150.228251)
1522	Buckenbowra	1	2536	'buckenbowra':1	(-35.769461999999997,150.065754)
1523	Catalina	1	2536	'catalina':1	(-35.723475999999998,150.19255200000001)
1524	Currowan	1	2536	'currowan':1	(-35.559823000000002,150.16718700000001)
1526	Durras North	1	2536	'durra':1 'north':2	(-35.627699,150.310957)
1527	East Lynne	1	2536	'east':1 'lynn':2	(-35.578817000000001,150.25887700000001)
1528	Guerilla Bay	1	2536	'bay':2 'guerilla':1	(-35.826391999999998,150.21806599999999)
1529	Jeremadra	1	2536	'jeremadra':1	(-35.809125000000002,150.13659899999999)
1532	Maloneys Beach	1	2536	'beach':2 'maloney':1	(-35.705933000000002,150.24797699999999)
1533	Malua Bay	1	2536	'bay':2 'malua':1	(-35.783334000000004,150.23207099999999)
1534	Mogo	1	2536	'mogo':1	(-32.265782999999999,150.01149799999999)
1535	Nelligen	1	2536	'nelligen':1	(-35.647438000000001,150.141482)
1537	Rosedale	1	2536	'rosedal':1	(-35.818606000000003,150.21988899999999)
1538	Runnyford	1	2536	'runnyford':1	(-35.716923999999999,150.11391699999999)
1539	South Durras	1	2536	'durra':2 'south':1	(-35.650987999999998,150.29502600000001)
1540	Sunshine Bay	1	2536	'bay':2 'sunshin':1	(-35.741605999999997,150.20909)
1541	Surf Beach	1	2536	'beach':2 'surf':1	(-35.761341000000002,150.21012999999999)
1542	Surfside	1	2536	'surfsid':1	(-35.700788000000003,150.19831300000001)
1544	Bergalia	1	2537	'bergalia':1	(-35.981261000000003,150.105175)
1545	Bingie	1	2537	'bingi':1	(-36.011130000000001,150.153153)
1546	Broulee	1	2537	'broule':1	(-35.854996,150.17461599999999)
1547	Coila	1	2537	'coila':1	(-36.022283999999999,150.102934)
1549	Deua	1	2537	'deua':1	(-35.817684999999997,149.794894)
1551	Kiora	1	2537	'kiora':1	(-35.922829,150.03892099999999)
1552	Meringo	1	2537	'meringo':1	(-35.983842000000003,150.14769200000001)
1553	Mogendoura	1	2537	'mogendoura':1	(-35.872225,150.058818)
1554	Moruya	1	2537	'moruya':1	(-35.911738999999997,150.07800399999999)
1555	Moruya Heads	1	2537	'head':2 'moruya':1	(-35.913601999999997,150.13261700000001)
1556	Mossy Point	1	2537	'mossi':1 'point':2	(-35.837390999999997,150.17592300000001)
1557	Tomakin	1	2537	'tomakin':1	(-35.821767000000001,150.193026)
1559	Tuross Head	1	2537	'head':2 'tuross':1	(-36.060747999999997,150.13715199999999)
1560	Milton	1	2538	'milton':1	(-35.315085000000003,150.43452500000001)
1561	Bawley Point	1	2539	'bawley':1 'point':2	(-35.522387000000002,150.393202)
1564	Burrill Lake	1	2539	'burril':1 'lake':2	(-35.387188999999999,150.449603)
1565	Conjola	1	2539	'conjola':1	(-35.219631,150.43486999999999)
1566	Conjola Park	1	2539	'conjola':1 'park':2	(-35.371592999999997,150.452135)
1568	Kioloa	1	2539	'kioloa':1	(-35.544426000000001,150.383971)
1569	Lake Conjola	1	2539	'conjola':2 'lake':1	(-35.269291000000003,150.49274199999999)
1570	Lake Tabourie	1	2539	'lake':1 'tabouri':2	(-35.443750000000001,150.398471)
1571	Manyana	1	2539	'manyana':1	(-35.258412999999997,150.51395600000001)
1572	Mollymook	1	2539	'mollymook':1	(-35.339323999999998,150.47422800000001)
1573	Termeil	1	2539	'termeil':1	(-35.487170999999996,150.33930799999999)
1576	Bamarang	1	2540	'bamarang':1	(-34.894362000000001,150.53446400000001)
1577	Basin View	1	2540	'basin':1 'view':2	(-35.091102999999997,150.56228100000001)
1578	Berrara	1	2540	'berrara':1	(-35.205582,150.550411)
1579	Bolong	1	2540	'bolong':1	(-34.847006,150.649574)
1581	Burrier	1	2540	'burrier':1	(-34.870381000000002,150.45113699999999)
1582	Callala Bay	1	2540	'bay':2 'callala':1	(-34.987609999999997,150.718141)
1563	Berringer Lake	1	2539	'berring':1 'lake':2	(-35.404000000000003,150.40299999999999)
1584	Cambewarra	1	2540	'cambewarra':1	(-34.820751000000001,150.542226)
1585	Cudmirrah	1	2540	'cudmirrah':1	(-35.198039999999999,150.557818)
1587	Currarong	1	2540	'currarong':1	(-35.018738999999997,150.82421400000001)
1588	Erowal Bay	1	2540	'bay':2 'erow':1	(-35.102435999999997,150.653639)
1589	Falls Creek	1	2540	'creek':2 'fall':1	(-34.968232,150.59692899999999)
1590	Greenwell Point	1	2540	'greenwel':1 'point':2	(-34.907929000000003,150.729736)
1591	Hmas Albatross	1	2540	'albatross':2 'hmas':1	(-34.943598000000001,150.54842300000001)
1593	Huskisson	1	2540	'huskisson':1	(-35.038849999999996,150.67094299999999)
1596	Meroo Meadow	1	2540	'meadow':2 'meroo':1	(-34.809874000000001,150.61837800000001)
1597	Myola	1	2540	'myola':1	(-35.027104000000001,150.67325299999999)
1598	Numbaa	1	2540	'numbaa':1	(-34.873429000000002,150.678484)
1600	Orient Point	1	2540	'orient':1 'point':2	(-34.910800000000002,150.74965800000001)
1601	Pyree	1	2540	'pyre':1	(-34.911669000000003,150.68468799999999)
1602	Sanctuary Point	1	2540	'point':2 'sanctuari':1	(-35.104131000000002,150.62694099999999)
1603	St Georges Basin	1	2540	'basin':3 'georg':2 'st':1	(-35.090788000000003,150.597815)
1604	Sussex Inlet	1	2540	'inlet':2 'sussex':1	(-35.157009000000002,150.59624700000001)
1606	Tapitallee	1	2540	'tapitalle':1	(-34.829514000000003,150.54043300000001)
1607	Terara	1	2540	'terara':1	(-34.865447000000003,150.62743599999999)
1608	Tomerong	1	2540	'tomerong':1	(-35.052033999999999,150.58706799999999)
1609	Vincentia	1	2540	'vincentia':1	(-35.069536999999997,150.67517799999999)
1611	Woollamia	1	2540	'woollamia':1	(-35.013672999999997,150.63761199999999)
1612	Worrigee	1	2540	'worrige':1	(-34.890369999999997,150.62607399999999)
1613	Wrights Beach	1	2540	'beach':2 'wright':1	(-35.112034999999999,150.66525200000001)
1614	Yalwal	1	2540	'yalwal':1	(-34.916933999999998,150.424339)
1616	Bomaderry	1	2541	'bomaderri':1	(-34.855412000000001,150.608383)
1617	North Nowra	1	2541	'north':1 'nowra':2	(-34.860731000000001,150.59146699999999)
1618	Nowra	1	2541	'nowra':1	(-34.872698,150.60342)
1620	Bodalla	1	2545	'bodalla':1	(-36.090909000000003,150.05174099999999)
1621	Nerrigundah	1	2545	'nerrigundah':1	(-36.118478000000003,149.90112999999999)
1622	Barragga Bay	1	2546	'barragga':1 'bay':2	(-36.502628000000001,150.053011)
1623	Bermagui	1	2546	'bermagui':1	(-36.422732000000003,150.06439)
1624	Cuttagee	1	2546	'cuttage':1	(-36.492756999999997,150.053495)
1626	Dignams Creek	1	2546	'creek':2 'dignam':1	(-36.347484000000001,150.01018500000001)
1627	Kianga	1	2546	'kianga':1	(-36.196069000000001,150.13102599999999)
1628	Narooma	1	2546	'narooma':1	(-36.218319000000001,150.13224600000001)
1630	Tilba Tilba	1	2546	'tilba':1,2	(-36.324421999999998,150.062667)
1631	Tinpot	1	2546	'tinpot':1	(-36.231670000000001,149.88289499999999)
1632	Wallaga Lake	1	2546	'lake':2 'wallaga':1	(-36.356673000000001,150.06605300000001)
1633	Berrambool	1	2548	'berrambool':1	(-36.878799999999998,149.91740200000001)
1634	Merimbula	1	2548	'merimbula':1	(-36.887762000000002,149.91055299999999)
1637	Greigs Flat	1	2549	'flat':2 'greig':1	(-36.968353,149.86626799999999)
1638	Nethercote	1	2549	'nethercot':1	(-37.017789999999998,149.828723)
1639	Pambula	1	2549	'pambula':1	(-36.929246999999997,149.874618)
1641	Bega	1	2550	'bega':1	(-36.674261999999999,149.84324000000001)
1642	Bemboka	1	2550	'bemboka':1	(-36.629916999999999,149.57296400000001)
1643	Bournda	1	2550	'bournda':1	(-36.836801000000001,149.91299799999999)
1644	Brogo	1	2550	'brogo':1	(-36.570993000000001,149.823508)
1645	Burragate	1	2550	'burrag':1	(-37.001083000000001,149.628928)
1647	Cobargo	1	2550	'cobargo':1	(-36.387610000000002,149.88777200000001)
1648	Doctor George Mountain	1	2550	'doctor':1 'georg':2 'mountain':3	(-36.665809000000003,149.892211)
1650	Mogareeka	1	2550	'mogareeka':1	(-36.698430999999999,149.97598199999999)
1652	Mumbulla Mountain	1	2550	'mountain':2 'mumbulla':1	(-36.545445000000001,149.864645)
1653	Nelson	1	2550	'nelson':1	(-33.652794999999998,150.915685)
1654	Quaama	1	2550	'quaama':1	(-36.464379000000001,149.87009)
1655	Rocky Hall	1	2550	'hall':2 'rocki':1	(-36.913722999999997,149.48800499999999)
1656	Tathra	1	2550	'tathra':1	(-36.729728000000001,149.985917)
1658	Wandella	1	2550	'wandella':1	(-36.299399000000001,149.84866500000001)
1659	Wapengo	1	2550	'wapengo':1	(-36.594544999999997,150.01827599999999)
1660	Wolumla	1	2550	'wolumla':1	(-36.831994999999999,149.811442)
1662	Yowrie	1	2550	'yowri':1	(-36.297586000000003,149.717828)
1664	Kiah	1	2551	'kiah':1	(-37.149723000000002,149.856899)
1665	Wonboyn	1	2551	'wonboyn':1	(-37.251046000000002,149.914953)
1667	Badgerys Creek	1	2555	'badgeri':1 'creek':2	(-33.883375999999998,150.74135100000001)
1668	Bringelly	1	2556	'bringelli':1	(-33.945706999999999,150.72520700000001)
1669	Catherine Field	1	2557	'catherin':1 'field':2	(-33.993544999999997,150.77485799999999)
1670	Rossmore	1	2557	'rossmor':1	(-33.945965000000001,150.772763)
1671	Eagle Vale	1	2558	'eagl':1 'vale':2	(-34.037882000000003,150.814153)
1673	Kearns	1	2558	'kearn':1	(-34.021321,150.803211)
1674	Blairmount	1	2559	'blairmount':1	(-34.049484999999997,150.799611)
1675	Claymore	1	2559	'claymor':1	(-34.045524,150.810024)
1676	Airds	1	2560	'aird':1	(-34.084468000000001,150.82904099999999)
1678	Appin	1	2560	'appin':1	(-34.200890999999999,150.78747899999999)
1680	Blair Athol	1	2560	'athol':2 'blair':1	(-34.063834999999997,150.80600699999999)
1679	Bradbury	1	2560	'bradburi':1	(-34.086005999999998,150.81401600000001)
1682	Englorie Park	1	2560	'englori':1 'park':2	(-34.082051999999997,150.795131)
1683	Gilead	1	2560	'gilead':1	(-34.107035000000003,150.76181500000001)
1684	Glen Alpine	1	2560	'alpin':2 'glen':1	(-34.084184,150.77527499999999)
1685	Kentlyn	1	2560	'kentlyn':1	(-34.073171000000002,150.85742999999999)
1661	Wyndham	1	2550	'wyndham':1	(-36.750999999999998,149.703)
1714	Elderslie	1	2570	'eldersli':1	(-34.059038000000001,150.71142699999999)
1760	Penrose	1	2579	'penros':1	(-34.670071999999998,150.22851199999999)
1686	Leumeah	1	2560	'leumeah':1	(-34.052284999999998,150.83339599999999)
1687	Rosemeadow	1	2560	'rosemeadow':1	(-34.101795000000003,150.800106)
1688	Ruse	1	2560	'ruse':1	(-34.069282999999999,150.84406899999999)
1690	Wedderburn	1	2560	'wedderburn':1	(-34.127555000000001,150.81269800000001)
1691	Woodbine	1	2560	'woodbin':1	(-34.049892,150.818872)
1692	Menangle Park	1	2563	'menangl':1 'park':2	(-34.100121000000001,150.75701599999999)
1696	Denham Court	1	2565	'court':2 'denham':1	(-33.990081000000004,150.84465299999999)
1695	Macquarie Links	1	2565	'link':2 'macquari':1	(-33.982185000000001,150.86756099999999)
1698	Bow Bowing	1	2566	'bow':1,2	(-34.015341999999997,150.83681999999999)
1699	Minto	1	2566	'minto':1	(-34.032021999999998,150.848208)
1700	Raby	1	2566	'rabi':1	(-34.021070999999999,150.81134700000001)
1702	Varroville	1	2566	'varrovill':1	(-34.010255000000001,150.822979)
1704	Harrington Park	1	2567	'harrington':1 'park':2	(-34.023238999999997,150.742232)
1705	Mount Annan	1	2567	'annan':2 'mount':1	(-34.054864000000002,150.76415800000001)
1706	Narellan	1	2567	'narellan':1	(-34.040523999999998,150.735615)
1707	Narellan Vale	1	2567	'narellan':1 'vale':2	(-34.055270999999998,150.74408)
1708	Menangle	1	2568	'menangl':1	(-34.108654000000001,150.74914899999999)
1710	Camden	1	2570	'camden':1	(-34.054599000000003,150.69567799999999)
1711	Camden Park	1	2570	'camden':1 'park':2	(-34.088673,150.721836)
1712	Cawdor	1	2570	'cawdor':1	(-34.108691,150.67198500000001)
1713	Cobbitty	1	2570	'cobbitti':1	(-34.015873999999997,150.69102899999999)
1716	Grasmere	1	2570	'grasmer':1	(-34.056292999999997,150.67317)
1717	Mount Hunter	1	2570	'hunter':2 'mount':1	(-34.071247999999997,150.64138199999999)
1718	Nattai	1	2570	'nattai':1	(-34.068935000000003,150.44568000000001)
1719	Oakdale	1	2570	'oakdal':1	(-34.078173999999997,150.51363900000001)
1721	The Oaks	1	2570	'oak':2	(-34.076872999999999,150.57108600000001)
1722	Werombi	1	2570	'werombi':1	(-33.988917999999998,150.57174000000001)
1724	Buxton	1	2571	'buxton':1	(-34.254367999999999,150.533907)
1725	Couridjah	1	2571	'couridjah':1	(-34.234217999999998,150.54756900000001)
1727	Razorback	1	2571	'razorback':1	(-33.033802999999999,149.81923)
1728	Wilton	1	2571	'wilton':1	(-34.240434,150.696426)
1729	Lakesland	1	2572	'lakesland':1	(-34.180869999999999,150.52683400000001)
1731	Tahmoor	1	2573	'tahmoor':1	(-34.222909999999999,150.593447)
1732	Bargo	1	2574	'bargo':1	(-34.289442999999999,150.58010300000001)
1733	Pheasants Nest	1	2574	'nest':2 'pheasant':1	(-34.255972999999997,150.63559900000001)
1734	Yanderra	1	2574	'yanderra':1	(-34.324174999999997,150.569254)
1736	Colo Vale	1	2575	'colo':1 'vale':2	(-34.400134000000001,150.48796899999999)
1737	Hill Top	1	2575	'hill':1 'top':2	(-33.796292000000001,151.27268100000001)
1738	Mittagong	1	2575	'mittagong':1	(-34.450856000000002,150.44878800000001)
1739	Welby	1	2575	'welbi':1	(-34.439532999999997,150.42808099999999)
1741	Bowral	1	2576	'bowral':1	(-34.477800000000002,150.41808599999999)
1742	Burradoo	1	2576	'burradoo':1	(-34.506394999999998,150.404854)
1743	Kangaloon	1	2576	'kangaloon':1	(-34.553365999999997,150.53384800000001)
1745	Barrengarry	1	2577	'barrengarri':1	(-34.720683000000001,150.52354299999999)
1746	Beaumont	1	2577	'beaumont':1	(-34.781804999999999,150.56162900000001)
1747	Berrima	1	2577	'berrima':1	(-34.489643999999998,150.33581599999999)
1749	Fitzroy Falls	1	2577	'fall':2 'fitzroy':1	(-34.640976000000002,150.478478)
1750	Kangaroo Valley	1	2577	'kangaroo':1 'valley':2	(-34.737825999999998,150.536215)
1751	Moss Vale	1	2577	'moss':1 'vale':2	(-34.547607999999997,150.373096)
1753	Robertson	1	2577	'robertson':1	(-34.589236999999997,150.596418)
1754	Sutton Forest	1	2577	'forest':2 'sutton':1	(-34.568289,150.32103599999999)
1755	Wildes Meadow	1	2577	'meadow':2 'wild':1	(-34.618189000000001,150.530044)
1756	Yarrunga	1	2577	'yarrunga':1	(-34.590674999999997,150.43952100000001)
1757	Bundanoon	1	2578	'bundanoon':1	(-34.632598000000002,150.321575)
1759	Marulan	1	2579	'marulan':1	(-34.711995999999999,150.005978)
1761	Tallong	1	2579	'tallong':1	(-34.718547999999998,150.08307099999999)
1762	Wingello	1	2579	'wingello':1	(-34.691726000000003,150.15674999999999)
1764	Bungonia	1	2580	'bungonia':1	(-34.829239000000001,149.869192)
1765	Golspie	1	2580	'golspi':1	(-34.290844999999997,149.66298399999999)
1766	Goulburn	1	2580	'goulburn':1	(-34.75535,149.717816)
1767	Kingsdale	1	2580	'kingsdal':1	(-34.663353999999998,149.66116299999999)
1769	Roslyn	1	2580	'roslyn':1	(-34.502904999999998,149.60749999999999)
1770	Tarago	1	2580	'tarago':1	(-35.084502999999998,149.62873500000001)
1771	Taralga	1	2580	'taralga':1	(-34.405566999999998,149.81868299999999)
1772	Towrang	1	2580	'towrang':1	(-34.685307999999999,149.85994199999999)
1774	Woodhouselee	1	2580	'woodhousele':1	(-34.570439,149.63111000000001)
1775	Yalbraith	1	2580	'yalbraith':1	(-34.241605999999997,149.773798)
1776	Yarra	1	2580	'yarra':1	(-34.762728000000003,149.62303499999999)
1777	Breadalbane	1	2581	'breadalban':1	(-34.800795999999998,149.46817300000001)
1778	Collector	1	2581	'collector':1	(-34.917290000000001,149.42433199999999)
1780	Gunning	1	2581	'gun':1	(-34.782263999999998,149.26636400000001)
1781	Bookham	1	2582	'bookham':1	(-34.789416000000003,148.63778400000001)
1782	Bowning	1	2582	'bown':1	(-34.767899999999997,148.81469899999999)
1784	Murrumbateman	1	2582	'murrumbateman':1	(-34.969552,149.03035)
1785	Wee Jasper	1	2582	'jasper':2 'wee':1	(-35.115771000000002,148.673123)
1786	Yass	1	2582	'yass':1	(-34.842149999999997,148.91122799999999)
1787	Bigga	1	2583	'bigga':1	(-34.084775999999998,149.15136100000001)
1789	Blanket Flat	1	2583	'blanket':1 'flat':2	(-34.128706999999999,149.19695100000001)
1701	St Andrews	1	2566	'andrew':2 'st':1	(-34.018999999999998,150.84100000000001)
1790	Crooked Corner	1	2583	'corner':2 'crook':1	(-34.228470000000002,149.24883199999999)
1791	Crookwell	1	2583	'crookwel':1	(-34.458075999999998,149.470291)
1792	Fullerton	1	2583	'fullerton':1	(-34.210656,149.51450199999999)
1794	Kialla	1	2583	'kialla':1	(-34.544342999999998,149.46078399999999)
1795	Laggan	1	2583	'laggan':1	(-34.384408999999998,149.54144700000001)
1796	Limerick	1	2583	'limerick':1	(-34.204084000000002,149.47751099999999)
1797	Peelwood	1	2583	'peelwood':1	(-34.111361000000002,149.427224)
1798	Rugby	1	2583	'rugbi':1	(-34.367221999999998,149.03241199999999)
1799	Tuena	1	2583	'tuena':1	(-34.016463999999999,149.32771199999999)
1801	Galong	1	2585	'galong':1	(-34.601585999999998,148.556895)
1802	Boorowa	1	2586	'boorowa':1	(-34.438597999999999,148.71632600000001)
1803	Murringo	1	2586	'murringo':1	(-34.272866999999998,148.509953)
1805	Rye Park	1	2586	'park':2 'rye':1	(-34.519573000000001,148.90769499999999)
1806	Harden	1	2587	'harden':1	(-34.555033000000002,148.36963499999999)
1807	Kingsvale	1	2587	'kingsval':1	(-34.457563999999998,148.36362399999999)
1808	Murrumburrah	1	2587	'murrumburrah':1	(-34.549329,148.35018299999999)
1810	Wallendbeen	1	2588	'wallendbeen':1	(-34.524318999999998,148.16015999999999)
1811	Bethungra	1	2590	'bethungra':1	(-34.762894000000003,147.852565)
1812	Cootamundra	1	2590	'cootamundra':1	(-34.639088999999998,148.02467100000001)
1813	Illabo	1	2590	'illabo':1	(-34.814798000000003,147.74066199999999)
1815	Milvale	1	2594	'milval':1	(-34.314943,147.87537900000001)
1816	Monteagle	1	2594	'monteagl':1	(-34.193244999999997,148.34227799999999)
1817	Young	1	2594	'young':1	(-34.313409999999998,148.297921)
1820	Jerrabomberra	1	2619	'jerrabomberra':1	(-35.384458000000002,149.19905299999999)
1821	Burra	1	2620	'burra':1	(-35.829467999999999,148.068724)
1822	Crestwood	1	2620	'crestwood':1	(-31.472265,152.90410900000001)
1823	Gundaroo	1	2620	'gundaroo':1	(-35.127744999999997,149.20979)
1825	Michelago	1	2620	'michelago':1	(-33.942390000000003,150.86505600000001)
1826	Queanbeyan	1	2620	'queanbeyan':1	(-35.354443000000003,149.23208299999999)
1827	Queanbeyan East	1	2620	'east':2 'queanbeyan':1	(-35.342807999999998,149.244392)
1829	Royalla	1	2620	'royalla':1	(-35.512227000000003,149.16269)
1830	Sutton	1	2620	'sutton':1	(-35.161199000000003,149.25297)
1831	Wamboin	1	2620	'wamboin':1	(-31.713913999999999,148.660146)
1832	Williamsdale	1	2620	'williamsdal':1	(-35.575035999999997,149.187254)
1833	Bungendore	1	2621	'bungendor':1	(-35.256082999999997,149.440417)
1835	Ballalaba	1	2622	'ballalaba':1	(-35.572682,149.666842)
1836	Boro	1	2622	'boro':1	(-35.142888999999997,149.66158899999999)
1837	Braidwood	1	2622	'braidwood':1	(-35.437700999999997,149.80086800000001)
1839	Jembaicumbene	1	2622	'jembaicumben':1	(-35.529643999999998,149.79821000000001)
1840	Majors Creek	1	2622	'creek':2 'major':1	(-35.570599999999999,149.73889700000001)
1841	Monga	1	2622	'monga':1	(-35.550289999999997,149.899619)
1842	Mongarlowe	1	2622	'mongarlow':1	(-35.422218000000001,149.922833)
1844	Reidsdale	1	2622	'reidsdal':1	(-35.589708999999999,149.84544600000001)
1845	Captains Flat	1	2623	'captain':1 'flat':2	(-35.552827000000001,149.44508300000001)
1846	Perisher Valley	1	2624	'perish':1 'valley':2	(-36.409835999999999,148.40429399999999)
1848	Bredbo	1	2626	'bredbo':1	(-35.959128999999997,149.15019100000001)
1849	Jindabyne	1	2627	'jindabyn':1	(-36.415073999999997,148.61887100000001)
1850	Berridale	1	2628	'berridal':1	(-36.369529999999997,148.83004500000001)
1852	Dalgety	1	2628	'dalgeti':1	(-36.502267000000003,148.83456200000001)
1853	Eucumbene	1	2628	'eucumben':1	(-36.140580999999997,148.63419099999999)
1855	Adaminaby	1	2629	'adaminabi':1	(-35.997349,148.769744)
1856	Cabramurra	1	2629	'cabramurra':1	(-35.939511000000003,148.38574600000001)
1857	Yaouk	1	2629	'yaouk':1	(-35.822302000000001,148.809946)
1858	Bungarby	1	2630	'bungarbi':1	(-36.649439999999998,149.002848)
1860	Chakola	1	2630	'chakola':1	(-36.072584999999997,149.15995100000001)
1861	Cooma	1	2630	'cooma':1	(-36.236578999999999,149.12545600000001)
1862	Jerangle	1	2630	'jerangl':1	(-35.885731,149.35886600000001)
1864	Peak View	1	2630	'peak':1 'view':2	(-36.093615,149.37213800000001)
1865	Rock Flat	1	2630	'flat':2 'rock':1	(-36.348444000000001,149.211761)
1867	Ando	1	2631	'ando':1	(-36.739930999999999,149.261211)
1868	Nimmitabel	1	2631	'nimmitabel':1	(-36.518225000000001,149.28042400000001)
1870	Bombala	1	2632	'bombala':1	(-36.909543999999997,149.242198)
1871	Cathcart	1	2632	'cathcart':1	(-36.843699000000001,149.38833500000001)
1872	Craigie	1	2632	'craigi':1	(-37.071027000000001,149.049329)
1873	Mila	1	2632	'mila':1	(-37.055377999999997,149.170141)
1875	Albury	1	2640	'alburi':1	(-36.082137000000003,146.91017400000001)
1876	East Albury	1	2640	'alburi':2 'east':1	(-36.075617000000001,146.92910499999999)
1878	South Albury	1	2640	'alburi':2 'south':1	(-36.097002000000003,146.91521299999999)
1879	Table Top	1	2640	'tabl':1 'top':2	(-35.980269999999997,147.000325)
1880	Talmalmo	1	2640	'talmalmo':1	(-35.958207000000002,147.558379)
1881	Thurgoona	1	2640	'thurgoona':1	(-36.044474999999998,146.98996099999999)
1882	Lavington	1	2641	'lavington':1	(-36.050576999999997,146.933346)
1884	Burrumbuttock	1	2642	'burrumbuttock':1	(-35.835428999999998,146.80286100000001)
1885	Gerogery	1	2642	'gerogeri':1	(-35.834294,146.99425500000001)
1886	Jindera	1	2642	'jindera':1	(-35.950071000000001,146.88594599999999)
1887	Jingellic	1	2642	'jingel':1	(-35.925609999999999,147.69994)
1889	Rand	1	2642	'rand':1	(-35.593046999999999,146.577718)
1890	Tooma	1	2642	'tooma':1	(-35.971080000000001,148.052595)
1891	Walbundrie	1	2642	'walbundri':1	(-35.690162000000001,146.72127)
1893	Howlong	1	2643	'howlong':1	(-35.958568,146.60586000000001)
1894	Bowna	1	2644	'bowna':1	(-35.964984000000001,147.13085599999999)
1895	Holbrook	1	2644	'holbrook':1	(-35.729413999999998,147.309788)
1819	Uriarra	1	2611	'uriarra':1	(-35.415999999999997,148.83799999999999)
1931	Wagga Wagga Raaf	1	2651	'raaf':3 'wagga':1,2	\N
1994	Riverina	1	2678	'riverina':1	\N
1944	Rosewood	1	2652	'rosewood':1	(-35.674750000000003,147.86404099999999)
1897	Woomargama	1	2644	'woomargama':1	(-35.832853999999998,147.24756099999999)
1898	Urana	1	2645	'urana':1	(-35.329447000000002,146.26568399999999)
1899	Balldale	1	2646	'balldal':1	(-35.845723999999997,146.51835800000001)
1900	Corowa	1	2646	'corowa':1	(-35.997951999999998,146.39121399999999)
1901	Daysdale	1	2646	'daysdal':1	(-35.647620000000003,146.30662799999999)
1903	Oaklands	1	2646	'oakland':1	(-35.557881999999999,146.16777099999999)
1904	Rennie	1	2646	'renni':1	(-35.812497,146.13286299999999)
1905	Savernake	1	2646	'savernak':1	(-35.734786,146.049317)
1907	Cal Lal	1	2648	'cal':1 'lal':2	(-34.006404000000003,141.11530099999999)
1908	Curlwaa	1	2648	'curlwaa':1	(-34.09281,141.96555799999999)
1909	Mourquong	1	2648	'mourquong':1	(-34.138711000000001,142.162958)
1910	Palinyewah	1	2648	'palinyewah':1	(-33.824750999999999,142.15556799999999)
1912	Pooncarie	1	2648	'pooncari':1	(-33.386994999999999,142.570537)
1913	Rufus River	1	2648	'river':2 'rufus':1	(-34.010922000000001,141.54208700000001)
1914	Wentworth	1	2648	'wentworth':1	(-34.106867999999999,141.91921500000001)
1916	Ashmont	1	2650	'ashmont':1	(-35.123179999999998,147.32995600000001)
1917	Carabost	1	2650	'carabost':1	(-35.578721999999999,147.71714399999999)
1918	Collingullie	1	2650	'collingulli':1	(-35.071845000000003,147.11145999999999)
1919	Cookardinia	1	2650	'cookardinia':1	(-35.558522000000004,147.232617)
1921	Glenfield Park	1	2650	'glenfield':1 'park':2	(-35.138910000000003,147.334699)
1922	Harefield	1	2650	'harefield':1	(-34.969757999999999,147.56646799999999)
1923	Kooringal	1	2650	'kooring':1	(-35.135247,147.376284)
1925	Mount Austin	1	2650	'austin':2 'mount':1	(-35.133028000000003,147.35840300000001)
1926	Tolland	1	2650	'tolland':1	(-35.147914999999998,147.34997899999999)
1927	Turvey Park	1	2650	'park':2 'turvey':1	(-35.131926,147.35864000000001)
1928	Wagga Wagga	1	2650	'wagga':1,2	(-35.109861000000002,147.37051500000001)
1929	Wagga Wagga South	1	2650	'south':3 'wagga':1,2	(-35.120882999999999,147.35547700000001)
1930	Forest Hill	1	2651	'forest':1 'hill':2	(-32.707980999999997,151.55000999999999)
1932	Boree Creek	1	2652	'bore':1 'creek':2	(-35.106183000000001,146.61426)
1933	Galore	1	2652	'galor':1	(-35.006425999999998,146.893574)
1935	Grong Grong	1	2652	'grong':1,2	(-34.73818,146.78126499999999)
1936	Gumly Gumly	1	2652	'gum':1,2	(-35.123767999999998,147.42116899999999)
1937	Humula	1	2652	'humula':1	(-35.483054000000003,147.76417900000001)
1938	Ladysmith	1	2652	'ladysmith':1	(-35.207801000000003,147.51398399999999)
1940	Marrar	1	2652	'marrar':1	(-34.823698,147.350199)
1941	Matong	1	2652	'matong':1	(-34.767836000000003,146.91933299999999)
1942	Merriwagga	1	2652	'merriwagga':1	(-33.820290999999997,145.62234599999999)
1945	Tabbita	1	2652	'tabbita':1	(-34.105646,145.847824)
1946	Tarcutta	1	2652	'tarcutta':1	(-35.27561,147.73874799999999)
1947	Uranquinty	1	2652	'uranquinti':1	(-35.194775999999997,147.24305100000001)
1948	Mannus	1	2653	'mannus':1	(-35.799191,147.93720500000001)
1949	Tumbarumba	1	2653	'tumbarumba':1	(-35.777459,148.01286099999999)
1951	The Rock	1	2655	'rock':2	(-35.268365000000003,147.11484300000001)
1952	Lockhart	1	2656	'lockhart':1	(-35.221085000000002,146.71634299999999)
1953	Milbrulong	1	2656	'milbrulong':1	(-35.260489999999997,146.841971)
1955	Henty	1	2658	'henti':1	(-35.517186000000002,147.03578099999999)
1956	Pleasant Hills	1	2658	'hill':2 'pleasant':1	(-35.467016999999998,146.79716500000001)
1957	Ryan	1	2658	'ryan':1	(-35.563496000000001,146.86612099999999)
1958	Walla Walla	1	2659	'walla':1,2	(-35.766734,146.90101899999999)
1959	Culcairn	1	2660	'culcairn':1	(-35.667766,147.03717)
1962	Junee	1	2663	'june':1	(-34.870998,147.58467899999999)
1963	Ardlethan	1	2665	'ardlethan':1	(-34.357354999999998,146.903401)
1964	Ariah Park	1	2665	'ariah':1 'park':2	(-34.348104999999997,147.22122200000001)
1965	Barellan	1	2665	'barellan':1	(-34.28434,146.57125600000001)
1967	Binya	1	2665	'binya':1	(-34.228296999999998,146.337827)
1968	Kamarah	1	2665	'kamarah':1	(-34.368121000000002,146.76096000000001)
1969	Mirrool	1	2665	'mirrool':1	(-34.287956999999999,147.09506500000001)
1971	Grogan	1	2666	'grogan':1	(-34.248023000000003,147.78206700000001)
1972	Reefton	1	2666	'reefton':1	(-34.247121,147.436969)
1973	Sebastopol	1	2666	'sebastopol':1	(-34.580295999999997,147.517663)
1974	Springdale	1	2666	'springdal':1	(-34.465713000000001,147.71729500000001)
1976	Trungley Hall	1	2666	'hall':2 'trungley':1	(-34.288518000000003,147.555937)
1977	Barmedman	1	2668	'barmedman':1	(-34.184676000000003,147.40675400000001)
1978	Bygalorie	1	2669	'bygalori':1	(-33.498370999999999,146.80361500000001)
1980	Girral	1	2669	'girral':1	(-33.704027000000004,147.07181800000001)
1981	Naradhan	1	2669	'naradhan':1	(-33.613483000000002,146.32506699999999)
1982	Rankins Springs	1	2669	'rankin':1 'spring':2	(-33.840127000000003,146.26543699999999)
1983	Tallimba	1	2669	'tallimba':1	(-33.994402000000001,146.87969200000001)
1985	Ungarie	1	2669	'ungari':1	(-33.639341000000002,146.97467800000001)
1986	Weethalle	1	2669	'weethall':1	(-33.875402000000001,146.625969)
1987	Burcher	1	2671	'burcher':1	(-33.515237999999997,147.25005899999999)
1989	Wyalong	1	2671	'wyalong':1	(-33.925882000000001,147.243019)
1990	Burgooney	1	2672	'burgooney':1	(-33.387503000000002,146.57978800000001)
1991	Lake Cargelligo	1	2672	'cargelligo':2 'lake':1	(-33.298907999999997,146.37032199999999)
1992	Hillston	1	2675	'hillston':1	(-33.481364999999997,145.53465600000001)
1993	Roto	1	2675	'roto':1	(-33.058497000000003,145.34302199999999)
1997	Benerembah	1	2680	'benerembah':1	(-34.441693999999998,145.81526600000001)
1998	Bilbul	1	2680	'bilbul':1	(-34.273406000000001,146.13817599999999)
1999	Griffith	1	2680	'griffith':1	(-34.289045000000002,146.04367099999999)
2000	Hanwood	1	2680	'hanwood':1	(-34.329292000000002,146.041304)
2086	Kingswood	1	2747	'kingswood':1	(-33.759967000000003,150.72046)
2080	Greendale	1	2745	'greendal':1	(-33.904792,150.646795)
2001	Lake Wyangan	1	2680	'lake':1 'wyangan':2	(-34.247506999999999,146.032567)
2002	Tharbogang	1	2680	'tharbogang':1	(-34.255222000000003,145.98869199999999)
2003	Widgelli	1	2680	'widgelli':1	(-34.332464999999999,146.14381299999999)
2004	Willbriggie	1	2680	'willbriggi':1	(-34.467973000000001,146.01603700000001)
2006	Yenda	1	2681	'yenda':1	(-34.249070000000003,146.19555500000001)
2007	Corobimilla	1	2700	'corobimilla':1	(-34.868082000000001,146.41361800000001)
2008	Morundah	1	2700	'morundah':1	(-34.946674999999999,146.29512399999999)
2010	Coolamon	1	2701	'coolamon':1	(-34.815539000000001,147.200085)
2011	Ganmain	1	2702	'ganmain':1	(-34.794899000000001,147.03882300000001)
2012	Yanco	1	2703	'yanco':1	(-34.630842999999999,146.40344999999999)
2014	Leeton	1	2705	'leeton':1	(-34.552199999999999,146.40644399999999)
2015	Murrami	1	2705	'murrami':1	(-34.426116,146.30074999999999)
2016	Wamoon	1	2705	'wamoon':1	(-34.534930000000003,146.33155199999999)
2017	Whitton	1	2705	'whitton':1	(-34.517992,146.18555599999999)
2019	Argoon	1	2707	'argoon':1	(-34.858279000000003,145.67414600000001)
2020	Coleambally	1	2707	'coleamb':1	(-34.805619,145.88269099999999)
2022	Caldwell	1	2710	'caldwel':1	(-35.630254000000001,144.50214199999999)
2023	Conargo	1	2710	'conargo':1	(-35.302371000000001,145.181217)
2024	Deniliquin	1	2710	'deniliquin':1	(-35.528543999999997,144.95897400000001)
2025	Gulpa	1	2710	'gulpa':1	(-35.761612,144.90051399999999)
2027	Mayrung	1	2710	'mayrung':1	(-35.464979,145.320415)
2028	Moira	1	2710	'moira':1	(-35.927134000000002,144.84798699999999)
2029	Wakool	1	2710	'wakool':1	(-35.470616,144.39569299999999)
2031	Booligal	1	2711	'boolig':1	(-33.679442000000002,144.749504)
2032	Carrathool	1	2711	'carrathool':1	(-34.407181999999999,145.43078700000001)
2033	Gunbar	1	2711	'gunbar':1	(-34.008896999999997,145.31152800000001)
2034	Hay	1	2711	'hay':1	(-34.500508000000004,144.845099)
2036	Oxley	1	2711	'oxley':1	(-31.117187000000001,147.57099099999999)
2037	Berrigan	1	2712	'berrigan':1	(-35.657429999999998,145.81264100000001)
2038	Blighty	1	2713	'blighti':1	(-35.591687,145.285731)
2040	Tocumwal	1	2714	'tocumw':1	(-35.812106999999997,145.56738899999999)
2041	Balranald	1	2715	'balranald':1	(-34.638049000000002,143.56110100000001)
2042	Hatfield	1	2715	'hatfield':1	(-33.866480000000003,143.738495)
2044	Mabins Well	1	2716	'mabin':1 'well':2	(-34.856532000000001,145.55286100000001)
2045	Dareton	1	2717	'dareton':1	(-34.091641000000003,142.042284)
2046	Gilmore	1	2720	'gilmor':1	(-35.328187999999997,148.163783)
2047	Talbingo	1	2720	'talbingo':1	(-35.581623999999998,148.30331100000001)
2049	Quandialla	1	2721	'quandialla':1	(-34.009523000000002,147.79333600000001)
2050	Brungle	1	2722	'brungl':1	(-35.139141000000002,148.22357500000001)
2051	Gundagai	1	2722	'gundagai':1	(-35.065534,148.107529)
2053	Nangus	1	2722	'nangus':1	(-35.055354000000001,147.90704600000001)
2054	Stockinbingal	1	2725	'stockinbing':1	(-34.506022999999999,147.87996100000001)
2055	Jugiong	1	2726	'jugiong':1	(-34.823298999999999,148.324895)
2057	Coolac	1	2727	'coolac':1	(-34.902613000000002,148.193499)
2058	Adelong	1	2729	'adelong':1	(-35.307946999999999,148.063682)
2059	Cooleys Creek	1	2729	'cooley':1 'creek':2	(-35.338495999999999,148.07817900000001)
2060	Grahamstown	1	2729	'grahamstown':1	(-35.264738000000001,148.035551)
2062	Tumblong	1	2729	'tumblong':1	(-35.136654999999998,148.00973999999999)
2063	Wondalga	1	2729	'wondalga':1	(-35.395476000000002,148.110309)
2064	Batlow	1	2730	'batlow':1	(-35.522019,148.144623)
2066	Bunnaloo	1	2731	'bunnaloo':1	(-35.791187000000001,144.62984800000001)
2067	Moama	1	2731	'moama':1	(-36.112623999999997,144.755549)
2069	Barham	1	2732	'barham':1	(-35.630473000000002,144.13042300000001)
2070	Moulamein	1	2733	'moulamein':1	(-35.089134999999999,144.03663599999999)
2071	Kyalite	1	2734	'kyalit':1	(-34.951605000000001,143.484273)
2074	Goodnight	1	2736	'goodnight':1	(-34.958682000000003,143.33743999999999)
2075	Euston	1	2737	'euston':1	(-34.574976999999997,142.745126)
2076	Gol Gol	1	2738	'gol':1,2	(-34.180087,142.21953099999999)
2077	Monak	1	2738	'monak':1	(-34.301471999999997,142.53279699999999)
2079	Glenmore Park	1	2745	'glenmor':1 'park':2	(-33.790683000000001,150.66929999999999)
2081	Luddenham	1	2745	'luddenham':1	(-33.883724999999998,150.69307900000001)
2082	Mulgoa	1	2745	'mulgoa':1	(-33.838166999999999,150.68337099999999)
2083	Regentville	1	2745	'regentvill':1	(-33.773648999999999,150.66910200000001)
2085	Cambridge Park	1	2747	'cambridg':1 'park':2	(-33.751519999999999,150.72543899999999)
2087	Llandilo	1	2747	'llandilo':1	(-33.708903999999997,150.75677300000001)
2088	Shanes Park	1	2747	'park':2 'shane':1	(-33.711305000000003,150.783287)
2090	Werrington County	1	2747	'counti':2 'werrington':1	(-33.747939000000002,150.75115500000001)
2091	Werrington Downs	1	2747	'down':2 'werrington':1	(-33.740586,150.733755)
2092	Orchard Hills	1	2748	'hill':2 'orchard':1	(-33.779330999999999,150.71631199999999)
2093	Castlereagh	1	2749	'castlereagh':1	(-33.668796,150.67654999999999)
2095	Emu Plains	1	2750	'emu':1 'plain':2	(-33.754097000000002,150.65326899999999)
2096	Leonay	1	2750	'leonay':1	(-33.759155999999997,150.65231800000001)
2097	Penrith	1	2750	'penrith':1	(-33.732126999999998,151.28035199999999)
2099	Silverdale	1	2752	'silverdal':1	(-33.942211999999998,150.58010200000001)
2100	Warragamba	1	2752	'warragamba':1	(-33.889727000000001,150.60481899999999)
2101	Bowen Mountain	1	2753	'bowen':1 'mountain':2	(-33.573870999999997,150.62781899999999)
2102	Grose Vale	1	2753	'grose':1 'vale':2	(-33.584088999999999,150.672944)
2104	Hobartville	1	2753	'hobartvill':1	(-33.601557,150.73567299999999)
2105	Londonderry	1	2753	'londonderri':1	(-33.645187999999997,150.73697999999999)
2106	Richmond	1	2753	'richmond':1	(-33.597752999999997,150.75289000000001)
2072	Koraleigh	1	2735	'koraleigh':1	(-35.128,143.43600000000001)
2131	St Clair	1	2759	'clair':2 'st':1	(-33.794362,150.79026099999999)
2187	Yellow Rock	1	2777	'rock':2 'yellow':1	(-33.695065,150.62408300000001)
2148	Nelson	1	2765	'nelson':1	(-33.652794999999998,150.915685)
2107	Yarramundi	1	2753	'yarramundi':1	(-33.627259000000002,150.672695)
2109	Tennyson	1	2754	'tennyson':1	(-33.536388000000002,150.73694599999999)
2110	Richmond Raaf	1	2755	'raaf':2 'richmond':1	(-33.604377999999997,150.796234)
2111	Bligh Park	1	2756	'bligh':1 'park':2	(-33.637650000000001,150.79458)
2112	Cattai	1	2756	'cattai':1	(-33.555841000000001,150.909515)
2113	Clarendon	1	2756	'clarendon':1	(-33.614736000000001,150.78198)
2114	Colo	1	2756	'colo':1	(-33.788187999999998,149.259388)
2116	Ebenezer	1	2756	'ebenez':1	(-33.524659999999997,150.881372)
2117	Freemans Reach	1	2756	'freeman':1 'reach':2	(-33.545428999999999,150.79487800000001)
2118	Glossodia	1	2756	'glossodia':1	(-33.535657,150.76585600000001)
2120	Maroota	1	2756	'maroota':1	(-33.473024000000002,150.97097199999999)
2121	Mcgraths Hill	1	2756	'hill':2 'mcgrath':1	(-33.613435000000003,150.84022200000001)
2122	Mulgrave	1	2756	'mulgrav':1	(-33.626052999999999,150.82991200000001)
2123	Pitt Town	1	2756	'pitt':1 'town':2	(-33.586184000000003,150.86008100000001)
2125	Wilberforce	1	2756	'wilberforc':1	(-33.558179000000003,150.84750600000001)
2126	Windsor	1	2756	'windsor':1	(-33.608814000000002,150.81748099999999)
2127	Kurmond	1	2757	'kurmond':1	(-33.549452000000002,150.70111600000001)
2128	Bilpin	1	2758	'bilpin':1	(-33.498252999999998,150.52219500000001)
2130	Kurrajong	1	2758	'kurrajong':1	(-33.546748999999998,150.660686)
2132	Erskine Park	1	2759	'erskin':1 'park':2	(-33.807617999999998,150.78931299999999)
2133	Colyton	1	2760	'colyton':1	(-33.776657,150.79343299999999)
2134	Oxley Park	1	2760	'oxley':1 'park':2	(-33.771261000000003,150.79264000000001)
2137	Glendenning	1	2761	'glenden':1	(-33.739075,150.85517400000001)
2138	Hassall Grove	1	2761	'grove':2 'hassal':1	(-33.733812999999998,150.83427699999999)
2139	Oakhurst	1	2761	'oakhurst':1	(-33.744047999999999,150.83481900000001)
2140	Plumpton	1	2761	'plumpton':1	(-33.751432000000001,150.841204)
2142	Acacia Gardens	1	2763	'acacia':1 'garden':2	(-33.730077000000001,150.90650199999999)
2143	Quakers Hill	1	2763	'hill':2 'quaker':1	(-33.728355999999998,150.88117700000001)
2144	Berkshire Park	1	2765	'berkshir':1 'park':2	(-33.672237000000003,150.79576)
2145	Box Hill	1	2765	'box':1 'hill':2	(-33.639114999999997,150.904697)
2147	Marsden Park	1	2765	'marsden':1 'park':2	(-33.697584999999997,150.83231799999999)
2149	Oakville	1	2765	'oakvill':1	(-33.622562000000002,150.862154)
2150	Riverstone	1	2765	'riverston':1	(-33.679381999999997,150.86159499999999)
2153	Rooty Hill	1	2766	'hill':2 'rooti':1	(-33.771549999999998,150.84392199999999)
2154	Doonside	1	2767	'doonsid':1	(-33.765070999999999,150.86929000000001)
2155	Woodcroft	1	2767	'woodcroft':1	(-33.754986000000002,150.87966599999999)
2156	Glenwood	1	2768	'glenwood':1	(-33.737862999999997,150.922732)
2157	Parklea	1	2768	'parklea':1	(-33.728122999999997,150.92380700000001)
2159	The Ponds	1	2769	'pond':2	(-34.054326000000003,150.75310400000001)
2160	Bidwill	1	2770	'bidwil':1	(-33.730240000000002,150.822765)
2161	Blackett	1	2770	'blackett':1	(-33.738506999999998,150.811206)
2162	Dharruk	1	2770	'dharruk':1	(-33.743231999999999,150.816642)
2163	Emerton	1	2770	'emerton':1	(-33.742854999999999,150.80826300000001)
2165	Lethbridge Park	1	2770	'lethbridg':1 'park':2	(-33.736938000000002,150.799824)
2166	Minchinbury	1	2770	'minchinburi':1	(-33.781672999999998,150.81366700000001)
2167	Mount Druitt	1	2770	'druitt':2 'mount':1	(-33.766433999999997,150.81698900000001)
2169	Tregear	1	2770	'tregear':1	(-33.751081999999997,150.79567800000001)
2170	Whalan	1	2770	'whalan':1	(-33.760165000000001,150.809528)
2171	Willmot	1	2770	'willmot':1	(-33.727620999999999,150.79156900000001)
2172	Glenbrook	1	2773	'glenbrook':1	(-33.768023999999997,150.62169299999999)
2176	Blaxland	1	2774	'blaxland':1	(-33.744262999999997,150.61007599999999)
2174	Mount Riverview	1	2774	'mount':1 'riverview':2	(-33.734273000000002,150.63117700000001)
2175	Warrimoo	1	2774	'warrimoo':1	(-33.722957999999998,150.604162)
2178	Laughtondale	1	2775	'laughtondal':1	(-33.410229000000001,151.02459200000001)
2179	Spencer	1	2775	'spencer':1	(-33.459454999999998,151.14238499999999)
2180	St Albans	1	2775	'alban':2 'st':1	(-33.290934,150.97026299999999)
2181	Wisemans Ferry	1	2775	'ferri':2 'wiseman':1	(-33.408878999999999,150.98004800000001)
2182	Faulconbridge	1	2776	'faulconbridg':1	(-33.696505000000002,150.534998)
2184	Springwood	1	2777	'springwood':1	(-33.700645000000002,150.55875)
2185	Valley Heights	1	2777	'height':2 'valley':1	(-33.705288000000003,150.58491900000001)
2186	Winmalee	1	2777	'winmale':1	(-33.673276000000001,150.61911000000001)
2188	Linden	1	2778	'linden':1	(-33.715528999999997,150.50447700000001)
2190	Hazelbrook	1	2779	'hazelbrook':1	(-33.720992000000003,150.451629)
2192	Leura	1	2780	'leura':1	(-33.714148999999999,150.330827)
2193	Medlow Bath	1	2780	'bath':2 'medlow':1	(-33.672525999999998,150.280742)
2194	Wentworth Falls	1	2782	'fall':2 'wentworth':1	(-33.709836000000003,150.376454)
2195	Lawson	1	2783	'lawson':1	(-33.718957000000003,150.430094)
2197	Blackheath	1	2785	'blackheath':1	(-33.635556000000001,150.28483)
2198	Megalong	1	2785	'megalong':1	(-33.704121000000001,150.24622400000001)
2199	Bell	1	2786	'bell':1	(-33.513745,150.279391)
2200	Dargan	1	2786	'dargan':1	(-33.489255999999997,150.26351399999999)
2202	Mount Victoria	1	2786	'mount':1 'victoria':2	(-33.588560999999999,150.251161)
2203	Mount Wilson	1	2786	'mount':1 'wilson':2	(-33.503126000000002,150.38836800000001)
2204	Black Springs	1	2787	'black':1 'spring':2	(-33.840966000000002,149.711027)
2205	Duckmaloi	1	2787	'duckmaloi':1	(-33.679898000000001,149.96420699999999)
2207	Gingkin	1	2787	'gingkin':1	(-33.888787999999998,149.927471)
2151	Vineyard	1	2765	'vineyard':1	(-33.646999999999998,150.84100000000001)
2273	Barry	1	2799	'barri':1	(-33.648293000000002,149.26954499999999)
2229	Woodstock	1	2793	'woodstock':1	(-33.745179999999998,148.84795800000001)
2285	Spring Hill	1	2800	'hill':2 'spring':1	(-33.398705999999997,149.15235000000001)
2208	Hazelgrove	1	2787	'hazelgrov':1	(-33.650013999999999,149.89371299999999)
2209	Oberon	1	2787	'oberon':1	(-33.703856000000002,149.85548399999999)
2211	Shooters Hill	1	2787	'hill':2 'shooter':1	(-33.895788000000003,149.86176599999999)
2212	Tarana	1	2787	'tarana':1	(-33.526572000000002,149.90818899999999)
2213	Bowenfels	1	2790	'bowenfel':1	(-33.471595999999998,150.124112)
2214	Clarence	1	2790	'clarenc':1	(-33.479311000000003,150.21555900000001)
2216	Cullen Bullen	1	2790	'bullen':2 'cullen':1	(-33.303401999999998,150.03251800000001)
2218	Hartley	1	2790	'hartley':1	(-33.548476000000001,150.15458799999999)
2219	Lidsdale	1	2790	'lidsdal':1	(-33.378534999999999,150.083775)
2220	Lithgow	1	2790	'lithgow':1	(-33.480068000000003,150.15798699999999)
2222	Lowther	1	2790	'lowther':1	(-33.624853000000002,150.10033100000001)
2223	Marrangaroo	1	2790	'marrangaroo':1	(-33.428677999999998,150.10622499999999)
2224	Rydal	1	2790	'rydal':1	(-33.492530000000002,150.03691499999999)
2225	Sodwalls	1	2790	'sodwal':1	(-33.516429000000002,150.00726599999999)
2226	Carcoar	1	2791	'carcoar':1	(-33.609622000000002,149.140601)
2228	Darbys Falls	1	2793	'darbi':1 'fall':2	(-33.931095999999997,148.859104)
2230	Bumbaldry	1	2794	'bumbaldri':1	(-33.906339000000003,148.45638500000001)
2231	Cowra	1	2794	'cowra':1	(-33.834679999999999,148.691192)
2233	Wattamondara	1	2794	'wattamondara':1	(-33.938468,148.60606799999999)
2234	Bald Ridge	1	2795	'bald':1 'ridg':2	(-33.934671999999999,149.42847399999999)
2235	Ballyroe	1	2795	'ballyro':1	(-34.084404999999997,149.60429400000001)
2236	Brewongle	1	2795	'brewongl':1	(-33.488779999999998,149.67541)
2238	Dark Corner	1	2795	'corner':2 'dark':1	(-33.306755000000003,149.87737100000001)
2239	Dunkeld	1	2795	'dunkeld':1	(-33.406576999999999,149.48566700000001)
2240	Duramana	1	2795	'duramana':1	(-33.267558000000001,149.53275300000001)
2242	Freemantle	1	2795	'freemantl':1	(-33.243662999999998,149.37857099999999)
2243	Gemalla	1	2795	'gemalla':1	(-33.524129000000002,149.837333)
2244	Georges Plains	1	2795	'georg':1 'plain':2	(-33.515628999999997,149.52318199999999)
2246	Isabella	1	2795	'isabella':1	(-33.954417999999997,149.666899)
2247	Judds Creek	1	2795	'creek':2 'judd':1	(-33.833711999999998,149.55098799999999)
2248	Kelso	1	2795	'kelso':1	(-33.419195999999999,149.61155500000001)
2249	Locksley	1	2795	'locksley':1	(-33.515827999999999,149.776599)
2250	Meadow Flat	1	2795	'flat':2 'meadow':1	(-33.434919000000001,149.92128199999999)
2252	Newbridge	1	2795	'newbridg':1	(-33.585731000000003,149.36482599999999)
2253	Peel	1	2795	'peel':1	(-33.290005999999998,149.615645)
2254	Perthville	1	2795	'perthvill':1	(-33.485900000000001,149.54697999999999)
2255	Raglan	1	2795	'raglan':1	(-33.422274999999999,149.64938900000001)
2256	Rockley	1	2795	'rockley':1	(-33.692545000000003,149.569433)
2258	Sunny Corner	1	2795	'corner':2 'sunni':1	(-33.381925000000003,149.88519099999999)
2260	Trunkey Creek	1	2795	'creek':2 'trunkey':1	(-33.824738000000004,149.36300700000001)
2261	Turondale	1	2795	'turondal':1	(-33.121541999999998,149.601111)
2263	Wattle Flat	1	2795	'flat':2 'wattl':1	(-33.140506999999999,149.69381300000001)
2264	West Bathurst	1	2795	'bathurst':2 'west':1	(-33.412694999999999,149.564797)
2265	Wimbledon	1	2795	'wimbledon':1	(-33.546855000000001,149.428684)
2267	Yetholme	1	2795	'yetholm':1	(-33.449582999999997,149.81669299999999)
2268	Garland	1	2797	'garland':1	(-33.707872999999999,149.02580900000001)
2270	Forest Reefs	1	2798	'forest':1 'reef':2	(-33.453985000000003,149.10924)
2271	Millthorpe	1	2798	'millthorp':1	(-33.445861999999998,149.18539699999999)
2272	Tallwood	1	2798	'tallwood':1	(-33.500866000000002,149.123535)
2275	Browns Creek	1	2799	'brown':1 'creek':2	(-33.525683000000001,149.14987600000001)
2276	Neville	1	2799	'nevill':1	(-33.709398,149.21507299999999)
2277	Vittoria	1	2799	'vittoria':1	(-33.435893999999998,149.37296699999999)
2278	Borenore	1	2800	'borenor':1	(-33.247292000000002,148.97450499999999)
2280	Lucknow	1	2800	'lucknow':1	(-33.345661999999997,149.161068)
2281	March	1	2800	'march':1	(-33.216351000000003,149.07654099999999)
2283	Nashdale	1	2800	'nashdal':1	(-33.296695999999997,149.01829900000001)
2284	Orange	1	2800	'orang':1	(-33.276947999999997,149.09977499999999)
2286	Bendick Murrell	1	2803	'bendick':1 'murrel':2	(-34.162820000000004,148.44984600000001)
2287	Crowther	1	2803	'crowther':1	(-34.096639000000003,148.50711799999999)
2288	Wirrimah	1	2803	'wirrimah':1	(-34.129055999999999,148.42425299999999)
2290	Gooloogong	1	2805	'gooloogong':1	(-33.650848000000003,148.41385)
2291	Eugowra	1	2806	'eugowra':1	(-33.427106999999999,148.37164999999999)
2292	Koorawatha	1	2807	'koorawatha':1	(-34.039890999999997,148.553887)
2294	Bimbi	1	2810	'bimbi':1	(-33.985252000000003,147.927491)
2295	Caragabal	1	2810	'caragab':1	(-33.843828999999999,147.73925600000001)
2296	Grenfell	1	2810	'grenfel':1	(-33.894984999999998,148.16115400000001)
2297	Pullabooka	1	2810	'pullabooka':1	(-33.755423999999998,147.82531800000001)
2298	Arthurville	1	2820	'arthurvill':1	(-32.554842999999998,148.74270899999999)
2300	Bodangora	1	2820	'bodangora':1	(-32.450252999999996,149.032287)
2301	Dripstone	1	2820	'dripston':1	(-32.650328999999999,148.98951500000001)
2302	Farnham	1	2820	'farnham':1	(-32.839359999999999,149.08643699999999)
2303	Maryvale	1	2820	'maryval':1	(-32.464179000000001,148.89915500000001)
2304	Mumbil	1	2820	'mumbil':1	(-32.725538999999998,149.049691)
2306	Spicers Creek	1	2820	'creek':2 'spicer':1	(-32.395842000000002,149.143044)
2307	Stuart Town	1	2820	'stuart':1 'town':2	(-32.805688000000004,149.07726299999999)
2308	Walmer	1	2820	'walmer':1	(-32.662973999999998,148.71969200000001)
2310	Narromine	1	2821	'narromin':1	(-32.231920000000002,148.23960600000001)
2311	Trangie	1	2823	'trangi':1	(-32.031886999999998,147.983937)
2217	Hampton	1	2790	'hampton':1	(-33.484000000000002,150.261)
2316	Mullengudgery	1	2825	'mullengudgeri':1	(-31.747548999999999,147.42891800000001)
2317	Nyngan	1	2825	'nyngan':1	(-31.562487000000001,147.19235599999999)
2318	Collie	1	2827	'colli':1	(-31.667726999999999,148.30349000000001)
2319	Curban	1	2827	'curban':1	(-31.512136000000002,148.61207099999999)
2321	Gulargambone	1	2828	'gulargambon':1	(-31.329692000000001,148.47118900000001)
2322	Warrumbungle	1	2828	'warrumbungl':1	(-31.277553999999999,148.98204100000001)
2323	Combara	1	2829	'combara':1	(-31.124693000000001,148.37341000000001)
2325	Ballimore	1	2830	'ballimor':1	(-32.195726000000001,148.90206499999999)
2326	Brocklehurst	1	2830	'brocklehurst':1	(-32.150734999999997,148.68887699999999)
2327	Dubbo	1	2830	'dubbo':1	(-32.245192000000003,148.60421199999999)
2328	Mogriguy	1	2830	'mogriguy':1	(-32.066389999999998,148.66057599999999)
2330	Balladoran	1	2831	'balladoran':1	(-31.852136000000002,148.626475)
2331	Byrock	1	2831	'byrock':1	(-30.661860000000001,146.40396999999999)
2332	Carinda	1	2831	'carinda':1	(-30.461198,147.69117299999999)
2334	Elong Elong	1	2831	'elong':1,2	(-32.116011999999998,149.02620200000001)
2335	Eumungerie	1	2831	'eumungeri':1	(-31.951111999999998,148.626363)
2336	Geurie	1	2831	'geuri':1	(-32.399031999999998,148.828532)
2337	Girilambone	1	2831	'girilambon':1	(-31.248445,146.90486899999999)
2339	Hermidale	1	2831	'hermidal':1	(-31.638847999999999,146.689584)
2340	Merrygoen	1	2831	'merrygoen':1	(-31.824228999999999,149.23064400000001)
2341	Neilrex	1	2831	'neilrex':1	(-31.720631999999998,149.307062)
2342	Nevertire	1	2831	'nevertir':1	(-31.838854000000001,147.71872300000001)
2344	Quambone	1	2831	'quambon':1	(-30.929382,147.86996300000001)
2345	Tooraweenah	1	2831	'tooraweenah':1	(-31.439404,148.910428)
2346	Wongarbon	1	2831	'wongarbon':1	(-32.334144000000002,148.75692100000001)
2348	Cryon	1	2832	'cryon':1	(-30.127724000000001,148.61168000000001)
2349	Cumborah	1	2832	'cumborah':1	(-29.742525000000001,147.767956)
2350	Walgett	1	2832	'walgett':1	(-30.021557999999999,148.11668399999999)
2351	Collarenebri	1	2833	'collarenebri':1	(-29.545809999999999,148.576548)
2353	Cobar	1	2835	'cobar':1	(-31.498218000000001,145.84072699999999)
2354	White Cliffs	1	2836	'cliff':2 'white':1	(-30.850444,143.083844)
2355	Wilcannia	1	2836	'wilcannia':1	(-31.558558999999999,143.37797599999999)
2356	Brewarrina	1	2839	'brewarrina':1	(-29.961518999999999,146.85899900000001)
2358	Barringun	1	2840	'barringun':1	(-29.189250000000001,145.88158999999999)
2359	Bourke	1	2840	'bourk':1	(-30.088847000000001,145.93774199999999)
2360	Enngonia	1	2840	'enngonia':1	(-29.318123,145.84617)
2361	Fords Bridge	1	2840	'bridg':2 'ford':1	(-29.752523,145.42497900000001)
2362	Louth	1	2840	'louth':1	(-30.533836000000001,145.11533499999999)
2364	Urisino	1	2840	'urisino':1	(-29.70804,143.73039700000001)
2365	Wanaaring	1	2840	'wanaar':1	(-29.706274000000001,144.14734300000001)
2366	Yantabulla	1	2840	'yantabulla':1	(-29.338394000000001,145.00275099999999)
2368	Coolah	1	2843	'coolah':1	(-31.774418000000001,149.61162100000001)
2369	Birriwa	1	2844	'birriwa':1	(-32.122231999999997,149.46506400000001)
2370	Dunedoo	1	2844	'dunedoo':1	(-32.016184000000003,149.395838)
2372	Wallerawang	1	2845	'wallerawang':1	(-33.410617999999999,150.06259700000001)
2373	Capertee	1	2846	'caperte':1	(-33.148969000000001,149.99001000000001)
2374	Glen Davis	1	2846	'davi':2 'glen':1	(-33.134332999999998,150.147648)
2375	Portland	1	2847	'portland':1	(-33.353124000000001,149.98227)
2377	Clandulla	1	2848	'clandulla':1	(-32.906520999999998,149.950771)
2378	Kandos	1	2848	'kando':1	(-32.857495,149.96946)
2379	Bylong	1	2849	'bylong':1	(-32.417309000000003,150.114058)
2380	Rylstone	1	2849	'rylston':1	(-32.799368999999999,149.97044199999999)
2382	Havilah	1	2850	'havilah':1	(-32.620676000000003,149.764365)
2383	Hill End	1	2850	'end':2 'hill':1	(-33.031247,149.41701399999999)
2384	Ilford	1	2850	'ilford':1	(-32.942208999999998,149.859658)
2385	Lue	1	2850	'lue':1	(-32.654139999999998,149.84217100000001)
2387	Running Stream	1	2850	'run':1 'stream':2	(-33.020110000000003,149.91120100000001)
2388	Turill	1	2850	'turil':1	(-32.156945,149.87927400000001)
2390	Ulan	1	2850	'ulan':1	(-32.282873000000002,149.73643899999999)
2391	Wilbetree	1	2850	'wilbetre':1	(-32.479582999999998,149.56804600000001)
2392	Windeyer	1	2850	'windey':1	(-32.776319999999998,149.5453)
2393	Wollar	1	2850	'wollar':1	(-32.361338000000003,149.94875999999999)
2395	Goolma	1	2852	'goolma':1	(-32.346144000000002,149.25686899999999)
2396	Gulgong	1	2852	'gulgong':1	(-32.362586999999998,149.53352799999999)
2397	Cudal	1	2864	'cudal':1	(-33.286704,148.73889800000001)
2398	Murga	1	2864	'murga':1	(-33.369987999999999,148.545278)
2400	Manildra	1	2865	'manildra':1	(-33.186577999999997,148.696347)
2401	Euchareena	1	2866	'euchareena':1	(-32.939005999999999,149.067204)
2402	Garra	1	2866	'garra':1	(-33.114373999999998,148.75626)
2404	Molong	1	2866	'molong':1	(-33.091970000000003,148.86877200000001)
2405	Baldry	1	2867	'baldri':1	(-32.865448000000001,148.500123)
2406	Cumnock	1	2867	'cumnock':1	(-32.927818000000002,148.75450900000001)
2407	Yeoval	1	2868	'yeoval':1	(-32.751829000000001,148.64903200000001)
2409	Tomingley	1	2869	'tomingley':1	(-32.556854000000001,148.21799100000001)
2410	Trewilga	1	2869	'trewilga':1	(-32.791362999999997,148.21964600000001)
2411	Alectown	1	2870	'alectown':1	(-32.933075000000002,148.257653)
2412	Cookamidgera	1	2870	'cookamidgera':1	(-33.224899999999998,148.32496800000001)
2413	Daroobalgie	1	2870	'daroobalgi':1	(-33.321111000000002,148.063142)
2415	Mandagery	1	2870	'mandageri':1	(-33.224277000000001,148.40161000000001)
2416	Parkes	1	2870	'park':1	(-33.138325999999999,148.17416600000001)
2417	Tichborne	1	2870	'tichborn':1	(-33.231850999999999,148.11719099999999)
2419	Forbes	1	2871	'forb':1	(-33.385342999999999,148.00790499999999)
2420	Garema	1	2871	'garema':1	(-33.566904999999998,147.99104399999999)
2421	Wirrinya	1	2871	'wirrinya':1	(-33.684092999999997,147.74749)
2445	Mildura	1	3500	'mildura':1	\N
2444	Waterloo	1	2899	'waterloo':1	(-33.900399999999998,151.20614399999999)
2423	Tottenham	1	2873	'tottenham':1	(-32.244042,147.35602800000001)
2424	Tullamore	1	2874	'tullamor':1	(-32.631462999999997,147.56402600000001)
2425	Fifield	1	2875	'fifield':1	(-32.807977000000001,147.45880500000001)
2426	Ootha	1	2875	'ootha':1	(-33.129345999999998,147.43459799999999)
2427	Trundle	1	2875	'trundl':1	(-32.922887000000003,147.70990399999999)
2428	Bogan Gate	1	2876	'bogan':1 'gate':2	(-33.106228999999999,147.80235400000001)
2429	Gunningbland	1	2876	'gunningbland':1	(-33.138047,147.92241899999999)
2430	Nelungaloo	1	2876	'nelungaloo':1	(-33.144016000000001,147.99822499999999)
2431	Condobolin	1	2877	'condobolin':1	(-33.089095,147.15217999999999)
2432	Derriwong	1	2877	'derriwong':1	(-33.119670999999997,147.364777)
2433	Euabalong	1	2877	'euabalong':1	(-33.112515000000002,146.47271499999999)
2434	Mount Hope	1	2877	'hope':2 'mount':1	(-32.824527000000003,145.88302999999999)
2435	Conoble	1	2878	'conobl':1	(-32.724744999999999,144.551875)
2436	Ivanhoe	1	2878	'ivanho':1	(-32.899777,144.30044100000001)
2437	Mossgiel	1	2878	'mossgiel':1	(-33.251798999999998,144.56694999999999)
2438	Trida	1	2878	'trida':1	(-33.020873000000002,145.015119)
2439	Menindee	1	2879	'meninde':1	(-32.392052999999997,142.41761299999999)
2440	Silverton	1	2880	'silverton':1	(-31.885922999999998,141.23290700000001)
2441	Tibooburra	1	2880	'tibooburra':1	(-29.434259000000001,142.01007899999999)
2442	Lord Howe Island	1	2890	'howe':2 'island':3 'lord':1	(-31.55247,159.08121700000001)
2443	Lord Howe Island	1	2898	'howe':2 'island':3 'lord':1	(-31.55247,159.08121700000001)
2446	Barooga	1	3644	'barooga':1	(-35.913566000000003,145.688503)
2447	Corryong	1	3707	'corryong':1	(-36.395000000000003,147.99799999999999)
\.


--
-- Data for Name: system_errors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_errors (id, error_type, description, occurred_at) FROM stdin;
1	Update Store	Could not update store 1	2019-09-26 17:22:52.64+10
2	Validate Reward	Could not parse userReward: null	2019-09-26 19:17:18.32+10
3	Validate Reward	Could not parse userReward: null	2019-09-26 19:17:29.84+10
4	Validate Reward	Could not parse userReward: null	2019-09-26 19:20:30.058+10
5	Validate Reward	Could not parse userReward: null	2019-09-26 19:21:40.644+10
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
-- Data for Name: us_gaz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_lex; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_rules (id, rule, is_custom) FROM stdin;
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
-- Data for Name: user_favorite_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_posts (user_id, post_id) FROM stdin;
\.


--
-- Data for Name: user_favorite_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_rewards (user_id, reward_id) FROM stdin;
1	3
1	1
2	3
2	5
2	2
2	8
2	12
\.


--
-- Data for Name: user_favorite_stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_favorite_stores (user_id, store_id) FROM stdin;
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
-- Data for Name: user_follows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_follows (user_id, follower_id) FROM stdin;
2	1
3	1
1	2
3	2
4	2
2	2765
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
1	nyatella	Luna	https://imgur.com/DAdLVwp.jpg	female	Luna	Lytele	Avid traveller, big foodie. Ramen or die! 🍜	1	3
3	annika_b	Annika	https://imgur.com/18N6fV3.jpg	female	Annika	McIntyre	🏹 Sagittarius\r\n🍜 Big Foodie\r\n📍 Tokyo, Amsterdam, Brooklyn	2	2
5	evalicious	Eva	https://imgur.com/fFa9R1o.jpg	female	Eva	Seacrest	\N	0	1
2	curious_chloe	Chloe	https://imgur.com/AwS5vPC.jpg	female	Chloe	Lee	🏹 Saggitarius\n✈ Tokyo, Amsterdam, and Brooklyn\n🏠 Living in Sydney\n🍜 Ramen, Pad Thai, and Boba is Lyf	2	5
4	miss.leia	Leia	https://imgur.com/CUVkwzY.jpg	female	Leia	Rochford	When a poet digs himself into a hole, he doesn't climb out. He digs deeper, enjoys the scenery, and comes out the other side enlightened.	1	2
\.


--
-- Data for Name: user_rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_rewards (user_id, reward_id, unique_code, last_redeemed_at, redeemed_count) FROM stdin;
2	18	MN6K	2019-10-02 21:00:37.644+10	5
2	19	Z7Z7	\N	0
2	17	9MNW	2019-10-02 21:00:06.265+10	3
2765	2	Y8Z2	2019-09-19 07:35:34.959+10	1
1	1	CX1P	2019-09-19 07:35:34.959+10	1
2	9	0MYD	2019-09-19 07:35:34.959+10	1
2	3	IODE	2019-09-19 07:35:34.959+10	1
2	7	N4CE	2019-09-19 07:35:34.959+10	1
2	8	OK1O	2019-09-19 07:35:34.959+10	1
2	12	5KK5	\N	0
2	1	5GVY	2019-09-19 07:35:34.959+10	5
2	5	NYKD	\N	0
2	15	GCDQ	\N	0
2	2	PLPZ	\N	0
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 10, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 2, true);


--
-- Name: comment_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_likes_id_seq', 5, true);


--
-- Name: comment_replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_replies_id_seq', 46, true);


--
-- Name: comment_reply_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_reply_likes_id_seq', 1, true);


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
-- Name: post_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_likes_id_seq', 4, true);


--
-- Name: post_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_photos_id_seq', 387, true);


--
-- Name: post_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_reviews_id_seq', 209, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 218, true);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rewards_id_seq', 19, true);


--
-- Name: store_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_addresses_id_seq', 53, true);


--
-- Name: store_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_groups_id_seq', 4, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stores_id_seq', 63, true);


--
-- Name: suburbs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suburbs_id_seq', 2448, true);


--
-- Name: system_errors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_errors_id_seq', 5, true);


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
    stores.coords,
    ((((((((setweight(to_tsvector('english'::regconfig, public.unaccent((stores.name)::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(locations.name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_first_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_second_line, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_name, ''::character varying))::text), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, public.unaccent(COALESCE(string_agg((cuisines.name)::text, ' '::text), ''::text))), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_number, ''::character varying))::text), 'C'::"char")) AS document
   FROM ((((((public.stores
     LEFT JOIN public.locations ON ((stores.location_id = locations.id)))
     LEFT JOIN public.suburbs ON ((stores.suburb_id = suburbs.id)))
     LEFT JOIN public.cities ON ((stores.city_id = cities.id)))
     LEFT JOIN public.store_cuisines ON ((store_cuisines.store_id = stores.id)))
     LEFT JOIN public.cuisines ON ((store_cuisines.cuisine_id = cuisines.id)))
     LEFT JOIN public.store_addresses ON ((store_addresses.store_id = stores.id)))
  GROUP BY stores.id, locations.name, suburbs.name, cities.name, stores.cover_image, store_addresses.address_first_line, store_addresses.address_second_line, store_addresses.address_street_name, store_addresses.address_street_number
  WITH NO DATA;


ALTER TABLE public.store_search OWNER TO postgres;

--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: comment_likes comment_likes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_pk PRIMARY KEY (id);


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
-- Name: post_likes post_likes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_pk PRIMARY KEY (id);


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
-- Name: comment_reply_likes reply_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_reply_likes
    ADD CONSTRAINT reply_likes_pkey UNIQUE (user_id, reply_id);


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
-- Name: system_errors system_errors_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_errors
    ADD CONSTRAINT system_errors_pk PRIMARY KEY (id);


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
-- Name: user_favorite_posts user_favorite_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_pkey PRIMARY KEY (user_id, post_id);


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
-- Name: admins_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admins_username_index ON public.admins USING btree (username);


--
-- Name: cities_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cities_name ON public.cities USING btree (name);


--
-- Name: comment_likes_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX comment_likes_id_uindex ON public.comment_likes USING btree (id);


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
-- Name: errors_error_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX errors_error_type_index ON public.system_errors USING btree (error_type);


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
-- Name: reward_search_document_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX reward_search_document_idx ON public.reward_search USING btree (document);


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
-- Name: suburbs_document_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX suburbs_document_idx ON public.suburbs USING btree (document);


--
-- Name: suburbs_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX suburbs_name ON public.suburbs USING btree (name);


--
-- Name: system_errors_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX system_errors_id_uindex ON public.system_errors USING btree (id);


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

CREATE INDEX user_rewards_redeemed_at_index ON public.user_rewards USING btree (last_redeemed_at);


--
-- Name: user_rewards_unique_code_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_rewards_unique_code_uindex ON public.user_rewards USING btree (unique_code);


--
-- Name: admins admins_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: cities cities_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_comments_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_comments_id_fk FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: comment_likes comment_likes_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_comments_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_comments_id_fk FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_stores_id_fk FOREIGN KEY (replied_by_store) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: comment_replies comment_replies_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_replies
    ADD CONSTRAINT comment_replies_user_profiles_user_id_fk FOREIGN KEY (replied_by) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: comment_reply_likes comment_reply_likes_comment_replies_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_comment_replies_id_fk FOREIGN KEY (reply_id) REFERENCES public.comment_replies(id) ON DELETE CASCADE;


--
-- Name: comment_reply_likes comment_reply_likes_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES public.comment_replies(id) ON DELETE CASCADE;


--
-- Name: comment_reply_likes comment_reply_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_reply_likes
    ADD CONSTRAINT comment_reply_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: comments comments_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_stores_id_fk FOREIGN KEY (commented_by_store) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: districts districts_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- Name: locations locations_suburb_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_suburb_id_fkey FOREIGN KEY (suburb_id) REFERENCES public.suburbs(id) ON DELETE CASCADE;


--
-- Name: comments post_comments_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT post_comments_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: comments post_comments_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT post_comments_user_accounts_id_fk FOREIGN KEY (commented_by) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: post_photos post_photos_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_photos
    ADD CONSTRAINT post_photos_posts_id_fk FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_reviews post_reviews_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_reviews
    ADD CONSTRAINT post_reviews_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: posts posts_posted_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_posted_by_id_fkey FOREIGN KEY (posted_by) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: posts posts_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: reward_rankings reward_rankings_rewards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_rankings
    ADD CONSTRAINT reward_rankings_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES public.rewards(id) ON DELETE CASCADE;


--
-- Name: rewards rewards_store_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_store_group_id_fkey FOREIGN KEY (store_group_id) REFERENCES public.store_groups(id) ON DELETE CASCADE;


--
-- Name: rewards rewards_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_addresses store_addresses_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_addresses
    ADD CONSTRAINT store_addresses_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: store_cuisines store_cuisines_cuisines_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_cuisines
    ADD CONSTRAINT store_cuisines_cuisines_id_fk FOREIGN KEY (cuisine_id) REFERENCES public.cuisines(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT store_follows_user_profiles_user_id_fk FOREIGN KEY (follower_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


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
    ADD CONSTRAINT store_tags_tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: suburbs suburbs_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suburbs
    ADD CONSTRAINT suburbs_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;


--
-- Name: user_claims user_claims_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_claims
    ADD CONSTRAINT user_claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_posts user_favorite_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_favorite_posts user_favorite_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_posts
    ADD CONSTRAINT user_favorite_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_favorite_stores user_favorite_stores_stores_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_stores_id_fk FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: user_favorite_stores user_favorite_stores_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_stores
    ADD CONSTRAINT user_favorite_stores_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_follows user_follows_user_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_follows user_follows_user_profiles_user_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_follows
    ADD CONSTRAINT user_follows_user_profiles_user_id_fk_2 FOREIGN KEY (follower_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


--
-- Name: user_logins user_logins_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_logins
    ADD CONSTRAINT user_logins_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_rewards user_rewards_reward_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_reward_id_fkey FOREIGN KEY (reward_id) REFERENCES public.rewards(id) ON DELETE CASCADE;


--
-- Name: user_rewards user_rewards_rewards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rewards
    ADD CONSTRAINT user_rewards_rewards_id_fk FOREIGN KEY (reward_id) REFERENCES public.rewards(id) ON DELETE CASCADE;


--
-- Name: user_rewards user_rewards_user_accounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rewards
    ADD CONSTRAINT user_rewards_user_accounts_id_fk FOREIGN KEY (user_id) REFERENCES public.user_accounts(id) ON DELETE CASCADE;


--
-- Name: user_favorite_rewards user_rewards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_favorite_rewards
    ADD CONSTRAINT user_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(user_id) ON DELETE CASCADE;


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
-- Name: reward_search; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.reward_search;


--
-- Name: store_search; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.store_search;


--
-- PostgreSQL database dump complete
--

