namespace BookShop
{
    using BookShop.Models.Enums;
    using Castle.Core.Internal;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Migrations.Operations;
    using System;
    using System.Globalization;
    using System.Linq;
    using System.Net.Http.Headers;
    using System.Text;

    public class StartUp
    {
        public static void Main()
        {
            using var db = new BookShopContext();
            DbInitializer.ResetDatabase(db);

            //Console.WriteLine(GetBooksByAgeRestriction(db, ToTitle(Console.ReadLine())));
            Console.WriteLine(GetBooksByPrice(db));
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

            StringBuilder names= new StringBuilder();

            foreach (var author in autauthors)
            {
                names.AppendLine(author.FullName);
            }

            return names.ToString().TrimEnd();
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
            StringBuilder result = new StringBuilder();

            var titlesAndAuthors = context.Books
                .Where(a => a.Author.LastName.ToLower().StartsWith(input.ToLower()))
                .Select(b => new 
                { 
                    Id = b.BookId,
                    Title = b.Title,
                    AuthorName = $"{b.Author.FirstName} {b.Author.LastName}",
                })
                .OrderBy(b => b.Id)
                .ToList();

            foreach (var book in titlesAndAuthors)
            {
                result.AppendLine($"{book.Title} ({book.AuthorName})");
            }

            return result.ToString().TrimEnd();
        }

        public static int CountBooks(BookShopContext context, int lengthCheck)
        {
            return context.Books
                .Where(t => t.Title.Length > lengthCheck)
                .ToList().Count;
        }

        public static string CountCopiesByAuthor(BookShopContext context)
        {
            StringBuilder result = new StringBuilder();

            var authorCopiesCount = context.Authors
                .Select(a => new
                {
                    FullName = $"{a.FirstName} {a.LastName}",
                    countBooks = a.Books.Sum(b => b.Copies)
                })
                .OrderByDescending(c => c.countBooks)
                .ToList();

            foreach (var author in authorCopiesCount)
            {
                result.AppendLine($"{author.FullName} - {author.countBooks}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetTotalProfitByCategory(BookShopContext context)
        {
            StringBuilder result = new StringBuilder();
            
            var categories = context.Categories
                .Select(c => new
                {
                    Name = c.Name,
                    Profit = c.CategoryBooks.Sum(b=> (b.Book.Price * b.Book.Copies))
                })
                .OrderByDescending(c => c.Profit)
                .ThenBy(c => c.Name)
                .ToList();

            foreach (var category in categories)
            {
                result.AppendLine($"{category.Name} ${category.Profit}");
            }

            return result.ToString().TrimEnd();
        }

        public static string GetMostRecentBooks(BookShopContext context)
        {
            StringBuilder result = new StringBuilder(); 

            var recentBooksCategory = context.Categories
                .Select(c => new
                {
                    Name = c.Name,
                    Books = c.CategoryBooks
                        .OrderByDescending(cb => cb.Book.ReleaseDate)
                        .Take(3)
                        .Select(b => new
                        {
                            Title = b.Book.Title,
                            Year = b.Book.ReleaseDate.Value.Year.ToString()
                        })
                })
                .OrderBy(c => c.Name)
                .ToList();

            foreach (var cat in recentBooksCategory)
            {
                result.AppendLine($"--{cat.Name}");

                foreach (var book in cat.Books)
                {
                    result.AppendLine($"{book.Title} ({book.Year})");
                }
            }

            return result.ToString().TrimEnd();
        }

        public static string ToTitle(string text)
        {
            if (text.IsNullOrEmpty())
                return null;
            return System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(text);
        }
    }
}
