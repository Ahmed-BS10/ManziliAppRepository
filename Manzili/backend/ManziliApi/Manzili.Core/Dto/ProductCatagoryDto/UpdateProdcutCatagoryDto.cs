using Microsoft.AspNetCore.Http;

namespace Manzili.Core.Dto.CatagoryDto
{
    public class UpdateProdcutCatagoryDto
    {
        public string Name { get; set; }

        public IFormFile Image { get; set; }

    }
}
