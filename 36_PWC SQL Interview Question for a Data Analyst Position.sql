

create table #source(id int, name varchar(5))

create table #target(id int, name varchar(5))

insert into #source values(1,'A'),(2,'B'),(3,'C'),(4,'D')

insert into #target values(1,'A'),(2,'B'),(4,'X'),(5,'F');

SELECT * FROM #source
SELECT * FROM #target

-- Method 1
--case when s.id = s.id then s.id  when t.id = t.id then t.id end as id (coalesce alternative)

SELECT coalesce(s.id,t.id) as id,s.name,t.name,
case when t.name is null then'new in source'
when s.name is null then 'new in targer' else 'mismatch' end as comment
from #source s
full outer join  #target t on s.id= t.id
where s.name <> t.name or s.name is null or t.name is null

-- Method 2

; with cte as (
Select *, 'source' as table_name
from #source
union all
Select * , 'target' as table_name
from #target )

Select id,count(*) as cnt, min(name) as mi,max(name) as ma,
min(table_name) as mit, max(table_name) as mat,
case when min(name) <> max(name) then'mismatch'
when min(table_name) ='new in source' then '' else 'new in target' end as comment
from cte
group by id having count(*) = 1 or ( count(*) =2 and min(name) <> max(name))


---
SELECT s.*,t.*
from #source s
full outer join  #target t on s.id= t.id
where isnull(s.name,'a') <> isnull(t.name,'b')


select  s.id as sid,t.id as tid,
case when s.id = s.id then s.id end as id
from #source s full outer join #target t on s.id = t.id
where s.name != t.name or s.name is null or t.name is null


-- Method 3

select id, 'new in source' as comment from #source where id not in (select id from #target)
union
select id, 'new in target' as comment from #target where id not in (select id from #source)
union
select s.id, 'mismatch' as comment 
from #source s join #target t on s.id = t.id and s.name != t.name

--
select a.id, comment
from
(select coalesce(s.id,t.id) as id,
CASE when t.id is null then 'New in Source'
	 when s.id is null then 'New in Target'
	 when t.name != s.name then 'Mismatch'
END AS Comment
from #source s
full join #target t on s.id = t.id) a 
where a.comment is not null;
--

with all_id as (
select id, name, 'source' as flag from #source 
union all 
select id,name, 'target' as flag from #target),
flag as (
select *,
count(1) over (partition by id,name) as cnt_1,
count(1) over (partition by id) as cnt_2
from all_id)

select
id,
max(case when cnt_1 =cnt_2 and flag='source' then 'New in Source'
when cnt_1=cnt_2 and flag='target' then 'New in target'
else  'Mismatch' end) as Comment
from flag where cnt_1!=2
group by id;


---

with sample1 as (
select * from #source
except
select * from #target
),
sample2 as (
select * from #target 
except
select * from #source
)

select coalesce(s1.id,s2.id) as id
    ,case  
        when s1.name <> s2.name then 'its a mismatch'
        when s1.name is null then 'new in target'
        when s2.name is null then 'new in source'
        end as "comment"        from
        sample1 s1 full join 
sample2 s2 on
s1.id=s2.id


---
with cte as (
select *,'Source' as Location from #source 
where id not in (select a.id from #source a inner join #target b on a.id=b.id and a.name=b.name)
union all
select *,'target' as Location from #target 
where id not in (select a.id from #source a inner join #target b on a.id=b.id and a.name=b.name)
)
select distinct a.id,
case when occurance>1 then 'Mismatch' 
when lower(Location)='source' then 'New in Source' 
when lower(Location)='target' then 'New in Source' else null end as comments
from cte a inner join (select id,count(id) as occurance from cte group by id )b on a.id=b.id


--

select id,'New in source' as comment from #source 
where id not in(select id from #target) and name not in (select name from #target)
union
select id,'New in target' as comment from #target
where id not in(select id from #source) and name not in (select name from #source)
union
select id,'Mismatch' as comment from #source 
where id in(select id from #target) and name not in (select name from #target)
union
select id,'Mismatch' as comment from #target
where id in(select id from #source) and name not in (select name from #source)


--

With CTE as(
Select s.id as s_id, s.name as s_name, t.id as t_id, t.name as t_name
  from #source s
FULL outer join #target as t
on s.id = t.id)
Select 
CASE 
when s_id is null then t_id else s_id end as id,final_status
from (
Select *,
CASe when s_name = t_name and s_id = t_id then 'All_Match'
	When s_name != t_name and s_id = t_id then 'Name_Mismatch'
	when s_id is null and t_id is not null then 'New_in_target'
	when s_id is not null and t_id is null then 'New_in_Source'
END as final_status
from CTE) as a
Where final_status != 'All_Match'


--
;
with cte_1 as 
(Select A.id as source_id, B.id as target_id,
CASE WHEN B.name is null THEN 'New in Source' WHEN A.name is null THEN 'New in Target' ELSE 'Mismatch' END as Comment
FROM #source A
FULL OUTER JOIN #target B
ON A.id = B.id
WHERE A.name!=B.name OR A.name is null OR B.name is null)
Select * from 
(Select source_id as id, Comment from cte_1
UNION 
Select target_id as id, Comment from cte_1)xyz
WHERE id is not null;

--

with 
cte_new_in_source as (select id,'New in Source' from #source where id not in (select id from #target)),
cte_new_in_target AS (select id,'New in Targer' from #target where id NOT IN (Select id from #source)),
cte_mismatch as (select s.id, 'Mismatch' from #source s inner join #target t on s.id=t.id and s.name!=t.name)
select * from cte_new_in_source union select  * from cte_new_in_target union select * from cte_mismatch

--

select case when s.id = s.id then s.id when t.id = t.id then t.id end as id,
case when s.name = s.name then 'new in source' when t.name = t.name then 'new in target' 
when s.name != t.name then 'mismatch'
end as comment
from #source s full outer join #target t on s.id = t.id
where s.name != t.name or s.name is null or t.name is null



select  s.id as sid,t.id as tid,
case when s.id = s.id then s.id  when t.id = t.id then t.id end as id
from #source s full outer join #target t on s.id = t.id
where s.name != t.name or s.name is null or t.name is null


--