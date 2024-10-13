-- SQL order of execution

--> From --> Join --> Where --> Group by --> having --> Select --> Order by --> Top 5 

Select * from dbo.emp1
/*First From emp1 will execute then Select */

Select * from dbo.emp1 where salary > 6000 
/*First From emp1 will execute 
  then where will execute
  then Select */


Select *,salary*1.0/2 as half_salary from dbo.emp1 
where salary > 6000 Order by half_salary desc
/*First From emp1 will execute 
  then where will execute
  then Select  then Order in desc ( as alias name working) 
  */

Select TOP 5 *,salary*1.0/2 as half_salary from dbo.emp1 
where salary > 6000 Order by half_salary desc
/*First From emp1 will execute 
  then where will execute
  then Select  then Order in desc ( as alias name working) 
  then TOP 5 
  */


Select department_id,d.dept_name,sum(salary) as dep_salary 
from dbo.emp1 e
inner join dbo.department d on e.department_id = d.dept_id
-- inner join.......
where salary > 6000  and d.dept_id =200
group by department_id,dept_name
having sum(salary) > 6000
Order by dep_salary desc
/*First From emp1 will execute 
  then inner join operation ( top to bottom flow)
  then where will execute (row level) filter on both table shows join is before where
  then Group by  then having  ( alias name wont work) (grouping)
  then Select  then Order in desc ( as alias name working) 
  then TOP 5 
  */

--> From --> Join --> Where --> Group by --> having --> Select --> Order by --> Top 5 

--What is the order of execution when window function exist in SQL Query
-- Along with Select 

--GROUP BY comes before SELECT. But what about those situations, 
--when we use GROUP BY clause on the number of the column (i.e., 1, 2, 3). 

--It will just pick the column list from select but execution will be later.