--question 1
use AdventureWorks2019
declare @Count int

select
	@Count = count(1)
from
	Sales.SalesOrderDetail

if @Count > 100000
begin
	print('Over 100,000')
end
else
begin
	print('100,000 or less')
end
go

--question 2
if month(getdate()) = 9 or month(getdate()) = 10
begin
	print('The month is ' + format(getdate(), 'MMMM', 'en-US'))
end
else if year(getdate()) % 2 = 0
begin
	print('The year is even')
end
else
begin
	print('The year is odd')
end
go

--question 3
if exists 
	(select
		SalesOrderID
	from
		Sales.SalesOrderHeader
	where
		SalesOrderID = 1
)
begin
	print('There is a SalesOrderID = 1')
end
else
begin
	print('There is not a SalesOrderID = 1')
end
go

--question 4
use AdventureWorks2019
go

create or alter function dbo.fn_AddTwoNumbers
(
	@num1 int
	,@num2 int
)
returns int
as
begin
	declare @sum int
	select
		@sum = @num1 + @num2
	return @sum
end
go

select dbo.fn_AddTwoNumbers(12, 12) 
go

--question 5
use AdventureWorks2019
go

create or alter function dbo.fn_RemoveNumbers
(
	@UserString varchar(250)
)
returns varchar(250)
as
begin
	declare @Numbers as varchar(50) = '%[0-9]%'
	while patindex(@Numbers, @UserString) > 0
		set @UserString = stuff(@UserString, patindex(@Numbers, @UserString), 1, '')

	return @UserString
end
go

select dbo.fn_RemoveNumbers('3233fff12024')
go

--question 6
use AdventureWorks2019
go

create or alter proc dbo.usp_CustomerTotals
as
begin
	select
		c.CustomerID
		,sum(soh.TotalDue) TotalDue
		,year(soh.OrderDate) 'Year'
		,datename(month, (soh.OrderDate)) 'Month'
	from
		Sales.SalesOrderHeader soh
		join Sales.Customer c on soh.CustomerID = c.CustomerID 
	group by
		c.CustomerID
		,year(soh.OrderDate)
		,datename(month, (soh.OrderDate))
	order by c.CustomerID
end
go

exec dbo.usp_CustomerTotals
go

--question 7
create or alter proc dbo.usp_CustomerTotals @CustomerID int
as
begin
	select
		c.CustomerID
		,sum(soh.TotalDue) TotalDue
		,year(soh.OrderDate) 'Year'
		,datename(month, (soh.OrderDate)) 'Month'
	from
		Sales.SalesOrderHeader soh
		join Sales.Customer c on soh.CustomerID = c.CustomerID 
	where c.CustomerID = @CustomerID
	group by
		c.CustomerID
		,year(soh.OrderDate)
		,datename(month, (soh.OrderDate))
end
go

exec dbo.usp_CustomerTotals @CustomerID = 30000
go

--question 8
use AdventureWorks2019
go

create or alter proc dbo.usp_ProductSales @ProductID int
as
begin
	declare @OrderQty int
	select
		@OrderQty = OrderQty
	from
		Sales.SalesOrderDetail
	where ProductID = @ProductID

	print 'Numbers of items sold for Product ' 
		+ cast(@ProductID as varchar(10)) + ': '
		+ cast(@OrderQty as varchar(10))
end
go
--select OrderQty, ProductID from Sales.SalesOrderDetail
exec dbo.usp_ProductSales @ProductID = 714