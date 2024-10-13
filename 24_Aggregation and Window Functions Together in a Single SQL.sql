-- How to use group by and rank window function together

Select category, count(distinct product_name) 
from [dbo].[Master_orders]  group by category


-- Top 5 Products in each category by Sales
;with sales_value as (
Select category,product_name, Sum(sales) as total_sales
from [dbo].[Master_orders]  group by category,product_name )
Select * from (
select *, rank () over (partition by category order by total_sales desc ) as rn
from sales_value ) a where rn<=5

-- Alternative Solution 
Select * from (
select category,product_name, Sum(sales) as total_sales,
rank () over (partition by category order by Sum(sales) desc ) as rn
from [dbo].[Master_orders]  group by category,product_name
) a where rn<=5

/*
Insights - when you do GROUP BY and RANK() in the same query, order of execution will be as follows :
GROUP BY  -> AGGREGATION FUNCTION --> RANK()
*/