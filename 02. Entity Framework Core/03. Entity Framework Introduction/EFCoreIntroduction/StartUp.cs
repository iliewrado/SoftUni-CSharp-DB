using SoftUni.Data;
using SoftUni.Models;
using System.Globalization;
using System.Text;

namespace SoftUni
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            SoftUniContext softUniContext = new SoftUniContext();

            //string result = GetEmployeesFullInformation(softUniContext);
            string result = GetEmployeesWithSalaryOver50000(softUniContext);

            Console.WriteLine(result);
        }

        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var allEmploees = context
                .Employees
                .OrderBy(e => e.EmployeeId)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.MiddleName,
                    e.JobTitle,
                    e.Salary
                })
                .ToArray();

            foreach (var e in allEmploees)
            {
                result.AppendLine($"{e.FirstName} {e.LastName} {e.MiddleName} {e.JobTitle} {e.Salary:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var allEmploees = context
                .Employees
                .Where(e => e.Salary > 50000)
                .Select(e =>  new
                {
                    e.FirstName,
                    e.Salary
                })
                .OrderBy(e => e.FirstName)
                .ToArray();

            foreach (var e in allEmploees)
            {
                result.AppendLine($"{e.FirstName} - {e.Salary:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var allEmploees = context
                .Employees
                .Where(e => e.Department.Name == "Research and Development")
                .OrderBy(e => e.Salary)
                .ThenByDescending(e => e.FirstName)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    departmentName = e.Department.Name,
                    e.Salary
                })
                .ToArray();

            foreach (var e in allEmploees)
            {
                result.AppendLine($"{e.FirstName} {e.LastName} from {e.departmentName} - ${e.Salary:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            Address address = new Address
            { 
                AddressText = "Vitoshka 15",
                TownId = 4
            };

            var employee = context
                .Employees
                .FirstOrDefault(e => e.LastName == "Nakov");

            employee.Address = address;
            context.SaveChanges();

            var allEmploees = context
                .Employees
                .OrderByDescending(e => e.AddressId)
                .Take(10)
                .Select(e => e.Address.AddressText);

            foreach (var e in allEmploees)
            {
                result.AppendLine($"{e}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var employeesAndProjects = context
                .Employees
                .Where(e => e.EmployeesProjects
                .Any(p => p.Project.StartDate.Year >= 2001
                            && p.Project.StartDate.Year <= 2003))
                .Take(10)
                .Select(e => new 
                {
                    e.FirstName,
                    e.LastName,
                    managerFirstName = e.Manager.FirstName,
                    managerLastName = e.Manager.LastName,
                    projects = e.EmployeesProjects.Select(p => new 
                    {
                        p.Project.Name, 
                        p.Project.StartDate, 
                        p.Project.EndDate
                    })
                })
                .ToList();

            foreach (var e in employeesAndProjects)
            {
                result.AppendLine($"{e.FirstName} {e.LastName} - Manager: {e.managerFirstName} {e.managerLastName}");

                foreach (var p in e.projects)
                {
                    result.AppendLine($"--{p.Name} - {p.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture)} - {(p.EndDate != null 
                        ? p.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture) : "not finished")}");
                }
            }


            return result.ToString().TrimEnd();
        }

        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var allEmploees = context
                .Addresses
                .OrderByDescending(a => a.Employees.Count)
                .ThenBy(t => t.Town.Name)
                .ThenBy(a => a.AddressText)
                .Take(10)
                .Select(a => new
                {
                    a.AddressText,
                    a.Town.Name,
                    a.Employees.Count
                })
                .ToArray();

            foreach (var e in allEmploees)
            {
                result.AppendLine($"{e.AddressText}, {e.Name} - {e.Count} employees");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetEmployee147(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            Employee emploee147 = context
                .Employees
                .First(e => e.EmployeeId == 147);
           
            result.AppendLine($"{emploee147.FirstName} {emploee147.LastName} - {emploee147.JobTitle}");

            foreach (var p in emploee147.EmployeesProjects
                .OrderBy(p => p.Project.Name))
            {
                result.AppendLine(p.Project.Name);
            }

            return result.ToString().TrimEnd();
        }

        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder(); 

            var departments = context
                .Departments
                .Where(d => d.Employees.Count > 5)
                .Select(d => new 
                {
                    d.Name,
                    d.Manager.FirstName, 
                    d.Manager.LastName,
                    d.Employees
                })
                .OrderBy(e => e.Employees.Count)
                .ThenBy(d => d.Name)
                .ToArray();

            foreach (var d in departments)
            {
                result.AppendLine($"{d.Name} - {d.FirstName} {d.LastName}");

                foreach (var e in d.Employees
                    .OrderBy(e => e.FirstName).ThenBy(e => e.LastName))
                {
                    result.AppendLine ($"{e.FirstName} {e.LastName} - {e.JobTitle}");
                }
            }

            return result.ToString().TrimEnd();
        }

        public static string GetLatestProjects(SoftUniContext context)
        {
            StringBuilder result = new StringBuilder();

            var latestProjects = context
                .Projects
                .OrderByDescending(p => p.StartDate)
                .Take(10)
                .Select(p => new
                {
                    p.Name,
                    p.Description,
                    p.StartDate
                })
                .OrderBy(p => p.Name)
                .ToArray();

            foreach( var d in latestProjects)
            {
                result.AppendLine(d.Name);
                result.AppendLine(d.Description);
                result.AppendLine(d.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture));
            }

            return result.ToString().TrimEnd();
        }
    }
}