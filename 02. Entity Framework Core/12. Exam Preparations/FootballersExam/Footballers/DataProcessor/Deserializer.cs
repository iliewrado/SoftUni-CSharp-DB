namespace Footballers.DataProcessor
{
    using Footballers.Data;
    using Footballers.Data.Models;
    using Footballers.Data.Models.Enums;
    using Footballers.DataProcessor.ImportDto;
    using Newtonsoft.Json;
    using System.ComponentModel.DataAnnotations;
    using System.Text;
    using System.Xml.Serialization;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedCoach
            = "Successfully imported coach - {0} with {1} footballers.";

        private const string SuccessfullyImportedTeam
            = "Successfully imported team - {0} with {1} footballers.";

        public static string ImportCoaches(FootballersContext context, string xmlString)
        {
            StringBuilder result = new StringBuilder();

            XmlSerializer serializer =
                new XmlSerializer(typeof(ImportCoachesDto[]), new XmlRootAttribute("Coaches"));
            var importDtos =
                serializer.Deserialize(new StringReader(xmlString)) as ImportCoachesDto[];
            List<Coach> validCoaches = new List<Coach>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Coach coach = new Coach()
                {
                    Name = dto.Name,
                    Nationality = dto.Nationality
                };

                foreach (var footboler in dto.Footballers)
                {
                    if (!IsValid(footboler))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    DateTime startDate;
                    if (!DateTime.TryParse(footboler.ContractStartDate, out startDate))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    DateTime endDate;
                    if (!DateTime.TryParse(footboler.ContractEndDate, out endDate))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    if (startDate > endDate)
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    Footballer footballer = new Footballer()
                    {
                        Name = footboler.Name,
                        BestSkillType = (BestSkillType)footboler.BestSkillType,
                        PositionType = (PositionType)footboler.PositionType,
                        ContractStartDate = startDate,
                        ContractEndDate = endDate,
                        Coach = coach,
                        CoachId = coach.Id
                    };

                    coach.Footballers.Add(footballer);
                }

                validCoaches.Add(coach);
                result.AppendLine(String
                    .Format(SuccessfullyImportedCoach, coach.Name, coach.Footballers.Count));
            }

            context.AddRange(validCoaches);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }

        public static string ImportTeams(FootballersContext context, string jsonString)
        {
            StringBuilder result = new StringBuilder();

            var importDtos = JsonConvert.DeserializeObject<ImportTeamsDto[]>(jsonString);
            List<Team> validTeams = new List<Team>();

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                if(dto.Trophies == 0)
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Team team = new Team()
                {
                    Name = dto.Name,
                    Nationality = dto.Nationality,
                    Trophies = dto.Trophies
                };

                foreach (var footbaler in dto.TeamsFootballers.Distinct())
                {
                    if(!context.Footballers.Any(f=> f.Id == footbaler))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    TeamFootballer teamFootballer = new TeamFootballer()
                    {
                        Team = team,
                        TeamId = team.Id,
                        Footballer = context.Footballers.First(f => f.Id == footbaler),
                        FootballerId = footbaler
                    };

                    team.TeamsFootballers.Add(teamFootballer);
                }

                validTeams.Add(team);
                result.AppendLine(String.Format(SuccessfullyImportedTeam, team.Name, team.TeamsFootballers.Count));
            }

            context.AddRange(validTeams);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }

        private static bool IsValid(object dto)
        {
            var validationContext = new ValidationContext(dto);
            var validationResult = new List<ValidationResult>();

            return Validator.TryValidateObject(dto, validationContext, validationResult, true);
        }
    }
}
