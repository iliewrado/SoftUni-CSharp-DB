using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    public class Country
    {
        [Key]
        public int CountryId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        
        [InverseProperty(nameof(Town))]
        public ICollection<Town> Towns { get; set; }


        public Country()
        {
            Towns= new HashSet<Town>();
        }
    }
}
