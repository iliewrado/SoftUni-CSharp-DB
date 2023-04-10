namespace SoftJail.DataProcessor
{
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;
    using System.Globalization;
    using System.Text;
    using System.Xml.Serialization;
    using Data;
    using Newtonsoft.Json;
    using SoftJail.Data.Models;
    using SoftJail.Data.Models.Enums;
    using SoftJail.DataProcessor.ImportDto;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid Data";

        private const string SuccessfullyImportedDepartment = "Imported {0} with {1} cells";

        private const string SuccessfullyImportedPrisoner = "Imported {0} {1} years old";

        private const string SuccessfullyImportedOfficer = "Imported {0} ({1} prisoners)";

        public static string ImportDepartmentsCells(SoftJailDbContext context, string jsonString)
        {
            StringBuilder output = new StringBuilder();

            var importDtos = JsonConvert.DeserializeObject<ImportDepartmentWithCellDto[]>(jsonString);
            List<Department> validDepartments = new List<Department>();

            foreach (var dto in importDtos)
            {
                if (!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                if (dto.Cells.Length == 0)
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Department department = new Department()
                {
                    Name = dto.Name
                };

                foreach (var celldto in dto.Cells)
                {
                    if (!IsValid(celldto))
                    {
                        output.AppendLine(ErrorMessage);
                        break;
                    }

                    Cell cell = new Cell()
                    {
                        CellNumber = celldto.CellNumber,
                        HasWindow = celldto.HasWindow
                    };

                    department.Cells.Add(cell);
                }

                if(department.Cells.Count > 0)
                {
                    validDepartments.Add(department);
                    output.AppendLine(String
                        .Format(SuccessfullyImportedDepartment, department.Name, department.Cells.Count));
                }
            }

            context.AddRange(validDepartments);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }

        public static string ImportPrisonersMails(SoftJailDbContext context, string jsonString)
        {
            var importDtos = JsonConvert.DeserializeObject<ImportPrisonerWithMailsDto[]>(jsonString);
            StringBuilder output = new StringBuilder();
            List<Prisoner> validPrisoners = new List<Prisoner>();

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                if (dto.Mails.Any(m => !IsValid(m)))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                bool isIncarcerationDateValid =
                    DateTime.TryParseExact(dto.IncarcerationDate, "dd/MM/yyyy", CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out DateTime incarcerationDate);
                if (!isIncarcerationDateValid)
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                DateTime? releaseDate = null;

                if (!String.IsNullOrEmpty(dto.ReleaseDate))
                {
                    bool isReleaseDateValid =
                    DateTime.TryParseExact(dto.IncarcerationDate, "dd/MM/yyyy", CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out DateTime dateValue);

                    if (!isReleaseDateValid)
                    {
                        output.AppendLine(ErrorMessage);
                        continue;
                    }

                    releaseDate = dateValue;
                }

                Prisoner prisoner = new Prisoner()
                {
                    FullName = dto.FullName,
                    Nickname = dto.Nickname,
                    Age = dto.Age,
                    IncarcerationDate = incarcerationDate,
                    ReleaseDate = releaseDate,
                    Bail = dto.Bail,
                    CellId = dto.CellId,
                    Cell = context.Cells.First(c => c.Id == dto.CellId)
                };

                foreach (var maildto in dto.Mails)
                {
                    if(!IsValid(maildto))
                    {
                        output.AppendLine(ErrorMessage);
                        continue;
                    }

                    Mail mail = new Mail()
                    {
                        Address = maildto.Address,
                        Description = maildto.Description,
                        Sender = maildto.Sender,
                        Prisoner = prisoner,
                        PrisonerId = prisoner.Id,
                    };

                    prisoner.Mails.Add(mail);
                }

                validPrisoners.Add(prisoner);
                output.AppendLine(String
                    .Format(SuccessfullyImportedPrisoner, prisoner.FullName, prisoner.Age));
            }

            context.AddRange(validPrisoners);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }

        public static string ImportOfficersPrisoners(SoftJailDbContext context, string xmlString)
        {
            StringBuilder output = new StringBuilder();

            XmlSerializer serializer = 
                new XmlSerializer(typeof(ImportOfficerPrisonerDto[]), new XmlRootAttribute("Officers"));
            var importDtos = 
                serializer.Deserialize(new StringReader(xmlString)) as ImportOfficerPrisonerDto[];
            List<Officer> validOfficers = new List<Officer>();
            List<OfficerPrisoner> prisonersOfficers = new List<OfficerPrisoner>(); 

            foreach (var dto in importDtos)
            {
                if(!IsValid(dto))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Weapon weapon;
                if (!Enum.TryParse(dto.Weapon, out weapon))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Position position;
                if (!Enum.TryParse(dto.Position, out position))
                {
                    output.AppendLine(ErrorMessage);
                    continue;
                }

                Officer officer = new Officer()
                {
                    DepartmentId = dto.DepartmentId,
                    Department = context
                    .Departments.First(d => d.Id == dto.DepartmentId),
                    Salary = dto.Salary,
                    FullName = dto.FullName,
                    Position = position,
                    Weapon = weapon
                };

                foreach (var pDto in dto.Prisoners)
                {
                    OfficerPrisoner officerPrisoner = new OfficerPrisoner()
                    {
                        OfficerId = officer.Id,
                        Officer = officer,
                        PrisonerId = pDto.Id,
                        Prisoner = context.Prisoners
                        .First(p => p.Id == pDto.Id)
                    };

                    officer.OfficerPrisoners.Add(officerPrisoner);
                    prisonersOfficers.Add(officerPrisoner);
                }

                validOfficers.Add(officer);
                output.AppendLine(String
                    .Format(SuccessfullyImportedOfficer, officer.FullName, officer.OfficerPrisoners.Count()));
            }

            context.AddRange(validOfficers);
            context.AddRange(prisonersOfficers);
            context.SaveChanges();

            return output.ToString().TrimEnd();
        }

        private static bool IsValid(object obj)
        {
            var validationContext = new System.ComponentModel.DataAnnotations.ValidationContext(obj);
            var validationResult = new List<ValidationResult>();

            bool isValid = Validator.TryValidateObject(obj, validationContext, validationResult, true);
            return isValid;
        }
    }
}