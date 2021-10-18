ALTER procedure [dbo].[initial_flight]
as
begin
--total level
insert into flight (total) values ('All flights)
update flight set id_total=id
--DBCC CHECKIDENT ('flight', RESEED, 0)

--schedule level
insert into flight(id_total,total, departure_time, arrival_time, schedule_source)
select u.id_total, u.total, schedules.departure_time, schedules.arrival_time, schedules.id
from flight u cross join
	(select distinct o.id, o.departure_time,o.arrival_time,o.departure_airport, o.arrival_airport  from 
		flights.dbo.schedules o) as schedules
order by schedules.departure_time

update flight set id_schedule=id where schedule_source is not null

update flight set id_departure_airport = 
(select a.id from airport a where a.airport_source = (select departure_airport from
flights.dbo.schedules o where o.id = flight.schedule_source))

update flight set id_arrival_airport = 
(select a.id from airport a where a.airport_source = (select arrival_airport from
flights.dbo.schedules o where o.id = flight.schedule_source))


--test the above query
--select f.schedule_source, f.id_departure_airport, a.airport_source, o.departure_airport from flight f 
--join airport a on a.id=f.id_departure_airport 
--join flights.dbo.schedules o on o.id = f.schedule_source

--type level
insert into flight(id_total, total, type,type_source)
select f.id_total, f.total, t.name, t.id
from (select * from flight where id_schedule is null) f
cross join flights.dbo.types as t 

update flight set id_type=id where type_source is not null

-- flight level
insert into flight(id_total, total, id_schedule, departure_time, arrival_time, schedule_source, id_departure_airport, id_arrival_airport,
id_type, type, type_source, flight_source)
select k.id_total, k.total,schedule.id_schedule, schedule.departure_time,
schedule.arrival_time, schedule.schedule_source, schedule.id_departure_airport, schedule.id_arrival_airport,
k.id_type, k.type, k.type_source,
fb.id
from flights.dbo.flight as fb
join flight as k on fb.tip_id=k.type_source
join flight as schedule on fb.schedule_id=schedule.schedule_source

update flight set id_flight=id where flight_source is not null

end
