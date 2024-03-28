select
	v.VendorID
	,v.VendorName
	,v.VendorContactFName
	 + ' ' + v.VendorContactLName VendorName
	 ,i.InvoiceNumber
	 ,format(i.InvoiceDate, 'MM-dd-yyyy') InvoiceDate
	 ,li.InvoiceLineItemDescription
	 ,li.InvoiceLineItemAmount
from
	Vendors v
	left join Invoices i on v.VendorId = i.VendorID
	left join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
where
	i.InvoiceNumber is not null
order by
	v.VendorName
	,i.InvoiceDate desc
	,li.InvoiceSequence
----------------------------------------------------------------------------------
with MostRecentInvoice as (
	select
		v.VendorID
		,v.VendorName
		,v.VendorContactFName
		,v.VendorContactLName
		,i.InvoiceNumber
		,i.InvoiceDate
		,li.InvoiceLineItemDescription
		,li.InvoiceLineItemAmount
		,dense_rank() over (partition by v.VendorID order by i.InvoiceDate desc) RecentInvoices
	from
		Vendors v
		left join Invoices i on v.VendorId = i.VendorID
		left join InvoiceLineItems li on i.InvoiceID = li.InvoiceID		
	/*where
		i.InvoiceNumber is not null*/
)
		
select
	mri.VendorID
	,mri.VendorName
	,mri.VendorContactFName
	+ ' ' + mri.VendorContactLName VendorContactName
	,mri.InvoiceNumber
	,format(mri.InvoiceDate, 'MM-dd-yyyy') InvoiceDate
	,mri.InvoiceLineItemDescription
	,mri.InvoiceLineItemAmount
from
	MostRecentInvoice mri
where
	mri.RecentInvoices = 1
order by
	mri.VendorName
