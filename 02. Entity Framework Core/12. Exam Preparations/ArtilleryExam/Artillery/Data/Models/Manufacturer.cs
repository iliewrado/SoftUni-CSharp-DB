using System.ComponentModel.DataAnnotations;

namespace Artillery.Data.Models
{
    public class Manufacturer
    {
        [Key]
        public int Id { get; set; }

        //Unique
        [Required]
        [StringLength(40, MinimumLength = 4)]
        public string ManufacturerName { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 10)]
        public string Founded { get; set; }

        public ICollection<Gun> Guns { get; set; }

        public Manufacturer()
        {
            this.Guns = new HashSet<Gun>();
        }
    }
}
