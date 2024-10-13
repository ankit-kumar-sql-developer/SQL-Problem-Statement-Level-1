
-- top 5 advanced sql interview questions and solutions-> very commonly asked


drop table if exists #emp
create table #emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into #emp
values (1, 'Ankit', 100,10000, 4, 39);
insert into #emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into #emp
values (3, 'Vikas', 100, 10000,4,37);
insert into #emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into #emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into #emp
values (6, 'Agam', 200, 12000,2, 14);
insert into #emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into #emp
values (8, 'Ashish', 200,5000,2,12);
insert into #emp
values (1, 'Saurabh',900,12000,2,51);

Select * from #emp

-- Top 3 product by sales , top 3 emp salaries within cat/dept

-- Top 2 highest
Select TOP 2 * from #emp order by salary desc 

;with cte as (
Select *,
row_number()  over (partition by department_id order by salary desc) as rn,
dense_rank()  over (partition by department_id order by salary desc) as rn1,
rank()  over (partition by department_id order by salary desc) as rn2
from #emp   )
select * from cte where rn in (1,2)

drop table if exists #Master_order
Select order_id,product_id,category,sales
into #Master_order from Master_orders

-- Top 5 sales 

Select * 
from #Master_order order by product_id, sales desc -- incorrect output

--select distinct product_id from  #Master_order
--Solution 1
select TOP 5 product_id , sum(sales) as Total_sales
from  #Master_order group by product_id order by Total_sales desc 

-- Solution 2

;with cte as (
select product_id , sum(sales) as Total_sales
from  #Master_order group by product_id )

Select top 5 product_id, Total_sales from cte order by Total_sales desc


-- Top 5 sales in each category

;with cte as (
select category, product_id , sum(sales) as Total_sales
from  #Master_order group by category,product_id )

select * from (
Select *,
row_number() over (partition by category order by Total_sales desc) as rn
from cte  ) t where rn<=5


-- 2 YOY Growth/product with current month sales more than prev month sales

-- lead/lag

/*
2020--> 100--> 0
2021- 200 --> 100 % growth
2022-300 --> 50 % */

;with cte as (
Select year(order_date) as year_order,sum(sales) as sales
from Master_orders
group by year(order_date)
)
,cte2 as (
Select *, 
lag(sales,1,sales) over (order by year_order) as Prev_Year_sales
from cte )

select year_order,
concat(Cast((sales- Prev_Year_sales)*100/Prev_Year_sales as Decimal(16,2)),'%') as YoYGrowth
from cte2


--- YOY on each category

;with cte as (
Select category,year(order_date) as year_order,
sum(sales) as sales
from Master_orders
group by category ,year(order_date))
,cte2 as (
Select *, 
lag(sales,1,sales) over (partition by category order by year_order) as Prev_Year_sales
from cte )
select year_order,category,
concat(Cast((sales- Prev_Year_sales)*100/Prev_Year_sales as Decimal(16,2)),'%') as YoYGrowth
from cte2

--- products with current month sales more than prev month sales

--SELECT FORMAT(order_date, 'yyyy-MMMM') from  Master_orders
--select datename(month,order_date) from  Master_orders


;with cte as (
Select product_id,FORMAT(order_date, 'yyyy-MMMM') as month_order,
sum(sales) as sales
from Master_orders
where month(order_date) =  9 and  year(order_date) = 2021
group by product_id,FORMAT(order_date, 'yyyy-MMMM')
order by product_id,FORMAT(order_date, 'yyyy-MMMM')

)
,cte2 as (
Select *, 
lag(sales,1,sales) over (partition by product_id order by month_order) as Prev_Year_sales
from cte )

select month_order,product_id,
concat(Cast((sales- Prev_Year_sales)*100/Prev_Year_sales as Decimal(16,2)),'%') as YoYGrowth
from cte2



---- Running/cumulative sales year wise/ Rolling n month sales

;with cte as (
Select year(order_date) as year_order,sum(sales) as sales
from Master_orders
group by year(order_date)
)

select *, 
sum(sales) over ( order by year_order) as RunningSales
from cte


-- Category wise 


;with cte as (
Select category,year(order_date) as year_order,sum(sales) as sales
from Master_orders
group by category,year(order_date)
)

select *, 
sum(sales) over (partition by category order by year_order) as RunningSales
from cte


--- Cumulative Rolling sum for last 5 months

;with cte as (
Select year(order_date) as year_order,month(order_date) as month_order,
sum(sales) as Sales
from Master_orders
group by month(order_date) ,year(order_date)
)

select *, 
sum(sales) over (order by year_order,month_order rows between 2 preceding and current row ) 
as RunningSales_3_Months
from cte

-- 3 preceding and 1 preceding -- last 3 month not current month

-- Pivoting Convert rows into column--year wise each category sales

Select year(order_date) as year_order,category,sum(sales) as Sales
from Master_orders
group by year(order_date) , category
order by year(order_date) , category

--output

Select year(order_date) as year_order,
sum(case when category ='Furniture' then sales else 0 end) as Fur_sales,
sum(case when category ='Office Supplies' then sales else 0 end) as Office_sales,
sum(case when category ='Technology' then sales else 0 end) as Technology_sales
from Master_orders
group by year(order_date)
order by year(order_date) 


-- Result of inner join