/*
The stored procedure sp_create_calendar_dim_table is 
to generate a calendar dimension table (cal_dim_new) containing a range of dates between the specified start and end dates
as parameters.
*/

-- Creation of Sp : sp_create_calender_dim_table
CREATE PROCEDURE sp_create_calender_dim_table
	@start_date date,
	@end_date date
as
BEGIN
	with recursive_cte as (
		Select @start_date as cal_date

		union all

		Select dateadd(dd,1,cal_date) as cal_date
		from recursive_cte
		where cal_date < @end_date
	)
	Select row_number() over(order by (select null)) as id, cal_date,
	datepart(year,cal_date) as cal_year,
	datepart(dayofyear,cal_date) as cal_year_day,
	datepart(quarter,cal_date) as cal_quarter, 
	datepart(month,cal_date) as cal_month,
	datename(month,cal_date) as cal_month_name,
	datepart(day,cal_date) as cal_month_day,
	datepart(week,cal_date) as cal_week,
	datepart(weekday,cal_date) as cal_week_day,
	datename(weekday,cal_date) as cal_day_name
	into cal_dim_new
	from recursive_cte 
	option (maxrecursion 0)
END;

-- Execute Sp : sp_create_calender_dim_table
EXEC sp_create_calender_dim_table @start_date = '2000-01-01', @end_date = '2050-12-31' 

-- Check the cal_dim_new table
Select * from cal_dim_new


-----
;with recursive_cte as (
		select cast('2000-01-01' as date) as cal_date
        union all
		Select dateadd(dd,1,cal_date) as cal_date
		from recursive_cte
		where cal_date < cast('2050-12-31' as date ) )
Select * from  recursive_cte 	option (maxrecursion 0)
