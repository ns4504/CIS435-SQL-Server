--Nathan Scott
--Question 1
use AdventureWorks2019
go

declare @MaxID int
declare @MinID int

select
	@MaxID = max(soh.SalesOrderID)
	,@MinID = min(soh.SalesOrderID)
from
	Sales.SalesOrderHeader soh

print 'Highest Sales Order ID: ' + cast(@MaxID as varchar)
print 'Lowest Sales Order ID: ' + cast(@MinID as varchar)
go

--Nathan Scott
--Question 2
use AdventureWorks2019
go

declare @ID int
set @ID = 70000

select
	*
from
	Sales.SalesOrderHeader soh
where
	soh.SalesOrderID > @ID
go

--Nathan Scott
--Question 3
declare @ID int
declare @FirstName nvarchar(50)
declare @LastName nvarchar(50)

select
	@ID = p.BusinessEntityID
	,@FirstName = p.FirstName
	,@LastName = p.LastName
from
	Person.Person p
where
	p.BusinessEntityID = 1

print cast(@ID as varchar) + ': ' + @FirstName + ' ' + @LastName
go

--Nathan Scott
--Question 4
declare @Count int

select
	@Count = count(1)
from
	Sales.SalesOrderDetail sod

if @Count > 100000
begin
	print 'Over 100,000'
end
else
begin
	print '100,000 or less'
end
go

--Nathan Scott
--Question 5 
begin try
	insert into HumanResources.Department --select * from HumanResources.Department
	values('Engineering', 'Research and Development', '2008-04-30 00:00:00.000')
end try
begin catch
	print 'Error Number: ' + convert(varchar(100), error_number())
	print 'Error Message: ' + convert(varchar(100), error_message())
end catch
go

--Nathan Scott
--Question 6
create or alter function fnFormatPhone
(
	@PhoNum bigint
)

returns table
	return
	(
	select
		format(@PhoNum, '(###) ###-####') PhoneNumber
	)
go

select * from dbo.fnFormatPhone(7577357008)
go
--Nathan Scott
--Question 7
create or alter procedure uspProductSales
	@ProductID int = 0
as 

if @ProductID > 0
begin
select
	p.ProductID
	,count(1) as NumberSold
from 
	Production.Product p
	join Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
where
	p.ProductID = @ProductID
group by
	p.ProductID
end
go

exec dbo.uspProductSales 707
