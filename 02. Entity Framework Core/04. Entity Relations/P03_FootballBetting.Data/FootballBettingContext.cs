using Microsoft.EntityFrameworkCore;
using P03_FootballBetting.Data.Models;

namespace P03_FootballBetting.Data
{
    public class FootballBettingContext : DbContext
    {
        //public DbSet<Bet> Bets { get; set; }

        //public DbSet<Country> Countries { get; set; }


        public FootballBettingContext(DbContextOptions options)
            : base(options)
        {
        }

        protected FootballBettingContext()
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Server=.;Database=SoftUni;User Id=sa;Password=Radoslav!;encrypt=false;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        //    modelBuilder.Entity<PlayerStatistic>()
        //        .HasKey(sc => new { sc.StudentId, sc.CourseId });

        //    base.OnModelCreating(modelBuilder);
        }
    }
}
