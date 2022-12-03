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

-- 12. Highest Peaks in Bulgaria

-- 13. Count Mountain Ranges

-- 14. Countries with Rivers

-- 15. *Continents and Currencies

-- 16. Countries Without Any Mountains

-- 17. Highest Peak and Longest River by Country

-- 18. Highest Peak Name and Elevation by Country