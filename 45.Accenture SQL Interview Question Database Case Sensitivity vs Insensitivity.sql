
drop table if exists #employees
create table #employees  (employee_id int,employee_name varchar(15), email_id varchar(15) );
delete from #employees;
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('101','Liam Alton', 'li.al@abc.com');
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('102','Josh Day', 'jo.da@abc.com');
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('103','Sean Mann', 'se.ma@abc.com'); 
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('104','Evan Blake', 'ev.bl@abc.com');
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('105','Toby Scott', 'jo.da@abc.com');
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('106','Anjali Chouhan', 'JO.DA@ABC.COM');
INSERT INTO #employees (employee_id,employee_name, email_id) VALUES ('107','Ankit Bansal', 'AN.BA@ABC.COM');

-- fetch lowercase email out of 3 duplicate 2 lower & 1 upper case 
select * from #employees where email_id=lower(email_id)

;with cte as (
select *, 
ASCII(email_id) as ascii_email,
rank() over (partition by email_id order by ASCII(email_id) desc) as rn
from #employees ) 

Select * from cte where rn=1

-- Case sensitive

ALTER TABLE #employees
ALTER COLUMN email_id VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS; -- case sensitive

select * from #employees where email_id=lower(email_id)

select * from (
select *, 
ASCII(email_id) as ascii_email,lower(email_id) as le,
rank() over (partition by lower(email_id) order by ASCII(email_id) desc) as rn
from #employees ) as  t 
where rn <>3


--
select * from #employees
where ASCII(email_id) <> ASCII(upper(email_id))
Union
select * from #employees
where email_id in (
select email_id from #employees
group by email_id having count(email_id) = 1)


---


WITH CTE AS(
SELECT *,
COUNT(*) OVER(PARTITION BY LOWER(email_id)) AS distincts,
CASE WHEN email_id = LOWER(email_id) THEN 1 ELSE 0 END AS FLAG
FROM #employees )

SELECT employee_id, employee_name, email_id FROM CTE WHERE 
(distincts = 1 AND flag = 0) OR flag = 1


---

select * from
(
select *,lower(email_id) as l_email ,ASCII(email_id) as ASCI, 
row_number() over(partition by lower(email_id) order by ASCII(email_id) desc) as rw 
from #employees
)A
where ASCI>97 or rw=1

---

;with temp as (
Select  lower(email_id) as l_email_id, count(1)  as cnt
from #employees
group by lower(email_id)
having count(1) >= 2
)
select * from #employees where email_id not in (select UPPER(l_email_id) from temp)

---
;with cte as (
select employee_id, employee_name,  email_id,
count(*) over (partition by email_id) as cnt from #employees )
, 
cte2 as (
select employee_id, employee_name, lower(email_id) as lw, email_id from cte
where cnt > 1
)

select * from cte2 
where ascii(lw) = ascii(email_id)

--

with cte as(
select *,case when lower(email_id)!=email_id then 'uppercase' else 'lowercase' end as caser,
row_number() over(partition by  lower(email_id) order by employee_id) as rn 
from #employees
)
select * from cte where rn<=1 or caser='lowercase'


---
select * from #employees
where employee_id not in (
select employee_id from (
select employee_id, employee_name, email_id, upper(email_id) as U_email_id , 
count(1) over(partition by upper(email_id) ) as cont
from #employees) a
where email_id=upper(email_id)
and cont>1 )
order by employee_id;


---
SELECT e1.employee_id 
FROM #employees  e1 INNER JOIN 
(SELECT LOWER(email_id) AS email_id,count(1) AS count
FROM #employees GROUP BY lower(email_id) HAVING count(1) > 1) e2 ON e1.email_id = e2.email_id
ORDER BY e1.employee_id
