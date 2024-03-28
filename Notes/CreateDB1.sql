use [master]
go

if db_id('Unit1') is not null
begin
	alter database Unit1 set single_user with rollback immediate;
	drop database Unit1;
end
go

create database Unit1
go

use Unit1
go

--Create Person table
create table Person(
	personId [int] identity(1,1) primary key
	,firstName [varchar](128) not null
	,middleInitial [varchar](1)
	,lastName [varchar](128) not null
	,dateOfBirth [date] not null
);

--Create Student table
create table Student(
	studentId [int] identity(1,1) primary key
	,personId [int] references Person (personId)
	,eMail [varchar](256)
);

--Create Course table
create table Course(
	courseId [int] identity(1,1) primary key
	,[name] [varchar](50) not null
	,teacher [varchar](256) not null
);

--Create Credit table
create table Credit(
	studentId [int] references Student (studentId)
	,courseId [int] references Course (courseId)
	,grade [decimal](5,2) CHECK (grade <= 100.00)
	,attempt [tinyint]
	,constraint [uq_studentgrades] unique clustered
	(
		studentId, courseId, Grade, Attempt
	),
	primary key(studentId, courseId)
);



