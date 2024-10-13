

Select * from dbo.emp -- 12 records

select count(*) from dbo.emp -- 12 (All record)
select count(1) from dbo.emp -- 12
select count(1),count(0),count(-1),count('Ankit') from dbo.emp -- 12
select count(dep_name) from dbo.emp -- 6 ( exclude null values)
select count(distinct dep_name) from dbo.emp -- 2 ( exclude null & duplicate values)
