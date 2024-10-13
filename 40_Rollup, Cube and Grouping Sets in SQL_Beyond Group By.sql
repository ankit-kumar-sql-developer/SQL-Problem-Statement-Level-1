

Create table #orders
(
    Id int primary key identity,
    Continent nvarchar(50),
    Country nvarchar(50),
    City nvarchar(50),
    amount int
);
Insert into #orders values('Asia','India','Bangalore',1000)
Insert into #orders values('Asia','India','Chennai',2000)
Insert into #orders values('Asia','Japan','Tokyo',4000)
Insert into #orders values('Asia','Japan','Hiroshima',5000)
Insert into #orders values('Europe','United Kingdom','London',1000)
Insert into #orders values('Europe','United Kingdom','Manchester',2000)
Insert into #orders values('Europe','France','Paris',4000)
Insert into #orders values('Europe','France','Cannes',5000);


Select * from #orders 

-- beyond group by  Rollup,cubes,grouping set

-- Without Rollup
select Continent,country,city,
sum(amount) as total_amount
from #orders group by Continent,country,city

Union all
select Continent,null country,null city,
sum(amount) as total_amount
from #orders group by Continent

Union all
select Continent,country,null city,
sum(amount) as total_amount
from #orders group by Continent,country

Union all
select null Continent,null country,null city,
sum(amount) as total_amount
from #orders 

-- With Rollup
select Continent,country,city,
sum(amount) as total_amount
from #orders group by rollup(Continent,country,city) -- heirarhical data combination

-- With cube
select Continent,country,city,
sum(amount) as total_amount
from #orders group by cube(Continent,country,city) --all data combination

-- With Grouping
select Continent,country,city,
sum(amount) as total_amount
from #orders group by grouping sets ((Continent,country),city) -- custom data combination

-- With Grouping
select Continent,country,city,
sum(amount) as total_amount
from #orders group by grouping sets ((Continent,country),(city),(Continent,city)) 