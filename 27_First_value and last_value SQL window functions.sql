

create table #employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);

insert into #employee values(1,'Ankit',100,10000,4,39);
insert into #employee values(2,'Mohit',100,15000,5,48);
insert into #employee values(3,'Vikas',100,10000,4,37);
insert into #employee values(4,'Rohit',100,5000,2,16);
insert into #employee values(5,'Mudit',200,12000,6,55);
insert into #employee values(6,'Agam',200,12000,2,14);
insert into #employee values(7,'Sanjay',200,9000,2,13);
insert into #employee values(8,'Ashish',200,5000,2,12);
insert into #employee values(9,'Mukesh',300,6000,6,51);
insert into #employee values(10,'Rakesh',500,7000,6,50);

Select * from #employee

-- First value 
Select *,FIRST_VALUE(emp_name) over (order by salary) as lowest_sale_emp
from #employee

Select *,FIRST_VALUE(salary) over (order by salary) as lowest_sale_emp
from #employee

Select *,FIRST_VALUE(emp_name) over (order by emp_age) as lowest_sale_emp
from #employee  -- Ashish

Select *,FIRST_VALUE(emp_name) over (partition by dept_id order by emp_age) as lowest_sale_emp
from #employee

Select *,FIRST_VALUE(emp_name) over (partition by dept_id order by emp_age desc) as lowest_sale_emp
from #employee


-- last value

Select *,Last_VALUE(emp_name) over (order by emp_age) as lowest_sale_emp
from #employee  -- row by row calculation thats why result diffrent


Select *,Last_VALUE(emp_name) over (partition by dept_id order by emp_age) as lowest_sale_emp
from #employee -- same result

-- correct output

Select *,Last_VALUE(emp_name) 
over (order by emp_age rows between current row and unbounded following) as lowest_sale_emp
from #employee

Select *,Last_VALUE(emp_name) 
over(partition by dept_id order by emp_age rows between current row and unbounded following) as lowest_sale_emp
from #employee


-- Incase of using Last value use First value and reverse sorting 