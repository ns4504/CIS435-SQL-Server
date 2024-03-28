use AdventureWorks2019;
--EX1
select
	count(1) as TotalProducts
from
	Production.Product
--EX2
select
	count(ProductSubcategoryID) as TotalSubcategoryProducts
from
	Production.Product
--EX3
select
	ProductSubcategoryID
	,count(1) as CountedProducts
from
	Production.Product
group by
	ProductSubcategoryID
--EX4
select
	cr.[Name] Country
	,sp.[Name] Province
from
	Person.CountryRegion cr
	join Person.StateProvince sp 
		on cr.CountryRegionCode = sp.CountryRegionCode 
--EX5
select
	cr.[Name] Country
	,sp.[Name] Province
from
	Person.CountryRegion cr
	join Person.StateProvince sp 
		on cr.CountryRegionCode = sp.CountryRegionCode 
where 
	cr.CountryRegionCode = 'CA'
	or cr.CountryRegionCode = 'DE'
--EX6
select
	avg(CommissionPct) as AverageCommissionPct
from
	Sales.SalesPerson
--EX7
select
	count(Gender) AllMaleEmployees
from
	HumanResources.Employee
where
	Gender = 'M'
--EX8
select
	max(ListPrice) 'Max List Price'
	,min(ListPrice) 'Min List Price'
from
	Production.Product
where
	ListPrice > 0.00
--EX9
select
	ProductID
	,LineTotal as 'Total'
from
		Sales.SalesOrderDetail
group by cube(
	LineTotal, ProductID --the query was missing 'ProductID'
	)
--EX10
select
	format(HireDate, 'MM/dd/yy') as HireDate
from
	HumanResources.Employee
--EX11a: 701 rows
select
	*
from
	Sales.Customer c
	left join Sales.SalesOrderHeader s on c.CustomerID = s.CustomerID
where
	s.SalesOrderID is null
--EX11b: 701 rows
select
	*
from
	Sales.Customer
where
	CustomerID not in (
	select
		CustomerID
	from
		Sales.SalesOrderHeader
	where
		CustomerID is not null)
--EX11c
select
	*
from
	Sales.Customer c
where not exists (
	select
		CustomerID
	from
		Sales.SalesOrderHeader s
	where
		c.CustomerID = s.CustomerID)
--EX12
select
	AccountNumber
	,TotalDue
	,OrderDate
from (
	select
		AccountNumber
		,TotalDue
		,OrderDate
		,row_number() over (partition by AccountNumber order by TotalDue desc) as Top5
	from
		Sales.SalesOrderHeader
	where AccountNumber in (
		select
			AccountNumber
		from
			Sales.SalesOrderHeader
		group by
			AccountNumber
		having
			sum(TotalDue) > 70000
	)
) Top5Highest
where 
	Top5 <= 5
order by
	AccountNumber
	,OrderDate desc