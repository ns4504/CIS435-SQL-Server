use AP
declare @TotalInvoiceDue money

select
	@TotalInvoiceDue = sum(i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal))
from
	Invoices i
where
	i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0

if @TotalInvoiceDue > 10000
begin
	select
		v.VendorName
		,i.InvoiceNumber
		,i.InvoiceDueDate
		,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID
	where
		i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
end
else
begin
	print 'The balance total is less than $10,000.00.'
end
------------------------------------------------------------
if object_id('tempdb..#FirstInvoice') is not null
	drop table #FirstInvoice
go

select
	i.VendorID
	,min(i.InvoiceDate) FirstInvoiceDate
into #FirstInvoice --select * from #FirstInvoice
from
	Invoices i
group by
	i.VendorID

select
	v.VendorName
	,fi.FirstInvoiceDate
	,i.InvoiceTotal
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join #FirstInvoice fi on i.VendorID = fi.VendorID
		and i.InvoiceDate = fi.FirstInvoiceDate
		
--clean up
drop table #FirstInvoice
------------------------------------------------------------
if object_id('FirstInvoice') is not null
	drop view FirstInvoice
go

--select * from FirstInvoice
create view FirstInvoice as
select
	i.VendorID
	,min(i.InvoiceDate) FirstInvoiceDate
from
	Invoices i
group by
	i.VendorID

--can do this in another query/instance
select
	v.VendorName
	,fi.FirstInvoiceDate
	,i.InvoiceTotal
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join FirstInvoice fi on i.VendorID = fi.VendorID
		and i.InvoiceDate = fi.FirstInvoiceDate
------------------------------------------------------------
declare @TableName varchar(128)

select
	@TableName = min(st.[name])
from
	sys.tables st
where
	st.is_ms_shipped = 0
--order by st.[name]

--print @TableName 
exec ('select count(1) CountOf' + @TableName + ' from ' + @TableName)
------------------------------------------------------------
declare @TableName varchar(128)
declare UserTables cursor static
for 
	select
		st.[name]
	from
		sys.tables st
	where
		st.is_ms_shipped = 0

open UserTables
fetch next from UserTables into @TableName

while @@fetch_status = 0
begin 
	exec('select count(1) RecordCount_' +  @TableName + ' from ' + @TableName)
	fetch next from UserTables into @TableName
end
close UserTables
deallocate UserTables