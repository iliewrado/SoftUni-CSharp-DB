namespace MusicHub
{
    using System;
    using System.Linq;
    using System.Text;
    using Data;
    using Initializer;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            MusicHubDbContext context =
                new MusicHubDbContext();

            DbInitializer.ResetDatabase(context);

            //Test your solutions here

            Console.WriteLine(ExportAlbumsInfo(context, 9));
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
                result.AppendLine("-Songs: ");
                
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
            throw new NotImplementedException();
        }
    }
}
