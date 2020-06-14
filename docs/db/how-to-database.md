### Get Started
* Go to [GCP](https://console.cloud.google.com/sql/instances/knob/connections?project=burntoast)
* Click on 'Connections'
* Click on 'Create a client certificate'
* Download the certificates and save them into toaster/secrets
* Under 'Connectivity' click on 'Add network' and add your ip address

### How to connect via Datagrip
* Host: ???
* User: ???
* Database: ???
* Under SSH/SSL tab
* Set the 3 files
* Set Mode to Verify CA

### How to connect via psql
```
psql "sslmode=verify-ca sslrootcert=knob-server-ca.pem \
      sslcert=knob-client-cert.pem sslkey=knob-client-key.pem \
      hostaddr=??? \
      port=5432 \
      user=??? dbname=???"
```



# Setup

## 1. Create database
* Go to [GCP](https://console.cloud.google.com/sql/instances/knob/connections?project=burntoast)
* Create database in Australia

## 2. Hydrate
* Connect to database via Datagrip
* Run
```
create extension cube;
create extension earthdistance;
create extension unaccent;
```
* pg_dump local database into meow.sql
* Prepend script with `create schema croissant;`;
* Replace instances of `public` with `croissant`;
* Replace `croissant.unaccent` with `public.unaccent`;
* Upload meow.sql into Google Bucket
* Run `gcloud sql import sql knob gs://burntoast-fix.appspot.com/meow.sql --database=postgres`
* If there is a permission error, click on 'Import' on the SQL Overview page and use that

## 3. Create users
* Click on 'Users'
* Add `toaster`, `toaster-nyatella`, and `nyatella`
* Connect to database via Datagrip
alter role toaster set search_path to croissant, public;
alter role nyatella set search_path to croissant, public;
alter role "toaster-nyatella" set search_path to croissant, public;
alter materialized view location_search owner to toaster;
alter materialized view cuisine_search owner to toaster;
alter materialized view reward_search owner to toaster;
alter materialized view store_search owner to toaster;

## 4. Update .env and app.yaml
* Update `.env` and `app.yaml`


### How to export local database
Open CMD
cd Desktop
pg_dump -U postgres --format=plain --no-owner --no-acl -v --schema=croissant burntoast > export.sql













### How to export the database
* Open DataGrip
* Right-click database
* Dump with `pg_dump`
* Path to pg_dump: `C:/Program Files/PostgreSQL/pg10/bin/pg_dump.exe`
* Statements: Copy (*This is super mega importante*)
* Database: burntoast
* Schemas: <empty>
* Tables: <empty>
* Format: File
* Uncheck Clean Database, Add "IF EXISTS", Create database, and Data only
* Out path: `C:/Desktop/export.sql`
* Add params to the box: `--no-owner --format=plain --no-acl`
* Run
* cd ~/Desktop
* sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' export.sql > export2.sql
* Replace `src/scripts/export.sql`
* Commit changes

Export database
```
pg_dump -U [USERNAME] --format=plain --no-owner --no-acl [DATABASE-NAME]  \
    | sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' > [SQL_FILE].sql
```

Export only schema
```
pg_dump -U [USERNAME] --format=plain --no-owner --no-acl --schema=[SCHEMA-NAME] [DATABASE-NAME] \
    | sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' > [SQL_FILE].sql
```

Example
```
pg_dump -U postgres --format=plain --no-owner --no-acl -v --schema=croissant burntoast \
    | sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' > export.sql
```



### How to connect to the database via Datagrip
* Visit [Heroku](https://data.heroku.com/datastores/08663315-9dc4-4d18-81ba-827e25eb4ebf#administration)
* Host: `ec2-54-163-237-249.compute-1.amazonaws.com`
* Database: `d1dugrvvqelvff`
* Port: `5432`
* User: `sikvdmrgyocaly`
* Password: Check the website
* Go to the Advanced tab
* ssl: `true`
* sslfactory: `org.postgresql.ssl.NonValidatingFactory`
