--Name: Nathan Scott
--Question 1
select
	v.VendorContactFName + ' '
		+ left(v.VendorContactLName, 1) + '.' as ContactName
	,substring(v.VendorPhone,  7, 8) as ContactPhone559AreaCode
from
	Vendors v
where
	left(v.VendorPhone, 5) = '(559)'
order by ContactName
--Name: Nathan Scott
--Question 2
select
	i.InvoiceNumber
	,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	,i.InvoiceDueDate
from
	Invoices i
where 
	i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
	and i.InvoiceDueDate < getdate() + 30
--Name: Nathan Scott
--Question 3
select
	i.InvoiceNumber
	,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	,i.InvoiceDueDate
from
	Invoices i
where 
	i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
	and i.InvoiceDueDate < cast(cast(year(getdate()) as char(4)) + '-'
							+ cast(month(getdate()) + 1 as char(2)) + '-01' as datetime)
--Name: Nathan Scott
--Question 4
select
	case
		when grouping(a.AccountDescription) = 1 then '*ALL*'
		else a.AccountDescription
	end as AccountDescription
	,case
		when grouping(v.VendorState) = 1 then '*ALL*'
		else v.VendorState
	end as VendorState
	,sum(li.InvoiceLineItemAmount) LineItemAmountSum
from 
	GLAccounts a
	join InvoiceLineItems li on a.AccountNo = li.AccountNo
	join Invoices i on li.InvoiceID = i.InvoiceID
	join Vendors  v on i.VendorID = v.VendorID
group by 
	a.AccountDescription
	,v.VendorState with cube
order by
	AccountDescription, VendorState
--Name: Nathan Scott
--Question 5
select
	*
from
	(
		select
		i.InvoiceNumber
		,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) as Balance
		,rank() over (order by i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal)) Rank
	from
		Invoices i
	where
		i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
	) as subquery
order by Balance desc