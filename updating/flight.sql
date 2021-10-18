ALTER procedure [dbo].[update_flight]
as
begin


select * from flights.dbo.schedules order by id desc


-- schedule
insert into flight(id_total,total, departure_time, arrival_time, schedule_source)
select u.id_total, u.total, schedules.departure_time, schedules.arrival_time, schedules.id
from (select * from flight where id_schedule is null and id_type is null) u cross join
	(select distinct o.id, o.departure_time,o.arrival_time,o.departure_airport, o.arrival_airport from 
		flights.dbo.schedules o 
		where o.id not in (select schedule_source from flight where schedule_source is not null)) as schedules
order by schedules.departure_time

update flight set id_schedule=id where id_schedule is null and schedule_source is not null

--airports
update flight set id_departure_airport = 
(select a.id from airport a where a.airport_source = (select departure_airport from
flights.dbo.schedules o where o.id = flight.schedule_source))

update flight set id_arrival_airport = 
(select a.id from airport a where a.airport_source = (select arrival_airport from
flights.dbo.schedules o where o.id = flight.schedule_source))


-- flight
insert into flight(id_total, total, id_schedule, departure_time, arrival_time, schedule_source, id_departure_airport, id_arrival_airport,
id_type, type, type_source, flight_source)
select distinct k.id_total, k.total,schedule.id_schedule, schedule.departure_time,
schedule.arrival_time, schedule.schedule_source, schedule.id_departure_airport, schedule.id_arrival_airport,
k.id_type, k.type, k.type_source,
fb.id
from flights.dbo.flight as fb
join flight as k on fb.tip_id=k.type_source
join flight as schedule on fb.schedule_id=schedule.schedule_source
where fb.id not in (select flight_source from flight where flight_source is not null)

update flight set id_flight=id where flight_source is not null

end
