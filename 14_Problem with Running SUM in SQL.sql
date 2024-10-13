/*
unbounded preceding  -> means window starting the first row of the resultset
current row -> means current row for which you are calculating value
unbounded Following -> means window ending the last row of the resultset
*/

Drop table if exists #products 
create table #products ( product_id varchar(20), cost int)

insert into #products values ('P1', 200), ('P2', 300), ('P3', 300), ('P4', 500), ('P5', 800)

Select * from #products

-- Running SUM
-- Duplicate record of cost
Select *, SUM(cost) over (order by cost asc ) as running_cost
From #products

Select *, SUM(cost) over (order by Cost asc,product_id ) as running_cost
From #products

Select *, SUM(cost) 
over (order by Cost asc rows between unbounded preceding and current row ) as running_cost
From #products



-- Solution 2
select p1.product_id, sum(p2.cost)
from #products p1  left join #products p2 on p1.product_id>= p2.product_id
group by p1.product_id

select p1.product_id ,p2.cost
from #products p1  left join #products p2 on p1.product_id>= p2.product_id
order by p1.product_id asc

/*
P1   P2   P3   P4  P5
P2   P3   P4   P5
P3   P4   P5
P4   P5
P5
*/

-- Solution 3

with cte as (
select *, rank() over (order by product_id) as rnk from #products
)
select cte.*, sum(cost) over(order by rnk asc) as running_cost from cte