using Manzili.Core.Enum;
using System.Text;

namespace Manzili.Core.Entities
{
    public class Order
    {
        public int OrderId { get; set; } // PK
        public int UserId { get; set; } // FK
        public int StoreId { get; set; } // FK


        public enOrderStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public double Total { get; set; }
        public string? Note { get; set; }


        public string DeliveryAddress { get; set; }
        public string? DeliveryTime { get; set; }
        public int? NumberOfProducts { get; set; }
        public int ?  DeliveryFees {  get; set; }

        // Navigation properties

        public ICollection<OrderProduct> OrderProducts { get; set; } = new List<OrderProduct>();
        public Store Store { get; set; }
        public User User { get; set; }

        
    }

}
