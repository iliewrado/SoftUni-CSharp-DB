using SoftJail.Data.Models.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SoftJail.Data.Models
{
    public class Officer
    {
        [Key]
        public int Id { get; set; }

        [Required(AllowEmptyStrings = false)]
        [StringLength(20, MinimumLength = 3)]
        public string FullName { get; set; }

        [Range(typeof(decimal), "0", "79228162514264337593543950335")]
        public decimal Salary  { get; set; }

        [Required]
        public Position Position { get; set; }

        [Required]
        public Weapon Weapon { get; set; }

        [Required]
        public int DepartmentId { get; set; }
        [ForeignKey(nameof(DepartmentId))]
        public Department Department { get; set; }

        public ICollection<OfficerPrisoner> OfficerPrisoners { get; set; }

        public Officer()
        {
            this.OfficerPrisoners = new HashSet<OfficerPrisoner>();
        }
    }
}
