use [master]
go

if db_id('L_LUNCHES') is not null
begin
	alter database L_LUNCHES set single_user with rollback immediate;
	drop database L_LUNCHES;
end
go

create database L_LUNCHES
go

use L_LUNCHES
go

--Create Suppliers table
create table L_SUPPLIERS(
	SUPPLIER_ID [varchar](3) primary key
	,SUPPLIER_NAME [varchar](30) not null
);

--Create Foods table
create table L_FOODS(
	SUPPLIER_ID [varchar](3) references L_SUPPLIERS(SUPPLIER_ID)
	,PRODUCT_CODE [varchar](2) not null
	,MENU_ITEM [int] not null
	,[DESCRIPTION] [varchar](20) not null
	,PRICE [numeric](4, 2) not null
	,PRICE_INCREASE [numeric](4,2)
	primary key (SUPPLIER_ID, PRODUCT_CODE)
);

--Create Departments table
create table L_DEPARTMENTS(
	DEPT_CODE [varchar](3) primary key
	,DEPARTMENT_NAME [varchar](30) not null
);

--Create Employees table
create table L_EMPLOYEES(
	EMPLOYEE_ID	[int] primary key
	,FIRST_NAME [varchar](10) not null
	,LAST_NAME [varchar](20) not null
	,DEPT_CODE [varchar](3) references L_DEPARTMENTS(DEPT_CODE)
	,HIRE_DATE [date]
	,CREDIT_LIMIT [decimal](4, 2)
	,PHONE_NUMBER [varchar](4)
	,MANAGER_ID [int]
);

--Create Lunches table
create table L_LUNCHES(
	LUNCH_ID [int] primary key
	,LUNCH_DATE [date] not null
	,EMPLOYEE_ID [int] references L_EMPLOYEES(EMPLOYEE_ID)
	,DATE_ENTERED [datetime] not null
);

--Create Lunch Items table
create table L_LUNCH_ITEMS(
    LUNCH_ID [int] references L_LUNCHES(LUNCH_ID),
    ITEM_NUMBER [int] not null,
    SUPPLIER_ID [varchar](3),
    PRODUCT_CODE [varchar](2),
    QUANTITY [int],
    primary key (LUNCH_ID, ITEM_NUMBER),
    foreign key (SUPPLIER_ID, PRODUCT_CODE) references L_FOODS(SUPPLIER_ID, PRODUCT_CODE)
);