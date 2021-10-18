ALTER procedure [dbo].[initial_time]
as
begin

--total level
insert into time(Total) values ('Total time')
update time set id_total=id

-- year level
declare @year int
set @year=2009
while @year<=2020
begin
insert into time(id_total,Total,year)
select id_total,total,@year from time where year is null

set @year=@year+1
end

update time set id_year=id where year is not null

--month level

declare @month int

set @year=2009
while @year<=2020
begin
	set @month=1
	while @month<=12
	begin
		insert into time(year,month,month_description)
		values (@year,@month,'month '+cast(@month as nvarchar))
		set @month=@month+1
	end
	set @year=@year+1
end

update month
set 
	month.id_total=year.id_total,
	month.Total=year.Total,
	month.id_year=year.id_year,
	month.id_month=month.id
from time as month join time as year
on (month.year=year.year and month.month is not null and year.month is null)
end
