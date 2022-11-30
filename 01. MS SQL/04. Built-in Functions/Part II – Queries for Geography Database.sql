-- Problem 12.	Countries Holding ‘A’ 3 or More Times
SELECT
	CountryName
	,IsoCode
	FROM Countries
	WHERE LOWER(CountryName) LIKE '%a%a%a%'
ORDER BY IsoCode

-- Problem 13.	 Mix of Peak and River Names
SELECT 
PeakName
,RiverName
,CONCAT(LEFT(LOWER(PeakName), LEN(PeakName)-1), LOWER(RiverName)) AS Mix
FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix
