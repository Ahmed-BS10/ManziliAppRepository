namespace Manzili.Core.Entities
{
    public class ProductCategory
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Image { get; set; }
        public int StoreCategoryId { get; set; }

 
        public ICollection<Product>? Products { get; set; }
        public StoreCategory StoreCategory { get; set; }
    }


}
