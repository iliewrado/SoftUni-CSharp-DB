using Footballers.Data.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Footballers.DataProcessor.ImportDto
{
    public class ImportTeamsDto
    {
        [JsonProperty("Name")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(40, MinimumLength = 3)]
        [RegularExpression(@"[A-Za-z\d\ \.\-]+")]
        public string Name { get; set; }

        [JsonProperty("Nationality")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(40, MinimumLength = 2)]
        public string Nationality { get; set; }

        [JsonProperty("Trophies")]
        [Required(AllowEmptyStrings = false)]
        public int Trophies { get; set; }

        [JsonProperty("Footballers")]
        public int[] TeamsFootballers { get; set; }
    }
}
