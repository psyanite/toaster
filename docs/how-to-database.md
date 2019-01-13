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
* Run
* Replace `src/data/migrations/export.sql`
* Commit changes

### How to Materialized View

```postgresql
create materialized view if not exists store_search as
SELECT stores.id                                                                                     AS id,
       stores.name                                                                                   AS name,
       locations.name                                                                                AS location,
       suburbs.name                                                                                  AS suburb,
       cities.name                                                                                   AS city,
       stores.cover_image,
       store_addresses.address_first_line                                                            AS address_first_line,
       store_addresses.address_second_line                                                           AS address_second_line,
       store_addresses.address_street_number                                                         AS street_number,
       store_addresses.address_street_name                                                           AS street_name,
       (((setweight(to_tsvector('english'::regconfig, (stores.name)::text), 'A'::"char") ||
          setweight(to_tsvector('english'::regconfig, (COALESCE(locations.name, ''))::text), 'B'::"char")) ||
         setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'B'::"char")) ||
        setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'B'::"char") ||
        setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_first_line, ''))::text), 'B'::"char") ||
        setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_second_line, ''))::text), 'B'::"char") ||
        setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_name, ''))::text), 'B'::"char") ||
        setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_number, ''))::text), 'C'::"char")) AS document
FROM (((stores
  LEFT JOIN locations ON ((stores.location_id = locations.id)))
  JOIN suburbs ON ((stores.suburb_id = suburbs.id)))
  JOIN cities ON ((stores.city_id = cities.id)))
  JOIN store_addresses ON ((store_addresses.store_id = stores.id));

drop materialized view store_search;

select * from store_search;

CREATE index store_search_document_idx ON store_search USING gin(document);
```
