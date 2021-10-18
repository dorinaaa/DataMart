ALTER procedure [dbo].[initial_traveler]
as
begin
--total level
insert into traveler (total) values ('All travelers)
update traveler set id_total=id

-- state level
insert into traveler(id_total,total, state, state_source)
select u.id_total, u.total, states.name, states.id
from traveler u cross join
	(select distinct sh.name, sh.id from 
		flights.dbo.state sh ) as states
order by states.name

update traveler set id_state=id where state is not null

-- city level
insert into traveler(id_total,total,id_state,state,state_source,city, city_source)
select k.id_total, k.total, k.id_state, k.state, k.state_source, cities.city, cities.id
from traveler k join 
(select distinct sh.state_id, sh.city, sh.id from 
		flights.dbo.address sh) as cities
	on k.state_source=cities.state_id
order by k.state

update traveler set id_city=id where city is not null


-- traveler level
insert into traveler(id_total, total, id_state,state, state_source, id_city, city, city_source,
name, last_name,age, traveler_source)
select k.id_total, k.total, k.id_state,k.state, k.state_source, k.id_city, k.city, k.city_source,
kb.name,kb.last_name,kb.age,kb.id
from traveler k join flights.dbo.traveler as kb on k.city_source=kb.address_id
order by kb.name

update traveler set id_traveler=id where traveler_source is not null


end
