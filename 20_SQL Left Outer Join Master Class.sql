
-- Left Join + where clause = Inner Join 

drop table if exists #emp
create table #emp(
emp_id int,
emp_name varchar(20),
dep_id int,
salary int,
manager_id int,
emp_age int);

delete from #emp;
insert into #emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into #emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into #emp
values (3, 'Vikas', 100, 10000,4,37);
insert into #emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into #emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into #emp
values (6, 'Agam', 200, 12000,2, 14);
insert into #emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into #emp
values (8, 'Ashish', 200,5000,2,12);
insert into #emp
values (9, 'Mukesh',300,6000,6,51);
insert into #emp
values (10, 'Rakesh',500,7000,6,50);

create table #dept(
dep_id int,
dep_name varchar(20));

INSERT INTO #dept VALUES (100,'Analytics'),(200,'IT'),(300,'HR'),(400,'Text Analytics');


Select * from #emp
Select * from #dept


-- Diffrence Between 2 Queries

-- Query 1
Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id and d.dep_name='Analytics';


Select * from #emp
left join ( select * from #dept where #dept.dep_name='Analytics') dept ON
dept.dep_id = #emp.dep_id

/*Only d.dep_name='Analytics' else all values be null for dep_name
Join is happening like #emp and #dept with d.dep_name='Analytics';
First Filter is applicable then Join happening
Select * from #emp 
LEFT JOIN
Select * from #dept where d.dep_name='Analytics'
*/

Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id and d.dep_name='Text Analytics';
/*all values be null for dep_name as dep_name=400 is in right table*/

-- Query 2

-- Below 2 query will give same result 
Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id 
Where dep_name='Analytics';

Select * from #emp e
inner join #dept d  on e.dep_id = d.dep_id 
Where dep_name='Analytics';      

/*Only d.dep_name='Analytics' will be shown due to filter conditon
First Join happening then Where filter will be applicable

Avoid putting filter on right column with left join -- inner join  will do work for you
*/

-- Left Join  filter on Right table
Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id 
where d.dep_id is null

-- Left Join  filter on Left table

Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id and e.salary=10000

Select * from #emp e
left join #dept d  on e.dep_id = d.dep_id 
where e.salary=10000

/*
Only salary with 10000 is getting joined
Right way to put filter on where condition
*/


-- Problem Statment 1
-- Result is same but function is diffrent 
SELECT * FROM #emp INNER JOIN #dept on #emp.dep_id=#dept.dep_id WHERE #emp.salary=10000 
AND #dept.dep_name = 'Analytics'

SELECT * FROM #emp LEFT JOIN #dept on #emp.dep_id=#dept.dep_id AND #dept.dep_name = 'Analytics' 
WHERE #emp.salary=10000