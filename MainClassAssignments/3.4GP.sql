--Nathan Scott
--Question 1
drop view if exists InvoiceBasic
go

create view InvoiceBasic
as
select
	v.VendorID
	,v.VendorName
	,v.DefaultTermsID
	,i.InvoiceNumber
	,i.InvoiceTotal
	,i.InvoiceDueDate
from
	VendorAddress v
	join Invoices i on v.VendorID = i.VendorID 
--Nathan Scott
--Question 1a
select
	*
from 
	InvoiceBasic
where
	VendorName like '[N-P]%'
order by VendorName
--Nathan Scott
--Question 2
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
--Nathan Scott
--Question 3
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
--Nathan Scott
--Question 3a
select
	*
from
	VendorAddress
where
	VendorID = 4
--Nathan Scott
--Question 3b
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
--Nathan Scott
--Question 3c
select
	*
from
	VendorAddress
where
	VendorID = 4
--Nathan Scott
--Question 4
select
	*
from
	sys.foreign_keys