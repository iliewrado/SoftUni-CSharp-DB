using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Trucks.DataProcessor.ImportDto
{
    [XmlType("Truck")]
    public class ImportTruckDTO
    {
        [XmlElement("RegistrationNumber")]
        [RegularExpression("^[A-Z]{2}[\\d]{4}[A-Z]{2}$")]
        [Required]
        public string RegistrationNumber { get; set; }

        [Required]
        [StringLength(17)]
        [XmlElement("VinNumber")]
        public string VinNumber { get; set; }

        [Required]
        [XmlElement("TankCapacity")]
        [Range(950, 1420)]
        public int TankCapacity { get; set; }

        [XmlElement("CargoCapacity")]
        [Range(5000, 29000)]
        public int CargoCapacity { get; set; }

        [XmlElement("CategoryType")]
        [Required]
        public int CategoryType { get; set; }

        [XmlElement("MakeType")]
        [Required]
        public int MakeType { get; set; }
    }
}   
