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
SELECT * INTO EmployeesEM
	FROM Employees

DELETE FROM EmployeesEM
	WHERE ManagerID = 42

UPDATE EmployeesEM
	SET Salary += 5000
	WHERE DepartmentID = 1

SELECT 
DepartmentID
,AVG(Salary) AS [AverageSalary]
FROM EmployeesEM
GROUP BY DepartmentID
-- 16. Employees Maximum Salaries

-- 17. Employees Count Salaries

-- 18. *3rd Highest Salary

-- 19. **Salary Challenge

