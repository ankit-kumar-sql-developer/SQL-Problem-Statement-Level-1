

create table #list (id varchar(5));
insert into #list values ('a');
insert into #list values ('a');
insert into #list values ('b');
insert into #list values ('c');
insert into #list values ('c');
insert into #list values ('c');
insert into #list values ('d');
insert into #list values ('d');
insert into #list values ('e');

-- Rank Duplicate records
Select * from #list



;with cte_dup as (
Select *, count(1) as T_Count
From #list group by id having count(1) > 1 
),
cte_rank as (
Select *, rank() over ( order by id asc) as rn from cte_dup )

Select l.*,'Dup'+ Cast(cr.rn as varchar(20))
from #list l
left join cte_rank  cr on l.id = cr.id


-- Solution 2


 SELECT r.Id AS input, CASE WHEN t.Ranks IS NOT NULL THEN CONCAT('DUP',t.Ranks) END AS output 
 FROM #list r LEFT OUTER JOIN
(SELECT Id, DENSE_RANK() OVER(ORDER BY Id) AS Ranks 
FROM #list GROUP BY Id HAVING COUNT(1) > 1) t
ON r.Id = t.Id

-- Solution 3

SELECT l1.*,
	   CASE WHEN l2.inner_id is null THEN Null
       ELSE concat('DUP',l2.seq) END Output
FROM  #list l1
LEFT JOIN 
(SELECT id inner_id ,dense_rank() over(order by id) seq
FROM  #list
GROUP BY id
HAVING count(1)>1 ) l2 ON l1.id = l2.inner_id;


/*
with c as(
select id,row_number()over(partition by id order by id) rn
from #list
),c2 as
(

select id,max(rn) b from c
group by id
)

select l.id,case when c2.b>1 then 'dup' else null end as n
from #list l join c2 on l.id=c2.id

*/

-- Solution 4
;with cte as (
select id
, count(1) cnt
,concat('DUP',RANK() over (order by id)) dn
from #list
group by id
having count(1)  > 1
)
select  l.id, c.dn
from #list l
left join  cte c on l.id = c.id
order by 1

-- Solution 5

WITH CTE AS (
SELECT id,COUNT(1) AS no_of_occurences FROM #list
GROUP BY id
HAVING COUNT(1)>1 )

SELECT #list.id,CONCAT('DUP',(DENSE_RANK()OVER(ORDER BY CTE.id ASC))) AS output  FROM CTE
INNER JOIN #list
ON CTE.id=#list.id

UNION ALL
SELECT id,CASE WHEN COUNT(1)=1 THEN 'NULL'  END AS output
FROM #list
GROUP BY id
HAVING COUNT(1)=1 
ORDER BY id



-- Solution 6


;with cte as
(
select *,count(*)over(partition by id) as cnt from #list
),cas as(
select *,case when cnt>1 then 'DUP' ELSE NULL end as c from cte
),rnk as(
select *,DENSE_RANK()over(order by id) as dr from cte where cnt>1
),distinctr as(
select distinct a.id,a.c+cast(dr as varchar(10)) as cat from cas a left join rnk b on a.id=b.id
)
select * from #list a inner join distinctr b on a.id=b.id


select id,case when dup=1 then null else 'Duplicated' end as duplicated_records from ( 
Select *,count(id) over(partition by id order by id)as dup from #list) as B




-- 


with A as 
(
   select
      id,
      concat('DUP', row_number() over (
   order by
      id)) as rid 
   from
      #list 
   group by
      id 
   having
      count(id) > 1
)
select
   l.id as input,
   A.rid as output 
from
   #list l 
   left join
      A 
      on l.id = A.id



--



;with cte as (
select id,count(1) as cnt,
case when count(1)!=1 then 'DUP' end as dup_flag
from #list
group by id
)
select l.id,a.dup_flag + cast(rn as varchar) as output 
from #list l left join (
select *,
row_number()over(order by id) as rn 
from cte where dup_flag is not null) a on l.id = a.id


--

with cte as
(select id, count(id) as con, rank() over(order by id)as rn
from #list
group by id 
having count(id) > 1)

select l.id, c.rn
from cte c
right outer join #list l
on c.id = l.id


--


With base as
(Select id,
count(*) as freq
from #list
group by id
 ),
 
 base2 as
 (Select *,
 concat('DUP',row_number() over()) as rank_
 from base
 where freq<>1
  )
  
  Select #list.id,
  rank_
  from #list
  left join base2
  on #list.id=base2.id


  --

 Select A.ID,B.DUP_Rank from 
(select id from #List) A 
left join 
(select id, 'DUP' + cast((rank() over (order by id)) as varchar(20)) as dup_rank 
from #List group by id having count(*)>1) B on A.id = B.id


--

with qa as (
    select 'a' as input union all
    select 'a' as input union all
    select 'b' as input union all
    select 'c' as input union all
    select 'c' as input union all
    select 'c' as input union all
    select 'd' as input union all
    select 'd' as input union all
    select 'e' as input 
),cte1 as (
select input, count(*) as cnt, CONCAT('DUP',rank() over(order by input)) as rnk from qa group by input having count(*)>1) 
select q.input, c.rnk from qa q left join cte1 c on q.input = c.input


--
                                                                                                                   with cte as(
SELECT id, count(1) over (Partition by id) as ct
from #list
)
SELECT id, 'DUP' + CAST(DENSE_RANK() OVER (ORDER BY id) AS VARCHAR) AS temp
from cte
where ct>1

UNION All
SELECT id, NULL as temp
from cte
where ct=1

--

