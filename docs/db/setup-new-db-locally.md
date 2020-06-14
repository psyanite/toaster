# Create database
* Connect to database via DataGrip
create database burntoast;
use schema public;
create extension unaccent;
create extension cube;
create extension earthdistance;

# Input data
* cd to project directory
psql -U postgres -d burntoast
drop schema if exists croissant cascade
create schema croissant
\i scripts/export.sql

# Setup role for local usage
* Role will have same permissions as the GSQL postgres role
create role nyatella with password '???';
alter role nyatella with CREATEDB;
grant all privileges on all tables in schema public,croissant to nyatella;
grant all privileges on all functions in schema public,croissant to nyatella;
grant all privileges on all sequences in schema public,croissant to nyatella;

# Setup role for toaster application
create role toaster with password '???';
grant all privileges on database burntoast to toaster;
alter role toaster set search_path = croissant, public;
alter role toaster with login;
grant usage on schema croissant to toaster;
grant select,insert,update,delete on all tables in schema croissant to toaster;
grant execute on all functions in schema croissant to toaster;
grant usage,select on all sequences in schema croissant to toaster;
alter materialized view location_search owner to toaster;
alter materialized view cuisine_search owner to toaster;
alter materialized view reward_search owner to toaster;
alter materialized view store_search owner to toaster;
