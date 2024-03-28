declare @VendorName varchar(50), @InvoiceAvg money
declare AvgCursor cursor static
for
	select
		v.VendorName
		,avg(i.InvoiceTotal) InvoiceAvg
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID
	group by
		v.VendorName

open AvgCursor
	fetch next from AvgCursor into @VendorName, @InvoiceAvg

	while @@FETCH_STATUS = 0
	begin
		print @VendorName + ', $' + convert(varchar, @InvoiceAvg, 1)
		fetch next from AvgCursor into @VendorName, @InvoiceAvg
	end
close AvgCursor

deallocate AvgCursor
--------------------------------------------------------------------
declare @TableName varchar(128)
declare @DyanmicSQL varchar(256)
declare SchemaCursor cursor static
for
	select
		[name]
	from
		sys.tables
		 
open SchemaCursor
	--print 'Every table in the AP Database:'
	fetch next from SchemaCursor into @TableName

	while @@fetch_status = 0
	begin
		--print '	> ' + @TableName 
		set @DyanmicSQL = 'select top 1 * from ' + @TableName
		exec(@DyanmicSQL)
		fetch next from SchemaCursor into @TableName
	end
close SchemaCursor
deallocate SchemaCursor
----------------------------------------------------------------------
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
----------------------------------------------------------------------
--select * from Invoices
--select * from InvoiceArchive

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