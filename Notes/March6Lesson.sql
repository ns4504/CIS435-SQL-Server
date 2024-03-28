use AP;
--------------------------------------------------------------------
select distinct
	v.*
from
	Vendors v 
	left join Invoices i on v.VendorID = i.VendorID
where
	i.InvoiceID is null

--------------------------------------------------------------------
select
	*
from
	Vendors v
where
	VendorID not in (select VendorID from Invoices)
--------------------------------------------------------------------
select
	*
from
	Invoices i
where
	PaymentTotal > (select
						avg(PaymentTotal)
					from
						Invoices
					where 
						PaymentTotal <> 0)
order by PaymentTotal
--------------------------------------------------------------------
select
	*
from
	Invoices i
where
	PaymentTotal > ALL(select top 50 percent
						PaymentTotal
					from
						Invoices
					where 
						PaymentTotal <> 0
					order by PaymentTotal)
order by PaymentTotal
--------------------------------------------------------------------
select
	*
from
	GLAccounts acct
where
	not exists (select
					1
				from
					InvoiceLineItems lineItems
				where
					acct.AccountNo = lineItems.AccountNo)
--------------------------------------------------------------------
select
	sum(InvoiceMax) 
from 
	(select
		i.VendorID
		,max(i.InvoiceTotal) InvoiceMax
	from
		Invoices i
	where
		i.InvoiceTotal - i.CreditTotal - i.PaymentTotal > 0
	group by
		i.VendorID) VendorsMaxInvoice
--------------------------------------------------------------------
with VendorsMaxInvoice as
(
	select
		i.VendorID
		,max(i.InvoiceTotal) InvoiceMax
	from
		Invoices i
	where
		i.InvoiceTotal - i.CreditTotal - i.PaymentTotal > 0
	group by
		i.VendorID
)
select
	sum(InvoiceMax)
from
	VendorsMaxInvoice
--------------------------------------------------------------------
with VendorsMaxInvoice2 as
(
	select
		i.VendorID
		,max(i.InvoiceTotal) InvoiceMax
	from
		Invoices i
	where
		i.InvoiceTotal - i.CreditTotal - i.PaymentTotal > 0
	group by
		i.VendorID
)
select
	*
from
	Vendors v
	join VendorsMaxInvoice2 vmiCte on v.VendorID = vmiCte.VendorID
--------------------------------------------------------------------
drop table if exists InvoiceCopy
--create a copy of invoices (named InvoiceCopy)
select
	i.*
into InvoiceCopy --create a new table with the specified records
from 
	Invoices i

select * from InvoiceCopy ic

drop table if exists VendorCopy
--create a copy of invoices (named InvoiceCopy)
select
	v.*
into VendorCopy --create a new table with the specified records
from 
	Vendors v

select * from VendorCopy vc

delete from VendorCopy
where VendorState <> 'CA'

insert into VendorCopy
select
	VendorName
	,VendorAddress1	
	,VendorAddress2
	,VendorCity
	,VendorState
	,VendorZipCode
	,VendorPhone
	,VendorContactLName
	,VendorContactFName
	,DefaultTermsID
	,DefaultAccountNo
from
	Vendors
where VendorState <> 'CA'


update Vendors --we updated the default table account no to 403
set 
	DefaultAccountNo = 403
where
	DefaultAccountNo = 400

select 
	*
from
	Vendors
where
	DefaultAccountNo = 403

select 
	* 
from 
	GLAccounts 
where 
	AccountNo = 400
	or AccountNo = 403

select
	*
from
	InvoiceCopy
order by PaymentDate desc

update InvoiceCopy
set 
	PaymentTotal = InvoiceTotal - CreditTotal
	,PaymentDate = getdate()
where
	InvoiceTotal - CreditTotal - PaymentTotal > 0

delete from VendorCopy --select * from VendorCopy
where
	VendorState not in (select distinct
							v.VendorState
						from
							VendorCopy v
							join InvoiceCopy i on v.VendorID = i.VendorID)