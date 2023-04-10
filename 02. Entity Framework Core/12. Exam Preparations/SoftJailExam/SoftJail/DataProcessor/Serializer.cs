namespace SoftJail.DataProcessor
{
    using Data;
    using Newtonsoft.Json;
    using SoftJail.DataProcessor.ExportDto;
    using System.Text;
    using System.Xml.Serialization;

    public class Serializer
    {
        public static string ExportPrisonersByCells(SoftJailDbContext context, int[] ids)
        {
            var prisoners = context.Prisoners
                .Where(p => ids.Contains(p.Id))
                .Select(p => new ExportPrisonerOfficerDto()
                {
                    Id = p.Id,
                    Name = p.FullName,
                    CellNumber = p.CellId,
                    Officers = p.PrisonerOfficers
                                .Where(o => o.PrisonerId == p.Id)
                                .Select(o => new ExportOfficerDto()
                                {
                                    OfficerName = o.Officer.FullName,
                                    Department = o.Officer.Department.Name,
                                    Salary = o.Officer.Salary
                                })
                                .OrderBy(o => o.OfficerName)
                                .ToArray(),
                    TotalOfficerSalary = p.PrisonerOfficers
                        .Where(o => o.PrisonerId == p.Id)
                        .Sum(of => of.Officer.Salary)
                })
                .OrderBy(p => p.Name)
                .ThenBy(p => p.Id)
                .ToArray();

            return JsonConvert.SerializeObject(prisoners, Formatting.Indented);
        }

        public static string ExportPrisonersInbox(SoftJailDbContext context, string prisonersNames)
        {
            string[] prisonerName = prisonersNames
                .Split(',', StringSplitOptions.RemoveEmptyEntries).ToArray();

            var prisoners = context.Prisoners
                .Where(p => prisonerName.Contains(p.FullName))
                .ToArray()
                .Select(p => new ExportPrisonersDto()
                {
                    Id = p.Id,
                    Name = p.FullName,
                    IncarcerationDate = p.IncarcerationDate.ToString("yyyy-MM-dd"),
                    Messages = p.Mails
                                .Select(m => new ExportMessageDto()
                                {
                                    Description = new string(m.Description.Reverse().ToArray())
                                })
                                .ToArray()
                })
                .OrderBy(p => p.Name)
                .ThenBy(p => p.Id)
                .ToArray();

            return SerializeXml(prisoners, "Prisoners");
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