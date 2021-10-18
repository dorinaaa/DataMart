ALTER procedure [dbo].[update_seat]
as
begin

-- airline
insert into seat(id_total,total, airline_name, airline_source)
select s.id_total, s.total, line.name, line.id
from (select * from seat where id_airline is null and id_plane is null and id_class is null) s cross join
	(select distinct la.name, la.id from flights.dbo.seat s
	join flights.dbo.plane a on a.id = s.plane_id
	join flights.dbo.airline la on la.id = a.id) as line
where line.id not in (select airline_source from seat where airline_source is not null)
order by line.name

update seat set id_airline=id where airline_source is not null and id_airline is null

-- plane
insert into seat(id_total,total, id_airline, airline_name, airline_source, plane_source)
select s.id_total, s.total, s.id_airline, s.airline_name, s.airline_source,
planes.id
from seat s join
	(select distinct a.id, la.id as la_id, la.name as la_name from 
		flights.dbo.plane a 
		join flights.dbo.airline la on la.id = a.airline_id ) as planes
	on s.airline_source=planes.la_id
	where planes.id not in (select plane_source from seat where plane_source is not null)
order by planes.la_name


update seat set id_plane=id where plane_source is not null and id_plane is null

-- seat
insert into seat(id_total,total, id_airline, airline_name, airline_source, id_plane, plane_source,
id_class, class_name,class_source, number, seat_source)
select distinct k.id_total,k.total, plane.id_airline, plane.airline_name, plane.airline_source,
plane.id_plane, plane.plane_source,
k.id_class, k.class_name,k.class_source, sb.number, sb.id
from flights.dbo.seat as sb
join seat as k on sb.class_id=k.class_source
join seat as plane on sb.plane_id=plane.plane_source
where sb.id not in (select seat_source from seat where seat_source is not null)

update seat set id_seat=id where seat_source is not null

end
