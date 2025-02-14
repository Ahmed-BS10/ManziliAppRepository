namespace Manzili.Core.Entities
{
    public class Product
    {
        public int ProductId { get; set; } // PK
        public string Name { get; set; }
        public double Price { get; set; }
        public int CategoryId { get; set; } // FK
        public string Description { get; set; }
        public int StoreId { get; set; } // FK
        public string ImageUrl { get; set; }
        public double Discount { get; set; }
        public int Quantity { get; set; }

        // Navigation properties
        //public StoreCategory Category { get; set; }
        //public Store Store { get; set; }
        //public ICollection<OrderProduct> OrderProducts { get; set; }
        //public ICollection<ProductRating> ProductRatings { get; set; }
        //public ICollection<Like> Likes { get; set; }
        //public ICollection<Comment> Comments { get; set; }
    }

}
