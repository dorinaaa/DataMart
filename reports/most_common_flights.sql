ALTER PROCEDURE [dbo].[report_most_common_flights]
	-- Add the parameters for the stored procedure here
	@airline nvarchar(50)
AS
BEGIN
select departure.state, arrival.state, count(*) as trips from reservations r join flight f on r.id_flight = f.id
join seat s on r.id_seat = s.id
join airport departure on departure.id = f.id_departure_airport
join airport arrival on arrival.id = f.id_arrival_airport
where s.airline_name = @airline
group by departure.state, arrival.state
order by trips desc

END
