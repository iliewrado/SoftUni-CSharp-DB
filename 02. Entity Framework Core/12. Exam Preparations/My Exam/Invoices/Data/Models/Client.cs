using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Invoices.Data.Models
{
    [XmlType(Namespace = "Data")]
    public class Client
    {
        //•	Id – integer, Primary Key
        [Key]
        public int Id { get; set; }

        //•	Name – text with length[10…25] (required)
        [Required]
        [StringLength(25, MinimumLength = 10)]
        public string Name { get; set; }

        //•	NumberVat – text with length[10…15] (required)
        [Required]
        [StringLength(15, MinimumLength = 10)]
        public string NumberVat { get; set; }

        //•	Invoices – collection of type Invoicе
        public HashSet<Invoice> Invoices { get; set; }

        //•	Addresses – collection of type Address
        public HashSet<Address> Addresses { get; set; }

        //•	ProductsClients – collection of type ProductClient
        public HashSet<ProductClient> ProductsClients { get; set; }

        public Client()
        {
            this.Invoices = new HashSet<Invoice>();
            this.Addresses = new HashSet<Address>();
            this.ProductsClients = new HashSet<ProductClient>();
        }
    }
}
