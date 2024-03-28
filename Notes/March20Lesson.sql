--------------------stored procedures---------------------------------
use AP
go

create or alter proc/*edure*/ spBalanceRange
	@VendorName varchar(100) = '%'
	,@BalanceMin money = 0
	,@BalanceMax money = 0
as

if @BalanceMax = 0
begin
	select
		v.VendorName
		,i.InvoiceNumber
		,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID
	where
		v.VendorName like @VendorName
		and i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) >= @BalanceMin
	order by Balance desc
end
else
begin
	select
		v.VendorName
		,i.InvoiceNumber
		,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID
	where
		v.VendorName like @VendorName
		and i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) between @BalanceMin and @BalanceMax
	order by Balance desc	
end
go
-----------------------------------------------------------
exec spBalanceRange 'M%'
exec spBalanceRange @BalanceMin = 200, @BalanceMax = 1000
exec spBalanceRange '[C,F]%', 0, 200
--------------------errors---------------------------------
use AP
go

--exec spInvoicesInDateRange '4/5/04', 'April 5, 2024'
create or alter proc spInvoicesInDateRange
	@DateMin varchar(50) = null
	,@DateMax varchar(50) = null
as

if @DateMin is null or @DateMax is null
	throw 50001, 'The DateMin and DateMax parameters are required.', 1

if not(isdate(@DateMin) = 1 and isdate(@DateMax) = 1)
	throw 50002, 'The date format is not valid. Please use mm/dd/yyyy.', 1

if cast(@DateMin as datetime) > cast(@DateMax as datetime)
	throw 50003, 'The DateMin parameter must be earlier than DateMax.', 1

select 
	i.InvoiceNumber
	,i.InvoiceDate
	,i.InvoiceTotal
	,i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) Balance
from
	Invoices i
where
	i.InvoiceDate between @DateMin and @DateMax
order by i.InvoiceDate
go
--------------------errors cont---------------------------------
use AP
go

begin try
	exec spInvoicesInDateRange '01/01/2012', null
end try
begin catch
	print 'Error Number: ' + convert(varchar(100), error_number())
	print 'Error Message: ' + convert(varchar(100), error_message())
end catch
go
--------------------scalar value function---------------------------------
use AP
go

create or alter function fnUnpaidInvoiceID()
returns int
begin
	return
		(select 
			min(i.InvoiceID)
		from
			Invoices i
		where
			i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal) > 0
			and i.InvoiceDate = (select 
									min(InvoiceDate)
								 from
									Invoices
								 where 
									InvoiceTotal - (CreditTotal + PaymentTotal) > 0))
end
go
--select * from Invoices where InvoiceID = dbo.fnUnpaidInvoiceID() 
--------------------table value function---------------------------------
use AP
go

create or alter function fnInvoicesInDateRange
(
	@DateMin datetime, @DateMax datetime
)
returns table
	return
	(
	select
		*
	from
		Invoices i
	where
		i.InvoiceDate between @DateMin and @DateMax
	)
go
--select * from dbo.fnInvoicesInDateRange('12/24/2011', '5/30/2012')
---------------------------------------------------------------------------------------------------
use AP
go

create or alter function fnInvoiceBalance
(
	@InvoiceID int
)
returns money
begin
	return
	(select 
			i.InvoiceTotal - (i.CreditTotal + i.PaymentTotal)
		from
			Invoices i
		where
			i.InvoiceID = @InvoiceID)
end
go

select
	*
	,dbo.fnInvoiceBalance(InvoiceID) Balance
from
	Invoices