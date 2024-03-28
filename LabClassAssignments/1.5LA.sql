--EX 1
SELECT 
	ProductID
	,[Name]
	,Color
	, ListPrice
FROM
	Production.Product
--EX 2
WHERE
	ListPrice > 0

--EX 3
SELECT
	[Name]
FROM
	Sales.Store
WHERE
	[Name] LIKE 'Bike%' 
	OR [Name] LIKE '%Bike'
ORDER BY
	[Name] DESC

--EX 4
SELECT
	AddressLine1
	,AddressLine2
	,City
	,PostalCode
FROM
	Person.[Address]
WHERE
	AddressLine2 != 'NULL'

--EX 5
SELECT
	AddressID
	,AddressLine1
	+', '+AddressLine2
	+', '+City
	+', '+PostalCode
	AS 
		FullAddress
FROM
	Person.[Address]
WHERE
	AddressLine2 != 'NULL'
ORDER BY
	FullAddress ASC

--EX 6
SELECT
	*
FROM
	Sales.CreditCard
WHERE
	CardType = 'SuperiorCard'
	AND ExpMonth = 11
	AND ExpYear = 2006

--EX 7
SELECT
	ProductID
	,StandardCost
FROM
	Production.ProductCostHistory
WHERE
	StandardCost > 10

--EX 8
SELECT
	Quantity
	,ProductID
FROM
	Sales.ShoppingCartItem
WHERE
	/*ShoppingCartItemID >= 1
	AND ShoppingCartItemID <= 4*/
	ShoppingCartItemID BETWEEN 1 AND 4

--EX 9
SELECT
	BusinessEntityID
	,TerritoryID
FROM
	Sales.SalesTerritoryHistory
WHERE
	BusinessEntityID LIKE '28%'

--EX 10
SELECT
	TerritoryID
	,BusinessEntityID
	,DATEDIFF(day, StartDate, EndDate)
	AS
		[Age in days]
FROM
	Sales.SalesTerritoryHistory
WHERE
	StartDate = '05/31/2011'
	AND
	EndDate = '11/29/2012'

--EX 11
SELECT
	*
FROM
	Sales.SalesTerritoryHistory
WHERE
	EndDate IS NULL
	AND	TerritoryID = 1
ORDER BY
	StartDate
	,BusinessEntityID

--EX 12
SELECT
	[Name]
	,CurrencyCode
FROM
	Sales.Currency
WHERE
	CurrencyCode LIKE '[A-C]%'
	AND CurrencyCode LIKE '%[R-T]'
ORDER BY
[Name] ASC

--EX 13
SELECT TOP 3
	[Name]
FROM 
	Person.ContactType
WHERE
	Name LIKE '%Manager'

--EX 14
SELECT
	BusinessEntityID
	,Rate
	,PayFrequency
	,Rate*40 as MonthlyPay
FROM
	HumanResources.EmployeePayHistory
WHERE
	PayFrequency = 1
ORDER BY
 MonthlyPay DESC

--EX 15
SELECT
	LocationID
	,[Name]
	,CostRate
	,[Availability]
FROM
	Production.[Location]
WHERE
	CostRate > 0
	AND [Availability] > 0
	AND [Name] LIKE 'F%'
	OR ([Name] LIKE 'S%')
ORDER BY
	CostRate
	,[Name]