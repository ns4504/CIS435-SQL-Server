select
	i.InvoiceTotal
	,cast(i.InvoiceTotal as decimal(17, 2)) CastTotalToDec
	,'$' + cast(i.InvoiceTotal as varchar) CastTotalToVarChar
	,convert(decimal(17, 2), i.InvoiceTotal) as ConvertTotalToDec
	,'$' + convert(varchar, i.InvoiceTotal, 1) as ConvertTotalToVarchar
	,'||||||||||||||||||||||||||||||||||||||||||||||||||'
	,i.InvoiceDate
	,cast(i.InvoiceDate as varchar) CastDateToVarchar
	,convert(varchar, i.InvoiceDate, 1) ConvertDateToVcStyle1	
	,convert(varchar, i.InvoiceDate, 10) ConvertDateToVcStyle2
	,cast(i.InvoiceDate as real) as CastDateToReal
from
	Invoices i
order by i.InvoiceDate
------------------------------------------------------------------
select
	v.VendorContactFName + ' '
		+ left(v.VendorContactLName, 1) + '.' as ContactName
	,substring(v.VendorPhone,  7, 8) as ContactPhone559AreaCode
from
	Vendors v
where
	left(v.VendorPhone, 5) = '(559)'
------------------------------------------------------------------
select
	i.InvoiceNumber
	,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	,i.InvoiceDueDate
from
	Invoices i
where 
	i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
	and i.InvoiceDueDate < getdate() + 30
------------------------------------------------------------------
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
------------------------------------------------------------------
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
------------------------------------------------------------------
select
	*
from
	(
		select
		i.InvoiceNumber
		,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) as Balance
		,row_number() over (order by i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal)) RowNum
	from
		Invoices i
	where
		i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
	) as subquery
where 
	RowNum <= 3
order by Balance desc
------------------------------------------------------------------
with OrderedInvoices as 
(
	select
		v.VendorID
		,v.VendorName
		,i.InvoiceNumber
		,i.InvoiceDate
		,row_number() over(partition by v.VendorID order by i.InvoiceDate desc) RowNum
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID
)
select
	oi.VendorID
	,oi.VendorName
	,oi.InvoiceNumber
	,oi.InvoiceDate
from
	OrderedInvoices oi
where 
	oi.RowNum = 1
order by oi.VendorID