use AP;

select
	v.VendorName
	,v.VendorPhone
	,sum(i.PaymentTotal) as SumPayments
	,count(i.PaymentTotal) as TotalPayments
	,avg(i.PaymentTotal) as AveragePayment
	,max(i.PaymentTotal) as MaxPayment
	,min(i.PaymentTotal) as MinPayment
from
	Invoices i
	join Vendors v on i.VendorID = v.VendorID
group by
	v.VendorName
	,v.VendorPhone