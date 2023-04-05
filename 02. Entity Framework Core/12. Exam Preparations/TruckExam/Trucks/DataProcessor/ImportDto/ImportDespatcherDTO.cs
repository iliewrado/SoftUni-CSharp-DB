using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Trucks.DataProcessor.ImportDto
{
    [XmlType("Despatcher")]
    public class ImportDespatcherDTO
    {
        [XmlElement("Name")]
        [Required]
        [StringLength(40, MinimumLength = 2)]
        public string Name { get; set; }

        [XmlElement("Position")]
        [Required(AllowEmptyStrings = false)]
        public string? Position { get; set; }
        public List<ImportTruckDTO> Trucks { get; set; }

        public ImportDespatcherDTO()
        {
            Trucks = new List<ImportTruckDTO>();
        }
    }
}
