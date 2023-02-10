using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace MusicHub.Data.Models
{
    public class Writer
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(20)]
        public string Name { get; set; }

        public string? Pseudonym { get; set; }

        public virtual ICollection<Song> Songs { get; set; }

        public Writer()
        {
            this.Songs = new HashSet<Song>();
        }
    }
}
