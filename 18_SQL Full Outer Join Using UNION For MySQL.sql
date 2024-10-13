
--DDL Statement
Drop table if exists #Customer
Drop table if exists #Customer_order

Create Table #Customer (Customer_id int, customer_name Varchar(20),Gender varchar(10),Dob date, age int)
Create Table #Customer_order (Order_id int,Customer_id int, orderDate date, ShipDate date)

Insert into #Customer Values (1,'Rahul','M','2000-01-05',24   )
Insert into #Customer Values (2,'Shilpa','F','2004-04-05',20   )
Insert into #Customer Values (3,'Ramesh','M','2003-07-07',21    )
Insert into #Customer Values (4,'Katrina','F','2005-02-05',19   )
Insert into #Customer Values (5,'Alia','F','1992-01-01',32     )

Insert into #Customer_order Values (1000,1,'2022-01-05','2022-01-11')
Insert into #Customer_order Values (1001,2,'2022-02-04','2022-02-06')
Insert into #Customer_order Values (1002,3,'2022-01-01','2022-01-19')
Insert into #Customer_order Values (1002,4,'2022-01-06','2022-01-30')
Insert into #Customer_order Values (1004,6,'2022-02-07','2022-02-13')


Select * From #Customer
Select * From #Customer_order

--FULL outer JOIN 
Select C.Customer_id,c.customer_name, CO.Customer_id as CO_Customer_ID,co.orderDate
From #Customer C 
FULL OUTER JOIN #Customer_order co
ON C.Customer_id = co.Customer_id


-- Full Outer Join using Left Join

Select C.Customer_id,c.customer_name, CO.Customer_id as CO_Customer_ID,co.orderDate
From #Customer C 
LEFT JOIN #Customer_order co
ON C.Customer_id = co.Customer_id

Union all 
Select C.Customer_id,c.customer_name, CO.Customer_id as CO_Customer_ID,co.orderDate
From #Customer_order co 
LEFT JOIN  #Customer C 
ON C.Customer_id = co.Customer_id Where c.Customer_id is null

--FULL outer JOIN using Left & Right Join UNION
Select C.Customer_id,c.customer_name, CO.Customer_id as CO_Customer_ID,co.orderDate
From #Customer C 
LEFT JOIN #Customer_order co
ON C.Customer_id = co.Customer_id

UNION 
Select C.Customer_id,c.customer_name, CO.Customer_id as CO_Customer_ID,co.orderDate
From #Customer C 
Right JOIN #Customer_order co
ON C.Customer_id = co.Customer_id


--UNION only
Select *, ROW_NUMBER() over (ORDER BY countera) as counterB
From
(
Select C.Customer_id as  CCustomerID,c.customer_name, CO.Customer_id as COCustomerID, Co.orderDate,
ROW_NUMBER() over (ORDER BY C.Customer_id) as countera
From #Customer C LEFT JOIN #Customer_order CO
ON C.Customer_id = co.Customer_id
UNION
Select C.Customer_id as  CCustomerID,c.customer_name, CO.Customer_id as CoCustomerID, Co.orderDate,
ROW_NUMBER() over (ORDER BY CO.Customer_id) as countera
From #Customer C RIGHT JOIN #Customer_order CO
ON C.Customer_id = co.Customer_id
) X