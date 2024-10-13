-- Rolling calculations SUM,AVG,Min,Max


Select * from dbo.Master_orders

-- Rolling 3 month sum ( current month + previous 2 month )

-- Step 1 year,month,sale

;with year_month_sales as (
Select datepart(year,order_date) as year_order,datepart(month,order_date) as month_order,sum(Sales) as sales
from dbo.Master_orders group by datepart(year,order_date) ,datepart(month,order_date) )


Select *, 
Sum(Sales) over ( order by year_order,month_order rows between 1 preceding and 1 following) as rolling_sum,
Avg(Sales) over ( order by year_order,month_order rows between 1 preceding and 1 following) as rolling_avg,
Min(Sales) over ( order by year_order,month_order rows between 1 preceding and 1 following) as rolling_min,
Max(Sales) over ( order by year_order,month_order rows between 1 preceding and 1 following) as rolling_max
from year_month_sales -- 1 prev current row 1 next 


--Select *, 
--Sum(Sales) over ( order by year_order,month_order rows between 1 preceding and 1 following) as rolling_sum
--from year_month_sales

--Select *, 
--Sum(Sales) over ( order by year_order,month_order rows between 2 preceding and 0 preceding) as rolling_3_sum
--from year_month_sales

--Select *, 
--Sum(Sales) over ( order by year_order,month_order rows between 4 preceding and 0 preceding) as rolling_5_sum
--from year_month_sales