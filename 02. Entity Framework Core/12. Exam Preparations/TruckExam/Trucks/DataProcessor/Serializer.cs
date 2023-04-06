namespace Trucks.DataProcessor
{
    using Data;
    using Newtonsoft.Json;
    using System.Text;
    using System.Xml.Serialization;
    using Trucks.DataProcessor.ExportDto;

    public class Serializer
    {
        public static string ExportDespatchersWithTheirTrucks(TrucksContext context)
        {
            var despatchers = context.Despatchers
                .Where(d => d.Trucks.Any())
                .ToArray()
                .Select(d => new ExportDespatcherWithTrucksDTO()
                {
                    TruckCount = d.Trucks.Count(),
                    Name = d.Name,
                    Trucks = d.Trucks
                              .Select(t => new ExportTrucksForDespatcherDTO()
                              {
                                  RegistrationNumber = t.RegistrationNumber,
                                  MakeType = t.MakeType.ToString()
                              })
                              .OrderBy(t => t.RegistrationNumber)
                              .ToArray()
                })
                .OrderByDescending(d => d.Trucks.Count())
                .ThenBy(d => d.Name)
                .ToArray();

            XmlSerializer xmlSerializer = 
                new XmlSerializer(typeof(ExportDespatcherWithTrucksDTO[]), new XmlRootAttribute("Despatchers"));
            XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
            namespaces.Add(string.Empty, string.Empty);

            StringBuilder result = new StringBuilder();
            StringWriter writer = new StringWriter(result);

            xmlSerializer.Serialize(writer, despatchers, namespaces);

            return result.ToString().TrimEnd();
        }

        public static string ExportClientsWithMostTrucks(TrucksContext context, int capacity)
        {
            var clients = context.Clients
                .Where(c => c.ClientsTrucks.Any(t => t.Truck.TankCapacity >= capacity))
                .ToArray()
                .Select(c => new ExportClientWithTrucksDTO()
                {
                    Name = c.Name,
                    Trucks = c.ClientsTrucks
                            .Where(t => t.Truck.TankCapacity >= capacity)
                            .Select(t => new ExportTruckDTO()
                            {
                                RegistrationNumber = t.Truck.RegistrationNumber,
                                VinNumber = t.Truck.VinNumber,
                                TankCapacity = t.Truck.TankCapacity,
                                CargoCapacity = t.Truck.CargoCapacity,
                                CategoryType = t.Truck.CategoryType.ToString(),
                                MakeType = t.Truck.MakeType.ToString()
                            })
                            .OrderBy(t => t.MakeType)
                            .ThenByDescending(t => t.CargoCapacity)
                            .ToArray()
                })
                .OrderByDescending(c => c.Trucks.Count())
                .ThenBy(c => c.Name)
                .Take(10)
                .ToArray();

            return JsonConvert.SerializeObject(clients, Formatting.Indented);
        }
    }
}
