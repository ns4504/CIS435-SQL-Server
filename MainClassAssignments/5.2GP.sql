---Question 1------------------------------------------------------
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
	fetch next from AvgCursor

	while @@FETCH_STATUS = 0
	begin
		fetch next from AvgCursor
	end
close AvgCursor

deallocate AvgCursor
---Question 2------------------------------------------------------
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
---Question 3-------------------------------------------------------
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