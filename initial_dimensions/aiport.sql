ALTER procedure [dbo].[initial_airport]
as
begin
--total level
insert into airport (total) values ('All airports')
update airport set id_total=id


--state level
insert into airport(id_total,total, state, state_source)
select u.id_total, u.total, states.name, states.id
from airport u cross join
	(select distinct sh.name, sh.id from 
		flights.dbo.state sh ) as states
order by states.name

update airport set id_state=id where state_source is not null

--city level
insert into airport(id_total,total,id_state,state,state_source,city, city_source)
select k.id_total, k.total, k.id_state, k.state, k.state_source, cities.city, cities.id
from airport k join 
(select distinct sh.state_id, sh.city, sh.id from 
		flights.dbo.address sh) as cities
	on k.state_source=cities.state_id
order by k.state

update airport set id_city=id where city_source is not null


--airport level
insert into airport(id_total, total, id_state,state, state_source, id_city, city, city_source,
name, airport_source)
select k.id_total, k.total, k.id_state,k.state, k.state_source, k.id_city, k.city, k.city_source,
kb.name,kb.id
from airport k join flights.dbo.airport as kb on k.city_source=kb.address_id
order by kb.name

update airport set id_airport=id where airport_source is not null


end
