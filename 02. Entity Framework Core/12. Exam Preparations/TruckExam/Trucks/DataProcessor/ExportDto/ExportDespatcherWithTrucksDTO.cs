using System.Xml.Serialization;

namespace Trucks.DataProcessor.ExportDto
{
    [XmlType("Despatcher")]
    public class ExportDespatcherWithTrucksDTO
    {
        [XmlAttribute("TrucksCount")]
        public int TruckCount { get; set; }

        [XmlElement("DespatcherName")]
        public string Name { get; set; }

        [XmlArray("Trucks")]
        public ExportTrucksForDespatcherDTO[] Trucks { get; set; }
    }
}
