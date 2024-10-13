
Drop Table if exists [dbo].emp_manager 
create table emp_manager(emp_id int,emp_name varchar(50),salary int,manager_id int);
insert into emp_manager values(	1	,'Ankit',	10000	,4	);
insert into emp_manager values(	2	,'Mohit',	15000	,5	);
insert into emp_manager values(	3	,'Vikas',	10000	,4	);
insert into emp_manager values(	4	,'Rohit',	5000	,2	);
insert into emp_manager values(	5	,'Mudit',	12000	,6	);
insert into emp_manager values(	6	,'Agam',	12000	,2	);
insert into emp_manager values(	7	,'Sanjay',	9000	,2	);
insert into emp_manager values(	8	,'Ashish',	5000	,2	);

-- Solution 1

Select e.emp_id,e.emp_name,m.emp_name as ManagerName, e.salary,m.salary as manager_salary
from [dbo].emp_manager e
Inner Join [dbo].emp_manager m on e.manager_id = m.emp_id
where e.salary > m.salary


-- Solution 2 
SELECT emp_name
FROM [dbo].emp_manager  e
WHERE salary > (
    SELECT salary
    FROM emp_manager
    WHERE emp_id = e.manager_id
);     

-- Solution 3
with cte1 as(
select e.emp_id,e.emp_name,m.emp_name as manager_name,e.salary as emp_salary,m.salary as manager_salary
 from emp_manager e join emp_manager m on e.manager_id=m.emp_id
)
select * from cte1 where emp_salary>manager_salary



-- Wrong Output Join Condition
Select e.emp_id,e.emp_name,m.emp_name as ManagerName, e.salary,m.salary as manager_salary
from [dbo].emp_manager e
Inner Join [dbo].emp_manager m on e.emp_id = m.manager_id
where e.salary > m.salary


-- Problem Statement 

Drop table if exists #EmployeeT
create table #EmployeeT(
emp_id int,
emp_name varchar(20),
salary int,)

insert into #EmployeeT
values (1, 'Ram', 4500);
insert into #EmployeeT
values (3, 'Gopi', 17500);
insert into #EmployeeT
values (3, 'Shyam', 9500);
insert into #EmployeeT
values (4, 'Nisha', 13500);


create table #Salary_range(
From_sal int,
To_sal int,
Grade varchar(20),
)

insert into #Salary_range
values (0,5000,'A');
insert into #Salary_range
values (5001,10000,'B');
insert into #Salary_range
values (10001,15000,'C');
insert into #Salary_range
values (15001,20000,'D');


Select E.emp_name as 'Name',S.Grade from #EmployeeT E
Inner join #Salary_range S
on E.salary between S.From_Sal and S.To_Sal
