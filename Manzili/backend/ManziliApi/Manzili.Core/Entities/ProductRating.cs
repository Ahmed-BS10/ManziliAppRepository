namespace Manzili.Core.Entities
{
    public class ProductRating
    {
        public int ProductRatingId { get; set; } // PK
        public int RatingValue { get; set; }
        public int ProductId { get; set; } // FK
        public int UserId { get; set; } // FK
        public DateTime CreatedAt { get; set; }

        // Navigation properties
        //public Product Product { get; set; }
        //public User User { get; set; }
    }

}
