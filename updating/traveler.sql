ALTER procedure [dbo].[update_traveler]
as
begin

-- traveler
insert into traveler(id_total, total, id_state,state, state_source, id_city, city, city_source,
name, last_name,age, traveler_source)
select distinct k.id_total, k.total, k.id_state,k.state, k.state_source, k.id_city, k.city, k.city_source,
kb.name,kb.last_name,kb.age,kb.id
from traveler k join flights.dbo.traveler as kb on k.city_source=kb.address_id
where kb.id not in (select traveler_source from traveler where traveler_source is not null)
order by kb.name

update traveler set id_traveler=id where traveler_source is not null 


end
