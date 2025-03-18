using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ProductDto
{
    public class GetAllProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public string Description { get; set; }
        public string State { get; set; } // Product status (Available, Out of Stock, etc.)
        public double? Rate { get; set; }
        public string ImageUrl { get; set; } // Main image URL
        public string StoreCategoryName { get; set; }
        public string ProductCategoryName { get; set; } // Add this property

        public GetAllProduct(Product product)
        {
            Id = product.Id;
            Name = product.Name;
            Price = product.Price;
            Description = product.Description;
            State = product.State;
            Rate = product.Rate;
            ImageUrl = product.ImageUrls?.FirstOrDefault(); // Get the first image if available
        }
    }
}
