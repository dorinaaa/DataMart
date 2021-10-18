ALTER PROCEDURE [dbo].[report_less_favorite_destinations] 
	-- Add the parameters for the stored procedure here
	@month int
AS
BEGIN
select a.state, count(*) as reservations from reservations r join flight f on r.id_flight=f.id
join airport a on a.id = f.id_arrival_airport
join time k on k.id = r.id_time
where k.month = @month
group by a.state
order by reservations
END

Destinacionet dhe linet me te lira nga state:
ALTER PROCEDURE [dbo].[report_cheapest_destinations_and_airline]
	-- Add the parameters for the stored procedure here
	@state nvarchar(50)
AS
BEGIN
select distinct arrival.state, s.airline_name,  r.price from reservations r join flight f on r.id_flight = f.id
join seat s on r.id_seat = s.id
join airport departure on departure.id = f.id_departure_airport
join airport arrival on arrival.id = f.id_arrival_airport
where departure.state = @state
order by r.price
END
