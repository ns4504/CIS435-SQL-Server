--Nathan Scott
--Exercise 2
use AP_AllObjects;
go

create role CIS435l;
grant select on GLAccounts to CIS435l;
grant insert, update, delete on Invoices to CIS435l;
grant select on schema :: dbo to CIS435l;
go

--Nathan Scott
--Exercise 3
create login cis435l_user1 with password = '!Password1' 
	,default_database = AP_AllObjects;
create user cis435l_user1 for login cis435l_user1; 
alter role CIS435l add member cis435l_user1;

--Nathan Scott
--Exercise 4
insert into Invoices
values(122, '989319-467', getdate(), 3813.34, 3813.34, 0.00, 3, getdate(), getdate());
select * from Invoices;

update Invoices
set VendorID = 123
where InvoiceID = (select max(InvoiceID) from Invoices);
select * from Invoices;

delete from Invoices
where InvoiceID = (select max(InvoiceID) from Invoices);
select * from Invoices;