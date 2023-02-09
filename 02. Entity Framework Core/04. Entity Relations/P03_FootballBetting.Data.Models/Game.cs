using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P03_FootballBetting.Data.Models
{
    public class Game
    {
        [Key]
        public int GameId { get; set; }

        [ForeignKey(nameof(Team.HomeGames))]
        public int HomeTeamId { get; set; }
        public Team HomeTeam { get; set; }

        [ForeignKey(nameof(Team.AwayGames))]
        public int AwayTeamId { get; set; }
        public Team AwayTeam { get; set; }


        public int HomeTeamGoals { get; set; }

        public int AwayTeamGoals { get; set; }

        public DateTime DateTime { get; set; }

        public decimal HomeTeamBetRate { get; set; }

        public decimal AwayTeamBetRate { get; set; }

        public decimal DrawBetRate { get; set; }

        public BetPrediction Result { get; set; }


        [InverseProperty(nameof(PlayerStatistic))]
        public ICollection<PlayerStatistic> PlayerStatistics { get; set; }

        
        [InverseProperty(nameof(Bet))]
        public ICollection<Bet> Bets { get; set; }


        public Game()
        { 
            PlayerStatistics = new HashSet<PlayerStatistic>();
            Bets = new HashSet<Bet>();
        }
    }
}
