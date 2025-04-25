namespace Manzili.Core.Entities
{
    public class OrderProduct
    {
        public int OrderProductId { get; set; }
        public int OrderId { get; set; } // PK, FK
        public int ProductId { get; set; } // FK


        public double Price { get; set; }
        public int Quantity { get; set; } = 1;
        public double TotlaPrice { get; set; }



        // Navigation properties
        public Order Order { get; set; }
        public Product? Product { get; set; }
    }

}
