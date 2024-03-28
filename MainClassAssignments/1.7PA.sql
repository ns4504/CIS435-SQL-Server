--Step 1
select
	VendorContactLName
	,VendorContactFName
	,VendorName
from
	dbo.Vendors
order by
	VendorContactLName
	,VendorContactFName

--Step 2
select
	InvoiceNumber as Number
	,InvoiceTotal as Total
	,PaymentTotal + CreditTotal as Credits
	,InvoiceTotal - (PaymentTotal 
		+ CreditTotal) as Balance
from
	dbo.Invoices

--Step 3
select
	VendorContactLName
	+', '+VendorContactFName
	as 'Full Name'
from
	dbo.Vendors
order by
	VendorContactLName
	,VendorContactFName

--Step 4
select
	InvoiceTotal
	,InvoiceTotal*.1 as '10%'
	,InvoiceTotal + InvoiceTotal*.1 as 'Plus 10%'
from
	dbo.Invoices
where
	--Formula for Balance Due:
	InvoiceTotal - PaymentTotal - CreditTotal > 1000
order by
	InvoiceTotal desc

--Step 5
select
	InvoiceNumber as Number
	,InvoiceTotal as Total
	,PaymentTotal + CreditTotal as Credits
	,InvoiceTotal - (PaymentTotal 
		+ CreditTotal) as Balance
from
	dbo.Invoices
where 
	InvoiceTotal >= 500
	and InvoiceTotal <= 10000

-- step 6
select
	VendorContactLName
	+', '+VendorContactFName
	as 'Full Name'
from
	dbo.Vendors
where
	VendorContactLName like 'A%'
	or VendorContactLName like 'B%'
	or VendorContactLName like 'C%'
	or VendorContactLName like 'E%'
order by
	VendorContactLName
	,VendorContactFName

--Step 7
select
	CASE
		WHEN PaymentDate is null 
			and InvoiceTotal - PaymentTotal - CreditTotal > 0
		THEN 'Valid Payment Date'
		ELSE 'Invalid Payment Date'
	END 
	,PaymentDate
	,InvoiceTotal
	,PaymentTotal
	,CreditTotal
	,InvoiceTotal - PaymentTotal - CreditTotal as BalanceDue
from
	dbo.Invoices
where
	PaymentDate is null
	and InvoiceTotal - PaymentTotal - CreditTotal > 0
	or PaymentDate is not null
		and InvoiceTotal - PaymentTotal - CreditTotal <= 0