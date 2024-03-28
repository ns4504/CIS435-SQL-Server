--Nathan Scott
--Question 1
select
	i.VendorID
	,sum(i.PaymentTotal)  PaymentSum
from
	Invoices i
group by i.VendorID
--Nathan Scott
--Question 2
select top 10
	v.VendorName
	,sum(i.PaymentTotal) PaymentSum
from
	Vendors v
	join invoices i on v.VendorID = i.VendorID
group by v.VendorName
order by PaymentSum desc
--Nathan Scott
--Question 3
select
	a.AccountDescription
	,count(1) LineItemCount
	,sum(li.InvoiceLineItemAmount) LineItemSum
from
	GLAccounts a
	join InvoiceLineItems li on a.AccountNo = li.AccountNo
group by
	a.AccountDescription
having 
	count(1) > 1
order by LineItemCount desc;
--Nathan Scott
--Question 4
select
	li.AccountNo
	,sum(li.InvoiceLineItemAmount) LineItemSum
from
	InvoiceLineItems li
group by li.AccountNo with rollup
--Nathan Scott
--Question 5
select
	v.VendorName
	,a.AccountDescription
	,count(1) LineItemCount
	,sum(li.InvoiceLineItemAmount) LineItemSum
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
	join GLAccounts a on li.AccountNo = a.AccountNo
group by v.VendorName, a.AccountDescription
order by v.VendorName, a.AccountDescription
--Nathan Scott
--Question 6
select
	v.VendorName
	,count(distinct li.AccountNo) 'Number of Accounts'
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
group by v.VendorName
having count(distinct li.AccountNo) > 1