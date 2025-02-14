
using Manzili.Core.Constant;
using Microsoft.AspNetCore.Http;

namespace Manzili.Core.Services
{
    public class FileService : IFileService
    {

        public async Task<string> UploadImageAsync(string targetFolder, IFormFile file)
        {
           

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
                return "FailedToUploadImage";
            }
        }

        public async Task<OperationResult<bool>> Delete(string imageUrl)
        {
            if (string.IsNullOrWhiteSpace(imageUrl))
                return OperationResult<bool>.Failure("Invalid image URL.");


            var wwwRootPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
            var imagePath = Path.Combine(wwwRootPath, imageUrl.TrimStart('/'));

            if (!File.Exists(imagePath))
                return OperationResult<bool>.Failure("Image not found.");

            try
            {
                File.Delete(imagePath);
                return OperationResult<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return OperationResult<bool>.Failure(message: $"Failed to delete image: {ex.Message}");
            }
        }



    }
}


