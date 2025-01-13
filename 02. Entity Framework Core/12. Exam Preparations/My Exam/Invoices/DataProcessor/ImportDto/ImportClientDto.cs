using Invoices.Data.Models;
using Invoices.DataProcessor.ImportDto;

using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Invoices.DataProcessor.ImportDto
{
    [XmlType("Client")]
    public class ImportClientDto
    {
        [XmlElement("Name")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(25, MinimumLength = 10)]
        public string Name { get; set; }

        [XmlElement("NumberVat")]
        //•	NumberVat – text with length[10…15] (required)
        [Required(AllowEmptyStrings = false)]
        [StringLength(15, MinimumLength = 10)]
        public string NumberVat { get; set; }

        //•	Invoices – collection of type Invoicе
        [XmlElement("Addresses")]
        //•	Addresses – collection of type Address
        public Address[] Addresses { get; set; }

    }
}
