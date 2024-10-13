/*

Starting and ending rows might be fixed or relative to the current row based on the following keywords:

CURRENT ROW, the current row
UNBOUNDED PRECEDING, all rows before the current row -> fixed
UNBOUNDED FOLLOWING, all rows after the current row -> fixed
x PRECEDING, x rows before the current row -> relative
y FOLLOWING, y rows after the current row -> relative
Possible kinds of calculation include:

Both starting and ending row are fixed, the window consists of all rows of a partition, e.g. a Group Sum, i.e. aggregate plus detail rows
One end is fixed, the other relative to current row, the number of rows increases or decreases, e.g. a Running Total, Remaining Sum
Starting and ending row are relative to current row, the number of rows within a window is fixed, e.g. a Moving Average over n rows


*/

CREATE TABLE [dbo].[int_orders](
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (30, CAST(N'1995-07-14' AS Date), 9, 1, 460)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST(N'1996-08-02' AS Date), 4, 2, 540)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (40, CAST(N'1998-01-29' AS Date), 7, 2, 2400)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (50, CAST(N'1998-02-03' AS Date), 6, 7, 600)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (60, CAST(N'1998-03-02' AS Date), 6, 7, 720)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (70, CAST(N'1998-05-06' AS Date), 9, 7, 150)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST(N'1999-01-30' AS Date), 4, 8, 1800)
--Add Duplicate
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST(N'1999-01-30' AS Date), 4, 8, 1800)
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST(N'1996-08-02' AS Date), 4, 2, 540)


Select * from dbo.int_orders

-- Aggregation in SQL 

--Sum
Select SUM([amount]) AS TotalSales from dbo.int_orders

Select [salesperson_id],SUM([amount]) AS TotalSales
from dbo.int_orders group by Salesperson_id

Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over () 
From dbo.int_orders

Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (partition by [salesperson_id]) 
From dbo.int_orders

Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date]) 
From dbo.int_orders  -- Running Total because of distinct order date 


Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (partition by [salesperson_id] order by  [order_date]) 
From dbo.int_orders -- Running Total by ID  because of distinct order date 

-- Previous 3 rows 
Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date] rows between 2 preceding  and current row) 
From dbo.int_orders

-- Previous 2 rows Exclude current row
Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date] rows between 2 preceding and 1 preceding ) 
From dbo.int_orders

-- Prev 1 row, current row & Next 1 row Include current row also 
Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date] rows between 1 preceding and 1 following ) 
From dbo.int_orders

-- All Prev row similar to running sum ( diffrence will be in case of duplicates)
Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date] rows between unbounded preceding and current row ) 
From dbo.int_orders

Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by  [order_date]) 
From dbo.int_orders 

--Select [order_number], [order_date], [cust_id], [salesperson_id], [amount],
--Sum (Amount) over (order by  amount) 
--From dbo.int_orders 

-- Adding partition by
Select[order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over 
(partition by [salesperson_id] order by [order_date] rows between 1 preceding and current row) 
From dbo.int_orders

-- use of lead & lag without using it
Select[order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by [order_date] rows between 1 preceding and 1 preceding) 
From dbo.int_orders


Select[order_date], [cust_id], [salesperson_id], [amount],
Sum (Amount) over (order by [order_date] rows between 1 following and 1 following) 
From dbo.int_orders
