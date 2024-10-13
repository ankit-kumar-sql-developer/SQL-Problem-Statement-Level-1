

Create table #students  (
student_id int,
skill varchar(20)
);
delete from #students;
insert into #students values
(1,'sql'),(1,'python'),(1,'tableau'),(2,'sql'),(3,'sql'),(3,'python'),(4,'tableau'),(5,'python'),(5,'tableau');

Select * from #students

-- Problem Statement To find student who only SQL & Python ( Student id = 3)
-- Student should have 2 skilss
--Having can be avoided by using cte

-- Method 1
;with cte as (
Select student_id, count(*) as Total_skills,
count( case when skill in ('sql','python') then skill else null end) as sp_skills
from #students group by student_id ) 
Select * from cte where Total_skills =2 and sp_skills = 2

-- Method 2
Select student_id, count(*) as Total_skills,
count( case when skill in ('sql','python') then skill else null end) as sp_skills
from #students group by student_id
having count(*) = 2 and 
count( case when skill in ('sql','python') then skill else null end) =2

-- Method 3
Select student_id, count(*) as Total_skills,
count( case when skill not in ('sql','python') then skill else null end) as spn_skills
from #students group by student_id
having count(*) = 2 and 
count( case when skill not in ('sql','python') then skill else null end) =0


-- Method 4

Select student_id, count(*) as Total_skills
from #students 
where student_id not in (
select student_id from #students where skill not in ('sql','python'))
group by student_id
having count(*) = 2

-- Method 5

Select student_id
from #students 
group by student_id
having count(*) = 2
Except
Select student_id
from #students 
where skill not in ('sql','python')

-- Method 6 -- co related sub query 

Select student_id, count(*) as Total_skills
from #students s1
where not exists
(select student_id from #students s2 where s2.skill not in ('sql','python') 
and s1.student_id=s2.student_id)
group by student_id
having count(*) = 2

/*
select student_id from #students s2 where s2.skill not in ('sql','python') 
Result s2 id : 1,4,5

Select student_id, count(*) as Total_skills
from #students s1 group by student_id
Result S1 id : 1,2,3,4,5

where not exists means ( result of s2 id : 1,4,5 will be excluded )

id = 2,3 left after putting having count(*) = 2 
id 2 will be excluded 
output would be id = 3
*/

-- Method 7 
;with sql1 as (select * from #students where skill ='sql'),
python as (select * from #students where skill ='python'),
Other as (select * from #students where skill not in ('sql','python') )

select *
from sql1 s
inner join python p on s.student_id = p.student_id
left join other o on s.student_id = o.student_id 
where o.skill is null
--( s left table other right table s= 1,3 o=1,4,5)


-- Method 8

select s.*,o.*,p.*
from #students s
inner join #students p on s.student_id = p.student_id
left join #students o on s.student_id = o.student_id  and o.skill not in ('sql','python')
where s.skill='sql' and p.skill='python' and o.skill is null

-- Method 9

;with sql1 as (select * from #students where skill ='sql'),
python as (select * from #students where skill ='python'),
Other as (select * from #students where skill not in ('sql','python') )

select student_id
from sql1 s
intersect 
select student_id from python
except 
select student_id from other 


-- Method 10

;with cte as (
Select student_id,
sum( case when skill in ('sql','python') then 1 else 5 end) as sp_skills
from #students group by student_id ) 
Select * from cte where  sp_skills = 2

-- Method 11
select student_id from #students 
group by student_id 
having sum(case when skill in ('sql','python') then 1 else -1 end) =2

--

SELECT student_id,count(*),
STRING_AGG(skill,',')WITHIN GROUP(ORDER BY skill) AS skillset
FROM #students
GROUP BY student_id
HAVING STRING_AGG(skill,',')WITHIN GROUP(ORDER BY skill)='python,sql';

--
SELECT student_id
FROM #students
GROUP BY student_id
HAVING COUNT(DISTINCT skill) = 2
AND SUM(CASE WHEN skill = 'sql' OR skill = 'python' THEN 1 ELSE 0 END) = 2;


--SELECT student_id,
-- SUM(CASE WHEN skill = 'sql' OR skill = 'python' THEN 1 ELSE 0 END)
--FROM #students
--GROUP BY student_id


---
WITH cte AS (
    SELECT 
        student_id,
        COUNT(DISTINCT skill) AS num_skills,
        SUM(CASE WHEN skill IN ('sql', 'python') THEN 1 ELSE 0 END) AS python_sql_count
    FROM 
        #students
    GROUP BY 
        student_id
)
SELECT 
    student_id 
FROM 
    cte 
WHERE 
    num_skills = 2 -- Ensure there are exactly 2 distinct skills
    AND python_sql_count = 2; -- Ensure both skills are SQL and Python

	--

with cte as(select student_id,case when skill='python' then 1
			when skill='sql' then 1
            else 3 end as flag from #students),
            cte2 as(
            select student_id,sum(flag) as total  from cte group by student_id)
            select STUDENT_ID from cte2 where total=2

--
SELECT student_id,count(*)
FROM #students
GROUP BY student_id
having count(*) =2 and max(skill) = 'sql' and min(skill) = 'python'

--
select student_id,count1 as total_skill,STRING_AGG(skill,', ') as skill
from(select *,
lag(skill) over(order by student_id)  as lag1,
lead(skill) over(order by student_id)  as lead1,
count(*) over(partition by student_id) as count1
from #students)x
where count1 = 2 and (lead1='python' or skill='python' and lag1='sql')
group by student_id,count1

--

select student_id from #students where 
skill='python' and student_id in (
select student_id from #students where skill='sql'
)
and 
student_id in (
select student_id from #students group by student_id having count(skill)=2
)

--

select 
student_id
from 
#students
group by 
student_id
having 
count(skill) = 2
and 
count(skill) = sum(case when skill = 'sql' or skill ='python' then 1 else 0 end)

--
;with a as(
select student_id, count(*) as c1
from #students
group by student_id
having count(*)=2 )
,b as (
select student_id, min(skill) as mi,max(skill)  as ma
from #students
where student_id in(select student_id from a)
group by student_id
having min(skill)='python' and max(skill)='sql'
)
select distinct student_id from b;


--

with base as(
select student_id,skill,
count(*) over(partition by student_id ) as cnt,
case when skill='sql' or skill='python' then 1 else 0 end as flag 
from #students) 
select student_id 
from base 

group by student_id
having max(cnt)=2 and sum(flag)=2

--

--with cte as
--(select student_id,string_agg(skill,',' ) as skill_aggregated 
--from #students  group by student_id
-- )
-- select student_id from cte where skill_aggregated='python,sql';

 ;with cte as
 (
 select student_id,
 max(case when skill='sql' then 'Y' else 'N' end) as sql_skill,
 max(case when skill='python' then 'Y' else 'N' end) as python_skill,
 max(case when skill='tableau' then 'Y' else 'N' end) as tableau_skill
 from #students
 group by student_id
-- order by student_id
)
select * from cte where sql_skill='Y' and python_skill='Y' and tableau_skill='N'


--

 select  student_id,sum(case when  skill in ('sql' , 'python' ) then 1 else 0  end),count(*)
 from #students
 group by student_id having 
 sum(case when  skill in ('sql' , 'python' ) then 1 else 0  end) = 2 
 and
 count(*)  =sum(case when  skill in ('sql' , 'python' ) then 1 else 0  end) 

 --
 with cte as (
 select student_id
 from #students
 group by student_id having count(distinct skill) = 2  )

 select  student_id
 from #students
 where skill in ('sql' , 'python' )
 and student_id in (select * from cte )
 group by student_id having count(*) = 2

--

with cte as
(
select student_id,count(distinct skill) cnt from #students 
group by student_id --order by student_id
),
cte1 as(
select s.student_id,c.cnt,
s.skill,row_number() over(partition by s.student_id order by s.student_id) rn 
from #students s
join cte c on s.student_id=c.student_id and c.cnt=2 and (s.skill='sql' or s.skill='python'))
select student_id from cte1 group by student_id having count(rn)!=1;


--

with cte AS
(select student_id, count(skill) as skills from #students
group by student_id
having count(skill)=2),
cte2 as
(select a.student_id, skills, case when skill='sql' or skill='python' then 1
else 0
end as checker
from cte a 
left join #students b on a.student_id=b.student_id)

select student_id, count(checker) from cte2 
where checker=1
group by student_id
having count(checker)=2

--

with cte as
(select student_id, count(skill) as skills from #students
where skill in('sql', 'python')
group by student_id
having count(skill)=2 )

select b.student_id,skills from #students a 
right join cte b on a.student_id=b.student_id
group by b.student_id, skills
having b.skills=count(a.skill) -- ( 2=2)

