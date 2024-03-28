use MyGuitarShop;
go
--Question 1 & 2
drop proc if exists spInsertCategory
go

create proc spInsertCategory
	@CategoryName varchar(255)
as
begin try
	insert into Categories
	values 
		(@CategoryName);
	print 'SUCCESS: Record was inserted'
end try
begin catch
	print 'FAILURE: Record was not inserted.'
end catch
go

exec spInsertCategory @CategoryName = 'Guitar';
exec spInsertCategory @CategoryName = 'Woodwinds';
go

--Question 3
create or alter function fnDiscountPrice
(
	@ID int
)
returns money
begin
	declare @Discount money;
	select 
		 @Discount = oi.DiscountAmount
	from
		OrderItems oi --select * from OrderItems
	where 
		oi.ItemID = @ID;

	return @Discount;
end;
go

select dbo.fnDiscountPrice(1) as ItemDiscount
go

--Question 4
create or alter function fnItemTotal
(
	@ID int
)
returns money
begin
	declare @ItemTotal money
	select
		@ItemTotal = oi.ItemPrice - dbo.fnDiscountPrice(@ID)
	from
		OrderItems oi

	return @ItemTotal;
end;
go

select dbo.fnItemTotal(1) as ItemTotal;
go

--Question 5
drop proc if exists spInsertProduct;
go

create proc spInsertProduct --select * from Products
	@CatID int
	,@ProdCode varchar(10)
	,@ProdName varchar(255)
	,@ListPric money
	,@DiscPerc money
as
begin
	insert into Products
	values
		(@CatID
		,@ProdCode
		,@ProdName
		,''
		,@ListPric
		,@DiscPerc
		,getdate())
end;
go

exec spInsertProduct 
	@CatID = 6
	,@ProdCode = 'cymba'
	,@ProdName = 'Brass Cymbal'
	,@ListPric = 1069.95
	,@DiscPerc = 10;
exec spInsertProduct 
	@CatID = 14
	,@ProdCode = 'flute'
	,@ProdName = 'Wooden Flutes'
	,@ListPric = 605
	,@DiscPerc = 15;
go

--Question 6
drop proc if exists spUpdateProductDiscount;
go

create proc spUpdateProductDiscount --select * from Products
	@prodID int
	,@discPerc money
as
if @discPerc >= 0
begin
	update Products 
	set	DiscountPercent = @discPerc
	where ProductID = @prodID
end 
else
begin
	print 'ERROR: Discount Percent cannot be negative. It must be positive.'
end;
go

exec spUpdateProductDiscount @prodID = 1, @discPerc = 10
go

--Question 7
create or alter trigger Products_UPDATE
on Products
after update
as
begin
	declare @discPerc money
	select @discPerc = DiscountPercent from Products

	if @discPerc > 1 and @discPerc > 0
	begin
		declare @newDisc int
		update Products
		set DiscountPercent = DiscountPercent * 100
		where DiscountPercent < 1 and DiscountPercent > 0
	end;
end;
go


exec spUpdateProductDiscount @prodID = 1, @discPerc = .5
go

select * from Products
go

--Question 8
create or alter trigger Products_INSERT
on Products
after insert
as
begin
	declare @date date
	select @date = DateAdded from Products

	if @date is null
	begin
		update Products
		set DateAdded = getdate() 
		where DateAdded is null
	end;
end;
go

insert into Products 
values
	(1, 'cbel', 'Cow Bell', '', 60, 10, null)
go

select * from Products
go

--Question 9
drop table if exists ProductsAudit
go

create table ProductsAudit
(
	 AuditID int identity(1,1) primary key
	,ProductID int not null references Products(ProductID)
	,CategoryID int not null references Categories(CategoryID)
	,ProductCode varchar(10) not null
	,ProductName varchar(255) not null
	,ListPrice money not null
	,DiscountPercent money not null
	,DateUpdated datetime not null
)
go

create or alter trigger Products_UPDATE2
on Products
after update
as
begin
	insert into ProductsAudit
	(
		ProductID 
		,CategoryID 
		,ProductCode 
		,ProductName 
		,ListPrice 
		,DiscountPercent 
		,DateUpdated
	)
	select
		p.ProductID
		,p.CategoryID
		,p.ProductCode
		,p.ProductName
		,p.ListPrice
		,p.DiscountPercent
		,p.DateAdded
	from
		deleted p
end;
go

update Products
set DiscountPercent = 0.5
where ProductID = 3
go

select * from ProductsAudit
go

--Question 10
declare 
	@prodName varchar(255)
	,@listPric money

declare ExpensiveProducts cursor
for
	select
		ProductName
		,ListPrice
	from
		Products
	where
		ListPrice > 700;

open ExpensiveProducts
begin
	fetch next from ExpensiveProducts into @prodName, @listPric

	while @@fetch_status = 0
	begin
	print @prodName + ', ' + cast(@listPric as varchar)

	fetch next from ExpensiveProducts into @prodName, @listPric
	end
end
close ExpensiveProducts
deallocate ExpensiveProducts
go