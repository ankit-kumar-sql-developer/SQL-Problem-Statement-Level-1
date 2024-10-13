
Drop Table If exists [dbo].emp
create table [dbo].emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into [dbo].emp
values
(1, 'Ankit', 100,10000, 4, 39) ;
insert into [dbo].emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into [dbo].emp
values (3, 'Vikas', 100, 10000,4,37);
insert into [dbo].emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into [dbo].emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into [dbo].emp
values (6, 'Agam', 200, 12000,2, 14);
insert into [dbo].emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into [dbo].emp
values (8, 'Ashish', 200,5000,2,12);
insert into [dbo].emp
values (9, 'Mukesh',300,6000,6,51);
insert into [dbo].emp
values (10, 'Rakesh',300,7000,6,50);
insert into [dbo].emp
values (1, 'Shaan',900,12000,6,50);

Drop Table if exists [dbo].emp1
Select * into [dbo].emp1 FROM [dbo].emp 


Drop table if exists [dbo].department
create table [dbo].department(
 
 dept_id int,
 dept_name varchar(10)
 );
 
insert into [dbo].department values(100,'Analytics');
insert into [dbo].department values(300,'IT');

Select * FROM [dbo].department

Drop table if exists [dbo].orders
create table [dbo].orders(
 customer_name char(10),
 order_date date,
 order_amount int,
 customer_gender char(6)
 );
 
 insert into [dbo].orders values('Shilpa','2020-01-01',10000,'Male');
 insert into [dbo].orders values('Rahul','2020-01-02',12000,'Female');
 insert into [dbo].orders values('SHILPA','2020-01-02',12000,'Male');
 insert into [dbo].orders values('Rohit','2020-01-03',15000,'Female');
 insert into [dbo].orders values('shilpa','2020-01-03',14000,'Male');



--Q1 - How to find duplicates in a given table

Select emp_id,Count(1) as CountofEmp
FROM [dbo].emp group by emp_id  having count(1) > 1

--Q2 -> How to delete duplicates

--Select *, row_number() over ( order by emp_id ) FROM [dbo].emp

;with cte as (
Select *, row_number() over ( partition by emp_id order by emp_id ) as rn
FROM [dbo].emp )

Delete from cte where rn > 1

Select * FROM [dbo].emp  -- Row 11 deleted


--Q3 -> difference between union and union all

Select manager_id FROM [dbo].emp
Union all
Select manager_id FROM [dbo].emp1


Select manager_id FROM [dbo].emp
Union 
Select manager_id FROM [dbo].emp1   -- Remove Duplicate


--Q5 -> employees who are not present in department table

Select * FROM [dbo].emp where department_id not in  ( Select dept_id from [dbo].department);

Select e.*,d.*
From [dbo].emp  e 
Left Join [dbo].department d on e.department_id = d.dept_id
where d.dept_id is null


--Q6 > second highest salary in each dep

;with cte as (
Select *,dense_rank() over (partition by department_id order by salary desc) as rn
FROM [dbo].emp )

Select * from cte where rn = 2

--Q7 -> find all transaction done by Shilpa

Select * from [dbo].orders where customer_name = 'Shilpa'
Select * from [dbo].orders where upper(customer_name) = 'Shilpa'

--Q10 -› update query to swap gender

Update  a
Set a.customer_gender=  case when a.customer_gender = 'Male' then 'Female'
when a.customer_gender = 'Female' then 'Male' END
From  [dbo].orders   a 

update [dbo].orders 
set customer_gender= IIF(customer_gender='Male','Female','Male');

Select * from [dbo].orders 

