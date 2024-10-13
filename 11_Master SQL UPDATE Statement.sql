
Select * from emp ;
Select * from department ;

-- Update syntax for Single value

Update emp set salary = 12000  

-- Update with where clause

Update emp set salary = 12000  where emp_id =1

-- Update  multiple Values

Update emp set salary = 12000 , department_id=200  where emp_id =2

-- Update col with constant values and derivations 

Update emp set salary = Salary*1.1  where emp_id =3

Update emp set salary = Case when department_id = 100 then salary * 1.1 when department_id = 200
then salary*1.2 else salary end 
where emp_id =3

select  0.2*100 
select 20.0/100.0

-- Update using Join

Alter table emp add dep_name varchar(20);

Update a
set dep_name = d.dept_name
from emp a
inner join department d on a.department_id =  d.dept_id

-- Interview Question on update
Alter table emp add  gender varchar(5);

Alter table emp alter column gender varchar(10);

Update emp set gender = case when department_id = 100 then 'Male' else 'Female' end 

Select * from emp 

Update emp
set gender = Case when gender='Male' then 'Female' 
when gender='Female' then 'Male'  end 


 -- Cautious before running an update tips

 Select *,
 Case when gender='Male' then 'Female' 
when gender='Female' then 'Male'  end 
 from emp