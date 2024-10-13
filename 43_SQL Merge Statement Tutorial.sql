

CREATE TABLE #SourceProducts(
    ProductID  INT,
    ProductName  VARCHAR(50),
    Price   DECIMAL(9,2)
);
CREATE TABLE #TargetProducts(
    ProductID  INT,
    ProductName  VARCHAR(50),
    Price   DECIMAL(9,2)
);


delete from #SourceProducts;
INSERT INTO #SourceProducts VALUES(1,'Table',90),(3,'Chair',70)

delete from #TargetProducts;
INSERT INTO #TargetProducts VALUES(1,'Table',100),(2,'Desk',180)

--merge --> insert,update,delete in single statement

Select * from #SourceProducts
select * from #TargetProducts

--update opeartion -->1 updated 90
--insert 3
merge #TargetProducts as t
using #SourceProducts as s
on  t.productid= s.productid
when matched then update set t.price = s.price , t.productname= s.ProductName 
when not matched by target then
insert values (s.productid,s.ProductName,s.price)
when not matched by source then delete
;


