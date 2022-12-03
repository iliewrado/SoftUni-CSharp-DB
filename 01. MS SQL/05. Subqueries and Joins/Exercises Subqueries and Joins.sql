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
ORDER BY E.AddressID

-- 2.	Addresses with Towns
SELECT TOP 50
E.FirstName
,E.LastName
,T.[Name] AS Town
,A.AddressText
FROM Employees AS E
JOIN Addresses AS A ON E.AddressID = A.AddressID
JOIN Towns AS T ON A.TownID = T.TownID
ORDER BY E.FirstName, E.LastName

-- 3.	Sales Employee
SELECT
E.EmployeeID
,E.FirstName
,E.LastName
,D.[Name] AS [DepartmentName]
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID AND D.[Name] = 'Sales'
ORDER BY E.EmployeeID

-- 4.	Employee Departments


-- 5.	Employees Without Project


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
ORDER BY E.HireDate

-- 7.	Employees with Project


-- 8.	Employee 24


-- 9.	Employee Manager


-- 10. Employee Summary
SELECT TOP 50
E.EmployeeID
,CONCAT(E.FirstName, ' ', E.LastName) AS [EmployeeName]
,CONCAT(M.FirstName, ' ', M.LastName) AS [ManagerName]
,D.[Name] AS [DepartmentName]
FROM Employees AS E
LEFT JOIN Employees AS M ON E.ManagerID = M.EmployeeID
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
ORDER BY E.EmployeeID
