using Newtonsoft.Json;

namespace Artillery.DataProcessor.ImportDto
{
    public class ImportCountryForGunDto
    {
        [JsonProperty("Id")]
        public int Id { get; set; }
    }
}
