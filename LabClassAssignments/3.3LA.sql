--Nathan Scott
--Question 1
select
	left(a.AddressLine1, 10) 'First 10 chars–AddressLine1'
from
	Person.[Address] a
--Nathan Scott
--Question 2
select
	substring(a.AddressLine1, 9, 6) 'Characters 10-15 of AddressLine1'
from
	Person.[Address] a
--Nathan Scott
--Question 3
select
	upper(p.FirstName) + ' '
		+ upper(p.LastName) PersonName
from
	Person.Person p
--Nathan Scott
--Question 4
select
	null 'From ProductNumber column:'
	,substring(p.ProductNumber, 4, 4) 'Chars after hyphen'
	,charindex('-', p.ProductNumber) '# characters after hyphen'
from
	Production.Product p
--Nathan Scott
--Question 5
select
	soh.SalesOrderID
	,soh.OrderDate
	,soh.ShipDate
	,datediff(day, soh.OrderDate, soh.ShipDate) 'Days b/w order & ship date'
from
	Sales.SalesOrderHeader soh
--Nathan Scott
--Question 6
select
	convert(varchar, soh.OrderDate, 10) OrderDateNoTime
	,convert(varchar, soh.ShipDate, 10) ShipDateNoTime
from
	Sales.SalesOrderHeader soh
--Nathan Scott
--Question 7
select
	soh.SalesOrderID
	,soh.OrderDate
	,dateadd(month, 6, soh.OrderDate) 'OrderDate + 6 Months'
from
	Sales.SalesOrderHeader soh
--Nathan Scott
--Question 8
select
	soh.SalesOrderID
	,soh.OrderDate
	,year(soh.OrderDate) OrderYear
	,datename(month, soh.OrderDate) OrderMonth
from
	Sales.SalesOrderHeader soh
--Nathan Scott
--Question 9
select
	coalesce(p.Title + ' ', '')
		+ p.FirstName + ' '
		+ coalesce(p.MiddleName + ' ', '')
		+ p.LastName + ' '
		+ coalesce(p.Suffix, '') full_name
from
	Person.Person p
--Nathan Scott
--Question 10
select
	soh.SalesOrderID
	,soh.OrderDate
from
	Sales.SalesOrderHeader soh
order by
	month(soh.OrderDate) 
	,year(soh.OrderDate) 