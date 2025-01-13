using Invoices.Data.Models.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Invoices.Data.Models
{
    public class Invoice
    {
        //•	Id – integer, Primary Key
        [Key]
        public int Id { get; set; }

        //•	Number – integer in range[1, 000, 000, 000…1, 500, 000, 000] (required)
        [Required]
        [Range(1000000000, 1500000000)]
        public int Number { get; set; }

        //•	IssueDate – DateTime(required)
        [Required]
        public DateTime IssueDate { get; set; }

        //•	DueDate – DateTime(required)
        [Required]
        public DateTime DueDate { get; set; }

        //•	Amount – decimal (required)
        [Required]
        public decimal Amount { get; set; }

        //•	CurrencyType – enumeration of type CurrencyType, with possible values(BGN, EUR, USD) (required)
        [Required]
        public CurrencyType CurrencyType { get; set; }

        //•	ClientId – integer, foreign key(required)
        [Required]
        public int ClientId { get; set; }
        //•	Client – Client
        [ForeignKey(nameof(ClientId))]
        public Client Client { get; set; }
    }
}
