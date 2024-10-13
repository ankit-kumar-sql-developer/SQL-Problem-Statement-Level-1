
/*
select cast('2000-01-01' as date) as cal_date
,datepart(year,'2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name
*/

Drop table if exists dbo.calendar_dim

-- Recursive cte

;with cte as (
select cast('2000-01-01' as date) as cal_date
,datepart(year,'2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name
union all
select Dateadd(day,1,cal_date)  as cal_date,
datepart(year,Dateadd(day,1,cal_date)) as cal_year,
datepart(dayofyear,Dateadd(day,1,cal_date)) as cal_year_day
,datepart(quarter,Dateadd(day,1,cal_date)) as cal_quarter
,datepart(month,Dateadd(day,1,cal_date)) as cal_month
,datename(month,Dateadd(day,1,cal_date)) as cal_month_name
,datepart(day,Dateadd(day,1,cal_date)) as cal_month_day
,datepart(week,Dateadd(day,1,cal_date)) as cal_week
,datepart(weekday,Dateadd(day,1,cal_date)) as cal_week_day
,datename(weekday,Dateadd(day,1,cal_date)) as cal_day_name
from cte
where cal_date < cast('2050-12-31' as date )
)

select *,row_number() over ( order by cal_date asc) as rn
into dbo.calendar_dim from cte  option(MAXRECURSION 32676)


select * from dbo.calendar_dim










-- Recursive cte

;with cte as (
select 1 as id
union all
select id +1 as id
from cte
where id<1000 )

select * from cte option(MAXRECURSION 32676)