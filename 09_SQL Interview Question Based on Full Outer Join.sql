

create table #emp_2020
(
emp_id int,
designation varchar(20)
);

create table #emp_2021
(
emp_id int,
designation varchar(20)
)

insert into #emp_2020 values (1,'Trainee'), (2,'Developer'),(3,'Senior Developer'),(4,'Manager');
insert into #emp_2021 values (1,'Developer'), (2,'Developer'),(3,'Manager'),(5,'Trainee');


-- Find the change in employee status
Select * from #emp_2020
Select * from #emp_2021


-- Solution 1

-- If we want to compare string value with NULL 

Select ISNULL(a.emp_id,b.emp_id) as emp_id,
Case when a.designation != b.designation then 'Promoted' 
when a.designation is null then 'Resigned'
when b.designation is null then 'New' END as Comment 
from #emp_2020 a
full outer join #emp_2021 b on a.emp_id = b.emp_id  
where ISNULL(a.designation,'XYZ') != ISNULL(b.designation,'PQR')



-- Solution 5

select * from
(select isnull(e1.emp_id,e2.emp_id) as emp_id,
        case when e1.designation!=e2.designation then 'Promoted' 
			 when e1.designation is null then 'New'
			 when e2.designation is null then 'Resigned' end as Comment
from #emp_2020 e1 full outer join #emp_2021 e2 
on e1.emp_id=e2.emp_id)t
where Comment is not null



-- Solution 2
Select * from (
Select a.emp_id,a.designation as Prev_designation,b.designation as New_designation,
Case when a.designation <> b.designation then 'Promoted' End as Comment
from #emp_2020 a
full outer join #emp_2021 b on a.emp_id = b.emp_id   
where a.designation <> b.designation

Union all
Select b.emp_id,a.designation as Prev_designation,b.designation as New_designation,
Case when a.designation is null then 'New' End as Comment
from #emp_2020 a
full outer join #emp_2021 b on a.emp_id = b.emp_id   
where a.emp_id is  null -- or b.emp_id is null

Union all
Select a.emp_id,a.designation as Prev_designation,b.designation as New_designation,
Case when b.designation is null then 'Resigned' End as Comment
from #emp_2020 a
full outer join #emp_2021 b on a.emp_id = b.emp_id   
where  b.emp_id is null ) t
order by t.emp_id



-- Solution 3


select COALESCE (e1.emp_id, e2.emp_id),
case when e2.emp_id is null then 'Resigned'
     when e1.emp_id is null then 'Newly joined'
     else 'Promoted' end as status
from #emp_2020 e1 full outer join #emp_2021 e2 
on e1.emp_id=e2.emp_id
where (e1.emp_id is null or e2.emp_id is null) or (e1.designation <> e2.designation)



-- Solution 4

;with cte as(
select #emp_2020.emp_id as id_20, #emp_2021.emp_id as id_21
,case 
	when #emp_2020.designation!=#emp_2021.designation then 'Promoted'
	when #emp_2021.emp_id is null then 'Resigned'
	when #emp_2020.emp_id is null then 'Traniee'
	end as designation1
from #emp_2020 full outer join #emp_2021 on #emp_2020.emp_id = #emp_2021.emp_id)

select id_20 as emp_id,designation1 from cte
where id_20 is not null and designation1 is not null
union 
select id_21 as emp_id,designation1 from cte
where id_21 is not null and designation1 is not null




