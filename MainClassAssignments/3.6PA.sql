--Nathan Scott
--Question 1
drop view if exists dbo.vw_Products
go

create view dbo.vw_Products
as
select
	p.[Name]
	,p.Color
	,p.Size
	,p.[Weight]
	,p.Class
	,p.Style
	,p.StandardCost CurrentPrice
	,pch.StartDate
	,pch.EndDate
	,pch.StandardCost PreviousPrice			  
from
	Production.Product p --select * from Production.Product
	join Production.ProductCostHistory pch on p.ProductID = pch.ProductID --select * from Production.ProductCostHistory
go

select
	*
from
	dbo.vw_Products
--Nathan Scott
--Question 2
drop view if exists dbo.vw_CustomerTotals
go

create view dbo.vw_CustomerTotals
as
select
	soh.CustomerID
	,count(soh.TotalDue) TotalSales
	,month(soh.DueDate) DueMonth
	,year(soh.DueDate) DueYear
from
	Sales.SalesOrderHeader soh 
group by 
	month(soh.DueDate)
	,year(soh.DueDate)
	,soh.CustomerID
go

select
	*
from 
	vw_CustomerTotals
order by TotalSales desc