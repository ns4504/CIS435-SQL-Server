--PART A: AP Database
use AP
go
--Nathan Scott
--Question 1
select
	v.VendorName Vendor
	,i.InvoiceDate [Date]
	,i.InvoiceNumber Number
	,li.InvoiceSequence #
	,li.InvoiceLineItemAmount LineItem
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
order by
	Vendor
	,[Date]
	,Number
	,#

--Nathan Scott
--Question 2
select
	v.VendorName
	,count(i.InvoiceID) InvoiceCount
	,sum(i.InvoiceTotal) InvoiceSum
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
group by
	v.VendorName
order by
	InvoiceCount desc

--Nathan Scott
--Question 3
select
	v.VendorName
	,i.InvoiceID
	,li.InvoiceSequence
	,li.InvoiceLineItemAmount
from
	Vendors v
	join Invoices i on v.VendorID = i.VendorID
	join(
		select
			li.InvoiceID
			,count(li.InvoiceID) lineItemCount
		from 
			InvoiceLineItems li
		group by
			li.InvoiceID
		having
			count(li.InvoiceID) > 1
	) s on i.InvoiceID = s.InvoiceID
	join InvoiceLineItems li on i.InvoiceID = li.InvoiceID

--Nathan Scott
--Question 4
with uniqueLocations as (
	select
		v.VendorCity
		,v.VendorState
		,count(1) numOfVendorsPerLocation
	from
		Vendors v
	group by v.VendorCity ,v.VendorState
	having count(1) = 1
)
select
	v.VendorName
	,v.VendorCity
	,v.VendorState
from
	Vendors v
	join uniqueLocations ul on v.vendorCity = ul.vendorCity and v.VendorState = ul.VendorState

--Nathan Scott
--Question 5
drop table if exists VendorMidterm
select
	*
into VendorMidterm
from
	Vendors v
go

select * from VendorMidterm

--Nathan Scott
--Question 6
delete from VendorMidterm
where VendorState in (	select
		v.VendorState
	from 
		VendorMidterm v
		left join Invoices i on v.VendorID = i.VendorID
	group by
		v.VendorState
	having count(i.InvoiceID) = 0
)

--PART B: AdventureWorks Database
use AdventureWorks2019
go
--Nathan Scott
--Question 7
select
	substring(p.ProductNumber, charindex('-', p.ProductNumber) + 1, 10) 'Characters after hyphen'
from
	Production.Product p

--Nathan Scott
--Question 8
select
	convert(varchar, soh.OrderDate, 1) OrderDateNoTime
	,convert(varchar, soh.ShipDate, 1) ShipDateNoTime
from
	Sales.SalesOrderHeader soh

--Nathan Scott
--Question 9
select
	e.BusinessEntityID
	,case
		when e.BusinessEntityID % 2 = 0 then 'Even'
		else 'Odd'
	end EvenOrOdd
from
	HumanResources.Employee e

--PART C: L_LUNCHES Database
use L_LUNCHES
go
--Nathan Scott
--Question 10
select
	*
	,PRICE 
		+ isnull(PRICE_INCREASE, 0) PROPOSED_PRICE
from
	L_FOODS
order by
	PROPOSED_PRICE

--Nathan Scott
--Question 11
select
	f.SUPPLIER_ID
	,f.PRODUCT_CODE
	,f.[DESCRIPTION]
	,upper(left(f.[DESCRIPTION], 3)) 
		+ case
					when left(right(rtrim(f.[DESCRIPTION])
					,charindex(' ',reverse(rtrim(f.[DESCRIPTION])) + ' ')-1),3) 
					= (left(f.[DESCRIPTION], 3)) then ''
					else '_' + right(rtrim(f.[DESCRIPTION])
					,charindex(' ',reverse(rtrim(f.[DESCRIPTION])) + ' ')-1) 
				end ABRV_DESCRIPT

from
	L_FOODS f

--Nathan Scott
--Question 12
select
	l.LUNCH_ID
	,convert(varchar, l.LUNCH_DATE, 1) LUNCH_DATE
	,l.DATE_ENTERED
from
	L_LUNCHES l
	join L_EMPLOYEES e on l.EMPLOYEE_ID = e.EMPLOYEE_ID
where
	e.FIRST_NAME + e.LAST_NAME = 'SUSANBROWN'
	or e.FIRST_NAME + e.LAST_NAME = 'PAULAJACOBS' --there is no paula jacobs in the database