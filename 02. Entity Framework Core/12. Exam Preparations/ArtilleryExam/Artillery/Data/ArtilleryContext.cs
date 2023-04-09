using Artillery.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace Artillery.Data
{
    public class ArtilleryContext : DbContext
    {
        public DbSet<CountryGun> CountriesGuns { get; set; }

        public DbSet<Country> Countries { get; set; }

        public DbSet<Gun> Guns { get; set; }

        public DbSet<Manufacturer> Manufacturers { get; set; }

        public DbSet<Shell> Shells { get; set; }

        public ArtilleryContext() 
        { 
        }

        public ArtilleryContext(DbContextOptions options)
            : base(options) 
        { 
        }

         protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder
                    .UseSqlServer(Configuration.ConnectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Manufacturer>()
                .HasIndex(n => n.ManufacturerName)
                .IsUnique();

            modelBuilder.Entity<CountryGun>()
                .HasKey(cg => new { cg.CountryId, cg.GunId });

            base.OnModelCreating(modelBuilder);
        }
    }
}
