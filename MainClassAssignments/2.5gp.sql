--Nathan Scott
--Question 1
select
	v.VendorName
from
	Vendors v
where 
	v.VendorID in (select
					i.VendorID
				   from
					Invoices i)
order by v.VendorName
--Nathan Scott
--Question 2
select
	i.InvoiceNumber
	,i.InvoiceTotal
from
	Invoices i
where 
	i.PaymentTotal > (select
						avg(i.PaymentTotal)
					  from 
						Invoices i
					  where
						i.PaymentTotal <> 0)
--Nathan Scott
--Question 3
select
	i.InvoiceNumber
	,i.InvoiceTotal
from
	Invoices i
where
	i.PaymentTotal > all(
	select top 50 percent i.PaymentTotal
	from 
		Invoices i
	where 
		i.PaymentTotal <> 0
	order by i.PaymentTotal)
--Nathan Scott
--Question 4
select
	a.AccountNo
	,a.AccountDescription
from
	GLAccounts a
where not exists (
	select
		*
	from
		InvoiceLineItems li
	where
		li.AccountNo = a.AccountNo)
order by a.AccountNo
--Nathan Scott
--Question 5
select
	sum(InvoiceMax) as SumOfMaximums
from
	(select i.VendorID, max(i.InvoiceTotal) as InvoiceMax
	 from
		Invoices i
	where
		i.InvoiceTotal - i.CreditTotal - i.PaymentTotal > 0
	group by 
		i.VendorID) MaxInvoice
--Nathan Scott
--Question 6
with MaxInvoice as
(
	select
		i.VendorID
		,max(i.InvoiceTotal) as InvoiceMax
	from
		Invoices i
	where
		i.InvoiceTotal - i.CreditTotal - i.PaymentTotal > 0
	group by
		i.VendorID
)
select 
	sum(InvoiceMax) SumOfMaximums
from
	MaxInvoice