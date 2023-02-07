using System.Collections.Generic;

namespace P03_FootballBetting.Data.Models
{
    internal class Color
    {
        public int ColorId { get; set; }
        
        public string Name { get; set; }

        public ICollection<Team> PrimaryKitTeams { get; set; }

        public ICollection<Team> SecondaryKitTeams { get; set; }

        public Color()
        {
            PrimaryKitTeams = new HashSet<Team>();
            SecondaryKitTeams = new HashSet<Team>();  
        }
    }
}
