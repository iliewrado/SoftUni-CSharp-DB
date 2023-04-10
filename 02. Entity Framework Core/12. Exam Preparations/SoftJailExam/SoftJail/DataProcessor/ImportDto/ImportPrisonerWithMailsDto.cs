using SoftJail.Data.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace SoftJail.DataProcessor.ImportDto
{
    public class ImportPrisonerWithMailsDto
    {
        [JsonProperty("FullName")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(20, MinimumLength = 3)]
        public string FullName { get; set; }

        [JsonProperty("Nickname")]
        [Required(AllowEmptyStrings = false)]
        [RegularExpression(@"The [A-Z]{1}[a-z]+")]
        public string Nickname { get; set; }

        [JsonProperty("Age")]
        [Required]
        [Range(18, 65)]
        public int Age { get; set; }

        [JsonProperty("IncarcerationDate")]
        [Required]
        public string IncarcerationDate { get; set; }

        [JsonProperty("ReleaseDate")]
        public string? ReleaseDate { get; set; }

        [JsonProperty("Bail")]
        [Range(typeof(decimal), "0", "79228162514264337593543950335")]
        public decimal? Bail { get; set; }

        [JsonProperty("CellId")]
        [Required]
        public int CellId { get; set; }

        [JsonProperty("Mails")]
        public ImportMailsForPrisonerDto[] Mails { get; set; }
    }
}
    