namespace Manzili.Core.Entities
{
    public class Favorite
    {
        public int FavoriteId { get; set; } 
        public int UserId { get; set; } 
        public int StoreId { get; set; } 
        public DateTime CreatedAt { get; set; }

      // Navigation properties
        public User User { get; set; }
        public Store Store { get; set; }
    }

}
