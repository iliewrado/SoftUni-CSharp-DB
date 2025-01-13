using Invoices.Data.Models;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace Invoices.DataProcessor.ImportDto
{
    public class ImportProductDto
    {
        [JsonProperty("Name")]
        [Required]
        [StringLength(30, MinimumLength = 9)]
        public string Name { get; set; }

        [JsonProperty("Price")]
        //Price – decimal in range[5.00…1000.00] (required)
        [Required]
        [Range(typeof(decimal), "5.00", "1000.00")]
        public decimal Price { get; set; }

        [JsonProperty("CategoryType")]
        //CategoryType – enumeration of type CategoryType, with possible values(ADR, Filters, Lights, Others, Tyres) (required)
        [Required]
        public int CategoryType { get; set; }

        [JsonProperty("Clients")]
        //ProductsClients – collection of type ProductClient
        public int[] ProductsClients { get; set; }

    }
}
