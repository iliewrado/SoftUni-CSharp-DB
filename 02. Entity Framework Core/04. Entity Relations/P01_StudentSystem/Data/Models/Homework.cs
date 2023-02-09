﻿using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01_StudentSystem.Data.Models
{
    public class Homework
    {
        [Key]
        public int HomeworkId { get; set; }

        [Required]
        [StringLength(255)]
        public string Content { get; set; }

        public ContentType ContentType { get; set; }

        public DateTime SubmissionTime { get; set; }

        
        [ForeignKey(nameof(StudentId))]
        public int StudentId { get; set; }
        public virtual Student Student { get; set; }


        [ForeignKey(nameof(CourseId))]
        public int CourseId { get; set; }
        public virtual Course Course { get; set; }
    }
}
