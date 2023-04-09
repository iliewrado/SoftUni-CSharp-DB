using System.ComponentModel.DataAnnotations;

namespace Artillery.DataProcessor
{
    using Artillery.Data;
    using Artillery.Data.Models;
    using Artillery.Data.Models.Enums;
    using Artillery.DataProcessor.ImportDto;
    using Newtonsoft.Json;
    using System.Text;
    using System.Xml.Serialization;

    public class Deserializer
    {
        private const string ErrorMessage =
            "Invalid data.";
        private const string SuccessfulImportCountry =
            "Successfully import {0} with {1} army personnel.";
        private const string SuccessfulImportManufacturer =
            "Successfully import manufacturer {0} founded in {1}.";
        private const string SuccessfulImportShell =
            "Successfully import shell caliber #{0} weight {1} kg.";
        private const string SuccessfulImportGun =
            "Successfully import gun {0} with a total weight of {1} kg. and barrel length of {2} m.";

        public static string ImportCountries(ArtilleryContext context, string xmlString)
        {
            XmlSerializer serializer =
               new XmlSerializer(typeof(ImportCountryDto[]), new XmlRootAttribute("Countries"));
            var importDtos =
                serializer.Deserialize(new StringReader(xmlString)) as ImportCountryDto[];

            StringBuilder result = new StringBuilder();
            List<Country> validCountries = new List<Country>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Country country = new Country()
                {
                    CountryName = dto.CountryName,
                    ArmySize = dto.ArmySize
                };

                validCountries.Add(country);
                result.AppendLine(String.Format(SuccessfulImportCountry, country.CountryName, country.ArmySize));
            }

            context.AddRange(validCountries);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }

        public static string ImportManufacturers(ArtilleryContext context, string xmlString)
        {
            XmlSerializer serializer =
               new XmlSerializer(typeof(ImportManufacturerDto[]), new XmlRootAttribute("Manufacturers"));
            var importDtos =
                serializer.Deserialize(new StringReader(xmlString)) as ImportManufacturerDto[];

            StringBuilder result = new StringBuilder();
            List<Manufacturer> validManufacturers = new List<Manufacturer>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                if (validManufacturers.Any(n => n.ManufacturerName == dto.ManufacturerName))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Manufacturer manufacturer = new Manufacturer()
                {
                    ManufacturerName = dto.ManufacturerName,
                    Founded = dto.Founded
                };

                string[] foundetElements = manufacturer.Founded
                    .Split(", ", StringSplitOptions.RemoveEmptyEntries)
                    .ToArray();

                string place = $"{foundetElements[foundetElements.Length - 2]}, {foundetElements[foundetElements.Length - 1]}";

                validManufacturers.Add(manufacturer);
                result.AppendLine(String
                    .Format(SuccessfulImportManufacturer, manufacturer.ManufacturerName, place));
            }

            context.AddRange(validManufacturers);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }

        public static string ImportShells(ArtilleryContext context, string xmlString)
        {
            XmlSerializer serializer =
               new XmlSerializer(typeof(ImportShellDto[]), new XmlRootAttribute("Shells"));
            var importDtos =
                serializer.Deserialize(new StringReader(xmlString)) as ImportShellDto[];

            StringBuilder result = new StringBuilder();
            List<Shell> validShells = new List<Shell>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Shell shell = new Shell()
                {
                    ShellWeight = dto.ShellWeight,
                    Caliber = dto.Caliber
                };

                validShells.Add(shell);
                result.AppendLine(String.Format(SuccessfulImportShell, shell.Caliber, shell.ShellWeight));
            }

            context.AddRange(validShells);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }

        public static string ImportGuns(ArtilleryContext context, string jsonString)
        {
            StringBuilder result = new StringBuilder();

            var importDtos = JsonConvert.DeserializeObject<ImportGunsDto[]>(jsonString);
            List<Gun> validGuns = new List<Gun>();
            List<CountryGun> countryGuns = new List<CountryGun>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }


                GunType gunType;
                if (!Enum.TryParse(dto.GunType, out gunType))
                {
                    result.AppendLine(ErrorMessage);
                    continue;
                }

                Gun gun = new Gun()
                {
                    ManufacturerId = dto.ManufacturerId,
                    Manufacturer = context.Manufacturers
                    .First(i => i.Id == dto.ManufacturerId),
                    GunWeight = dto.GunWeight,
                    BarrelLength = dto.BarrelLength,
                    NumberBuild = dto.NumberBuild,
                    Range = dto.Range,
                    GunType = gunType,
                    ShellId = dto.ShellId,
                    Shell = context.Shells
                .First(i => i.Id == dto.ShellId)
                };

                foreach (var id in dto.CountriesGuns)
                {
                    if (!context.Countries.Any(i => i.Id == id.Id))
                    {
                        result.AppendLine(ErrorMessage);
                        continue;
                    }

                    CountryGun countryGun = new CountryGun()
                    {
                        CountryId = id.Id,
                        Country = context.Countries
                        .First(i => i.Id == id.Id),
                        Gun = gun,
                        GunId = gun.Id
                    };

                    countryGuns.Add(countryGun);
                }

                validGuns.Add(gun);
                result.AppendLine(String.Format(SuccessfulImportGun, gun.GunType, gun.GunWeight, gun.BarrelLength));
            }

            context.AddRange(validGuns);
            context.AddRange(countryGuns);
            context.SaveChanges();

            return result.ToString().TrimEnd();
        }
        private static bool IsValid(object obj)
        {
            var validator = new ValidationContext(obj);
            var validationRes = new List<ValidationResult>();

            var result = Validator.TryValidateObject(obj, validator, validationRes, true);
            return result;
        }
    }
}