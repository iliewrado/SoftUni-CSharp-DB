using Invoices.Data.Models.Enums;
using System.ComponentModel.DataAnnotations;

namespace Invoices.Data.Models
{
    public class Product
    {
        //•	Id – integer, Primary Key
        [Key]
        public int Id { get; set; }

        //Name – text with length[9…30] (required)
        [Required]
        [StringLength(30, MinimumLength = 9)]
        public string Name { get; set; }

        //Price – decimal in range[5.00…1000.00] (required)
        [Required]
        [Range(typeof(decimal), "5.00", "1000.00")]
        public decimal Price { get; set; }
        
        //CategoryType – enumeration of type CategoryType, with possible values(ADR, Filters, Lights, Others, Tyres) (required)
        [Required]
        public CategoryType CategoryType { get; set; }

        //ProductsClients – collection of type ProductClient
        public HashSet<ProductClient> ProductsClients { get; set; }

        public Product()
        {
            this.ProductsClients = new HashSet<ProductClient>();
        }
    }
}
