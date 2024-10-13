
-- Pattern matching in SQL with LIKE

Select * from [dbo].[Master_orders] 
where customer_name = 'Andrew Allen'

-- % O or more characters
Select customer_name,order_id,order_date from [dbo].[Master_orders] 
where customer_name like  'Andrew%'

-- Name ending with Allen
Select customer_name,order_id,order_date from [dbo].[Master_orders] 
where customer_name like  '%Allen'

-- Start with A & Name ending with N
Select customer_name,order_id,order_date from [dbo].[Master_orders] 
where customer_name like  'A%n'

-- in between ALL should be there 
Select distinct customer_name,order_id,order_date from [dbo].[Master_orders] 
where customer_name like  '%All%'


-- '_' single character second letter is a and after that anything
Select distinct customer_name from [dbo].[Master_orders] 
where customer_name like  '_a%'

-- '_' third letter is a and after that anything
Select distinct customer_name from [dbo].[Master_orders] 
where customer_name like  '__a%'


-- '[]' anything within bracket First letter A then second letter n or p 
Select distinct customer_name from [dbo].[Master_orders] 
where customer_name like  'A[ndy]%'

-- '[]' anything within bracket First letter A then second letter wont be n or p 
Select distinct customer_name from [dbo].[Master_orders] 
where customer_name like  'A[^ndy]%'

-- Second letter in range from b to k 
Select distinct customer_name from [dbo].[Master_orders] 
where customer_name like  'A[b-k]%'