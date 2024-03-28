use MyGuitarShop
go
--Nathan Scott
--Question 1
select
	p.ProductName
	,p.ListPrice
	,p.DateAdded
from
	Products p
where
	p.ListPrice > 500
	and p.ListPrice < 2000
order by p.DateAdded desc

--Nathan Scott
--Question 2
select
	p.ProductName
	,p.ListPrice
	,cast(cast(p.DiscountPercent as int) as varchar) + '%' DiscountPercent
	,p.ListPrice
		* (p.DiscountPercent/100) DiscountAmount
	,p.ListPrice 
		+ (p.ListPrice
		* (p.DiscountPercent / 100)) DiscountPrice
from
	Products p

--Nathan Scott
--Question 3
select
	oi.ItemID
	,oi.ItemPrice
	,oi.DiscountAmount
	,oi.Quantity
	,oi.ItemPrice
		* oi.Quantity PriceTotal
	,oi.DiscountAmount
		* oi.Quantity DiscountTotal
	,(oi.ItemPrice
		- oi.DiscountAmount)
		* oi.Quantity ItemTotal
from
	OrderItems oi
where
	(oi.ItemPrice 
		- oi.DiscountAmount)
		* oi.Quantity > 500
order by ItemTotal desc

--Nathan Scott
--Question 4
select
	100 Price
	,.07 TaxRate
	,100 * .07 TaxAmount
	,100 + 100 * .07 Total

--Nathan Scott
--Question 5
with UniqueListPrices as (
	select
		p.ProductName
		,p.ListPrice
		,row_number() over (partition by p.ListPrice order by p.ProductName) RowNum
	from
		Products p
)
select
	ulp.ProductName
	,ulp.ListPrice
from
	UniqueListPrices ulp
where
	RowNum = 1

--Nathan Scott
--Question 6
select
	c.CategoryName
	,p.ProductID
from
	Categories c
	full outer join Products p on c.CategoryID = p.CategoryID
where
	p.ProductID is null

--Nathan Scott
--Question 7
select
	case
		when o.ShipDate is null then 'NOT SHIPPED'
		else 'SHIPPED'
	end ShipStatus
	,o.OrderID
	,o.OrderDate
from 
	Orders o
order by
	o.OrderDate

--Nathan Scott
--Question 8
select
	c.EmailAddress
	,count(o.OrderID) NumberOfOrders
	,( oi.ItemPrice
		- oi.DiscountAmount)
		* Quantity OrderTotal
from
	Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join OrderItems oi on o.OrderID = oi.OrderID
group by
	c.EmailAddress
	,(oi.ItemPrice 
		- oi.DiscountAmount)
		* Quantity

--Nathan Scott
--Question 9
select
	100 Price
	,.07 TaxRate
	,100 * .07 TaxAmount
	,100 + 100 * .07 Total
where
	100 + 100 * .07 > 400

--Nathan Scott
--Question 10
select
	isnull(p.ProductName, 'Grand Total: ') ProductName
	,sum((oi.ItemPrice - oi.DiscountAmount)
		* oi.Quantity) Total
from
	Products p
	join OrderItems oi on p.ProductID = oi.ProductID
group by 
	p.ProductName with rollup

--Nathan Scott
--Question 11
select
	c.EmailAddress
	,count(distinct p.ProductCode) UniqueProductsPerOrder
from
	Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join OrderItems oi on o.OrderID = oi.OrderID
	join Products p on oi.ProductID = p.ProductID
group by
	c.EmailAddress

--Nathan Scott
--Question 12a
select
	c.EmailAddress
	,o.OrderID
	,sum((oi.ItemPrice - oi.DiscountAmount)
		* oi.Quantity) Total
from
	Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join OrderItems oi on o.OrderID = oi.OrderID
group by
	c.EmailAddress
	,o.OrderID

--Nathan Scott
--Question 12b
select
	sq.EmailAddress
	,max(sq.Total) LargestOrder
from 
(
	select
		c.EmailAddress
		,o.OrderID
		,sum((oi.ItemPrice - oi.DiscountAmount)
			* oi.Quantity) Total
	from
		Customers c
		join Orders o on c.CustomerID = o.CustomerID
		join OrderItems oi on o.OrderID = oi.OrderID
	group by
		c.EmailAddress
		,o.OrderID
) sq
group by sq.EmailAddress

--Nathan Scott
--Question 13
with DistinctDiscount as
(
	select
		p.ProductName
		,p.DiscountPercent
		,row_number() over (partition by p.DiscountPercent order by p.DiscountPercent) RowNum
		,count(1) over (partition by p.DiscountPercent order by p.DiscountPercent) TotalRows
	from
		Products p
)

select
	dd.ProductName
	,dd.DiscountPercent
from
	DistinctDiscount dd
where
	dd.TotalRows < 2

--Nathan Scott
--Question 14
select
	sq.EmailAddress
	,sq.OrderID
	,sq.OrderDate
from
(
	select
		c.EmailAddress
		,o.OrderID
		,o.OrderDate
		,row_number() over (partition by c.EmailAddress order by o.OrderDate) RowNum
	from 
		Customers c
		join Orders o on c.CustomerID = o.CustomerID
) sq
where 
	sq.RowNum = 1

--Nathan Scott
--Question 15
insert into Categories
values('Brass')

--Nathan Scott
--Question 16 
update Categories
set CategoryName = 'Woodwinds'
where CategoryID = 5

--Nathan Scott
--Question 17
delete from Categories
where CategoryID = 5

--Nathan Scott
--Question 18
insert into Products --select * from Products 
values
(
	4
	,'dgx_640'
	,'Yamaha DGX 640 88-Key Digital Piano'
	,'Long description to come.'
	,799.99
	,0
	,getdate()
)

--Nathan Scott
--Question 19
select
	p.ListPrice
	,cast(p.ListPrice as decimal(7,1)) CastListPriceToDecimal
	,convert(int, p.ListPrice) ConvertListPriceToInt
	,cast(p.ListPrice as int) CastListPriceToInt
from
	Products p

--Nathan Scott
--Question 20
select
	convert(varchar, OrderDate, 1) ConvertToVarchar1
	,convert(varchar, OrderDate, 0) ConvertToVarchar0
	,convert(varchar, OrderDate, 14) ConvertToVarchar14
from
	Orders

--Nathan Scott
--Question 21
select
	OrderDate
	,year(OrderDate) OrderYear
	,day(OrderDate) OrderDay
	,month(OrderDate) OrderMonth
	,OrderDate + 30 'OrderDate + 30 Days'
from
	Orders

--Nathan Scott
--Question 22
select
	CardNumber
	,len(CardNumber) '# of Characters In CardNumber'
	,right(CardNumber, 4) 'Last 4 Digits of CardNumber'
from
	Orders

--Nathan Scott
--Question 23
select
	OrderID
	,OrderDate
	,OrderDate + 2 ApproxShipDate
	,ShipDate
	,datediff(day, Orderdate, ShipDate) DaysToShip
from
	Orders

--Nathan Scott
--Question 24
drop view if exists CustomerAddresses
go
create view CustomerAddresses as
select
	c.CustomerID
	,c.EmailAddress
	,c.LastName
	,c.FirstName
	,ba.Line1 BillLine1
	,ba.Line2 BillLine2
	,ba.City BillCity
	,ba.[State] BillState
	,ba.ZipCode BillZip
	,sa.Line1 ShipLine1
	,sa.Line2 ShipLine2
	,sa.City ShipCity
	,sa.[State] ShipState
	,sa.ZipCode ShipZip
from
	Customers c
	join Addresses ba on c.BillingAddressID = ba.AddressID
	join Addresses sa on c.ShippingAddressID = sa.AddressID

--Nathan Scott
--Question 25
drop view if exists OrderItemProducts
go
create view OrderItemProducts as
select
	o.OrderID
	,o.OrderDate
	,o.TaxAmount
	,o.ShipDate
	,oi.ItemPrice
	,oi.DiscountAmount
	,oi.ItemPrice
		- oi.DiscountAmount FinalPrice
	,oi.Quantity
	,(oi.ItemPrice
		- oi.DiscountAmount)
		* oi.Quantity ItemTotal
	,p.ProductName
from
	Orders o
	join OrderItems oi on o.OrderID = oi.OrderID
	join Products p on oi.ProductID = p.ProductID