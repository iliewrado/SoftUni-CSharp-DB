using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P03_FootballBetting.Data.Models
{
    internal class Town
    {
        public int TownId { get; set; }

        public string Name { get; set; }

        public string CountryId { get; set; }
        public Country Country { get; set; }

        public ICollection<Team> Teams { get; set; }

        public Town()
        {
            Teams = new HashSet<Team>();
        }
    }
}
