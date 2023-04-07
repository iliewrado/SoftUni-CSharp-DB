using Newtonsoft.Json;

namespace Footballers.DataProcessor.ExportDto
{
    public class ExportTeamdto
    {
        [JsonProperty("Name")]
        public string TeamName { get; set; }

        [JsonProperty("Footballers")]
        public ExportFooballerTeamDto[] TeamDto { get; set; }
    }
}
