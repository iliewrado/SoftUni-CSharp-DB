--Problem 1.	One-To-One Relationship
CREATE DATABASE [Table Relations]
GO

USE [Table Relations]

CREATE TABLE [Persons](
[PersonID] INT IDENTITY (1, 1) NOT NULL
,[FirstName] NVARCHAR(50) NOT NULL
,[Salary] DECIMAL(8, 2)
,[PassportID] INT UNIQUE NOT NULL)


CREATE TABLE [Passports](
[PassportID] INT IDENTITY(101, 1) NOT NULL
,[PassportNumber] NVARCHAR(10) NOT NULL)
GO

ALTER TABLE [Passports]
ADD CONSTRAINT PK_Passports PRIMARY KEY ([PassportID])

ALTER TABLE [Persons]
ADD CONSTRAINT PK_Person PRIMARY KEY([PersonID])

ALTER TABLE [Persons]
ADD CONSTRAINT FK_Passport FOREIGN KEY ([PassportID]) REFERENCES [Passports]([PassportID])
GO

INSERT INTO [Passports]
VALUES ('N34FG21B')
	,('K65LO4R7')
	,('ZE657QP2')

INSERT INTO [Persons]
VALUES ('Roberto', 43300.00, 102)
,('Tom', 56100.00, 103)
,('Yana', 60200.00, 101)
GO

--Problem 2.	One-To-Many Relationship
CREATE TABLE [Manufacturers](
[ManufacturerID] INT IDENTITY(1, 1) NOT NULL
,[Name] NVARCHAR(50) NOT NULL
,[EstablishedOn] DATE DEFAULT GETDATE()
,CONSTRAINT PK_Manufacturer PRIMARY KEY([ManufacturerID])
)
GO

CREATE TABLE [Models](
[ModelID] INT IDENTITY (101, 1) NOT NULL
,[Name] NVARCHAR(50) NOT NULL
,[ManufacturerID] INT NOT NULL
,CONSTRAINT PK_Model PRIMARY KEY([ModelID])
,CONSTRAINT FK_Manufacturer FOREIGN KEY([ManufacturerID]) REFERENCES [Manufacturers]([ManufacturerID])
)
GO

INSERT INTO [Manufacturers]
VALUES ('BMW', '07/03/1916')
,('Tesla', '01/01/2003')
,('Lada', '01/05/1966')
GO

INSERT INTO [Models]
VALUES ('X1', 1)
,('i6', 1)
,('Model S', 2)
,('Model X', 2)
,('Model 3', 2)
,('Nova', 3)
GO

--Problem 3.	Many-To-Many Relationship
CREATE TABLE [Students](
[StudentID] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
,[Name] NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE [Exams](
[ExamID] INT IDENTITY(101, 1) NOT NULL PRIMARY KEY
,[Name] NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE [StudentsExams](
[StudentID] INT NOT NULL
,[ExamID] INT NOT NULL
,CONSTRAINT PK_StudentsExams
PRIMARY KEY(StudentID, ExamID)
,CONSTRAINT FK_StudentsExams_Students 
FOREIGN KEY(StudentID) REFERENCES Students(StudentID)
,CONSTRAINT FK_StudentsExams_Exams 
FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
)
GO

INSERT INTO [Students]
VALUES ('Mila')
,('Toni')
,('Ron')
GO

INSERT INTO [Exams]
VALUES ('SpringMVC')
,('Neo4j')
,('Oracle 11g')
GO

INSERT INTO [StudentsExams]
VALUES (1, 101)
,(1, 102)
,(2, 101)
,(3, 103)
,(2, 102)
,(2, 103)
GO

--Problem 4.	Self-Referencing 
CREATE TABLE [Teachers](
[TeacherID] INT NOT NULL PRIMARY KEY
,[Name] NVARCHAR(30) NOT NULL
,[ManagerID] INT
,CONSTRAINT FK_Teachers_Teachers FOREIGN KEY(ManagerID)
REFERENCES [Teachers](TeacherID)
)
GO

INSERT INTO [Teachers]
VALUES (101, 'John', NULL)
,(102, 'Maya',	106)
,(103, 'Silvia', 106)
,(104, 'Ted', 105)
,(105, 'Mark', 101)
,(106, 'Greta', 101)
GO