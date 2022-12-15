-- Part I – Queries for Gringotts Database

-- 1. Records’ Count
SELECT COUNT([Id]) AS [Count]
FROM WizzardDeposits

-- 2. Longest Magic Wand
SELECT MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits

-- 3. Longest Magic Wand Per Deposit Groups
SELECT 
DepositGroup
,MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY DepositGroup

-- 4. * Smallest Deposit Group Per Magic Wand Size
SELECT TOP(2)
DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- 5. Deposits Sum
SELECT 
DepositGroup
,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup

-- 6. Deposits Sum for Ollivander Family
SELECT 
DepositGroup
,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- 7. Deposits Filter
SELECT 
DepositGroup
,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY [TotalSum] DESC

-- 8.  Deposit Charge
SELECT 
DepositGroup
,MagicWandCreator
,MIN(DepositCharge) AS [MinDepositCharge]
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- 9. Age Groups

--10. First Letter

