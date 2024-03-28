use AP;

create role PaymentEntry;

grant update
	on Invoices
	to PaymentEntry;

grant insert, update
	on InvoiceLineItems
	to PaymentEntry;

alter role db_datareader add member PaymentEntry;

---------------------------------------------------
create login AAaron with password = 'AAar99999',
	default_database = AP;

create user AAaron for login AAaron;

alter role PaymentEntry add member AAaron;

---------------------------------------------------
create table NewLogins
(
	LoginName varchar(128) 
);

insert into NewLogins
values
	('BBrown')
	,('CChaplin')
	,('DDyre')
	,('Eebbers');

---------------------------------------------------
declare @DynamicSQL varchar(256)
	,@LoginName varchar(128)
	,@TempPassword char(9);

declare LoginCursor cursor
dynamic
for
	select distinct	
		*
	from
		NewLogins;

open LoginCursor
fetch next from LoginCursor into @LoginName

while @@fetch_status = 0
begin
	set @TempPassword = left(@LoginName, 4) + '99999'
	--1. create login
	set @DynamicSQL = 'create login ' + @LoginName + ' with password = ''' 
		+ @TempPassword + ''', default_database = AP'
	exec(@DynamicSQL);

	--2. create user
	set @DynamicSQL = 'create user ' + @LoginName + ' for login ' + @LoginName
	exec(@DynamicSQL);

	--3. add user to role (alter role)
	set @DynamicSQL = 'alter role PaymentEntry add member ' + @LoginName
	exec(@DynamicSQL);

	fetch next from LoginCursor into @LoginName
end
close LoginCursor
deallocate LoginCursor