
create table [dbo].products (
id int,
name varchar(10)
);
insert into [dbo].products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

create table [dbo].colors (
color_id int,
color varchar(50)
);
insert into [dbo].colors values (1,'Blue'),(2,'Green'),(3,'Orange');

create table [dbo].sizes
(
size_id int,
size varchar(10)
);

insert into [dbo].sizes values (1,'M'),(2,'L'),(3,'XL');

create table [dbo].transactions
(
order_id int,
product_name varchar(20),
color varchar(10),
size varchar(10),
amount int
);
insert into [dbo].transactions values (1,'A','Blue','L',300),(2,'B','Blue','XL',150),(3,'B','Green','L',250),(4,'C','Blue','L',250),
(5,'E','Green','L',270),(6,'D','Orange','L',200),(7,'D','Green','M',250);


--Cross Join

Select * from dbo.products; -- 5 Records

Select * from dbo.colors ;  -- 3 Records

Select * from [dbo].sizes ; -- 3 Records


Select *  from dbo.products, dbo.colors ;   -- 5*3 = 15 Records


-- Use Case 1 : Prepare Master Data

Select product_name,color,size,Sum(amount) as [Total Amount]
from dbo.transactions group by product_name,color,size

-- Now for A : we need sales of all size for A 

;with master_data as 
(
Select p.name as Product_Name,c.color,s.size
from dbo.products p, dbo.colors c , [dbo].sizes s 
), 
Sales as (  
Select product_name,color,size,Sum(amount) as [Total Amount]
from dbo.transactions group by product_name,color,size
)

Select  md.Product_Name, md.color, md.size, ISNULL(s.[Total Amount],0)
from master_data md 
LEFT JOIN sales s on md.Product_Name= s.product_name and md.color = s.color and md.size = s.size
Order by [Total Amount]




-- Use case 2 : Prepare large no of rows for Performance testing


-- Select * INTO [dbo].[Master_orders] FROM [Asus].[dbo].[orders]

Drop table if exists [dbo].transactions_test
Select * into [dbo].transactions_test  from [dbo].transactions where 1=2


INSERT INTO [dbo].transactions_test 
Select row_number() over (order by t.order_id) as order_id,t.product_name,t.color,
case when row_number() over (order by t.order_id) %3 = 0 then 'L' else 'XL' end as size, t.amount
from  [dbo].transactions t ,[dbo].[Master_orders] m 


select * from transactions_test

