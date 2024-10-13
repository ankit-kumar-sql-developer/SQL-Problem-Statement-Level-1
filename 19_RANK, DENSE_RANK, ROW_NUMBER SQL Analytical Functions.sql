

create table #employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int
);
insert into #employee values(1,'Ankit',100,10000);
insert into #employee values(2,'Mohit',100,15000);
insert into #employee values(3,'Vikas',100,10000);
insert into #employee values(4,'Rohit',100,5000);
insert into #employee values(5,'Mudit',200,12000);
insert into #employee values(6,'Agam',200,12000);
insert into #employee values(7,'Sanjay',200,9000);
insert into #employee values(8,'Ashish',200,5000);

Select * from #employee

-- Ranking
Select emp_id, emp_name, dept_id, salary,
Rank() over (order by salary desc ) as [Rank], -- Skip rank
Dense_Rank() over (order by salary desc ) as [DenseRank], -- Do not skip rank
Row_number() over (order by salary desc ) as [Row] --Unique value each row 
from #employee

-- Department wise Rank (Window Function)
Select emp_id, emp_name, dept_id, salary,
Rank() over (Partition by dept_id order by salary desc ) as [Rank], -- Skip rank
Dense_Rank() over (Partition by dept_id order by salary desc ) as [DenseRank], -- Do not skip rank
Row_number() over (Partition by dept_id order by salary desc ) as [Row] --Unique value each row 
from #employee

-- Department wise highest salary
; With cte as (
Select emp_id, emp_name, dept_id, salary,
Dense_Rank() over (Partition by dept_id order by salary desc ) as [DenseRank]
from #employee )

Select * from cte where DenseRank = 1

-- using SubQuery
Select * from (
Select emp_id, emp_name, dept_id, salary,
Rank() over (Partition by dept_id order by salary desc ) as [Rank]
from #employee ) a where [Rank]=1
