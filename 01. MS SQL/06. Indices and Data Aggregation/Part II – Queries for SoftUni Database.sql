-- Part II – Queries for SoftUni Database

-- 13. Departments Total Salaries
SELECT 
DepartmentID
,SUM(Salary) AS [TotalSalary]
FROM Employees AS E 
GROUP BY DepartmentID

-- 14. Employees Minimum Salaries
SELECT 
DepartmentID
,MIN(SALARY) AS [MinimumSalary]
FROM Employees
WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID

-- 15. Employees Average Salaries
SELECT *
INTO TempTable
FROM Employees
WHERE Salary > 30000

DELETE FROM TempTable
WHERE ManagerID = 42

UPDATE TempTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT 
DepartmentID
,AVG(Salary) AS AverageSalary
FROM TempTable
GROUP BY DepartmentID

-- 16. Employees Maximum Salaries
SELECT 
DepartmentID
,MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING NOT MAX(Salary) BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries
SELECT 
COUNT(Salary) AS [Count]
FROM Employees
GROUP BY ManagerID 
HAVING ManagerID IS NULL

-- 18. *3rd Highest Salary


-- 19. **Salary Challenge

