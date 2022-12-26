-- Part III – Queries for Diablo Database
USE Diablo
GO

-- 13.	*Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames (@gamename NVARCHAR(50))
RETURNS TABLE
AS
	RETURN (SELECT 
			SUM(Cash) AS [SumCash]
			FROM (
				SELECT
				U.Cash 
				,ROW_NUMBER() OVER(ORDER BY U.Cash DESC) AS Ordered
				FROM Games AS G
				JOIN UsersGames AS U ON G.Id = U.GameId
				WHERE G.[Name] = @gamename) AS [Rows]
			WHERE Ordered %2 != 0)
GO