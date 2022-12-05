USE [SoftUni]
GO

-- 1.	Employee Address
SELECT TOP 5
E.EmployeeID
,E.JobTitle
,A.AddressID
,A.AddressText
FROM Employees AS E
JOIN Addresses AS A ON E.AddressID = A.AddressID
ORDER BY E.AddressID ASC

-- 2.	Addresses with Towns
SELECT TOP 50
E.FirstName
,E.LastName
,T.[Name] AS Town
,A.AddressText
FROM Employees AS E
JOIN Addresses AS A ON E.AddressID = A.AddressID
JOIN Towns AS T ON A.TownID = T.TownID
ORDER BY E.FirstName, E.LastName ASC

-- 3.	Sales Employee
SELECT
E.EmployeeID
,E.FirstName
,E.LastName
,D.[Name] AS [DepartmentName]
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID AND D.[Name] = 'Sales'
ORDER BY E.EmployeeID ASC

-- 4.	Employee Departments
SELECT TOP 5
E.EmployeeID
,E.FirstName
,E.Salary
,D.[Name] AS [DepartmentName]
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 15000
ORDER BY E.DepartmentID ASC

-- 5.	Employees Without Project
SELECT TOP 3
E.EmployeeID
,E.FirstName
FROM Employees AS E
LEFT JOIN EmployeesProjects AS P ON E.EmployeeID = P.EmployeeID
WHERE P.ProjectID IS NULL
ORDER BY E.EmployeeID ASC

-- 6.	Employees Hired After
SELECT
E.FirstName
,E.LastName
,E.HireDate
,D.[Name] AS [DeptName]
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID 
WHERE 
	E.HireDate > '1999-01-01'
	AND D.[Name] IN ('Sales', 'Finance')
ORDER BY E.HireDate ASC

-- 7.	Employees with Project
SELECT TOP 5
E.EmployeeID
,E.FirstName
,P.[Name] AS [ProjectName]
FROM Employees AS E
LEFT JOIN EmployeesProjects AS EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects AS P ON EP.ProjectID = P.ProjectID
WHERE P.StartDate > '2002-08-13' AND P.EndDate IS NULL
ORDER BY E.EmployeeID ASC

-- 8.	Employee 24
SELECT
E.EmployeeID
,E.FirstName
,CASE
	WHEN DATEPART(YEAR, P.StartDate) > '2004' THEN NULL
	ELSE P.[Name] 
	END AS [ProjectName]
FROM Employees AS E
JOIN EmployeesProjects AS EP ON E.EmployeeID = EP.EmployeeID AND EP.EmployeeID = 24
LEFT JOIN Projects AS P ON EP.ProjectID = P.ProjectID

-- 9.	Employee Manager
SELECT
E.EmployeeID
,E.FirstName
,E.ManagerID
,M.FirstName AS [ManagerName]
FROM Employees AS E
JOIN Employees AS M ON E.ManagerID = M.EmployeeID AND E.ManagerID IN (3, 7)
ORDER BY E.EmployeeID
 
-- 10. Employee Summary
SELECT TOP 50
E.EmployeeID
,CONCAT(E.FirstName, ' ', E.LastName) AS [EmployeeName]
,CONCAT(M.FirstName, ' ', M.LastName) AS [ManagerName]
,D.[Name] AS [DepartmentName]
FROM Employees AS E
LEFT JOIN Employees AS M ON E.ManagerID = M.EmployeeID
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
ORDER BY E.EmployeeID ASC

-- 11. Min Average Salary
SELECT
	MIN(DT.AverageSalary) AS [MinAverageSalary]
FROM(
	SELECT 
	AVG(Salary) AS [AverageSalary]
	FROM Employees 
	GROUP BY DepartmentID) AS DT


USE [Geography]
-- 12. Highest Peaks in Bulgaria
SELECT
MC.CountryCode
,M.MountainRange
,P.PeakName
,P.Elevation
FROM Peaks AS P
JOIN Mountains AS M ON P.MountainId = M.Id
JOIN MountainsCountries AS MC ON M.Id = MC.MountainId
	WHERE MC.CountryCode = 'BG' AND P.Elevation > 2835
ORDER BY P.Elevation DESC

-- 13. Count Mountain Ranges
SELECT 
MC.CountryCode
,COUNT(MC.CountryCode) AS MountainRanges
FROM Mountains AS M
JOIN MountainsCountries AS MC ON M.Id = MC.MountainId
WHERE MC.CountryCode = 'BG' OR MC.CountryCode = 'US' OR MC.CountryCode = 'RU'
GROUP BY MC.CountryCode
ORDER BY MountainRanges DESC

-- 14. Countries with Rivers
SELECT TOP 5
C.CountryName
,R.RiverName
FROM Countries AS C
JOIN Continents AS CON ON C.ContinentCode = CON.ContinentCode
							AND CON.ContinentName = 'Africa'
LEFT JOIN CountriesRivers AS CR ON C.CountryCode = CR.CountryCode
LEFT JOIN Rivers AS R ON CR.RiverId = R.Id
ORDER BY C.CountryName ASC

-- 15. *Continents and Currencies
SELECT 
ContinentCode
,CurrencyCode
,CurrencyUsage
FROM
	(SELECT 
	*, DENSE_RANK() OVER(PARTITION BY ContinentCode 
						 ORDER BY CurrencyUsage DESC) AS [CR]
	FROM
		(SELECT 
		CON.ContinentCode
		,CT.CurrencyCode
		,COUNT(CT.CurrencyCode) AS CurrencyUsage
		FROM Continents AS CON
		LEFT JOIN Countries AS CT ON CT.ContinentCode = CON.ContinentCode
		GROUP BY CON.ContinentCode, CT.CurrencyCode) AS CurrencyUsageQuery
	WHERE CurrencyUsage > 1) AS CRQ
WHERE CR = 1
ORDER BY ContinentCode

-- 16. Countries Without Any Mountains
SELECT
COUNT(C.CountryCode) AS [Count]
FROM Countries AS C
LEFT JOIN MountainsCountries AS M ON C.CountryCode = M.CountryCode
WHERE M.MountainId IS NULL

-- 17. Highest Peak and Longest River by Country
SELECT TOP 5
C.CountryName
,MAX(P.Elevation) AS HighestPeakElevation
,MAX(R.[Length]) AS LongestRiverLength
FROM Countries AS C
LEFT JOIN MountainsCountries AS M ON C.CountryCode = M.CountryCode
LEFT JOIN Peaks AS P ON M.MountainId = P.MountainId
LEFT JOIN CountriesRivers AS CR ON C.CountryCode = CR.CountryCode
LEFT JOIN Rivers AS R ON CR.RiverId = R.Id
GROUP BY C.CountryName 
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, C.CountryName

-- 18. Highest Peak Name and Elevation by Country