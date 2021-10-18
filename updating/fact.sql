ALTER procedure [dbo].[update_reservations]
as
begin
insert into reservations(id_time, id_traveler, id_flight, id_seat, price)
select kh.id, u.id, f.id, s.id, SUM(fd.price)
from flights.dbo.reservation r 
	join flights.dbo.flight_details fd on r.flight_details_id = fd.id
	join traveler u on u.traveler_source=r.traveler_id
	join flight f on f.flight_source=fd.flight_id
	join seat s on s.seat_source=fd.seat_id
	join time kh on kh.year=year(r.time_reservationit) and kh.month=month(r.time_reservationit)
	where
	kh.id not in (select id_time from reservations) 
	or u.id not in (select id_traveler from reservations)
	or f.id not in (select id_flight from reservations)
	or s.id not in (select id_seat from reservations)
group by u.id,f.id,s.id,kh.id
end
