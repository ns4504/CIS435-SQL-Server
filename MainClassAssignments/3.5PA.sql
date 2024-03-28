--Nathan Scott
--Question 1
select
	convert(varchar, p.ProductID) + ': '
		+p.[Name] as ProductDescriptionConvert
	,cast(p.ProductID as varchar) + ': '
		+p.[Name] as ProductDescriptionCast
from
	Production.Product p
--Nathan Scott
--Question 2
select
	left(a.AddressLine1, 10) First10OfAddrLine1
from
	Person.[Address] a
--Nathan Scott
--Question 3
select
	soh.SalesOrderID
	,soh.OrderDate
	,soh.ShipDate
	,datediff(day, soh.OrderDate, soh.ShipDate) DaysTpShip
from
	Sales.SalesOrderHeader soh
--Nathan Scott
--Question 4
select
	soh.SalesOrderID
	,OrderDate
	,year(soh.OrderDate) OrderYear
	,month(soh.OrderDate) OrderMonth
from
	Sales.SalesOrderheader soh
--Nathan Scott
--Question 5
select
	case
		when OrderQty < 10 then 'Under 10'
		when OrderQty >= 10 and OrderQty <= 19 then '10-19'
		when OrderQty >19 and OrderQty <= 29 then '20-29'
		when OrderQty >29 and OrderQty <= 39 then '30-39'
		else '40 and over'
	end AmountOfOrders
	,SalesOrderID
	,OrderQty
from
	Sales.SalesOrderDetail
--Nathan Scott
--Question 6
select
	p.PersonType
	,p.FirstName + ' '
		+coalesce(p.MiddleName + ' ', '')
		+p.LastName [PersonName]
from
	Person.Person p
order by
	case
		when p.PersonType = 'IN' then p.LastName
		when p.PersonType = 'SP' then p.LastName
		when p.PersonType = 'SC' then p.LastName
		else p.FirstName
	end
--Nathan Scott
--Question 7
with CountJobs as 
(
	select
		e.JobTitle
		,count(1) NumberOfJobsPerTitle
	from
		HumanResources.Employee e
	group by e.JobTitle
)
select
	p.FirstName
	,p.LastName
	,e.HireDate
	,cj.*
from
	HumanResources.Employee e
	join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
	join CountJobs cj on e.JobTitle = cj.JobTitle
--Nathan Scott
--Question 8
select
	soh.CustomerID
	,soh.SalesOrderID
	,soh.OrderDate
from
	Sales.SalesOrderHeader soh
	join (select
			soh2.CustomerID
			,count(soh2.CustomerID) as countOrders
		from
			Sales.SalesOrderHeader soh2
		group by
			soh2.CustomerID) sohSub on soh.CustomerID = sohSub.CustomerID
where 
	countOrders >= 5
order by soh.CustomerID