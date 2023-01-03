-- Database Basics MS SQL Exam – 19 06 2022
-- N.B.
-- Use VARCHAR for strings, not NVARCHAR. 
-- Keep in mind that Judge doesn’t accept the “ALTER” statement 
-- and square brackets naming when the names are not keywords.

-- Section 1. DDL (30 pts)
CREATE DATABASE Zoo

GO

USE Zoo

GO

-- 1.	Database design
CREATE TABLE Owners(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
,PhoneNumber VARCHAR(15) NOT NULL
,[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes(
Id INT PRIMARY KEY IDENTITY
,AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages(
Id INT PRIMARY KEY IDENTITY
,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(30) NOT NULL
,BirthDate DATE NOT NULL
,OwnerId INT FOREIGN KEY REFERENCES Owners(Id)
,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages(
CageId INT NOT NULL FOREIGN KEY REFERENCES Cages(Id)
,AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id)
PRIMARY KEY (CageId ,AnimalId)
)

CREATE TABLE VolunteersDepartments(
Id INT PRIMARY KEY IDENTITY
, DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
,PhoneNumber VARCHAR(15) NOT NULL
,[Address] VARCHAR(50) 
,AnimalId INT FOREIGN KEY REFERENCES Animals(Id)
,DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)


-- Section 2. DML (10 pts)
-- Before you start you have to import "01. DDL_Dataset.sql ". 
-- If you have created the structure correctly the data should be successfully inserted. 

-- 2.	Insert