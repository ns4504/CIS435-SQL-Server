--question 1
--select * from Vendors
--select * from Invoices where VendorID = 123
--when FedEx buys UPS - the merger will cause a name change to "FedUP  
--update invoices for UPS(122) to associate with FedEx(123)
--delete UPS(122)
--update name of UPS(122) to "FedUP"
use AP

begin tran/*saction*/
	update Invoices
		set VendorID = 123
		where VendorID = 122

	delete from Vendors
		where VendorID = 122

	update Vendors
		set VendorName = 'FedUP'
		where VendorID = 12
commit tran/*saction*/

--question 2
begin tran
	insert into InvoiceArchive
		select
			*
		from
			Invoices i
		where 
			i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) = 0

	delete from Invoices
	where InvoiceID in (select InvoiceID
					    from InvoiceArchive)
commit tran