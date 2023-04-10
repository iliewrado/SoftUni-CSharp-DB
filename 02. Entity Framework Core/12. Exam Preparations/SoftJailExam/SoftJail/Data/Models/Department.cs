using System.ComponentModel.DataAnnotations;

namespace SoftJail.Data.Models
{
    public class Department
    {
        [Key]
        public int Id { get; set; }

        [Required(AllowEmptyStrings = false)]
        [StringLength(25, MinimumLength = 3)]
        public string Name { get; set; }

        public ICollection<Cell> Cells { get; set; }

        public Department()
        {
            this.Cells = new HashSet<Cell>();
        }
    }
}
