using Manzili.Core.Entities;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ProductDto
{
    public class CreateProductDto
    {
        public string Name { get; set; }
        public double Price { get; set; }
        public int ProductCategoryId { get; set; } 
        public string Description { get; set; }
        public List<IFormFile> formImages { get; set; }
        public int? Quantity { get; set; }

        
    }
}
