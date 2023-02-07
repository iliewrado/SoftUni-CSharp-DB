using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P01_StudentSystem.Data.Models
{
    public class Course
    {
        [Key]
        public int CourseId { get; set; }

        [Required]
        [StringLength(80)]
        public string Name { get; set; }

        public string? Description { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public decimal Price { get; set; }

        public virtual ICollection<StudentCourse> StudentsEnrolled { get; set; }
        
        public virtual ICollection<Homework> HomeworkSubmissions { get; set; }

        public virtual ICollection<Resource> Resources { get; set; }


        public Course()
        {
            StudentsEnrolled = new HashSet<StudentCourse>();
            HomeworkSubmissions = new HashSet<Homework>();
            Resources = new HashSet<Resource>();
        }
    }
}
