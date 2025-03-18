using Manzili.Core.Entities;
using Manzili.Core.Enum;
using System.Text.Json.Serialization;

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
    public int Quantity { get; set; } // Total quantity
    public string State { get; set; } = enProductStatus.Available.ToString();
    public double? Rate { get; set; }

    public List<ProductSize>? Sizes { get; set; } = new List<ProductSize>();

    public ProductCategory ProductCategory { get; set; }
    [JsonIgnore]
    public Store Store { get; set; }
    public ICollection<Image> Images { get; set; }

    // New properties for store name and rate
    public string StoreName => Store?.BusinessName;
    public double? StoreRate => Store?.Rate;
}
