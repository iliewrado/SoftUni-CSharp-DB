using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Trucks.Data.Models;

namespace Trucks.DataProcessor.ImportDto
{
    [JsonObject]
    public class ImportClientDTO
    {
        [JsonProperty("Name")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(40, MinimumLength = 3)]
        public string Name { get; set; }

        [JsonProperty("Nationality")]
        [Required]
        [StringLength(40, MinimumLength = 2)]
        public string Nationality { get; set; }

        [JsonProperty("Type")]
        [Required]
        public string Type { get; set; }

        [JsonProperty("Trucks")]
        public int[] Trucks { get; set; }
    }
}
