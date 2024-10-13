


create table #emp(
emp_id integer,
emp_name varchar(20),
salary integer,
dob date
);
insert into #emp values(1,'Ankit',10000,'1983-12-02');
insert into #emp values(2,'Mohit',15000,'1974-12-02');
insert into #emp values(3,'Vikas',10000,'1985-12-02');
insert into #emp values(4,'Rohit',5000,'2006-12-02');
insert into #emp values(5,'Mudit',12000,'1967-12-02');

select * from #emp

-- Dynamic way to create insert statment 

Select concat(emp_id,emp_name) from #emp

Select concat('INSERT INTO  #emp values(',emp_id,',',char(39),emp_name,char(39),',',salary,
',',char(39),dob,char(39),');') 
from #emp

