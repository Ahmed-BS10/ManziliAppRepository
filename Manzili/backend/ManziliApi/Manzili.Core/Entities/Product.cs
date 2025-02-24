using Manzili.Core.Enum;

namespace Manzili.Core.Entities
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
        public int ProductCategoryId { get; set; } // FK
        public string Description { get; set; }
        public int StoreId { get; set; } // FK
        public string ImageUrl { get; set; }
        public double Discount { get; set; } = 1;
        public int Quantity { get; set; } = 0;

        public string State = enProductStatus.Available.ToString();
        public double? Rate { get; set; }


        // Navigation properties
        public ProductCategory ProductCategory{ get; set; } = new ProductCategory();
        public Store Store { get; set; } = new Store();
        public ICollection<Image> Images { get; set; } = new List<Image>();


        //public ICollection<OrderProduct> OrderProducts { get; set; }
        //public ICollection<ProductRating> ProductRatings { get; set; }
        //public ICollection<Like> Likes { get; set; }
        //public ICollection<Comment> Comments { get; set; }
    }

}
