using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Invoices.DataProcessor.ImportDto
{
    [XmlType("Address")]
    public class ImportAddressDto
    {
        [XmlElement("StreetName")]
        //•	StreetName – text with length[10…20] (required)
        [Required(AllowEmptyStrings = false)]
        [StringLength(30, MinimumLength = 10)]
        public string StreetName { get; set; }

        [XmlElement("StreetNumber")]
        //•	StreetNumber – integer(required)
        [Required]
        public int StreetNumber { get; set; }

        [XmlElement("PostCode")]
        //•	PostCode – text(required)
        [Required(AllowEmptyStrings = false)]
        public string PostCode { get; set; }

        [XmlElement("City")]
        //•	City – text with length[5…15] (required)
        [Required(AllowEmptyStrings = false)]
        [StringLength(15, MinimumLength = 5)]
        public string City { get; set; }

        [XmlElement("Country")]
        //•	Country – text with length[5…15] (required)
        [Required(AllowEmptyStrings = false)]
        [StringLength(15, MinimumLength = 5)]
        public string Country { get; set; }

        //•	ClientId – integer, foreign key(required)
        [Required]
        public int ClientId { get; set; }
    }
}
