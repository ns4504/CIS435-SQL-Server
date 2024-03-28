--Query #1
select
	v.*
from
	Vendors v
	left join Invoices i on v.VendorID = i.VendorID
where
	i.InvoiceID is null
--Query #2
--no rows output, VendorID is a primary key
--this means that every invoice will ALWAYS have a vendor
select
	i.*
from
	Invoices I
	left join Vendors v on i.VendorID = v.VendorID
where
	v.VendorID is null