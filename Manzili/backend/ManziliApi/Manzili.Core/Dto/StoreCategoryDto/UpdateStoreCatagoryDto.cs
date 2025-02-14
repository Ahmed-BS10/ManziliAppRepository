using Microsoft.AspNetCore.Http;

namespace Manzili.Core.Dto.StoreCategoryDto
{
    public record UpdateStoreCatagoryDto(string Name, IFormFile Image);



}
