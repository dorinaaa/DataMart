ALTER PROCEDURE [dbo].[report_classes] 
	-- Add the parameters for the stored procedure here
	@name_klasi nvarchar(50)
AS
BEGIN

select s.airline_name, count(*) as reservations 
from reservations r join seat s on r.id_seat = s.id
where s.class_name = @name_klasi
group by s.airline_name
order by reservations desc

END

