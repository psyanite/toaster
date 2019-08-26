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

#### store_search
```postgresql
refresh materialized view store_search;

drop materialized view store_search;

create materialized view store_search as
select stores.id,
       stores.name,
       stores.phone_country,
       stores.phone_number,
       stores.location_id,
       stores.suburb_id,
       stores.city_id,
       stores.cover_image,
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


### rewards_search
```postgresql
create materialized view rewards_search as
SELECT rewards.id,
(
       setweight(to_tsvector('english'::regconfig, unaccent((rewards.name)::text)), 'A'::"char") ||
       setweight(to_tsvector('english'::regconfig, (coalesce(rewards.tags, ''::character varying))::text), 'A'::"char") ||
       setweight(to_tsvector('english'::regconfig, (coalesce(s.name, ''::character varying))::text), 'B'::"char") ||
       setweight(to_tsvector('english'::regconfig, (coalesce(sg.name, ''::character varying))::text), 'B'::"char")
) AS document
FROM rewards
    LEFT JOIN stores s on rewards.store_id = s.id
    LEFT JOIN store_groups sg on rewards.store_group_id = sg.id;
```


### city_locations
```postgresql
create materialized view city_locations as
select
  id,
  name,
  array_append(array_cat(suburbs, locations), name) as locations
from
    (select
    c.id,
    c.name,
    array_agg(distinct s.name) as suburbs,
    array_agg(distinct l.name) as locations
from (
    cities c
        join suburbs s on c.id = s.city_id
        join locations l on s.id = l.suburb_id
)
group by c.id) as view;

drop materialized view city_locations;
select * from city_locations;
create index city_locations_document_idx on city_locations (document);
```

### cuisine_search
```postgresql
create materialized view cuisine_search as
select 
  name,
  to_tsvector('english'::regconfig, unaccent(name)::text) as document
from cuisines;

select * from cuisine_search;
drop materialized view cuisine_search;
create index cuisines_search_document_idx on cuisine_search (document);
```

### location_search
```postgresql
create materialized view location_search as
select
    name,
    description,
    to_tsvector('english'::regconfig, unaccent(name)::text) as document
from (
   select c.name, d.name as description from cities c left join districts d on c.district_id = d.id
   union
   select s.name, c.name as description from suburbs s left join cities c on s.city_id = c.id
   union
   select l.name, concat_ws(', ',s.name,c.name) as description from locations l left join suburbs s on l.suburb_id = s.id left join cities c on s.city_id = c.id
) as view;

drop materialized view location_search;
select * from location_search;
create index location_search_document_idx on location_search (document);
```

### store_ratings_cache
```postgresql
select s.id,
       sum(case when r.overall_score = 'good' then 1 else 0 end) as hearts,
       sum(case when r.overall_score = 'okay' then 1 else 0 end) as okays,
       sum(case when r.overall_score = 'bad' then 1 else 0 end)  as burnts
from stores s
         left join posts p on p.store_id = s.id
         left join post_reviews r on r.post_id = p.id
group by s.id;
```
