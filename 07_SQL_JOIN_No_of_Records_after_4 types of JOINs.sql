
Drop table if exists #t1
create table #t1 (id1 int)
insert into #t1 values (1), (1)
insert into #t1 values (2)
insert into #t1 values (2)
insert into #t1 values (4)
insert into #t1 values (null)


Drop table if exists #t2
create table #t2 (id2 int)
insert into #t2 values (1), (1), (1)
insert into #t2 values (3)
insert into #t2 values (2)
insert into #t2 values (2)
insert into #t2 values (null)

Select * from #t1
Select * from #t2

Select * from #t1 t1
inner join #t2 t2 on t1.id1 = t2.id2   --  8

Select * from #t1 t1
left join #t2 t2 on t1.id1 = t2.id2   -- 8

Select * from #t1 t1
right join #t2 t2 on t1.id1 = t2.id2   -- 9

Select * from #t1 t1
full outer join #t2 t2 on t1.id1 = t2.id2   -- 9



-- Null is not equal to Null 



-- Problem Statement 1

declare @Country as table (country varchar(20))

insert into @Country select 'INDIA'
insert into @Country select 'AUS'
insert into @Country select 'Srilanka'
insert into @Country select 'England'
insert into @Country select 'South Africa'

-- Input
select * 
from @Country c1, @Country c2
where c1.country > c2.country


-- Problem Statement 2

Drop table if exists #input
Create table #input(
[Name] Varchar(20),Saving_Account Int,Current_Account Int )

Insert into #input Values 
('Ram',1000, 2000),('Raj',3000,4000)

Select * FROM #input

--Output

Select Name,Saving_Account as Amount, 'Saving_Amount' as Account_Type
from #input  
Union All
Select Name,Current_Account as Amount, 'Current_Account' as Account_Type
from #input  