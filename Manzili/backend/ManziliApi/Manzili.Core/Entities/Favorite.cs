namespace Manzili.Core.Entities
{
    public class Favorite
    {
        public int FavoriteId { get; set; } // PK
        public int UserId { get; set; } // FK
        public int StoreId { get; set; } // FK
        public DateTime CreatedAt { get; set; }

        // Navigation properties
    //    public User User { get; set; }
     //   public Store Store { get; set; }
    }

}
