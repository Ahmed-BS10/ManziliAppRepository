using Microsoft.AspNetCore.Http;

namespace Manzili.Core.Services
{
    public interface IFileService
    {
        Task<OperationResult<bool>> Delete(string imageUrl);
        Task<string> UploadImageAsync(string targetFolder, IFormFile file);
    }
}