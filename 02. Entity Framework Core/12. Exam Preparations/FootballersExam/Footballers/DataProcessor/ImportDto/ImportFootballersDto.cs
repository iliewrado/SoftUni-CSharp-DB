using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Footballers.DataProcessor.ImportDto
{
    [XmlType("Footballer")]
    public class ImportFootballersDto
    {
        [XmlElement("Name")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(40, MinimumLength = 2)]
        public string Name { get; set; }

        [XmlElement("ContractStartDate")]
        [Required(AllowEmptyStrings = false)]
        public string ContractStartDate { get; set; }

        [XmlElement("ContractEndDate")]
        [Required(AllowEmptyStrings = false)]
        public string ContractEndDate { get; set; }

        [XmlElement("PositionType")]
        [Required]
        public int PositionType { get; set; }

        [XmlElement("BestSkillType")]
        [Required]
        public int BestSkillType { get; set; }
    }
}
