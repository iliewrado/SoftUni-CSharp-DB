﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SoftJail.Data.Models
{
    public class Prisoner
    {
        [Key]
        public int Id { get; set; }

        [Required(AllowEmptyStrings = false)]
        [StringLength(20, MinimumLength = 3)]
        public string FullName { get; set; }

        [Required(AllowEmptyStrings = false)]
        [RegularExpression(@"The [A-Z]{1}[a-z]+")]
        public string Nickname { get; set; }

        [Required]
        [Range(18, 65)]
        public int Age { get; set; }

        [Required]
        public DateTime IncarcerationDate { get; set; }

        public DateTime? ReleaseDate { get; set; }


        [Range(typeof(decimal), "0", "79228162514264337593543950335")]
        public decimal? Bail { get; set; }

        [Required]
        public int CellId { get; set; }
        [ForeignKey(nameof(CellId))]
        public Cell Cell { get; set; }

        public ICollection<Mail> Mails { get; set; }

        public ICollection<OfficerPrisoner> PrisonerOfficers { get; set; }

        public Prisoner()
        {
            this.Mails = new HashSet<Mail>();
            this.PrisonerOfficers = new HashSet<OfficerPrisoner>();
        }
    }
}
