namespace Manzili.Core.Entities
{
    public class Order
    {
        public int OrderId { get; set; } // PK
        public int UserId { get; set; } // FK

       // public int StoreId { get; set; } // FK
        public DateTime CreatedAt { get; set; }
        public double Total { get; set; }

        // Navigation properties
     //   public User User { get; set; }
      //  public Store Store { get; set; }
       // public ICollection<OrderProduct> OrderProducts { get; set; }
    }

}
