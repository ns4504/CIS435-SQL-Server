use AP;

select
	isNull(a.AccountDescription, 'TOTAL') as 'AccountDescription' --isNull allows the rollup below to have a value in the desc
	/*,count(1) as LineItemCount 
		Counts every record:
			>count(*) is the slowest (scans EVERY column)
			>count(VendorID) is medium speed (scans ONE column, use primary key(non-null))
			>count(1) is the fastest (scans NO columns, can be any number)*/
	,sum(li.InvoiceLineItemAmount) as 'LineItemSum'
from
	GLAccounts a
	join InvoiceLineItems li on a.AccountNo = li.AccountNo
group by
	a.AccountDescription with rollup --rollup combined everything and displays at the end
having --this is the "where" clause for aggregate functions(count, sum, etc.), similarly, cannot use aliases
	count(1) > 1
--------------------------------------------------------------------------------------------------------------

select
	v.VendorName
	,count(li.AccountNo) as 'Accounts'
	,count(distinct li.AccountNo) as 'DistinctAccounts'
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
group by
	v.VendorName