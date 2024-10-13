
-- Calculate Mode in SQL

/*
1,2,3,3,4,5,6  --> Mode = 3 (most frequent value in array)
1,2,3,3,4,5,6,6,6  --> Mode = 6 (most frequent value in array)
1,2,3,3,3,4,5,6,6,6  --> Mode = 6,3 (most frequent value in array)
*/

drop table #mode
create table #mode 
(
id int
);

insert into #mode values (1),(2),(2),(3),(3),(3),(3),(4),(5);
insert into #mode values (4)
insert into #mode values (4)
insert into #mode values (4)

Select * from #mode

--Method 1

; with freq_cte as(
Select id, count(id) as Frequency
From #mode group by id )

Select * from freq_cte where Frequency=( Select max(Frequency) from freq_cte )


--Method 2

; with freq_cte as(
Select id, count(id) as Frequency
From #mode group by id ),
freq_cte2 as(
Select *, rank() over ( order by frequency desc) as rn 
from freq_cte )


Select * from freq_cte2 where rn= 1

-- Method 3 

;with cte as
(
select *,
rank() over(order by count(id) desc) as rnk
from #mode
group by id
)
select id
from cte 
where rnk = 1;



-- Method 4   WITH TIES

SELECT TOP 1 WITH TIES *,COUNT(1) AS frequency FROM #mode
GROUP BY id
ORDER BY COUNT(1) DESC;


select id, count(id) as occurrences from #mode
group by id having count(id) = (select max(id) from #mode )     