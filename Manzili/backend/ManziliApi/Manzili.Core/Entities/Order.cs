using Manzili.Core.Enum;

namespace Manzili.Core.Entities
{
    public class Order
    {
        public int OrderId { get; set; } // PK
        public int UserId { get; set; } // FK

        public enOrderStatus Status { get; set; }
       // public int StoreId { get; set; } // FK
        public DateTime CreatedAt { get; set; }
        public double Total { get; set; }


        public string? Note { get; set; }


        public ICollection<OrderProduct> OrderProducts { get; set; } = new List<OrderProduct>();
        public Store Store { get; set; }

        // Navigation properties
        //   public User User { get; set; }
        //  public Store Store { get; set; }
        // public ICollection<OrderProduct> OrderProducts { get; set; }
    }

}
