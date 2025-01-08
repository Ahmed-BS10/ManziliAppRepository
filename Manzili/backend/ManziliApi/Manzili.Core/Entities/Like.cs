namespace Manzili.Core.Entities
{
    public class Like
    {
        public int LikeId { get; set; } // PK
        public int ProductId { get; set; } // FK
        public int UserId { get; set; } // FK
        public bool IsLike { get; set; }

        // Navigation properties
        public Product Product { get; set; }
        public User User { get; set; }
    }

}
