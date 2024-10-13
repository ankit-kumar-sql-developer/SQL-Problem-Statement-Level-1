
create table #product_master 
(
product_id int,
product_name varchar(100)
);

insert into #product_master values(100,'iphone5'),(200,'hp laptop'),(300,'dell laptop');

create table #orders_usa
(
order_id int,
product_id int,
sales int
);
create table #orders_europe
(
order_id int,
product_id int,
sales int
);

create table #orders_india
(
order_id int,
product_id int,
sales int
);
--delete from #orders_india
insert into #orders_usa values (1,100,500);
insert into #orders_usa values (7,100,500);
insert into #orders_europe values (2,200,600);
insert into #orders_india values (3,100,500);
insert into #orders_india values (4,200,600);
insert into #orders_india values (8,100,500);

Select * from #orders_usa
Select * from #orders_europe
Select * from #orders_india


-- Full Outer Join in depth & alternatives
/*
Product wise sales each country
product_id, sales_usa, sales_europe, sales_india
100,	500,	null,	500
200,	null,	600,	600
*/

Select coalesce(u.product_id,e.product_id,i.product_id ) as Product_id,
u.sales as Usa_sales, e.sales as Europe_sales, i.sales as India_Sales
from #orders_usa u 
Full outer Join #orders_europe  e on u.product_id = e.product_id
Full outer Join #orders_india   i on coalesce(u.product_id,e.product_id) = i.product_id

-- Overcome challenge of output of above query 
-- When joining on non primary key remove duplicate values else it will do cross join 

Select coalesce(u.product_id,e.product_id,i.product_id ) as Product_id,
u.sales as Usa_sales, e.sales as Europe_sales, i.sales as India_Sales
From (select product_id,sum(sales) as sales from #orders_usa group by product_id)u 
Full outer Join (select product_id,sum(sales) as sales from #orders_europe group by product_id)  e 
on u.product_id = e.product_id
Full outer Join (select product_id,sum(sales) as sales from #orders_india group by product_id)   i 
on coalesce(u.product_id,e.product_id) = i.product_id

-- Alternatives 1 
Select * from #product_master

Select pm.Product_id,
u.sales as Usa_sales, e.sales as Europe_sales, i.sales as India_Sales
from #product_master pm 
left join (select product_id,sum(sales) as sales from #orders_usa group by product_id) u 
on pm.product_id = u.product_id
left Join (select product_id,sum(sales) as sales from #orders_europe group by product_id)  e 
on pm.product_id = e.product_id
left Join (select product_id,sum(sales) as sales from #orders_india group by product_id)   i 
on pm.product_id = i.product_id
where not (u.sales is null and e.sales is null and i.sales is null)

-- or
Select pm.Product_id,
u.sales as Usa_sales, e.sales as Europe_sales, i.sales as India_Sales
from (select product_id from #orders_usa 
union select product_id from #orders_europe union select product_id from #orders_india  ) pm 
left join (select product_id,sum(sales) as sales from #orders_usa group by product_id) u 
on pm.product_id = u.product_id
left Join (select product_id,sum(sales) as sales from #orders_europe group by product_id)  e 
on pm.product_id = e.product_id
left Join (select product_id,sum(sales) as sales from #orders_india group by product_id)   i 
on pm.product_id = i.product_id
where not (u.sales is null and e.sales is null and i.sales is null)


-- ALternative 2
;with cte as (
Select product_id, sales as usa_sales , null as europe_sales , null as India_sales from #orders_usa
union all
Select product_id,  null as usa_sales , sales as usa_sales , null as India_sales from #orders_europe
union all
Select product_id, null as usa_sales , null as europe_sales , sales India_sales from #orders_india
)
select product_id, sum(usa_sales) as usa_sales,
sum(europe_sales) as usa_europe , sum(India_sales) as India_sales from cte group by product_id



--

with cte as (
  select *,'e' as region from orders_europe
  union
  select *,'i' from orders_india
  union 
  select *,'u' from orders_usa
)

select product_id
     , sum(case when region = 'u' then sales end) as sales_usa
     , sum(case when region = 'e' then sales end) as sales_europe
     , sum(case when region = 'i' then sales end) as sales_india
from cte
group by product_id