namespace Invoices.DataProcessor
{
    using System.ComponentModel.DataAnnotations;
    using System.Text;
    using System.Xml.Serialization;
    using Invoices.Data;
    using Invoices.Data.Models;
    using Invoices.Data.Models.Enums;
    using Invoices.DataProcessor.ImportDto;
    using Newtonsoft.Json;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedClients
            = "Successfully imported client {0}.";

        private const string SuccessfullyImportedInvoices
            = "Successfully imported invoice with number {0}.";

        private const string SuccessfullyImportedProducts
            = "Successfully imported product - {0} with {1} clients.";


        public static string ImportClients(InvoicesContext context, string xmlString)
        {
            XmlSerializer serializer =
                    new XmlSerializer(typeof(ImportClientDto[]), new XmlRootAttribute("Clients"));
            var importDtos =
                serializer.Deserialize(new StringReader(xmlString)) as ImportClientDto[];
            List<Client> validclients = new List<Client>();
            StringBuilder output = new StringBuilder();

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                } 
                
                Client client = new Client()
                {
                    Name = dto.Name,
                    NumberVat = dto.NumberVat
                };

                foreach (var adto in dto.Addresses)
                {
                    if(!IsValid(adto))
                    {
                        output.AppendLine(ErrorMessage);
                        continue;
                    }

                    Address address = new Address()
                    {
                        StreetName = adto.StreetName,
                        StreetNumber = adto.StreetNumber,
                        City = adto.City,
                        PostCode = adto.PostCode,
                        Country = adto.Country,
                        ClientId = client.Id,
                        Client = client
                    };

                    client.Addresses.Add(address);
                }

                validclients.Add(client);
                output.AppendLine(String.Format(SuccessfullyImportedClients, client.Name));
            }

            context.AddRange(validclients);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }


        public static string ImportInvoices(InvoicesContext context, string jsonString)
        {
            StringBuilder output = new StringBuilder();
            var importDtos = JsonConvert.DeserializeObject<ImportInvoiceDto[]>(jsonString);
            List<Invoice> validInvoices = new List<Invoice>();


            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                DateTime issueDate;
                if (!DateTime.TryParse(dto.IssueDate, out issueDate))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                DateTime dueDate;
                if (!DateTime.TryParse(dto.DueDate, out dueDate))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                if (issueDate > dueDate)
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Invoice invoice = new Invoice()
                {
                    Number = dto.Number,
                    IssueDate = issueDate,
                    DueDate = dueDate,
                    Amount = dto.Amount,
                    CurrencyType = (CurrencyType)dto.CurrencyType,
                    ClientId = dto.ClientId,
                    Client = context.Clients.First(c => c.Id == dto.ClientId)
                };
                
                validInvoices.Add(invoice);
                output.AppendLine(String.Format(SuccessfullyImportedInvoices, invoice.Number));
            }

            context.AddRange(validInvoices);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }

        public static string ImportProducts(InvoicesContext context, string jsonString)
        {
            StringBuilder output = new StringBuilder();
            List<Product> validProducts = new List<Product>();
            List<ProductClient> productClients  = new List<ProductClient>();
            var importDto = JsonConvert.DeserializeObject<ImportProductDto[]>(jsonString);

            foreach (var dto in importDto)
            {
                if(!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage); 
                    continue;
                }

                CategoryType categoryType;
                if(!Enum.TryParse(dto.CategoryType.ToString(), out categoryType))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Product product = new Product()
                { 
                    Name = dto.Name,
                    CategoryType = categoryType,
                    Price = dto.Price,
                };

                foreach (var pc in dto.ProductsClients.Distinct())
                {
                    if(!context.Clients.Any(c => c.Id == pc))
                    {
                        output.AppendLine(ErrorMessage);
                        continue;
                    }

                    ProductClient productClient = new ProductClient()
                    {
                        Product = product,
                        ProductId = product.Id,
                        ClientId = pc,
                        Client = context.Clients.First(c => c.Id == pc)
                    };

                    productClients.Add(productClient);
                }


                validProducts.Add(product);
                output.AppendLine(String.Format(SuccessfullyImportedProducts, product.Name, product.ProductsClients.Count));
            }

            context.AddRange(productClients);
            context.AddRange(validProducts);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }

        public static bool IsValid(object dto)
        {
            var validationContext = new ValidationContext(dto);
            var validationResult = new List<ValidationResult>();

            return Validator.TryValidateObject(dto, validationContext, validationResult, true);
        }
    } 
}
