use AP;
go

/*
	select * from Invoices;
	select * from Vendors;
*/
------------------\/ 202 records \/-----------------------
select
	v.*
	,'||||||||||||||||||'
	,i.*
from
	Vendors v
	left join Invoices i on v.VendorID = i.VendorID
where
	v.VendorState = 'CA'
	and	  (i.PaymentTotal < 1000
		or i.PaymentTotal is null)
order by
	v.VendorID
------------------\/ 114 records \/-----------------------
select
	v.*
	,'||||||||||||||||||'
	,i.* 
from
	Vendors v
	right join Invoices i on v.VendorID = i.VendorID
order by
	v.VendorID