--Problem 1.	Create Database
CREATE DATABASE Minions

--Problem 2.	Create Tables
CREATE TABLE [Minions](
Id INT PRIMARY KEY NOT NULL
, [Name] VARCHAR(50) NOT NULL
, [Age] INT NOT NULL)

CREATE TABLE [Towns](
[Id] INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

--Problem 3.	Alter Minions Table
ALTER TABLE Minions
ADD TownId INT FOREIGN KEY (TownId) REFERENCES Towns (Id)

--Problem 4.	Insert Records in Both Tables
INSERT INTO Towns ([ID], [Name])
VALUES (1, 'Sofia')
,(2, 'Plovdiv')
,(3, 'Varna')
INSERT INTO Minions ([ID], [Name], [Age], [TownId])
VALUES (1, 'Kevin', 22, 1)
,(2, 'Bob', 15, 3)
,(3, 'Steward', 18, 2)

--Problem 5.	Truncate Table Minions
TRUNCATE TABLE Minions

--Problem 6.	Drop All Tables
DROP TABLE Minions, Towns