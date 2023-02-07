﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01_StudentSystem.Data.Models
{
    public class Resource
    {
        [Key]
        public int ResourceId { get; set; }

        [Required]
        [StringLength(50)]
        public string Name { get; set; }

        [Column(TypeName = "char(MAX)")]
        public string Url { get; set; }

        public ResourceType ResourceType { get; set; }

        [ForeignKey(nameof(CourseId))]
        public int CourseId { get; set; }
        public virtual Course Course { get; set; }
    }
}
