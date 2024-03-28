use L_LUNCHES
go

--question 1
--select * from L_FOODS
create or alter proc spInsertFood
	@supplierID varchar(3) 
	,@productCode varchar(2)
	,@menuItem int
	,@description varchar(20)
	,@price numeric(4, 2)
	,@priceIncrease numeric(4, 2)
as

if @price < 0
	throw 50001, 'Price must be greater than 0.', 1

if @priceIncrease < 0
	throw 50002, 'Price Increase must be greater than 0.', 1

if @menuItem < 0
	throw 50003, 'Menu Item must be greater than 0.', 1

	insert into dbo.L_FOODS (SUPPLIER_ID, PRODUCT_CODE, MENU_ITEM, [DESCRIPTION], PRICE, PRICE_INCREASE)
	values(@supplierID, @productCode, @menuItem, @description, @price, @priceIncrease)
go

--question 2
exec spInsertFood 'JBR', 'GB', '12', 'JBR GREEN BEANS', '1.50', null
exec spInsertFood 'JBR', 'CR', '12', 'CARROTS', '2.00', null
go

--question 3
drop trigger if exists upperDescInsert
go
create trigger upperDescInsert on L_FOODS
after insert
as
begin
	update L_FOODS
	set 
		[DESCRIPTION] = UPPER(i.[DESCRIPTION])
	from L_FOODS f
	join inserted i on f.SUPPLIER_ID = i.SUPPLIER_ID and
						f.PRODUCT_CODE = i.PRODUCT_CODE
end
go

drop trigger if exists upperDescUpdate
go
create trigger upperDescUpdate on L_FOODS
after update
as
begin
	update L_FOODS
	set 
		[DESCRIPTION] = UPPER(i.[DESCRIPTION])
	from L_FOODS f
	join inserted i on f.SUPPLIER_ID = i.SUPPLIER_ID and
						f.PRODUCT_CODE = i.PRODUCT_CODE
end
go
	
--question 4
--select * from L_FOODS
exec spInsertFood 'ASP', 'CR', '12', 'asp carrots', '2.00', null
go
