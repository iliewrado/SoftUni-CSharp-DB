using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace SoftJail.DataProcessor.ImportDto
{
    public class ImportMailsForPrisonerDto
    {
        [JsonProperty("Description")]
        [Required(AllowEmptyStrings = false)]
        public string Description { get; set; }

        [JsonProperty("Sender")]
        [Required(AllowEmptyStrings = false)]
        public string Sender { get; set; }

        [JsonProperty("Address")]
        [Required(AllowEmptyStrings = false)]
        [RegularExpression(@"[A-Za-z\ \d]+str.")]
        public string Address { get; set; }
    }
}
