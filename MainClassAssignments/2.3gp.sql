--Name: Nathan Scott
--Question 1
use AP;

select
	v.*
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID

--Name: Nathan Scott
--Question 2
select
	v.VendorName
	,i.InvoiceNumber
	,i.InvoiceDate
	,i.InvoiceTotal
	- (i.PaymentTotal
	+ i.CreditTotal) Balance
from
	Vendors v --select * from Vendors
	join Invoices i on v.VendorID = i.VendorID --select * from Invoices
where
	i.InvoiceTotal
	- (i.PaymentTotal
	+ i.CreditTotal) <> 0
order by VendorName

--Name: Nathan Scott
--Question 3
select
	v.VendorName
	,v.DefaultAccountNo
	,a.AccountDescription
from
	Vendors v
	join GLAccounts a on v.DefaultAccountNo = a.AccountNo
order by
	AccountDescription
	,VendorName

--Name: Nathan Scott
--Question 4
use L_LUNCHES
select
	e.FIRST_NAME
	+ ' ' + e.LAST_NAME FullName
	,l.LUNCH_DATE
	,f.[DESCRIPTION]
	,li.QUANTITY
	,s.SUPPLIER_NAME
from
	L_EMPLOYEES e
	left join L_LUNCHES l on e.EMPLOYEE_ID = l.EMPLOYEE_ID
	left join L_LUNCH_ITEMS li on l.LUNCH_ID = li.LUNCH_ID
	left join L_FOODS f on li.PRODUCT_CODE = f.PRODUCT_CODE
	left join L_SUPPLIERS s on f.SUPPLIER_ID = s.SUPPLIER_ID