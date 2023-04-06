using Footballers.Data.Models.Enums;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Footballers.Data.Models
{
    public class Footballer
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(40, MinimumLength = 2)]
        public string Name { get; set; }

        [Required]
        public DateTime ContractStartDate { get; set; }

        [Required]
        public DateTime ContractEndDate { get; set; }

        [Required]
        public PositionType PositionType { get; set; }
            
        [Required]
        public BestSkillType BestSkillType { get; set; }

        [Required]
        [ForeignKey(nameof(Coach))]
        public int CoachId { get; set; }
        public Coach Coach { get; set; }

        public ICollection<TeamFootballer> TeamsFootballers { get; set; }

        public Footballer()
        {
            this.TeamsFootballers = new HashSet<TeamFootballer>();
        }
    }
}
