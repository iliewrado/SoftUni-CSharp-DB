using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProductsShop.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; }

        public string FirstName { get; set; }

        [Required]
        [MinLength(3)]
        public string LastName { get; set; }

        public int? Age { get; set; }

        [InverseProperty(nameof(Product.SellerId))]
        public ICollection<Product> ProductsSold { get; set; }

        [InverseProperty(nameof(Product.BuyerId))]
        public ICollection<Product> ProductsBought { get; set; }

        
        public User()
        {
            ProductsSold = new HashSet<Product>();
            ProductsBought= new HashSet<Product>();
        }    
    }
}
