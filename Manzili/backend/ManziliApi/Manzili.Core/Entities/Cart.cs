namespace Manzili.Core.Entities
{
    public class Cart
    {
        public int CartId { get; set; }
        public int UserId { get; set; }
        public int StoreId { get; set; }


      
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public string? Note { get; set; }



        // Navigation properties
        public User User { get; set; }
        public Store Store { get; set; }
        public ICollection<CartProduct>? CartProducts { get; set; } = new List<CartProduct>();

    }
}
