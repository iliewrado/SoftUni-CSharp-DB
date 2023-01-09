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
,PRIMARY KEY (AircraftId, PilotId)
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
SELECT 
Manufacturer
,Model	
,FlightHours	
,Condition
FROM Aircraft
ORDER BY FlightHours DESC

-- 6.	Pilots and Aircraft
SELECT
P.FirstName
,P.LastName
,A.Manufacturer
,A.Model
,A.FlightHours 
FROM Pilots AS P
JOIN PilotsAircraft AS PA ON P.Id = PA.PilotId
JOIN Aircraft AS A ON PA.AircraftId = A.Id
WHERE FlightHours IS NOT NULL AND FlightHours <= 304
ORDER BY FlightHours DESC, P.FirstName

-- 7.	Top 20 Flight Destinations
SELECT TOP (20)
F.Id AS DestinationId
,[Start]
,P.FullName
,A.AirportName
,F.TicketPrice
FROM FlightDestinations AS F
JOIN Passengers AS P ON F.PassengerId = P.Id
JOIN Airports AS A ON F.AirportId = A.Id
WHERE DATEPART(DAY, F.[Start]) % 2 = 0
ORDER BY F.TicketPrice DESC, A.AirportName

-- 8.	Number of Flights for Each Aircraft
SELECT
A.Id AS AircraftId
,A.Manufacturer
,A.FlightHours
,COUNT(F.Id) AS FlightDestinationsCount
,ROUND(AVG(F.TicketPrice), 2) AS AvgPrice
FROM Aircraft AS A
JOIN FlightDestinations AS F ON A.Id = F.AircraftId
GROUP BY A.Id, A.Manufacturer, A.FlightHours
HAVING COUNT(F.Id) >= 2 
ORDER BY FlightDestinationsCount DESC, A.Id 

-- 9.	Regular Passengers
SELECT 
P.FullName
,COUNT(*) AS CountOfAircraft
,SUM(F.TicketPrice) AS TotalPayed
FROM FlightDestinations AS F
JOIN Passengers AS P ON F.PassengerId = P.Id
WHERE P.FullName LIKE '_a%'
GROUP BY P.FullName
HAVING COUNT(*) > 1
ORDER BY P.FullName

-- 10.	Full Info for Flight Destinations
SELECT 
A.AirportName
,F.[Start] AS DayTime
,F.TicketPrice
,P.FullName
,C.Manufacturer
,C.Model
FROM FlightDestinations AS F
JOIN Airports AS A ON F.AirportId = A.Id
JOIN Passengers AS P ON F.PassengerId = P.Id
JOIN Aircraft AS C ON F.AircraftId = C.Id
WHERE DATEPART(HOUR, F.[Start]) BETWEEN 6 AND 20
	  AND F.TicketPrice > 2500
ORDER BY C.Model

-- Section 4. Programmability (20 pts)
GO
-- 11.	Find all Destinations by Email Address
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS 
BEGIN
RETURN (SELECT 
		COUNT(*)
		FROM FlightDestinations
		WHERE PassengerId IN (SELECT Id FROM Passengers
								WHERE Email = @email))
END
GO

-- Query
-- SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
-- Output
-- 1

-- 12.	Full Info for Airports
CREATE PROC usp_SearchByAirportName (@airportName VARCHAR(70))
AS 
BEGIN 
SELECT
A.AirportName
,P.FullName,
	CASE 
		 WHEN TicketPrice <= 400 THEN 'Low'
		 WHEN TicketPrice BETWEEN 401 AND 1500 THEN 'Medium' 
		 WHEN TicketPrice > 1500 THEN 'High'
		 END AS LevelOfTickerPrice	
,AC.Manufacturer	
,AC.Condition	
,T.TypeName 
FROM FlightDestinations AS F
JOIN Airports AS A ON F.AirportId = A.Id
JOIN Passengers AS P ON F.PassengerId = P.Id
JOIN Aircraft AS AC ON F.AircraftId = AC.Id
JOIN AircraftTypes AS T ON AC.TypeId = T.Id
WHERE A.AirportName = @airportName
ORDER BY Manufacturer, FullName
END
GO


-- Query
-- EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'

-- Result
-- AirportName			FullName			LevelOfTickerPrice	Manufacturer	Condition	TypeName
-- Sir Seretse			Alyson Jankowski	Low					Airbus			B			Private Single Engine
-- Khama International 
-- Airport	
-- ........


