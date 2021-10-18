ALTER procedure [dbo].[update_airport]
as
begin


-- airport
insert into airport(id_total, total, id_state,state, state_source, id_city, city, city_source,
name, airport_source)
select distinct k.id_total, k.total, k.id_state,k.state, k.state_source, k.id_city, k.city, k.city_source,
kb.name,kb.id
from airport k join flights.dbo.airport as kb on k.city_source=kb.address_id
where kb.id not in (select airport_source from airport where airport_source is not null)
order by kb.name

update airport set id_airport=id where airport_source is not null


end

