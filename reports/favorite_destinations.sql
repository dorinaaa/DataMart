ALTER PROCEDURE [dbo].[report_favorite_destinations]
AS
BEGIN

select state from airport a join (select f.id_arrival_airport as id, count(*) as c from reservations r join flight f on r.id_flight=f.id
join airport a on a.id = f.id_arrival_airport
group by f.id_arrival_airport) as destinations
on a.id=destinations.id
order by destinations.c desc;

END
