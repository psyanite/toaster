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
* Replace `src/scripts/export.sql`
* Commit changes

### How to Materialized View
```postgresql
refresh materialized view store_search;

drop materialized view store_search;

create materialized view store_search as
select stores.*,
       (((((((setweight(to_tsvector('english'::regconfig, unaccent(stores.name)), 'A'::"char") ||
              setweight(to_tsvector('english'::regconfig, (COALESCE(locations.name, ''::character varying))::text), 'B'::"char")) ||
             setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'B'::"char")) ||
            setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'B'::"char")) ||
           setweight(               to_tsvector('english'::regconfig,(COALESCE(store_addresses.address_first_line, ''::character varying))::text),'B'::"char")) ||
          setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_second_line, ''::character varying))::text), 'B'::"char")) ||
         setweight(to_tsvector('english'::regconfig, (COALESCE(store_addresses.address_street_name, ''::character varying))::text), 'B'::"char")) ||
         setweight(to_tsvector('english'::regconfig, unaccent(coalesce((string_agg(cuisines.name, ' ')), ''))), 'B'::"char") ||
        setweight(to_tsvector('english'::regconfig,(COALESCE(store_addresses.address_street_number, ''::character varying))::text),'C'::"char")) as document
from ((((stores
  left join locations on ((stores.location_id = locations.id)))
  join suburbs on ((stores.suburb_id = suburbs.id)))
  join cities on ((stores.city_id = cities.id)))
  left join store_cuisines on ((store_cuisines.store_id = stores.id))
  left join cuisines on ((store_cuisines.cuisine_id = cuisines.id))
 join store_addresses on ((store_addresses.store_id = stores.id)))
group by stores.id, locations.name, suburbs.name, cities.name, stores.cover_image, store_addresses.address_first_line, store_addresses.address_second_line, store_addresses.address_street_name, store_addresses.address_street_number;

create index store_search_document_idx
on store_search (document);

select * from store_search;

select *
from store_search
where document @@ to_tsquery('english', 'westfield')
order by ts_rank(document, to_tsquery('english', 'westfield')) desc;
```
