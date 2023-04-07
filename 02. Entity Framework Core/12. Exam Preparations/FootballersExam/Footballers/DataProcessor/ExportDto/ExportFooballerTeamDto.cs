using Newtonsoft.Json;

namespace Footballers.DataProcessor.ExportDto
{

    public class ExportFooballerTeamDto
    {
        [JsonProperty("FootballerName")]
        public string FootballerName { get; set; }
        [JsonProperty("ContractStartDate")]
        public string StartDate { get; set; }

        [JsonProperty("ContractEndDate")]
        public string EndDate { get; set; }

        [JsonProperty("BestSkillType")]
        public string BestSkil { get; set; }

        [JsonProperty("PositionType")]
        public string Position { get; set; }
    }
}
