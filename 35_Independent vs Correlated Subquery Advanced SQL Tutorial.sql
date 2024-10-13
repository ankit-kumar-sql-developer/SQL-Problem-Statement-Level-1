

--independent vs correlated sub queries
--why do we need sub queries
--independent sub queries
--correlated sub queries
/*
we need subqueries: when the required format of the data is not given/not available, 
then we need to derive it and the join it back with the main data.
Independent Subquery - 1. it can be run independently 2. it runs only once
Correlated Subquery - 1. It cannot run independently because it has the reference of the main query
2. it runs for every record of the main query
*/
drop table if exists #emp
create table #emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

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
values (10, 'Rakesh',300,7000,6,50);

select * from  #emp 

-- To print employee details who's salary is more than their department average salary
/*
Independent SubQuery -- Run independently , Run once
works as virtual table*/
select e.* from #emp e
inner join (
Select department_id,avg(salary) as sal
from #emp group by department_id ) d -- Independent SubQuery
on e.department_id = d.department_id
where e.salary > d.sal 

-- Co-related sub query
--In inner query there is refrence of outer query for each record of outer query inner query will run
-- Can not run independently
select * from #emp e1
where salary > ( select avg(e2.salary) from #emp e2 where e1.department_id=e2.department_id)


-- Alternative 1
select * from
(select *, avg(salary) over(partition by department_id ) as avg_dep_sal
from #emp) e
where e.avg_dep_sal < e.salary