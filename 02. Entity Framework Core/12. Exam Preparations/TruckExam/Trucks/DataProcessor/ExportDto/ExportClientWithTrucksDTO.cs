using Newtonsoft.Json;

namespace Trucks.DataProcessor.ExportDto
{
    public class ExportClientWithTrucksDTO
    {
        [JsonProperty("Name")]
        public string Name { get; set; }

        [JsonProperty("Trucks")]
        public ExportTruckDTO[] Trucks { get; set; }
    }
}
