using Invoices.Data.Models.Enums;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Invoices.DataProcessor.ImportDto
{
    public class ImportInvoiceDto
    {
        [JsonProperty("Number")]
        //•	Number – integer in range[1, 000, 000, 000…1, 500, 000, 000] (required)
        [Required]
        [Range(1000000000, 1500000000)]
        public int Number { get; set; }

        [JsonProperty("IssueDate")]
        //•	IssueDate – DateTime(required)
        [Required]
        public string IssueDate { get; set; }

        [JsonProperty("DueDate")]
        //•	DueDate – DateTime(required)
        [Required]
        public string DueDate { get; set; }

        [JsonProperty("Amount")]
        //•	Amount – decimal (required)
        [Required]
        public decimal Amount { get; set; }

        [JsonProperty("CurrencyType")]
        //•	CurrencyType – enumeration of type CurrencyType, with possible values(BGN, EUR, USD) (required)
        [Required]
        public int CurrencyType { get; set; }

        [JsonProperty("ClientId")]
        //•	ClientId – integer, foreign key(required)
        [Required]
        public int ClientId { get; set; }
        //•	Client – Client
    }
}
