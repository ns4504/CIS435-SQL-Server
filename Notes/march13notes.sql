drop view if exists InvoiceBasic
go

create view InvoiceBasic
as
select
	v.VendorID
	,v.VendorName
	,v.DefaultTermsID
	,v.VendorFullAddress
	,i.InvoiceNumber
	,i.InvoiceTotal
	,i.InvoiceDueDate
from
	VendorAddress v
	join Invoices i on v.VendorID = i.VendorID 
go 

select 
	* 
from 
	InvoiceBasic ib
	join Terms t on ib.DefaultTermsID = t.TermsID
go
-------------------------------------------------------
drop view if exists Top10PaidInvoices
go

create view Top10PaidInvoices
as
select top 10
	v.VendorID
	,v.VendorName
	,max(i.InvoiceDate) LatestInvoiceDate
	,sum(i.InvoiceTotal) SumOfInvoiceTotal
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID 
where
	i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) = 0 --invoice already paid
group by
	v.VendorID
	,v.VendorName
order by SumOfInvoiceTotal desc
go

select
	*
from
	Top10PaidInvoices
-------------------------------------------------------
drop view if exists VendorAddress
go

create view VendorAddress
as
select
	*
	,v.VendorAddress1 + ' '
		+ isnull(v.VendorAddress2 + ' ', '')
		+ v.VendorCity + ', '
		+ v.VendorState + '  '
		+ v.VendorZipCode VendorFullAddress
from
	Vendors v
go
-------------------------------------------------------
select
	*
from
	VendorAddress

update VendorAddress
set
	VendorAddress1 = '1990 Westwood Blvd'
	,VendorAddress2 = 'Ste 260'
where
	VendorID = 4

update VendorAddress
set
	VendorAddress1 = '4420 N. First Street'
	,VendorAddress2 = 'Suite 108'
where
	VendorID = 14

update VendorAddress
set
	VendorAddress1 = '1483 Chain Bridge Rd '
	,VendorAddress2 = 'Ste 202'
where
	VendorID = 31

--update VendorAddress
--set
--	VendorFullAddress = '123 Main Street LA, CA  12345'
--where
--	VendorID = 4
--go
-------------------------------------------------------