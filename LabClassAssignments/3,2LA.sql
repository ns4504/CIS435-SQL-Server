--Nathan Scott
--Example 1
select
	datalength(pd.Description) 'Length of Each Description'
from
	Production.ProductDescription pd
--Nathan Scott
--Example 2
select
	c.CurrencyCode
	,left([name], 3) 'First 3 Letters of Currency Name'
from
	Sales.Currency c
--Nathan Scott
--Example 3
select
	p.[Name]
	,datediff(day, p.SellStartDate, p.SellEndDate) 'Days for Sell'
from
	Production.Product p
where
	p.SellEndDate is not null
--Nathan Scott
--Example 4
select
	e.BusinessEntityID
	,left(e.HireDate, 7) HireDate
from
	HumanResources.Employee e
--Nathan Scott
--Example 5
select
	left(p.FirstName, 1) + '. '
		+ isnull(left(p.MiddleName, 1) + '. ', '')
		+ p.LastName 'Person Name'
from
	Person.Person p
--Nathan Scott
--Example 6
select
	e.JobTitle
	,count(e.OrganizationLevel) 'Organization Levels Per Title'
from
	HumanResources.Employee e
group by
	e.JobTitle