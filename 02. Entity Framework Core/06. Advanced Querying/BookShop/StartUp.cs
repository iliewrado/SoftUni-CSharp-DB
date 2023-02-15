namespace BookShop
{
    using BookShop.Models.Enums;
    using Castle.Core.Internal;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore.Migrations.Operations;
    using System;
    using System.Globalization;
    using System.Linq;
    using System.Text;

    public class StartUp
    {
        public static void Main()
        {
            using var db = new BookShopContext();
            DbInitializer.ResetDatabase(db);

            //Console.WriteLine(GetBooksByAgeRestriction(db, ToTitle(Console.ReadLine())));
            //Console.WriteLine(GetBooksByPrice(db));
            GetBooksReleasedBefore(db, Console.ReadLine());
        }

        public static string GetBooksByAgeRestriction(BookShopContext context, string command)
        {
            bool isParsed = Enum.TryParse(command, true, out AgeRestriction ageRestriction);

            if (isParsed)
            {
                var restrictedBooks = context.Books
                .Where(b => b.AgeRestriction.Equals(ageRestriction))
                .Select(b => b.Title)
                .OrderBy(b => b)
                .ToList();

                return String.Join(Environment.NewLine, restrictedBooks);
            }

            return String.Empty;
        }

        public static string GetGoldenBooks(BookShopContext context)
        {
            var goldenBooks = context.Books
                .Where(b => b.Copies < 5000 && (int)b.EditionType == 2)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            return String.Join(Environment.NewLine, goldenBooks).TrimEnd();
        }

        public static string GetBooksByPrice(BookShopContext context)
        {
            StringBuilder result = new StringBuilder();

            var books = context.Books
                .Where(p => p.Price > 40)
                .Select(p => new
                {
                    Price = p.Price,
                    Title = p.Title
                })
                .OrderByDescending(p => p.Price)
                .ToList();

            foreach (var book in books)
            {
                result.AppendLine($"{book.Title} - ${book.Price:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetBooksNotReleasedIn(BookShopContext context, int year)
        {
            var titles = context.Books
                .Where(b => b.ReleaseDate == null 
                || b.ReleaseDate.Value.Year != year)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList();

            return String.Join(Environment.NewLine, titles).TrimEnd();
        }

        public static string GetBooksByCategory(BookShopContext context, string input)
        {
            string[] listOfCategories = input.ToLower()
                .Split(' ', StringSplitOptions.RemoveEmptyEntries);

            var listOfBooks = context.Books
                .Where(b => b.BookCategories.Any(c => listOfCategories.Contains(c.Category.Name.ToLower())))
                .Select(b => b.Title)
                .OrderBy(t => t)
                .ToList();

            return String.Join(Environment.NewLine, listOfBooks).TrimEnd();
        }

        public static string GetBooksReleasedBefore(BookShopContext context, string date)
        {
            StringBuilder result = new StringBuilder();
            DateTime inputDate = DateTime.ParseExact(date, "dd-MM-yyyy", CultureInfo.InvariantCulture);

            var listOfBooks = context.Books
                .Where(b => b.ReleaseDate < inputDate)
                .OrderByDescending(d => d.ReleaseDate)
                .Select(b => new 
                {
                    Title = b.Title,
                    Edition = b.EditionType,
                    Price = b.Price
                })
                .ToList();

            foreach (var book in listOfBooks)
            {
                result.AppendLine($"{book.Title} - {book.Edition} - ${book.Price:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetAuthorNamesEndingIn(BookShopContext context, string input)
        {
            var autauthors = context.Authors
                .Where(a => a.FirstName.EndsWith(input))
                .Select(a => new
                {
                    FullName = $"{a.FirstName} {a.LastName}"
                })
                .OrderBy(a => a.FullName)
                .ToList();

            return String.Join(Environment.NewLine, autauthors);
        }

        public static string GetBookTitlesContaining(BookShopContext context, string input)
        {
            var bookTitles = context.Books
                .Where(t => t.Title.ToLower().Contains(input.ToLower()))
                .Select(t => t.Title)
                .OrderBy(t => t)
                .ToList();

            return String.Join(Environment.NewLine, bookTitles);
        }

        public static string GetBooksByAuthor(BookShopContext context, string input)
        {
            return string.Empty;
        }

        public static string ToTitle(string text)
        {
            if (text.IsNullOrEmpty())
                return null;
            return System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(text);
        }
    }
}
