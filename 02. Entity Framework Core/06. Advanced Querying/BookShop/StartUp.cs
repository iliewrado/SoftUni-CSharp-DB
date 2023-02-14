﻿namespace BookShop
{
    using BookShop.Models.Enums;
    using Castle.Core.Internal;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore.Migrations.Operations;
    using System;
    using System.Linq;
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


        public static string ToTitle(string text)
        {
            if (text.IsNullOrEmpty())
                return null;
            return System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(text);
        }
    }
}
