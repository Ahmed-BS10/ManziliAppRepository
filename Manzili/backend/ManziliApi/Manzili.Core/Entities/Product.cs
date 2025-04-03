using Manzili.Core.Entities;
using Manzili.Core.Enum;
using System.Text.Json.Serialization;

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Price { get; set; }
    public string? Description { get; set; }
    public string State { get; set; } = enProductStatus.Available.ToString();
    public int? Quantity { get; set; } 
   

    public double? Discount { get; set; }
    public double? Rate { get; set; }
  





    public int ProductCategoryId { get; set; }
    public int StoreId { get; set; }
    public int? CartId { get; set; }

    public ProductCategory ProductCategory { get; set; }
    public Store Store { get; set; }
    public ICollection<Image>? Images { get; set; }
    public ICollection<CartProduct>? CartProducts { get; set; }








}




public class GteFullInfoProdcut
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Price { get; set; }
    public string? Description { get; set; }
    public string State { get; set; } = enProductStatus.Available.ToString();
    public int? Quantity { get; set; }


    public double? Rate { get; set; }
    public string StoreName { get; set; }
    public List<string>? images { get; set; }

   
}