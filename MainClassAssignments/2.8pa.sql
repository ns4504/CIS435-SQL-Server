--q1
select 
	sod.ProductID
	,count(1) ItemsOrderedPerProduct
from
	Sales.SalesOrderDetail sod
group by
	sod.ProductID
--q2
select
	pr.ProductLine
	,count(pr.ProductID) ProductsPerLine
from
	Production.Product pr
group by
	pr.ProductLine
having
	count(pr.ProductID) > 100
order by
	count(pr.ProductID) desc
--q3
select
	pr.ProductID
	,count(productModelID)
	--,pr.Color
from
	Production.Product pr
where
	pr.Color in ('Blue', 'Red')
group by
	pr.ProductID
	--,pr.Color
having
	count(productModelID) = 1
--q4
select
	soh.OrderDate
	,sum(pr.ProductID) ProductsOrderedToday
from
	Sales.SalesOrderHeader soh
	left join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	left join Production.Product pr on sod.ProductID = pr.ProductID
group by
	soh.OrderDate
--q5
select
	pe.FirstName
		+ ' ' + pe.LastName [Name]
	,count(soh.SalesOrderNumber) OrdersPlaced
from
	Person.Person pe
	left join Sales.Customer c on pe.BusinessEntityID = c.PersonID
	left join sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
group by
	pe.FirstName
		+ ' ' + pe.LastName