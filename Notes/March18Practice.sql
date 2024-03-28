select top 10
	v.VendorID
	,v.VendorName
	,count(1) NumberOfInvoices
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
group by
	v.VendorID
	,v.VendorName
order by NumberOfInvoices desc