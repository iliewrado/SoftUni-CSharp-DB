using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Footballers.DataProcessor.ImportDto
{
    [XmlType("Coach")]
    public class ImportCoachesDto
    {
        [XmlElement("Name")]
        [Required]
        [StringLength(40, MinimumLength = 2)]
        public string Name { get; set; }

        [XmlElement("Nationality")]
        [Required(AllowEmptyStrings = false)]
        public string Nationality { get; set; }

        public List<ImportFootballersDto> Footballers { get; set; }

        public ImportCoachesDto()
        {
            this.Footballers = new List<ImportFootballersDto>();
        }
    }
}
