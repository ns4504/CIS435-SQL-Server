--Nathan Scott
--Question 1
use AdventureWorks2019;
declare CustomerProductCursor cursor
for
	select
		pe.LastName + ', '
			+ left(pe.FirstName, 1) + '.' CustomerName
		,pr.[Name] ProductName
		,count(1) ProductAmount
	from
		Sales.Customer c
		join Person.Person pe on c.PersonID = pe.BusinessEntityID
		join Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
		join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
		join Production.Product pr on sod.ProductID = pr.ProductID
	group by pe.LastName, pe.FirstName, pr.[Name]
	order by CustomerName;

open CustomerProductCursor
fetch next from CustomerProductCursor 

while @@fetch_status = 0
begin
	fetch next from CustomerProductCursor 
end
close CustomerProductCursor
deallocate CustomerProductCursor

--Nathan Scott
--Question 2
use AdventureWorks2019;

declare @CustomerName varchar(128)
declare @OrderTotal money
declare CustomerProductCursor cursor
for
	select
		 pe.LastName + ', '
			+ left(pe.FirstName, 1) + '.' CustomerName
		,sum(soh.TotalDue) OrderTotal
	from
		Sales.Customer c
		join Person.Person pe on c.PersonID = pe.BusinessEntityID
		join Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
	group by pe.LastName, pe.FirstName;

open CustomerProductCursor;
fetch next from CustomerProductCursor into @CustomerName, @OrderTotal;

while @@fetch_status = 0 
begin
	print @CustomerName + ', $' + convert(varchar(20), @OrderTotal);
	fetch next from CustomerProductCursor into @CustomerName, @OrderTotal;
end

close CustomerProductCursor;
deallocate CustomerProductCursor;

--Nathan Scott
--Question 3
begin tran
	declare @name nvarchar(50) = 'Golfing Glovees '
	declare @catdesc xml = null
	declare @instr xml = null
	declare @rowguid uniqueidentifier = '57389F22-8B3A-4F9D-A1C7-62E541D9A73B'
insert into Production.ProductModel
values 
(
	@Name
	,@catdesc
	,@instr
	,@rowguid
	,getdate()
)
commit tran

--Nathan Scott
--Question 4
create login CIS435_user1 with password = 'P@ssword1',
	default_database = AdventureWorks2019;

create user CIS435_user1 for login CIS435_user1;

alter role db_datareader add member CIS435_user1;