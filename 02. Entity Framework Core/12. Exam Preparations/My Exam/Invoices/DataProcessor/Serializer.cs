namespace Invoices.DataProcessor
{
    using Invoices.Data;
    using Invoices.DataProcessor.ExportDto;
    using Newtonsoft.Json;
    using System.Globalization;
    using System.Text;
    using System.Xml.Serialization;

    public class Serializer
    {
        public static string ExportClientsWithTheirInvoices(InvoicesContext context, DateTime date)
        {
            var clients = context.Clients
                .Where(c => c.Invoices.Any(i => i.IssueDate > date))
                .ToArray()
                .Select(c => new ExportClientWithInvoiceDto()
                {
                    ClientName = c.Name,
                    VatNumber = c.NumberVat,
                    InvoicesCount = c.Invoices.Count,
                    inviceDto = c.Invoices
                                .Select(i => new ExportInvoiceClientDto()
                                {
                                    DueDate = i.DueDate.ToString("d", CultureInfo.InvariantCulture),
                                    Currency = i.CurrencyType.ToString(),
                                    InvoiceAmount = i.Amount,
                                    InvoiceNumber = i.Number,
                                    IssueDate = i.IssueDate.ToString()
                                })
                                .OrderBy(c => c.IssueDate)
                                .ThenByDescending(i => i.DueDate)
                                .ToArray()
                })
                .OrderByDescending(c => c.InvoicesCount)
                .ThenBy(c => c.ClientName)
                .ToArray();

            return SerializeXml(clients, "Clients");
        }

        public static string ExportProductsWithMostClients(InvoicesContext context, int nameLength)
        {
            var products = context.Products
                .Where(p => context.ProductsClients.Any())
                .ToArray()
                .Select(p => new ExportProductDto()
                {
                    Name = p.Name,
                    Category = p.CategoryType.ToString(),
                    Price = p.Price,
                    ClientProductDto = p.ProductsClients
                    .Where(c => c.Client.Name.Length >= nameLength)
                    .Select(c => new ExportClientProductDto()
                    {
                        Name = c.Client.Name,
                        NumberVat = c.Client.NumberVat
                    })
                    .OrderBy(n => n.Name)
                    .ToArray()
                })
                .OrderByDescending(p => p.ClientProductDto.Count())
                .ThenBy(p => p.Name)
                .Take(5)
                .ToArray();

            return JsonConvert.SerializeObject(products, Formatting.Indented);
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