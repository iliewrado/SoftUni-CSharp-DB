using Newtonsoft.Json;

namespace Invoices.DataProcessor.ExportDto
{
    public class ExportClientProductDto
    {
        [JsonProperty("Name")]
        public string Name { get; set; }

        [JsonProperty("NumberVat")]
        public string NumberVat { get; set; }
    }
}
