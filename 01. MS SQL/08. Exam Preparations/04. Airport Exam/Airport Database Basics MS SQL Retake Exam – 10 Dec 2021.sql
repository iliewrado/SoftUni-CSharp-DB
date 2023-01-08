-- Airport Database Basics MS SQL Retake Exam – 10 Dec 2021

-- N.B: Keep in mind that Judge doesn’t accept the “ALTER” statement
-- and square brackets naming when the names are not keywords.

-- Section 1. DDL (30 pts)
CREATE DATABASE Airport
GO

USE Airport
GO

-- 1.	Database design
CREATE TABLE Passengers (
Id INT PRIMARY KEY IDENTITY
,FullName VARCHAR(100) UNIQUE NOT NULL
,Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots (
Id INT PRIMARY KEY IDENTITY
,FirstName VARCHAR(30) UNIQUE NOT NULL
,LastName VARCHAR(30) UNIQUE NOT NULL
,Age TINYINT CHECK (Age BETWEEN 21 AND 62) 
,Rating FLOAT CHECK (Rating BETWEEN 0.0 AND 10.0)
)

CREATE TABLE AircraftTypes (
Id INT PRIMARY KEY IDENTITY
,TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft (
Id INT PRIMARY KEY IDENTITY
,Manufacturer VARCHAR(25) NOT NULL
,Model VARCHAR(30) NOT NULL
,[Year] INT NOT NULL
,FlightHours INT
,Condition CHAR(1) NOT NULL
,TypeId INT FOREIGN KEY REFERENCES AircraftTypes (Id) 
)

CREATE TABLE PilotsAircraft (
AircraftId INT FOREIGN KEY REFERENCES Aircraft (Id)
,PilotId INT FOREIGN KEY REFERENCES Pilots (Id)
PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports (
Id INT PRIMARY KEY IDENTITY
,AirportName VARCHAR(70) UNIQUE NOT NULL
,Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations (
Id INT PRIMARY KEY IDENTITY
,AirportId INT FOREIGN KEY REFERENCES Airports(Id) 
,[Start] DATETIME NOT NULL
,AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id)
,PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) 
,TicketPrice DECIMAL(18, 2) NOT NULL DEFAULT 15
)

-- Section 2. DML (10 pts)

-- Before you start you have to import "DDL_Dataset.sql ".
-- If you have created the structure correctly the data should be successfully inserted.

-- 2.	Insert
INSERT INTO Passengers (FullName, Email)
(SELECT 
 CONCAT(FirstName, ' ', LastName) AS FullName
,CONCAT(FirstName, LastName, '@gmail.com') AS Email 
FROM Pilots
WHERE Id BETWEEN 5 AND 15)

-- 3.	Update
UPDATE Aircraft
SET Condition = 'A'
WHERE (Condition = 'C' OR Condition = 'B')
	AND (FlightHours IS NULL OR FlightHours <= 100)
	AND ([Year] >= 2013)

-- 4.	Delete
DELETE FROM Passengers
WHERE LEN(FullName) <= 10

-- Section 3. Querying (40 pts)

-- You need to start with a fresh dataset, 
-- so recreate your DB and import the sample data again (01. DDL_Dataset.sql).

-- 5.	Aircraft


	