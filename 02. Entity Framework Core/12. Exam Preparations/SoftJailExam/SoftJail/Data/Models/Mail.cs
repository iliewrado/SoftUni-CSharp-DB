using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SoftJail.Data.Models
{
    public class Mail
    {
        [Key]
        public int Id { get; set; }

        [Required(AllowEmptyStrings = false)]
        public string Description { get; set; }

        [Required(AllowEmptyStrings = false)]
        public string Sender { get; set; }

        [Required(AllowEmptyStrings = false)]
        [RegularExpression(@"[A-Za-z\ \d]+str.")]
        public string Address { get; set; }

        [Required]
        public int PrisonerId { get; set; }
        [ForeignKey(nameof(PrisonerId))]
        public Prisoner Prisoner { get; set; }
    }
}
