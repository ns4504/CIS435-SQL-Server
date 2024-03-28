--Question 1
use AP;
go

drop proc if exists dbo.Vendor_info 
go

create proc Vendor_info
	@VendorName varchar(50)
as
begin
	if not exists (select 1 from Vendors where VendorName = @VendorName)
	begin
		throw 50001, 'Vendor does not exist.', 1;
	end

	declare @InvoiceTotal money
	declare @InvoiceCount int
	declare @InvoiceAvg money

	select 
		@InvoiceTotal = sum(i.InvoiceTotal)
		,@InvoiceCount = count(1)
		,@InvoiceAvg = avg(i.InvoiceTotal)
	from
		Vendors v
		join Invoices i on v.VendorID = i.VendorID

	print 'Information for the Vendor: ' + @VendorName
	print 'Invoice Total: ' + cast(@InvoiceTotal as varchar) 
	print 'Number of Invoices: ' + cast(@InvoiceCount as varchar)
	print 'Average Invoice Price: ' + cast(@InvoiceAvg as varchar)
end
go

exec dbo.Vendor_info @VendorName = 'Hello Fresh'
go

exec dbo.Vendor_info @VendorName = 'US Postal Service'
go

--Question 2
use AP;
go

drop proc if exists Vendor_Insert;
go

create proc Vendor_Insert
	@VenName varchar(50)
	,@VenAddr1 varchar(50) 
	,@VenAddr2 varchar(50) 
	,@VenCity varchar(50) 
	,@VenState char(2) 
	,@VenZip varchar(20) 
	,@VenPhone varchar(50) 
	,@VenContFName varchar(50)
	,@VenContLName varchar(50)
	,@DefTermID int 
	,@DefAccNo int 
as
begin
	--Validation
	if exists (select 1 from Vendors where VendorName = @VenName)
	begin
		throw 50001, 'Vendor already exists.', 1;
	end

	if
	(
		@VenName is null 
		or @VenAddr1 is null
		or @VenAddr2 is null
		or @VenCity is null
		or @VenState is null
		or @VenZip is null
		or @DefTermID is null
		or @DefAccNo is null
	)
	begin
		throw 50002, 'Only these fields can be null: @VenPhone, @VenContFName, @VenContLName', 1;
	end

	if not exists (select 1 from Terms where TermsID = @DefTermID)
	begin
		declare @ErrorThree varchar(100) 
			= cast(@DefTermID as varchar) + ' does not exist in the terms table. Please provide a valid TermsID.';

		throw 50003, @ErrorThree, 1;
	end

	if not exists (select 1 from GLAccounts where AccountNo = @DefAccNo)
	begin
		declare @ErrorFour varchar(100) 
			= cast(@DefAccNo as varchar) + ' does not exist in the GLAccounts table. Please provide a valid AccountNo.';

		throw 50004, @ErrorFour, 1;
	end

	--Insert into Vendors table
	insert into Vendors --select * from Vendors
	values
	(
		@VenName 
		,@VenAddr1 
		,@VenAddr2 
		,@VenCity 
		,@VenState 
		,@VenZip 
		,@VenPhone 
		,@VenContFName
		,@VenContLName 
		,@DefTermID 
		,@DefAccNo 
	);

	--provide the new VendorID
	declare @NewVendorID int
	
	select
		@NewVendorID = max(VendorID)
	from 
		Vendors

	print 'VendorID for the new entry: ' + cast(@NewVendorID as varchar)
end
go

exec Vendor_Insert 
		@VenName = 'US Postal Service'
		,@VenAddr1 = 'My Address'
		,@VenAddr2 = 'My Apartment Number'
		,@VenCity = 'My City'
		,@VenState = 'My State'
		,@VenZip = 'My Zip Code'
		,@VenPhone = null
		,@VenContFName = null
		,@VenContLName = null
		,@DefTermID = 12345
		,@DefAccNo = 54321
go

exec Vendor_Insert 
		@VenName = 'Whole Foods'
		,@VenAddr1 = 'My Address'
		,@VenAddr2 = 'My Apartment Number'
		,@VenCity = 'My City'
		,@VenState = 'My State'
		,@VenZip = 'My Zip Code'
		,@VenPhone = null
		,@VenContFName = null
		,@VenContLName = null
		,@DefTermID = 12345
		,@DefAccNo = 54321
go

exec Vendor_Insert 
		@VenName = 'Whole Foods'
		,@VenAddr1 = 'My Address'
		,@VenAddr2 = 'My Apartment Number'
		,@VenCity = null
		,@VenState = 'My State'
		,@VenZip = 'My Zip Code'
		,@VenPhone = null
		,@VenContFName = null
		,@VenContLName = null
		,@DefTermID = 1
		,@DefAccNo = 1
go

exec Vendor_Insert 
		@VenName = 'Whole Foods (again)'
		,@VenAddr1 = 'My Address'
		,@VenAddr2 = 'My Apartment Number'
		,@VenCity = 'My City'
		,@VenState = 'My State'
		,@VenZip = 'My Zip Code'
		,@VenPhone = null
		,@VenContFName = null
		,@VenContLName = null
		,@DefTermID = 1 --select * from Terms
		,@DefAccNo = 580 --select * from GLAccounts
go

--Question 3
use AP;
go

create or alter function fn_VendorAddress
(
	@VendorName varchar(50)
)
returns varchar(250)
as
begin
	declare @FullAddress varchar(250)
	
	select
		@FullAddress = replace(v.VendorAddress1 + ', ' + isnull(VendorAddress2, ' ') 
				+ ', ' + v.VendorCity + ', ' + v.VendorState
				+ '  ' + v.VendorZipCode, ',  , ', ', ')
	from
		Vendors v
	where
		v.VendorName = @VendorName
	return @FullAddress;
end
go

select dbo.fn_VendorAddress ('National Information Data CTR') --select * from Vendors
select dbo.fn_VendorAddress('US Postal Service')
go

--Question 4
declare VendorInvoiceSumCursor cursor
for
	select
		v.VendorName
		,i.InvoiceNumber
		,a.AccountNo
		,sum(li.InvoiceLineItemAmount) LineItemTotal
	from
		Vendors v
		join Invoices i on v.VendorID = i.InvoiceID
		join GLAccounts a on v.DefaultAccountNo = a.AccountNo
		join InvoiceLineItems li on i.InvoiceID = li.InvoiceID
	group by 
		v.VendorName
		,i.InvoiceNumber
		,a.AccountNo;

declare @VendorName varchar(50)
declare @InvoiceNumber varchar
declare @AccountNumber int
declare @LineItemSum money

open VendorInvoiceSumCursor;

	fetch next from VendorInvoiceSumCursor into @VendorName, @InvoiceNumber, @AccountNumber, @LineItemSum;

	while @@fetch_status = 0
	begin 
		print @VendorName + ' (' + @InvoiceNumber + ') - '
			+ cast(@AccountNumber as varchar) + ': $' + cast(@LineItemSum as varchar);
		
		fetch next from VendorInvoiceSumCursor into @VendorName, @InvoiceNumber, @AccountNumber, @LineItemSum;
	end
close VendorInvoiceSumCursor;
deallocate VendorInvoiceSumCursor;

--Question 5
drop trigger if exists VendorUpperTrim;
go

create trigger VendorUpperTrim
on Vendors
after insert, update
as
begin
	declare @VenID int;

	select 
		@VenID = VendorID
	from 
		inserted;

	update Vendors
	set
		VendorName = upper(VendorName)			
		,VendorAddress1 = upper(VendorAddress1)
		,VendorAddress2 = upper(VendorAddress2)		
		,VendorCity = upper(VendorCity)			
		,VendorState = upper(VendorState)		
		,VendorContactLName = upper(VendorContactLName)
		,VendorContactFName = upper(VendorContactFName)

	where VendorID = @VenID
end;
go

update Vendors
set 
	VendorName = 'United States Postal Service'
where
	VendorID = 1;
select * from Vendors