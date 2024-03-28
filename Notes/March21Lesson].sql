use AP
go

--select * from ShippingLabels
drop table if exists ShippingLabels
go
create table ShippingLabels
(
	VendorName varchar(50)
	,VendorAddress1 varchar(50)
	,VendorAddress2 varchar(50)
	,VendorCity varchar(50)
	,VendorState char(20)
	,VendorZipcode varchar(10)
)
go

--------------------------------
use AP
go

create or alter trigger InvoicesUpdateShippingLabels
	on Invoices
	after insert, update
as
	insert into ShippingLabels
	select
	v.VendorName 
	,v.VendorAddress1 
	,v.VendorAddress2 
	,v.VendorCity 
	,v.VendorState 
	,v.VendorZipcode 
	from
		Vendors v
		join Inserted i on v.VendorID = i.VendorID
go

--------------------------------
--select * from Invoices where InvoiceID = 100
update Invoices
set
	PaymentTotal = 55.55
	,PaymentDate = getdate()
where
	InvoiceID = 100
go

--------------------------------
use AP
go

--select * from TestUniqueNulls
drop table if exists TestUniqueNulls
create table TestUniqueNulls
(
	RowID int identity not null
	,NoDupName varchar(50) null
)
go

--------------------------------
use ap
go

create trigger NoDuplicates on TestUniqueNulls
after insert, update
as
begin
	if (select
			count(1)
		from
			TestUniqueNulls t
			join Inserted i on t.NoDupName = i.NoDupName) > 1
	begin
		rollback tran;
		throw 50001, 'Duplicate value', 1;
	end
end
--------------------------------
insert into TestUniqueNulls
values(null)

insert into TestUniqueNulls
values(null)

insert into TestUniqueNulls
values('CIS435')

insert into TestUniqueNulls
values('CIS435')

--select * from TestUniqueNulls
go

select
	*
from
	sys.triggers
go