using Manzili.Core.Enum;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Manzili.Core.Entities
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public int ProductCategoryId { get; set; }
        public string Description { get; set; }
        public int StoreId { get; set; }
        public List<string> ImageUrls { get; set; } = new List<string>();
        public double Discount { get; set; }
        public int Quantity { get; set; }
        public string State { get; set; } = enProductStatus.Available.ToString();
        public double? Rate { get; set; }
        public List<ProductSize>? Sizes { get; set; }
        public ProductCategory ProductCategory { get; set; }
        [JsonIgnore]
        public Store Store { get; set; }
        public ICollection<Image> Images { get; set; }
    }
}
