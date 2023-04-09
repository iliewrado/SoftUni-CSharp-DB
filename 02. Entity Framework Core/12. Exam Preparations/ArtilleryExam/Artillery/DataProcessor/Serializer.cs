namespace Artillery.DataProcessor
{
    using Artillery.Data;
    using Artillery.DataProcessor.ExportDto;
    using Newtonsoft.Json;
    using System.Text;
    using System.Xml.Serialization;

    public class Serializer
    {
        public static string ExportShells(ArtilleryContext context, double shellWeight)
        {
            var shells = context.Shells
                .Where(w => w.ShellWeight > shellWeight)
                .ToArray()
                .Select(s => new ExportShellDto()
                {
                    Caliber = s.Caliber,
                    ShellWeight = shellWeight,
                    Guns = s.Guns
                    .Where(t => t.GunType.ToString() == "AntiAircraftGun")
                    .Select(g => new ExportGunforShellDto()
                    { 
                        BarrelLength = g.BarrelLength,
                        GunType = g.GunType.ToString(),
                        GunWeight = g.GunWeight,
                        Range = g.Range > 3000 ? "Long-range" : "Regular range"
                    })
                    .OrderByDescending(w => w.GunWeight)
                    .ToArray()
                })
                .OrderBy(w => w.ShellWeight)
                .ToArray();

            return JsonConvert.SerializeObject(shells, Formatting.Indented);
        }

        public static string ExportGuns(ArtilleryContext context, string manufacturer)
        {
            var guns = context.Guns
                .Where(m => m.Manufacturer.ManufacturerName == manufacturer)
                .ToArray()
                .Select(g => new ExportGunsByManufacturDto()
                {
                    BarrelLength = g.BarrelLength,
                    Manufacturer = g.Manufacturer.ManufacturerName,
                    GunType = g.GunType.ToString(),
                    GunWeight = g.GunWeight,
                    Range = g.Range,
                    CountryDtos = g.CountriesGuns
                    .Where(c => c.Country.ArmySize > 4500000)
                    .Select(c => new ExportCountryDto()
                    {
                        CountryName = c.Country.CountryName,
                        ArmySize = c.Country.ArmySize
                    })
                    .OrderBy(a => a.ArmySize)
                    .ToArray()
                })
                .OrderBy(b => b.BarrelLength) 
                .ToArray();

            return SerializeXml(guns, "Guns");
        }

        private static string SerializeXml<T>(T dtObjects, string rootName)
        {
            XmlSerializer xmlSerializer =
               new XmlSerializer(typeof(T), new XmlRootAttribute(rootName));
            XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
            namespaces.Add(string.Empty, string.Empty);

            StringBuilder result = new StringBuilder();
            StringWriter writer = new StringWriter(result);

            xmlSerializer.Serialize(writer, dtObjects, namespaces);

            return result.ToString().TrimEnd();
        }
    }
}
