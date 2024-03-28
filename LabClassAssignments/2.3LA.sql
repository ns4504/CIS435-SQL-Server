--q1
select
	c.CompanyName
from
	SalesLT.Customer c
	join SalesLT.CustomerAddress ca on c.CustomerID = ca.CustomerID --select * from SalesLT.CustomerAddress
	join SalesLT.[Address] a on ca.AddressID = a.AddressID --select * from SalesLT.[Address]
where
	a.City = 'Dallas'
--q2
select
	p.[Name]
	,p.ProductNumber
	,p.ListPrice
	,sod.OrderQty
from
	SalesLT.Product p 
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
where
	p.ListPrice > 1000
	and sod.OrderQty is not null
--q3
select
	c.CompanyName
from
	SalesLT.Customer c
	join SalesLT.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
where 
	soh.TotalDue > 100000
--q4
select
	p.[Name]
	,c.CompanyName
	,sod.OrderQty
from
	SalesLT.Product p
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
	join SalesLT.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
	join SalesLT.Customer c on soh.CustomerID = c.CustomerID
where
	p.[Name] = 'Racing Socks, L'
	and c.CompanyName = 'Riding Cycles'
--q5
select
	sod.SalesOrderID
	,sod.UnitPrice
from
	SalesLT.SalesOrderDetail sod
where
	sod.OrderQty = 1
--q6
select
	c.CompanyName
from
	SalesLT.ProductModel pm
	join SalesLT.Product p on pm.ProductModelID = p.ProductModelID
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
	join SalesLT.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
	join SalesLT.Customer c on soh.CustomerID = c.CustomerID
where
	pm.[Name] = 'Racing Socks'
--q7
select
	pd.[Description]
from
	SalesLT.ProductDescription pd
	join SalesLT.ProductModelProductDescription pmpd 
		on pd.ProductDescriptionID = pmpd.ProductDescriptionID
	join SalesLT.ProductModel pm 
		on pmpd.ProductModelID = pm.ProductModelID
	join SalesLT.Product p on pm.ProductModelID = p.ProductModelID
where
	pmpd.Culture = 'fr'
	and p.ProductID = 736
--q8
select
	c.CompanyName
	,soh.SubTotal
	,p.[Weight]
from
	SalesLT.Product p 
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
	join SalesLT.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
	join SalesLT.Customer c on soh.CustomerID = c.CustomerID
order by
	soh.SubTotal desc
--q9
select
	count(1) CranksetsSentToLondon
from
	SalesLT.ProductCategory pc
	join SalesLT.Product p on pc.ProductCategoryID = p.ProductCategoryID
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID	
	join SalesLT.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
	join SalesLT.[Address] sa on soh.ShipToAddressID = sa.AddressID
where
	pc.[Name] = 'Cranksets'
	and sa.City = 'London'
--q10
select
	p.[Name]
	,sod.OrderQty
from
	SalesLT.Product p 
	join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
	join SalesLT.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
	join SalesLT.Customer c on soh.CustomerID = c.CustomerID
where 
	c.CompanyName like 'Futuristic Bikes'