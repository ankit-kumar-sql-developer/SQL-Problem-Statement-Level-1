
/*
CREATE TABLE Vw_orders (
    order_id INT,
    order_date DATE,
    product_name VARCHAR(20),
    sales INT
);

INSERT INTO Vw_orders (order_id, order_date, product_name, sales) VALUES 
(1, '2023-01-15', 'Laptop', 1200),
(2, '2023-01-17', 'Smartphone', 800),
(3, '2023-01-20', 'Tablet', 600),
(4, '2023-02-05', 'Smartwatch', 300),
(5, '2023-02-08', 'Headphones', 150),
(6, '2023-02-10', 'Monitor', 200),
(7, '2023-02-15', 'Keyboard', 80),
(8, '2023-02-20', 'Mouse', 50),
(9, '2023-03-01', 'Printer', 220),
(10, '2023-03-05', 'Camera', 500);

CREATE TABLE Vwreturns (
order_id INT,
return_date DATE);

INSERT INTO Vwreturns (order_id,return_date) 
VALUES (1, '2023-01-20'),(5, '2023-01-20')

*/

-- View
--drop view if exists view_orders;  

Create view view_orders as (
Select o.*, r.return_date from Vw_orders o
left join Vwreturns r on o.order_id=r.order_id
)


Select * from view_orders  
-- this is not storing data 
-- every time we run underlying query will run 

-- Materlised View

-- Store data, if you insert new record  in table you wont get latest data 

-- refresh materialized view mvw_orders ;