namespace MusicHub
{
    using System;
    using System.Linq;
    using System.Text;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore;
    using MusicHub.Data.Models;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            MusicHubDbContext context =
                new MusicHubDbContext();

            DbInitializer.ResetDatabase(context);

            Console.WriteLine(ExportSongsAboveDuration(context, 4));
        }

        public static string ExportAlbumsInfo(MusicHubDbContext context, int producerId)
        {
            StringBuilder result = new StringBuilder();

            var allAlbums = context
                .Albums
                .Where(p => p.ProducerId == producerId)
                .Select(a => new 
                { 
                    AlbumName = a.Name,
                    ReleaseDate = a.ReleaseDate.ToString("MM/dd/yyyy"),
                    ProducerName = a.Producer.Name,
                    Songs = a.Songs
                        .Select(s=> new 
                        { 
                            SongName = s.Name,
                            Price = s.Price,
                            WriterName = s.Writer.Name,
                        }).OrderByDescending(s => s.SongName)
                        .ThenBy(w => w.WriterName)
                        .ToList(),
                    Price = a.Price
                })
                .ToList();

            foreach (var album in allAlbums.OrderByDescending(p => p.Price))
            {
                result.AppendLine($"-AlbumName: {album.AlbumName}");
                result.AppendLine($"-ReleaseDate: {album.ReleaseDate}");
                result.AppendLine($"-ProducerName: {album.ProducerName}");
                result.AppendLine("-Songs:");
                
                int count = 0;
                
                foreach (var song in album.Songs)
                {
                    result.AppendLine($"---#{++count}");
                    result.AppendLine($"---SongName: {song.SongName}");
                    result.AppendLine($"---Price: {song.Price:f2}");
                    result.AppendLine($"---Writer: {song.WriterName}");
                }

                result.AppendLine($"-AlbumPrice: {album.Price:f2}");
            }

            return result.ToString().TrimEnd();
        }

        public static string ExportSongsAboveDuration(MusicHubDbContext context, int duration)
        {
            StringBuilder result = new StringBuilder();

            var songsAbove = context
                .Songs
                .Include(s => s.SongPerformers)
                .ThenInclude(sp => sp.Performer)
                .Include(s => s.Writer)
                .Include(s => s.Album)
                .ThenInclude(a => a.Producer)
                .AsEnumerable()
                .Where(s => s.Duration.TotalSeconds > duration)
                .Select(s => new 
                {
                    SongName = s.Name,
                    WriterName = s.Writer.Name,
                    PerformerFullName = s.SongPerformers
                    .Select(p => ($"{p.Performer.FirstName} {p.Performer.LastName}"))
                    .FirstOrDefault(),
                    AlbumProducer = s.Album.Producer.Name,
                    Duration = s.Duration.ToString("c")
                })
                .OrderBy(s => s.SongName)
                .ThenBy(w => w.WriterName)
                .ThenBy(p => p.PerformerFullName)
                .ToList();

            int count = 0;

            foreach (var song in songsAbove)
            {
                result.AppendLine($"-Song #{++count}");
                result.AppendLine($"---SongName: {song.SongName}");
                result.AppendLine($"---Writer: {song.WriterName}");
                result.AppendLine($"---Performer: {song.PerformerFullName}");
                result.AppendLine($"---AlbumProducer: {song.AlbumProducer}");
                result.AppendLine($"---Duration: {song.Duration}");
            }

            return result.ToString().TrimEnd();
        }
    }
}
