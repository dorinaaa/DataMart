ALTER procedure [dbo].[initial_seat]
as
begin
--total level
insert into seat (total) values ('All seats')
update seat set id_total=1


--airline level
insert into seat(id_total,total, airline_name, airline_source)
select s.id_total, s.total, line.name, line.id
from seat s cross join
	(select distinct la.name, la.id from flights.dbo.seat s
	join flights.dbo.plane a on a.id = s.plane_id
	join flights.dbo.airline la on la.id = a.id) as line
order by line.name

update seat set id_airline=id where airline_source is not null


-- plane level
insert into seat(id_total,total, id_airline, airline_name, airline_source, plane_source)
select s.id_total, s.total, s.id_airline, s.airline_name, s.airline_source,
planes.id
from seat s join
	(select distinct a.id, la.id as la_id, la.name as la_name from 
		flights.dbo.plane a 
		join flights.dbo.airline la on la.id = a.airline_id ) as planes
	on s.airline_source=planes.la_id
order by planes.la_name


update seat set id_plane=id where plane_source is not null

select * from seat

--class level
insert into seat(id_total, total, class_name,class_source)
select s.id_total, s.total, k.name, k.id
from (select * from seat where id_airline is null) s
cross join flights.dbo.class as k

update seat set id_class=id where class_source is not null


-- seat level
insert into seat(id_total,total, id_airline, airline_name, airline_source, id_plane, plane_source,
id_class, class_name,class_source, number, seat_source)
select k.id_total,k.total, plane.id_airline, plane.airline_name, plane.airline_source,
plane.id_plane, plane.plane_source,
k.id_class, k.class_name,k.class_source, sb.number, sb.id
from flights.dbo.seat as sb
join seat as k on sb.class_id=k.class_source
join seat as plane on sb.plane_id=plane.plane_source

update seat set id_seat=id where seat_source is not null

end
