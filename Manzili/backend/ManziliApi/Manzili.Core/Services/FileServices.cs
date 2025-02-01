
namespace Manzili.Core.Services
{
    public class FileService
    {

        public async Task<string> UploadImageAsync(string targetFolder, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return "NoImage";

            try
            {

                var folder = Path.Combine(Directory.GetCurrentDirectory() + "/wwwroot", targetFolder);
                Directory.CreateDirectory(folder);

                var extension = Path.GetExtension(file.FileName);
                var fileName = $"{Guid.NewGuid().ToString().Replace("-", string.Empty)}{extension}";

                var filePath = Path.Combine(folder, fileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                    await fileStream.FlushAsync();
                }

                return $"/{targetFolder}/{fileName}";
            }
            catch (Exception ex)
            {

                Console.WriteLine($"Error: {ex.Message}");


                return "FailedToUploadImage";
            }
        }
    }
}


