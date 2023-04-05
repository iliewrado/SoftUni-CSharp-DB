namespace Trucks.DataProcessor
{
    using System.ComponentModel.DataAnnotations;
    using System.Text;
    using System.Xml.Serialization;
    using Data;
    using Newtonsoft.Json;
    using Trucks.Data.Models;
    using Trucks.Data.Models.Enums;
    using Trucks.DataProcessor.ImportDto;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedDespatcher
            = "Successfully imported despatcher - {0} with {1} trucks.";

        private const string SuccessfullyImportedClient
            = "Successfully imported client - {0} with {1} trucks.";

        public static string ImportDespatcher(TrucksContext context, string xmlString)
        {
            StringBuilder result = new StringBuilder();

            XmlSerializer serializer = 
                new XmlSerializer(typeof(ImportDespatcherDTO[]), new XmlRootAttribute("Despatchers"));
            var importDtos = 
                serializer.Deserialize(new StringReader(xmlString)) as ImportDespatcherDTO[];
            List<Despatcher> validDespatcher = new List<Despatcher>();

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Despatcher despatcher = new Despatcher()
                {
                    Name = dto.Name,
                    Position = dto.Position
                };

                foreach (var truckd in dto.Trucks)
                {
                    if (!IsValid(truckd))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    Truck truck = new Truck()
                    {
                        RegistrationNumber = truckd.RegistrationNumber,
                        VinNumber = truckd.VinNumber,
                        TankCapacity = truckd.TankCapacity,
                        CargoCapacity = truckd.CargoCapacity,
                        CategoryType = (CategoryType)truckd.CategoryType,
                        MakeType = (MakeType)truckd.MakeType,
                    };

                    despatcher.Trucks.Add(truck);
                }

                validDespatcher.Add(despatcher);
                result.AppendLine(String
                    .Format(SuccessfullyImportedDespatcher, despatcher.Name, despatcher.Trucks.Count));
            }

            context.Despatchers.AddRange(validDespatcher);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }
        public static string ImportClient(TrucksContext context, string jsonString)
        {
            StringBuilder result = new StringBuilder();

            var importDtos = JsonConvert.DeserializeObject<ImportClientDTO[]>(jsonString);
            List<Client> validClients = new List<Client>();

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                if (dto.Type == "usual")
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Client client = new Client()
                {
                    Name = dto.Name,
                    Nationality = dto.Nationality,
                    Type = dto.Type,
                };

                foreach (var item in dto.Trucks.Distinct())
                {
                    if (!context.Trucks.Any(t=> t.Id == item))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    ClientTruck clientTruck = new ClientTruck()
                    {
                        Client = client,
                        ClientId = client.Id,
                        Truck = context.Trucks.First(t => t.Id == item),
                        TruckId = item
                    };

                    client.ClientsTrucks.Add(clientTruck);
                }

                validClients.Add(client);
                result.AppendLine(String
                    .Format(SuccessfullyImportedClient, client.Name, client.ClientsTrucks.Count));
            }

            context.Clients.AddRange(validClients);
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