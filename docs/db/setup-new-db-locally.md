# Create database
* Connect to database via DataGrip
* Run script
```
create database burntoast;

use schema public;
create extension unaccent;
create extension cube;
create extension earthdistance;
create extension unaccent;
```

# Refresh
* drop schema croissant;

# Input data
* cd to project directory
* `psql -U postgres -d burntoast`
* set schema croissant'
* `\i scripts/clean.sql`
* `\i scripts/export.sql`

# Setup role for local usage
* Role will have same permissions as the GSQL postgres role
create role nyatella with password 123;
alter role nyatella with CREATEDB;
grant all privileges on all tables in schema public,croissant to nyatella;
grant all privileges on all functions in schema public,croissant to nyatella;
grant all privileges on all sequences in schema public,croissant to nyatella;

# Setup role for toaster application
create role boomer with password 123;
grant all privileges on database burntoast;
alter role boomer set search_path = croissant;
alter role boomer with login;
grant usage on schema croissant to boomer;
grant select,insert,update,delete on all tables in schema croissant to boomer;
grant execute on all functions in schema croissant to boomer;
grant usage,select on all sequences in schema croissant to boomer;