using Microsoft.AspNetCore.Http;

namespace Manzili.Core.Dto.StoreCategoryDto
{
    public record CreateStoreCatagoryDto(string Name , IFormFile Image);



}
