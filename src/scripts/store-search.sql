drop materialized view if exists store_search;

create materialized view store_search as
select stores.*,
  (
      setweight(to_tsvector('english'::regconfig, unaccent(stores.name)), 'a'::"char") ||
      setweight(to_tsvector('english'::regconfig, (coalesce(locations.name, ''::character varying))::text), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (suburbs.name)::text), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (cities.name)::text), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (coalesce(store_addresses.address_first_line, ''::character varying))::text),'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (coalesce(store_addresses.address_second_line, ''::character varying))::text), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (coalesce(store_addresses.address_street_name, ''::character varying))::text), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, unaccent(coalesce((string_agg(cuisines.name, ' ')), ''))), 'b'::"char") ||
      setweight(to_tsvector('english'::regconfig, (coalesce(store_addresses.address_street_number, ''::character varying))::text),'c'::"char")
    ) as document
from ((((stores
left join locations on ((stores.location_id = locations.id)))
join suburbs on ((stores.suburb_id = suburbs.id)))
join cities on ((stores.city_id = cities.id)))
left join store_cuisines on ((store_cuisines.store_id = stores.id))
left join cuisines on ((store_cuisines.cuisine_id = cuisines.id))
join store_addresses on ((store_addresses.store_id = stores.id)))
group by stores.id, locations.name, suburbs.name, cities.name, stores.cover_image, store_addresses.address_first_line, store_addresses.address_second_line, store_addresses.address_street_name, store_addresses.address_street_number;

create index store_search_document_idx on store_search (document);

refresh materialized view store_search;

select * from store_search;

select * from store_search
where document @@ plainto_tsquery('english', 'westfield')
order by ts_rank(document, plainto_tsquery('english', 'westfield')) desc;
