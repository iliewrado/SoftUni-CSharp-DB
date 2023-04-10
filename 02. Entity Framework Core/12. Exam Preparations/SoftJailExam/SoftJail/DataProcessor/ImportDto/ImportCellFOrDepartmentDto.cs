﻿using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace SoftJail.DataProcessor.ImportDto
{
    public class ImportCellFOrDepartmentDto
    {
        [JsonProperty("CellNumber")]
        [Range(1, 1000)]
        public int CellNumber { get; set; }

        [JsonProperty("HasWindow")]
        [Required]
        public bool HasWindow { get; set; }
    }
}
