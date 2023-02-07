using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P03_FootballBetting.Data.Models
{
    internal class Position
    {
        public int PositionId { get; set; }

        public string Name { get; set; }

        public ICollection<Player> Players { get; set; }

        
        public Position()
        {
            Players = new List<Player>();
        }
    }
}
