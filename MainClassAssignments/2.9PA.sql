--Nathan Scott
--Question 1
select
	p.[Name]
	,p.ProductNumber
from
	Production.Product p
	join Purchasing.PurchaseOrderDetail pod on p.ProductID = pod.ProductID
where
	pod.PurchaseOrderID is not null
--Nathan Scott
--Question 2
select distinct 
	p.Color
from
	Production.Product p
	left join Production.ProductColor pc on p.Color = pc.Color
where p.Color = pc.Color
--Nathan Scott
--Question 3
select
	p.ModifiedDate
from
	Person.Person p
union
select
	e.HireDate
from
	HumanResources.Employee e
--Nathan Scott
--Question 4
with AllCustomers as (
select
	soh.SalesOrderID
	,soh.OrderDate
	,soh.CustomerID
from
	Sales.SalesOrderHeader soh
where
	soh.OrderDate like '%2011%'
)
select
	*
from
	AllCustomers ac
	join Sales.Customer c on ac.CustomerID = c.CustomerID
--Nathan Scott
--Question 5
insert into
	Production.Product (
		[Name] ,ProductNumber ,MakeFlag
		,FinishedGoodsFlag ,SafetyStockLevel
		,ReorderPoint ,StandardCost ,ListPrice
		,DaysToManufacture ,SellStartDate
		,rowguid ,ModifiedDate
	)
values (
		'AwesomeProduct' ,'TB-1234' ,1 ,0
		,800 ,600 ,0.00 ,0.00 ,1 ,getdate()
		,'694215B7-08F7-4C0D-ACB1-D734BA44C3C9'
		,getdate()
	)
select * from Production.Product where [Name] = 'AwesomeProduct'
--Nathan Scott
--Question 6
Update
	Person.PersonPhone
set
	PhoneNumber = Replace(PhoneNumber, '(11)', '(757)')
where
	PhoneNumberTypeID = 3
--Nathan Scott
--Question 7
delete from
	Production.Product
where 
	[Name] = 'AwesomeProduct'