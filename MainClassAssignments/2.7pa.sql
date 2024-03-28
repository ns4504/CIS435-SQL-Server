use AdventureWorks2019;
--q1
select
	p.Color
	,p.Size
	,pm.CatalogDescription
from
	Production.ProductModel pm
	join Production.Product p on pm.ProductModelID = p.ProductModelID
--q2
select
	p.FirstName
	,p.LastName
	,c.CustomerID
	,c.StoreID
	,c.TerritoryID
from
	Person.Person p
	left join Sales.Customer c on p.BusinessEntityID = c.PersonID
--q3
select
	sod.SalesOrderID
	,p.*
from
	Production.Product p
	left join Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
--q4
select
	sod.SalesOrderID
	,p.*
from
	Production.Product p
	left join Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
where
	sod.SalesOrderID is null
--q5
select
	pe.FirstName
	,pe.LastName
	,pr.[Name]
from
	Person.Person pe
	left join Sales.Customer c on pe.BusinessEntityID = c.PersonID
	left join Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
	left join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	left join Production.Product pr on sod.ProductID = pr.ProductID