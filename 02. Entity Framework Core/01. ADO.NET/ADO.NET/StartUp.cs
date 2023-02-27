using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;

namespace ADO.NET
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            using SqlConnection sqlConnection =
                new SqlConnection(Configuration.ConnectionString);

            sqlConnection.Open();

            string result = VillainNamesWithMinionCout(sqlConnection);
            Console.WriteLine(result);

            sqlConnection.Close();
        }

        // 2. Villain Names
        private static string VillainNamesWithMinionCout(SqlConnection sqlConnection)
        {
            StringBuilder output = new StringBuilder();
            string query = @"SELECT 
                                    v.Name, 
                                    COUNT(mv.VillainId) AS MinionsCount  
                            FROM Villains AS v 
                            JOIN MinionsVillains AS mv ON v.Id = mv.VillainId 
                                 GROUP BY v.Name 
                                 HAVING COUNT(mv.VillainId) > 3 
                            ORDER BY MinionsCount";

            SqlCommand command = new SqlCommand(query, sqlConnection);

            using SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                output.AppendLine($"{reader["Name"]} - {reader["MinionsCount"]}");
            }

            return output.ToString().TrimEnd();
        }

        // 3. Minion Names
        private static string MinionNamesAndAge(SqlConnection sqlConnection, int villainId)
        {
            StringBuilder output = new StringBuilder();

            string villanNameQuery = @"SELECT [Name] FROM Villains WHERE Id = @VillainId";

            SqlCommand villainCommand = new SqlCommand(villanNameQuery, sqlConnection);
            villainCommand.Parameters.AddWithValue("@VillainId", villainId);
            string villainName = (string)villainCommand.ExecuteScalar();

            if (string.IsNullOrEmpty(villainName))
                return $"No villain with ID {villainId} exists in the database.";

            output.AppendLine($"Villain: {villainName}");


            string minionsQuery = @"   SELECT m.[Name],
                                              m.Age
                                         FROM Villains AS v
                                    LEFT JOIN MinionsVillains AS mv ON v.Id = mv.VillainId
                                    LEFT JOIN Minions AS m ON m.Id = mv.MinionId
                                        WHERE mv.VillainId = @VillainId
                                     ORDER BY m.[Name]";
            SqlCommand minionsCommand = new SqlCommand(minionsQuery, sqlConnection);
            minionsCommand.Parameters.AddWithValue("@VillainId", villainId);

            SqlDataReader reader = minionsCommand.ExecuteReader();

            if (!reader.HasRows)
            {
                output.AppendLine("(no minions)");
            }
            else
            {
                int rowNum = 1;
                while (reader.Read())
                {
                    output.AppendLine($"{rowNum}. {reader["Name"]} {reader["Age"]}");
                    rowNum++;
                }
            }

            return output.ToString().TrimEnd();
        }

        // 4. Add Minion
        private static string AddNewMinion(SqlConnection sqlConnection, string[] minionInfo, 
            string villainName)
        {
            StringBuilder output = new StringBuilder();

            string minionName = minionInfo[0];
            int minionAge = int.Parse(minionInfo[1]);
            string townName = minionInfo[2];

            SqlTransaction sqlTransaction = sqlConnection.BeginTransaction();

            try
            {
                int townId = GetTownId(sqlConnection, sqlTransaction, output, townName);
                int villainId = GetVillainId(sqlConnection, sqlTransaction, output, villainName);
                int minionId = AddMinionAndGetId(sqlConnection, sqlTransaction, minionName, minionAge, townId);

                string addMinionToVillainQuery = @"INSERT INTO MinionsVillains (MinionId, VillainId)
                                                        VALUES
                                                        (@MinionId, @VillainId)";
                SqlCommand addMinionToVillainCmd =
                    new SqlCommand(addMinionToVillainQuery, sqlConnection, sqlTransaction);
                addMinionToVillainCmd.Parameters.AddWithValue("@MinionId", minionId);
                addMinionToVillainCmd.Parameters.AddWithValue("@VillainId", villainId);

                addMinionToVillainCmd.ExecuteNonQuery();
                output.AppendLine($"Successfully added {minionName} to be minion of {villainName}.");

                sqlTransaction.Commit();

            }
            catch (Exception e)
            {
                sqlTransaction.Rollback();
                return e.ToString();
            }

            return output.ToString().TrimEnd();
        }

        private static int AddMinionAndGetId(SqlConnection sqlConnection, SqlTransaction sqlTransaction, string minionName, int minionAge, int townId)
        {
            string addMinionQuery = @"INSERT INTO Minions([Name], Age, TownId)
                                               VALUES 
                                            (@MinionName, @MinionAge, @TownId)";
           
            SqlCommand addMinionCmd = new SqlCommand(addMinionQuery, sqlConnection, sqlTransaction);
            addMinionCmd.Parameters.AddWithValue("@MinionName", minionName);
            addMinionCmd.Parameters.AddWithValue("@MinionAge", minionAge);
            addMinionCmd.Parameters.AddWithValue("@TownId", townId);

            addMinionCmd.ExecuteNonQuery();

            string addedMinionIdQuery = @"SELECT Id
                                       FROM Minions
                                      WHERE [Name] = @MinionName AND Age = @MinionAge AND TownId = @TownId";
            
            SqlCommand getMinionIdCmd = new SqlCommand(addedMinionIdQuery, sqlConnection, sqlTransaction);
            getMinionIdCmd.Parameters.AddWithValue("@MinionName", minionName);
            getMinionIdCmd.Parameters.AddWithValue("@MinionAge", minionAge);
            getMinionIdCmd.Parameters.AddWithValue("@TownId", townId);

            int minionId = (int)getMinionIdCmd.ExecuteScalar();

            return minionId;
        }

        private static int GetVillainId(SqlConnection sqlConnection, SqlTransaction sqlTransaction, StringBuilder output, string villainName)
        {
            string villainIdQuery = @"SELECT Id
                                          FROM Villains
                                         WHERE [Name] = @VillainName";
            
            SqlCommand villainIdCmd = new SqlCommand(villainIdQuery, sqlConnection, sqlTransaction);
            villainIdCmd.Parameters.AddWithValue("@VillainName", villainName);

            object villainIdObj = villainIdCmd.ExecuteScalar();
            
            if (villainIdObj == null)
            {
                string evilnessFactorQuery = @"SELECT Id
                                                     FROM EvilnessFactors
                                                    WHERE [Name] = 'Evil'";
                
                SqlCommand evilnessFactorCmd =
                    new SqlCommand(evilnessFactorQuery, sqlConnection, sqlTransaction);
                
                int evilnessFactorId = (int)evilnessFactorCmd.ExecuteScalar();

                string insertVillainQuery = @"INSERT INTO Villains ([Name], EvilnessFactorId)
                                                     VALUES
                                                (@VillainName, @EvilnessFactorId)";
                
                SqlCommand insertVillainCmd =
                    new SqlCommand(insertVillainQuery, sqlConnection, sqlTransaction);
                insertVillainCmd.Parameters.AddWithValue("@VillainName", villainName);
                insertVillainCmd.Parameters.AddWithValue("@EvilnessFactorId", evilnessFactorId);

                insertVillainCmd.ExecuteNonQuery();
                output.AppendLine($"Villain {villainName} was added to the database.");

                villainIdObj = villainIdCmd.ExecuteScalar();
            }

            return (int)villainIdObj;
        }

        private static int GetTownId(SqlConnection sqlConnection, SqlTransaction sqlTransaction, StringBuilder output, string townName)
        {
            string townIdQuery = @"SELECT Id
                                     FROM Towns
                                    WHERE [Name] = @TownName";
            
            SqlCommand townIdCmd = new SqlCommand(townIdQuery, sqlConnection, sqlTransaction);
            townIdCmd.Parameters.AddWithValue("@TownName", townName);

            object townIdObj = townIdCmd.ExecuteScalar();
            
            if (townIdObj == null)
            {
                string addTownQuery = @"INSERT INTO Towns([Name])
                                             VALUES (@TownName)";
                
                SqlCommand addTownCmd = new SqlCommand(addTownQuery, sqlConnection, sqlTransaction);
                addTownCmd.Parameters.AddWithValue("@TownName", townName);

                addTownCmd.ExecuteNonQuery();

                output.AppendLine($"Town {townName} was added to the database.");

                townIdObj = townIdCmd.ExecuteScalar();
            }

            return (int)townIdObj;
        }

        // 5. Change Town Names Casing
        private static string ChangeTownNamesCasing(SqlConnection sqlConnection, string countryName)
        {
            string updateTownNamesQuery = @"UPDATE Towns
                                            SET Name = UPPER(Name)
                                            WHERE CountryCode = (SELECT c.Id 
                                                                FROM Countries AS c 
                                                                WHERE c.Name = @countryName)";

            using SqlCommand updateTownNamesCommand = new SqlCommand(updateTownNamesQuery, sqlConnection);

            updateTownNamesCommand.Parameters.AddWithValue("@countryName", countryName);

            int? affectedRows = updateTownNamesCommand.ExecuteNonQuery() as int?;

            if (affectedRows == 0)
                return "No town names were affected.";

            string selectTownNamesQuery = @" SELECT t.Name AS TownName
                                               FROM Towns as t
                                               JOIN Countries AS c ON c.Id = t.CountryCode
                                              WHERE c.Name = @countryName";

            using SqlCommand selectTownNamesCommand = new SqlCommand(selectTownNamesQuery, sqlConnection);

            selectTownNamesCommand.Parameters.AddWithValue("@countryName", countryName);

            using SqlDataReader reader = selectTownNamesCommand.ExecuteReader();

            List<string> townNames = new List<string>();

            while (reader.Read())
            {
                townNames.Add(reader["TownName"] as string);
            }

            StringBuilder output = new StringBuilder();
            output.AppendLine($"{townNames.Count} town names were affected.");
            output.AppendLine( String.Join(", ", townNames));

            return output.ToString().TrimEnd();
        }

        // 6. *Remove Villain 
        private static string DeleteVillain(SqlConnection sqlConnection, int villainId)
        {
            StringBuilder output = new StringBuilder();

            string villainNameQuery = @"SELECT [Name]
                                          FROM Villains
                                         WHERE Id = @VillainId";

            SqlCommand villainNameCmd = new SqlCommand(villainNameQuery, sqlConnection);
            villainNameCmd.Parameters.AddWithValue("@VillainId", villainId);

            string villainName = (string)villainNameCmd.ExecuteScalar();
            if (villainName == null)
                return $"No such villain was found.";

            SqlTransaction sqlTransaction = sqlConnection.BeginTransaction();
            
            try
            {
                string releaseMinionsQuery = @"DELETE FROM MinionsVillains
                                                 WHERE VillainId = @VillainId";
                
                SqlCommand releaseMinionsCmd =
                    new SqlCommand(releaseMinionsQuery, sqlConnection, sqlTransaction);
                releaseMinionsCmd.Parameters.AddWithValue("@VillainId", villainId);

                int minionsReleased = releaseMinionsCmd.ExecuteNonQuery();

                string deleteVillainQuery = @"DELETE FROM Villains
                                                WHERE Id = @VillainId";
                
                SqlCommand deleteVillainCmd =
                    new SqlCommand(deleteVillainQuery, sqlConnection, sqlTransaction);
                deleteVillainCmd.Parameters.AddWithValue("@VillainId", villainId);

                int villainsDeleted = deleteVillainCmd.ExecuteNonQuery();

                if (villainsDeleted != 1)
                {
                    sqlTransaction.Rollback();
                }

                output
                    .AppendLine($"{villainName} was deleted.")
                    .AppendLine($"{minionsReleased} minions were released.");
            }
            catch (Exception e)
            {
                sqlTransaction.Rollback();
                return e.ToString();
            }

            sqlTransaction.Commit();

            return output.ToString().TrimEnd();
        }
    }
}
