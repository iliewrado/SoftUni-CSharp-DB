namespace Footballers.DataProcessor
{
    using Data;
    using Footballers.Data.Models;
    using Footballers.DataProcessor.ExportDto;
    using Newtonsoft.Json;
    using System.Globalization;
    using System.Text;
    using System.Xml.Serialization;

    public class Serializer
    {
        public static string ExportCoachesWithTheirFootballers(FootballersContext context)
        {
            var coaches = context.Coaches
                .Where(c => c.Footballers.Any())
                .ToArray()
                .Select(c => new ExportCoachWithFootballersDto()
                {
                    FootballersCount = c.Footballers.Count(),
                    CoachName = c.Name,
                    Footballers = c.Footballers
                                   .Select(f => new ExportFootballerForCoachDto()
                                   { 
                                       Name = f.Name,
                                       Position = f.PositionType.ToString() 
                                   })
                                   .OrderBy(f => f.Name)
                                   .ToArray()
                })
                .OrderByDescending(c => c.FootballersCount)
                .ThenBy(c => c.CoachName)
                .ToArray();
            

            return SerializeXml(coaches, "Coaches");
        }

        public static string ExportTeamsWithMostFootballers(FootballersContext context, DateTime date)
        {
            var teams = context.Teams
                .Where(t => t.TeamsFootballers
                .Any(f => f.Footballer.ContractStartDate >= date))
                .ToArray()
                .Select(t => new ExportTeamdto()
                {
                    TeamName = t.Name,
                    TeamDto = t.TeamsFootballers
                                .Where(f => f.Footballer.ContractStartDate >= date)
                                .Select(f => new ExportFooballerTeamDto()
                                {
                                    FootballerName = f.Footballer.Name,
                                    BestSkil = f.Footballer.BestSkillType.ToString(),
                                    Position = f.Footballer.PositionType.ToString(),
                                    StartDate = f.Footballer.ContractStartDate.ToString("d", CultureInfo.InvariantCulture),
                                    EndDate = f.Footballer.ContractEndDate.ToString("d", CultureInfo.InvariantCulture)
                                })
                                .OrderByDescending(f => f.EndDate)
                                .ThenBy(f => f.FootballerName)
                                .ToArray()
                })
                .OrderByDescending(t => t.TeamDto.Count())
                .ThenBy(t => t.TeamName)
                .Take(5)
                .ToArray();

            return JsonConvert.SerializeObject(teams, Formatting.Indented);
        }

        private static string SerializeXml<T>(T dtObjects, string rootName)
        {
            XmlSerializer xmlSerializer =
               new XmlSerializer(typeof(T), new XmlRootAttribute(rootName));
            XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
            namespaces.Add(string.Empty, string.Empty);

            StringBuilder result = new StringBuilder();
            StringWriter writer = new StringWriter(result);

            xmlSerializer.Serialize(writer, dtObjects, namespaces);

            return result.ToString().TrimEnd();
        }
    }
}
