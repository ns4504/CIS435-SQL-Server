--ns4504 Q1
drop table if exists
	InvoiceCopy;
drop table if exists
	VendorCopy;

select
	*
into
	InvoiceCopy
from
	Invoices;

select
	*
into
	VendorCopy
from
	Vendors;
--ns4504 Q2
insert into
	InvoiceCopy
values (
	32
	,'AX-014-027'
	,'2012-6-21'
	,434.58
	,0
	,0
	,2
	,'2012-07-08'
	,NULL
);
--ns4504 Q3
insert into
	VendorCopy
select
	VendorName
	,VendorAddress1
	,VendorAddress2
	,VendorCity
	,VendorState
	,VendorZipCode
	,VendorPhone
	,VendorContactLName
	,VendorContactFName
	,DefaultTermsID
	,DefaultAccountNo
from
	Vendors
where
	VendorState <> 'CA';
--ns4504 Q4
update 
	VendorCopy
set 
	DefaultAccountNo = 403
where
	DefaultAccountNo = 400;
--ns4504 Q5
update
	InvoiceCopy
set
	PaymentDate = GETDATE()
	,PaymentTotal = InvoiceTotal - CreditTotal
where
	InvoiceTotal - CreditTotal - PaymentTotal > 0;
--ns4504 Q6
delete from
	VendorCopy
where
	VendorState = 'MN';
--ns4504 Q7
delete from	
	VendorCopy
where
	VendorState not in (
	select distinct
		VendorState
	from
		VendorCopy vc
		join InvoiceCopy ic on vc.VendorID = ic.VendorID);
	)