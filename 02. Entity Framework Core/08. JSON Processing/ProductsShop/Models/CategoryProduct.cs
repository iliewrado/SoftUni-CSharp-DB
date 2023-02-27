using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProductsShop.Models
{
    public class CategoryProduct
    {
        [Key]
        public int CategoryId { get; set; }

        [Key]
        public int ProductId { get; set; }

        [ForeignKey(nameof(CategoryId))]
        public Categorie Categorie { get; set; }

        [ForeignKey(nameof(ProductId))]
        public Product Product { get; set; }
    }
}
