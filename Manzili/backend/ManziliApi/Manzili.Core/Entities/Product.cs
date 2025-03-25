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
    public ICollection<Image> Images { get; set; }
    public Cart? Cart { get; set; }






    // New properties for store name and rate
    //public string StoreName => Store?.BusinessName;
    //public string StoreImage => Store?.ImageUrl;
    //public double? StoreRate => Store?.Rate;


   
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