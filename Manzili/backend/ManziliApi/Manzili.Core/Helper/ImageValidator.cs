using Microsoft.AspNetCore.Http;

public static class ImageValidator
{
    private static readonly string[] AllowedExtensions = { ".jpg", ".jpeg", ".png" , ".pdf"};
    private const long MaxFileSize = 2 * 1024 * 1024; 

    public static bool IsValidImage(IFormFile file, out string errorMessage)
    {
        errorMessage = string.Empty;

        //if (file == null || file.Length == 0)
        //    return true;
      
        var extension = Path.GetExtension(file.FileName).ToLower();
        if (!AllowedExtensions.Contains(extension))
        {
            errorMessage = "Invalid file extension. Allowed extensions: " + string.Join(", ", AllowedExtensions);
            return false;
        }

        if (file.Length > MaxFileSize)
        {
            errorMessage = "File size exceeds the allowed limit of 2MB.";
            return false;
        }

        return true;
    }
}
