/* write a sql to find business day between create date and resolved date by excluding
weeknd and public holidays 

--2022-08-01   -> Monday ,    --2022-08-03  -> Wednesday
--2022-08-01   -> Monday ,    --2022-08-12  -> Friday
--2022-08-01   -> Monday ,    --2022-08-16  -> Tuesday */



drop table if exists #tickets
create table #tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from #tickets;
insert into #tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');



drop table if exists #holidays
create table #holidays
(
holiday_date date
,reason varchar(100)
);
delete from #holidays;
insert into #holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day'),
('2022-08-14','Pak Independence day');


Select * from #holidays
Select * from #tickets

-- 1 week = 2 Holiday

-- Step 1
Select *,
datediff(day,create_date,resolved_date) as actual_days,--DATEPART(week,create_date),DATEPART(week,resolved_date),
datediff(week,create_date,resolved_date) as week_diff,
datediff(day,create_date,resolved_date)-2*datediff(week,create_date,resolved_date) as business_days
from #tickets

-- Step 2
Select *,
datediff(day,create_date,resolved_date)-2*datediff(week,create_date,resolved_date) - No_of_Holiday
as Business_days
from (
Select ticket_id, create_date,resolved_date,count(holiday_date) as No_of_Holiday
from #tickets t
left join #holidays  h on holiday_date between create_date and resolved_date
Group by ticket_id, create_date,resolved_date ) t


-- handling  holiday on weekend 
Select *,
datediff(day,create_date,resolved_date)-2*datediff(week,create_date,resolved_date) - No_of_Holiday
as Business_days from (
Select ticket_id, create_date,resolved_date,
count(case when datename(dw,holiday_date) not in ('Sunday')  then 1 end ) as No_of_Holiday
from #tickets t
left join #holidays  h on holiday_date between create_date and resolved_date
Group by ticket_id, create_date,resolved_date ) t



---


;
WITH cte as (
select * 
from #tickets as t LEFT JOIN #holidays as h
on h.holiday_date BETWEEN t.create_date AND t.resolved_date )

select *
, DATEDIFF(DAY,create_date,resolved_date) - 2*DATEDIFF(WEEK,create_date,resolved_date) 
- COUNT(reason) over(partition by ticket_id order by ticket_id) as  NOOFBUSINESSDAYS
from cte