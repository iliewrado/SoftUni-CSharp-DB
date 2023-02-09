using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    public class Color
    {
        [Key]
        public int ColorId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        
        [InverseProperty(nameof(Team.PrimaryKitColor))]
        public ICollection<Team> PrimaryKitTeams { get; set; }


        [InverseProperty(nameof(Team.SecondaryKitColor))]
        public ICollection<Team> SecondaryKitTeams { get; set; }

        
        public Color()
        {
            PrimaryKitTeams = new HashSet<Team>();
            SecondaryKitTeams = new HashSet<Team>();  
        }
    }
}
