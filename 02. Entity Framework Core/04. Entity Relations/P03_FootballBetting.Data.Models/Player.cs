using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P03_FootballBetting.Data.Models
{
    internal class Player
    {
        [Key]
        public int PlayerId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        public byte SquadNumber { get; set; }

        [ForeignKey(nameof(Team))]
        public int TeamId { get; set; }
        public Team Team { get; set; }

        
        [ForeignKey(nameof(Position))]
        public int PositionId { get; set; }
        public Position Position { get; set; }

        public bool IsInjured { get; set; } = false;


        [InverseProperty(nameof(PlayerStatistics))]
        public ICollection<PlayerStatistic> PlayerStatistics { get; set; }

        public Player()
        {
            PlayerStatistics = new HashSet<PlayerStatistic>();
        }
    }
}
