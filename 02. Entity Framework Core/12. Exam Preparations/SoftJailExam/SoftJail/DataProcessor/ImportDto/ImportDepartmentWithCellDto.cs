using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace SoftJail.DataProcessor.ImportDto
{
    public class ImportDepartmentWithCellDto
    {
        [JsonProperty("Name")]
        [Required(AllowEmptyStrings = false)]
        [StringLength(25, MinimumLength = 3)]
        public string Name { get; set; }

        [JsonProperty("Cells")]
        public ImportCellFOrDepartmentDto[] Cells { get; set; }
    }
}
