using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    internal class Town
    {
        [Key]
        public int TownId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        
        [ForeignKey(nameof(Country))]
        public string CountryId { get; set; }
        public Country Country { get; set; }

        
        [InverseProperty(nameof(Team))]
        public ICollection<Team> Teams { get; set; }

        public Town()
        {
            Teams = new HashSet<Team>();
        }
    }
}
