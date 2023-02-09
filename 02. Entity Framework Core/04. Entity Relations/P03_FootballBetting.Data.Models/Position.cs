using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    public class Position
    {
        [Key]
        public int PositionId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        
        [InverseProperty(nameof(Player))]
        public ICollection<Player> Players { get; set; }

        
        public Position()
        {
            Players = new List<Player>();
        }
    }
}
