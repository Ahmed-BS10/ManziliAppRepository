using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ProductCatagoryDto
{
    public class CreateProductCatagoryDto
    {
        public string Name { get; set; }
        public IFormFile ? Image { get; set; }
        public int StoreCategoryId { get; set; }


    }
}
