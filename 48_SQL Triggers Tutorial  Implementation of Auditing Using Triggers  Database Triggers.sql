/*
drop table if exists employee_audit
create table employee_audit (
id int identity(1,1),
audit_text varchar(200),
audit_timestamp datetime )


drop table if exists emp_Trigger
create table emp_Trigger(
emp_id int,
emp_name varchar(100),
email_id varchar(200),
salary int);

insert into emp_Trigger
values
(101, 'Ankit', 'Ankit@abc.com',10000);
insert into emp_Trigger
values (102, 'Mohit', 'Mohit@abc.com', 20000);
insert into emp_Trigger
values (103, 'Vikas', 'Vikas@abc.com', 10000);
insert into emp_Trigger
values (104, 'Rohit', 'Rohit@abc.com', 5000);
insert into emp_Trigger
values (105, 'Mudit', 'Mudit@abc.com', 12000);
insert into emp_Trigger
values (106, 'Agam', 'AGAM@ABC.COM', 12000);
insert into emp_Trigger
values (107, 'Sanjay', 'SANJAY@ABC.COM', 9000);


--insert into emp_Trigger
--values (109, 'Ashish', 200,5000);
--insert into emp_Trigger
--values (109, 'Mukesh',300,6000);
--insert into emp_Trigger
--values (110, 'Rakesh',300,7000);

Select * from employee_audit
Select * from emp_Trigger
*/


-- After insert trigger

create or alter trigger tr_emp_onInsert
on emp_Trigger for insert as
begin

Insert into employee_audit
select 'a new employee has been added with employee id '+ cast(emp_id as varchar(10)),
getdate()
from inserted

end 

-- when insert will get inserted data 
insert into emp_Trigger values (108, 'Mukesh','M@abc.com',45000);

-- After Delete

create or alter trigger tr_emp_afterDelete
on emp_Trigger for delete as
begin

Insert into employee_audit
select 'an employee has been delete with employee id '+ cast(emp_id as varchar(10)),
getdate()
from deleted

end 

Delete from emp_Trigger where emp_id=109

-- After Update
create or alter trigger tr_emp_afterUpdate
on emp_Trigger for update as
begin

Insert into employee_audit
select 'the data of employee has been updated with employee id '+ cast(i.emp_id as varchar(10))
+ case when i.emp_name != d.emp_name then ', employee name changed from ' + d.emp_name + ' to '+ i.emp_name
else '' end
+ case when i.salary != d.salary then ', salary changed from ' + cast(d.salary as varchar(100)) + ' to '+ cast(i.salary as varchar(100)) 
else '' end
+ case when i.email_id != d.email_id then ', email_id changed from ' + d.email_id + ' to '+ i.email_id 
else '' end
,getdate()
from  inserted  i
inner join deleted d  on i.emp_id= d.emp_id

end 

Update emp_Trigger set salary = 75000 ,emp_name = 'Demo1' where emp_id >=107