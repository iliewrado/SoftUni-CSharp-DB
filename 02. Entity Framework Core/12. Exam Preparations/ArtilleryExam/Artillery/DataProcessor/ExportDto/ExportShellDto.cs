using Newtonsoft.Json;

namespace Artillery.DataProcessor.ExportDto
{
    public class ExportShellDto
    {
        [JsonProperty("ShellWeight")]
        public double ShellWeight { get; set; }

        [JsonProperty("Caliber")]
        public string Caliber { get; set; }

        [JsonProperty("Guns")]
        public ExportGunforShellDto[] Guns { get; set; }
    }
}
