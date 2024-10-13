/*
Problem statement -- Find top 25 and bottom 25 percent customers by sales

The NTILE Analytical function is used to divide a result set into a specified number of groups or buckets based on a specific
Each row in the result set is assigned a group number that represents its position within the ordered set of data. 
*/

;with cte as (
Select customer_name,sum(sales) as total_sales 
from dbo.Master_orders group by customer_name )

Select * , NTILE(4) over ( order by total_sales desc) as cust_groups
from cte 

-- Top 18 --> NTILE(4) first group -->5,5,4,4
;with cte as (
Select Top 16 customer_name,sum(sales) as total_sales 
from dbo.Master_orders group by customer_name
order by total_sales desc )

Select * from (
Select * , NTILE(4) over ( order by total_sales desc) as cust_groups
from cte ) t where cust_groups = 1   -- Top 25%


-- Region wise

;with cte as (
Select customer_name,region,sum(sales) as total_sales 
from dbo.Master_orders group by customer_name,region)

Select * , NTILE(4) over ( partition by region order by total_sales desc) as cust_groups
from cte order by region,total_sales desc