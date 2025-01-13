using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Invoices.Data.Models
{
    public class Address
    {
        //•	Id – integer, Primary Key
        [Key]
        public int Id { get; set; }

        //•	StreetName – text with length[10…20] (required)
        [Required]
        [StringLength(30, MinimumLength = 10)]
        public string StreetName { get; set; }

        //•	StreetNumber – integer(required)
        [Required]
        public int StreetNumber { get; set; }

        //•	PostCode – text(required)
        [Required]
        public string PostCode { get; set; }

        //•	City – text with length[5…15] (required)
        [Required]
        [StringLength(15, MinimumLength = 5)]
        public string City { get; set; }

        //•	Country – text with length[5…15] (required)
        [Required]
        [StringLength(15, MinimumLength = 5)]
        public string Country { get; set; }

        //•	ClientId – integer, foreign key(required)
        [Required]
        public int ClientId { get; set; }
        //•	Client – Client
        [ForeignKey(nameof(ClientId))]
        public Client Client { get; set; }
    }
}
