
Drop table if exists [dbo].emp_compensation
create table [dbo].emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);

insert into [dbo].emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);


select * from [dbo].emp_compensation;


/*
select emp_id,
Case when salary_component_type='salary' then val end as salary,
Case when salary_component_type='bonus' then val end as bonus,
Case when salary_component_type='hike_percent' then val end as hike_percent
from [dbo].emp_compensation  
*/

select emp_id,
Sum(Case when salary_component_type='salary' then val end) as salary,
sum(Case when salary_component_type='bonus' then val end) as bonus,
Sum(Case when salary_component_type='hike_percent' then val end) as hike_percent
--into [dbo].emp_compensation_pivot
from [dbo].emp_compensation  
group by emp_id


--Pivot Function

select emp_id,salary,bonus,hike_percent
from
(select emp_id,salary_component_type,val from emp_compensation) p
PIVOT(
max(val)
for salary_component_type in ([salary],[bonus],[hike_percent])
)as pivot_table


-- ALTERNATIVE 1

-- There is only one not null value in each group. So max min avg all same ..
select emp_id,
Max(Case when salary_component_type='salary' then val end) as salary,
Max(Case when salary_component_type='bonus' then val end) as bonus,
Max(Case when salary_component_type='hike_percent' then val end) as hike_percent
from [dbo].emp_compensation  
group by emp_id

-- There is only one not null value in each group. So max min avg all same ..


-- ALTERNATIVE 2

select emp_id, salary, hike_percent, bonus
from (
select emp_id, val as salary,
lead(val) over a as hike_percent,
lead(val,2) over a as bonus,
row_number() over a as rn
from emp_compensation
window a as (partition by emp_id order by salary_component_type desc)
) t
where rn=1


-- ALTERNATIVE 3

SELECT DISTINCT(e1.emp_id), 
       e2.val as salary,
       e3.val as bonus,
       e4.val as hike_percent
       
FROM emp_compensation e1 
JOIN emp_compensation e2
ON e1.emp_id = e2.emp_id AND e2.salary_component_type = 'salary'
JOIN emp_compensation e3
ON e1.emp_id = e3.emp_id AND e3.salary_component_type = 'bonus'
JOIN emp_compensation e4
ON e1.emp_id = e4.emp_id AND e4.salary_component_type = 'hike_percent';


-- ALTERNATIVE 4

;with stats as  (

SELECT emp_id,
CASE WHEN salary_component_type = 'salary' THEN val END as salary,
CASE WHEN salary_component_type = 'bonus' THEN val END as bonus,
CASE WHEN salary_component_type = 'hike_percent' THEN val END as hike_percent
FROM emp_compensation)

SELECT emp_id, 
       SUM(salary) as salary,
       SUM(bonus) as bonus,
       SUM(hike_percent) as hike_percent
	FROM stats 
GROUP BY emp_id



--The named window definition in the WINDOW clause determines the partitioning and ordering of a rowset 
--before the window function, which uses the window in an OVER clause.
/*
select emp_id, val as salary,
lead(val) over (partition by emp_id order by salary_component_type desc) as hike_percent,
lead(val,2) over (partition by emp_id order by salary_component_type desc) as bonus,
row_number() over (partition by emp_id order by salary_component_type desc) as rn
from emp_compensation
--window a as (partition by emp_id order by salary_component_type desc)
*/




-- Columns to Rows

select * from [dbo].emp_compensation_pivot

Select * from (
Select emp_id, 'salary' as salary_component_type, salary as val from [dbo].emp_compensation_pivot
Union all
Select emp_id, 'bonus' as salary_component_type, bonus as val from [dbo].emp_compensation_pivot
union all
Select emp_id, 'hike_percent' as salary_component_type, hike_percent as val from [dbo].emp_compensation_pivot
) t order by emp_id




-- Problem Statment 1 
Drop table if exists #Profession
Create Table #Profession
(Name nvarchar(max), Profession nvarchar(max),Id int )

Insert into #Profession  (Name,Profession,Id) Values
('Samantha','Doctor',1),  
('Julia','Actor',2),                        
('Maria','Actor',2),                         
('Meera','Singer',3),                        
('Ashley','Professor',4) ,                    
('Ketty','Professor',4),                     
('Christeen','Professor',4),                     
('Jane','Actor',2),                         
('Jenny','Doctor',1),                        
('Priya','Singer',3)    


Select * from #Profession

-- Solution 1
SELECT
(SELECT STRING_AGG(Name, ',') FROM #Profession WHERE Profession = 'Doctor') AS Doctor,
(SELECT STRING_AGG(Name, ',') FROM #Profession WHERE Profession = 'Actor') AS Actor,
(SELECT STRING_AGG(Name, ',') FROM #Profession WHERE Profession = 'Singer') AS Singer,
(SELECT STRING_AGG(Name, ',') FROM #Profession WHERE Profession = 'Professor') AS Professor


/*
-- Create a temporary table to hold the comma-separated lists
CREATE TABLE #ConcatenatedLists (
    Profession NVARCHAR(MAX),
    NameList NVARCHAR(MAX)
);

-- Insert concatenated values into the temporary table
INSERT INTO #ConcatenatedLists (Profession, NameList)
SELECT 
    Profession,
    STRING_AGG(Name, ', ') AS NameList
FROM #Profession
GROUP BY Profession;


select * from #ConcatenatedLists


-- Split comma-separated lists into rows
SELECT 
    Profession,
    value AS Name
FROM #ConcatenatedLists
CROSS APPLY STRING_SPLIT(NameList, ',');

*/


SELECT value AS Doctor
FROM STRING_SPLIT(
    (SELECT STRING_AGG(Name, ',') WITHIN GROUP (ORDER BY Name) 
     FROM #Profession 
     WHERE Profession = 'Doctor'),
    ','
) AS SplitList 



-- Solution 2

;WITH NumberedSubjects AS (
    SELECT
        Profession,
        Name,
        ROW_NUMBER() OVER (PARTITION BY Profession ORDER BY Name) AS rn
    FROM #Profession
)


SELECT
    Profession,
    MAX(CASE WHEN rn = 1 THEN Name END) AS Sub1,
    MAX(CASE WHEN rn = 2 THEN Name END) AS Sub2,
    MAX(CASE WHEN rn = 3 THEN Name END) AS Sub3
FROM NumberedSubjects
GROUP BY Profession
ORDER BY Profession;


/*
Select 
(Case when Profession ='Doctor' Then  Name End) as Doctor,
(Case when Profession ='Singer' Then  Name End) as Singer,
(Case when Profession ='Professor' Then  Name  End) as Professor,
(Case when Profession ='Actor' Then  Name End) as Actor
from #Profession  

Select 
(select Name FROM #Profession WHERE Profession = 'Doctor') AS Doctor ;

*/




/*
select Doctor,Singer,Professor,Actor
from
(
select Name,Profession from #Profession) p
PIVOT( 
min(Name)
for Profession in ([Doctor],[Singer],[Professor],[Actor]
) 
)as pivot_table

Union all

select Doctor,Singer,Professor,Actor
from
(
select Name,Profession from #Profession) p
PIVOT( 
max(Name)
for Profession in ([Doctor],[Singer],[Professor],[Actor]
) 
)as pivot_table

*/


-- Problem Statment 2


DROP TABLE IF EXISTS #ClassSubjects;
CREATE TABLE #ClassSubjects (
    class CHAR(1),
    Sub NVARCHAR(50) );

INSERT INTO #ClassSubjects (class, Sub) VALUES
('A', 'Maths'),
('B', 'English'),
('A', 'Social'),
('B', 'Chemistry'),
('A', 'Physics'),
('B', 'Statistics'),
('A', 'Biology'),
('B', 'Maths'),
('A', 'Science'),
('B', 'Social');


Select * from #ClassSubjects;

-- Solution 1
Select class,
MAX(case when Sub='Maths' then Sub End) as Sub1,
MAX(case when Sub='English' then Sub End) as Sub2,
MAX(case when Sub='Social' then Sub End) as Sub3,
MAX(case when Sub='Chemistry' then Sub End) as Sub4,
MAX(case when Sub='Biology' then Sub End) as Sub5,
MAX(case when Sub='Statistics' then Sub End) as Sub6,
MAX(case when Sub='Science' then Sub End) as Sub7,
MAX(case when Sub='Physics' then Sub End) as Sub8
from #ClassSubjects GROUP BY CLASS


-- Solution 2

-- Add a row number to each subject within each class
;WITH NumberedSubjects AS (
    SELECT
        class,
        Sub,
        ROW_NUMBER() OVER (PARTITION BY class ORDER BY Sub) AS rn
    FROM #ClassSubjects
)

-- Pivot the data
SELECT
    class,
    MAX(CASE WHEN rn = 1 THEN Sub END) AS Sub1,
    MAX(CASE WHEN rn = 2 THEN Sub END) AS Sub2,
    MAX(CASE WHEN rn = 3 THEN Sub END) AS Sub3,
    MAX(CASE WHEN rn = 4 THEN Sub END) AS Sub4,
    MAX(CASE WHEN rn = 5 THEN Sub END) AS Sub5
FROM NumberedSubjects
GROUP BY class
ORDER BY class;


  

/*
; WITH NumberedProfessions AS (
    SELECT
        Name,
        Profession,
        ROW_NUMBER() OVER (PARTITION BY Profession ORDER BY Name) AS rn
    FROM #Profession
)

-- Pivot the data using conditional aggregation
SELECT
    MAX(CASE WHEN Profession = 'Doctor' AND rn = 1 THEN Name END) AS Doctor1,
    MAX(CASE WHEN Profession = 'Doctor' AND rn = 2 THEN Name END) AS Doctor2,
    MAX(CASE WHEN Profession = 'Doctor' AND rn = 3 THEN Name END) AS Doctor3,
    MAX(CASE WHEN Profession = 'Actor' AND rn = 1 THEN Name END) AS Actor1,
    MAX(CASE WHEN Profession = 'Actor' AND rn = 2 THEN Name END) AS Actor2,
    MAX(CASE WHEN Profession = 'Actor' AND rn = 3 THEN Name END) AS Actor3,
    MAX(CASE WHEN Profession = 'Singer' AND rn = 1 THEN Name END) AS Singer1,
    MAX(CASE WHEN Profession = 'Singer' AND rn = 2 THEN Name END) AS Singer2,
    MAX(CASE WHEN Profession = 'Professor' AND rn = 1 THEN Name END) AS Professor1,
    MAX(CASE WHEN Profession = 'Professor' AND rn = 2 THEN Name END) AS Professor2,
    MAX(CASE WHEN Profession = 'Professor' AND rn = 3 THEN Name END) AS Professor3
FROM NumberedProfessions
GROUP BY Profession
ORDER BY Profession;
*/