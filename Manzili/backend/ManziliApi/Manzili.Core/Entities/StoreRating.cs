namespace Manzili.Core.Entities
{
    public class StoreRating
    {
        public int StoreRatingId { get; set; } // PK
        public int UserId { get; set; } // FK

       // public int StoreId { get; set; } // FK
        public int RatingValue { get; set; }
        public DateTime CreatedAt { get; set; }

        // Navigation properties
        public User User { get; set; }
       // public Store Store { get; set; }
    }

}
