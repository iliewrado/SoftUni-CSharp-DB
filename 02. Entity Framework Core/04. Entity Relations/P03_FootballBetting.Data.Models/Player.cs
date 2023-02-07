using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P03_FootballBetting.Data.Models
{
    internal class Player
    {
        public int PlayerId { get; set; }
        
        public string Name { get; set; }

        public string SquadNumber { get; set; }

        public int TeamId { get; set; }
        public Team Team { get; set; }

        public int PositionId { get; set; }
        public Position Position { get; set; }

        public bool IsInjured { get; set; } = false;

        public ICollection<Game> PlayerStatistics { get; set; }

        public Player()
        {
            PlayerStatistics = new HashSet<Game>();
        }
    }
}
