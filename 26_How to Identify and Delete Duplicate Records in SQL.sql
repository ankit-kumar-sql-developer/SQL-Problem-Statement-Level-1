
Drop table if exists #employee
create table #employee (
   emp_id int,
   emp_name varchar(20),
   salary int,
   create_timestamp Datetime);

 Insert into #employee values   (1, 'Ankit', 20000, GETDATE())
 Insert into #employee values   (2, 'Rahul', 20000, GETDATE())
 Insert into #employee values   (3, 'Agam', 30000, GETDATE())
 Insert into #employee values  (1, 'Ankit', 15000, GETDATE())
 Insert into #employee values  (1, 'Ankit', 20000, GETDATE())


-- 1st case delete duplicate in SQL 
Select * from #employee

Delete from #employee where emp_id in ( 
Select emp_id from #employee group by emp_id having count(1)>1)
And create_timestamp in (Select min(create_timestamp) 
from #employee group by emp_id having count(1)>1)

--Select emp_id,min(create_timestamp)  from #employee group by emp_id having count(1)>1

Delete from #employee where emp_id in ( 
Select emp_id from #employee group by emp_id having count(1)>1)
And salary in (Select min(salary) 
from #employee group by emp_id having count(1)>1)

-- 2nd case exact duplicate

Delete from #employee where emp_id =1 
Insert into #employee values  (1, 'Ankit', 20000, '2022-12-25')
Insert into #employee values  (1, 'Ankit', 20000, '2022-12-25')

Select * from #employee

-- This will delete both 2 duplicate records
Delete from #employee where emp_id in ( 
Select emp_id from #employee group by emp_id having count(1)>1)
And create_timestamp in (Select min(create_timestamp) 
from #employee group by emp_id having count(1)>1)

-- Next Step to handle
Select * into #employee1 from #employee

Delete from #employee
Insert into #employee
Select Distinct * from #employee1

-- Select * from #employee1
-- 3rd case exact duplicate
Delete from #employee

Insert into #employee
select emp_id,emp_name,salary,create_timestamp from
(Select *, row_number () over (partition by emp_id order by salary) as rn 
from #employee1) t where rn=1

-- 4th case 

Delete from #employee1 where emp_id=1
Insert into #employee1 values  (1, 'Ankit', 20000, Getdate())
Insert into #employee1 values  (1, 'Ankit', 20000, Getdate())
Insert into #employee1 values  (1, 'Ankit', 20000, Getdate())

select * from #employee1

Insert into #employee
select emp_id,emp_name,salary,create_timestamp from (
Select *, row_number () over (partition by emp_id order by create_timestamp) as rn 
from #employee1 ) t where  rn = 1

-- 5th Case without backup 
select * from #employee
Insert into #employee values  (1, 'Ankit', 20000, Getdate())
Insert into #employee1 values  (1, 'Ankit', 20000, Getdate())

-- Run twice
Delete from #employee where emp_id in ( 
Select emp_id from #employee group by emp_id having count(1)>1)
And create_timestamp in (Select min(create_timestamp) 
from #employee group by emp_id having count(1)>1)


-- Both t
-- can be done via creating variable
Delete from #employee where emp_id not in ( 
Select emp_id from #employee group by emp_id  )
And create_timestamp not in (Select max(create_timestamp) 
from #employee group by emp_id )

select * from #employee


Select max(emp_id) ,max(create_timestamp) 
from #employee group by emp_id 
