using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ProductsShop.Models
{
    public class Categorie
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(15, MinimumLength = 3)]
        public string Name { get; set; }

        public ICollection<CategoryProduct> Categories { get; set; }

        public Categorie()
        {
            Categories= new HashSet<CategoryProduct>();
        }
    }
}
