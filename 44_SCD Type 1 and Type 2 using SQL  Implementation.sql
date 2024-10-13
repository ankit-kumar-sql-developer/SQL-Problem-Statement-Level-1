
Drop table if exists #product_stg
create table #product_stg(
    Product_id  INT,
    Product_Name VARCHAR(50),
    Price   DECIMAL(9,2)
);

Drop table if exists #product_dim
create table #product_dim(
    Product_id  INT primary key,
    Product_Name VARCHAR(50),
    Price   DECIMAL(9,2),
    last_update date
);


delete from #product_dim
delete from #product_stg

insert into #product_stg values(1,'iphone13',40000),(2,'iphone14',70000)

-- SCD1
select * from #product_stg

-- Insert this data into dim table
-- New product insert as it is

Declare @today date = '2024-01-01'

Insert into #product_dim
select Product_id,Product_Name,Price,@today
from #product_stg where product_id 
not in ( select product_id from #product_dim)

select * from #product_dim

-- New record added in stg table on 20-01-2024
-- Since this is SCD1 product_stg will be delete as it contain latest data

delete from #product_stg
insert into #product_stg values (1,'iphone13',30000),(3,'iphone15',90000)
Select * from #product_stg

/*
Update  d
set d.price=s.price
From #product_dim  d
inner join #product_stg s on d.Product_id= s.Product_id
*/
-- First update record then insert new record

Declare @new_today date = '2024-01-20'

Update #product_dim
set price=#product_stg.price, last_update=@new_today
From #product_stg where #product_stg.Product_id= #product_dim.Product_id

Insert into #product_dim
select Product_id,Product_Name,Price,@new_today
from #product_stg where product_id 
not in ( select product_id from #product_dim)

select * from #product_dim  -- SCD 1 

-- second iteration
-- New record added in stg table on 25-01-2024
-- Since this is SCD1 product_stg will be delete as it contain latest data
delete from #product_stg
insert into #product_stg values (2,'iphone14',40000),(4,'iphone16',95000)
Select * from #product_stg

-- First update record then insert new record

Declare @new_today date = '2024-01-25'

Update #product_dim
set price=#product_stg.price, last_update=@new_today
From #product_stg where #product_stg.Product_id= #product_dim.Product_id

Insert into #product_dim
select Product_id,Product_Name,Price,@new_today
from #product_stg where product_id 
not in ( select product_id from #product_dim)

select * from #product_dim  -- SCD 1 


-- SCD 2

Drop table if exists #product_stg
create table #product_stg(
    Product_id  INT,
    Product_Name VARCHAR(50),
    Price   DECIMAL(9,2)
);

drop table if exists #product_dimm
create table #product_dimm(
    product_key int identity(1,1) primary key,
    Product_id  INT,
    Product_Name VARCHAR(50),
    Price   DECIMAL(9,2),
    [start_date] date,
    end_date date
);

delete from #product_stg
insert into #product_stg values(1,'iphone13',40000),(2,'iphone14',70000)

-- Insert this data into dim table
-- New product insert as it is

Declare @start date = '2024-01-01'
Declare @end date = '9999-12-31'

Insert into #product_dimm
select Product_id,Product_Name,Price,@start,@end
from #product_stg where product_id 
not in ( select product_id from #product_dimm)

select * from #product_dimm

-- New record added in stg table on 20-01-2024
-- Since this is SCD1 product_stg will be delete as it contain latest data

delete from #product_stg
insert into #product_stg values (1,'iphone13',30000),(3,'iphone15',90000)
Select * from #product_stg
-- select * from #product_dimm

-- First update record then insert new record

Declare @new_start date = '2024-01-20'

Update #product_dimm
set end_date= dateadd(day,-1,@new_start)
From #product_stg where #product_stg.Product_id= #product_dimm.Product_id
And end_date='9999-12-31' ;


Insert into #product_dimm
select Product_id,Product_Name,Price,@new_start,'9999-12-31'
from #product_stg -- both records need to be inserted

select * from #product_dimm  -- SCD 2

--insert into #product_stg values (1,'iphone13',25000) next iteration