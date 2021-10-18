ALTER PROCEDURE [dbo].[report_avg_age] 
	-- Add the parameters for the stored procedure here
	@name_state nvarchar(50)
AS
BEGIN
select avg(u.age) from reservations r join traveler u on r.id_traveler=u.id
join flight f on f.id = r.id_flight
join airport a on a.id = f.id_arrival_airport
where a.state = @name_state
END

