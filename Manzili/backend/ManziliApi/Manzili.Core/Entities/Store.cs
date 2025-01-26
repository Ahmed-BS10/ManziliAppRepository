namespace Manzili.Core.Entities
{
    public class Store : User
    {
       // public int StoreId { get; set; } // PK
       public string Image {  get; set; }
        public string BusinessName { get; set; }
        public string BankAccount { get; set; }
        public string Status { get; set; }

        // Navigation properties
       
        //public ICollection<StoreRating> StoreRatings { get; set; }
       // public ICollection<Order> Orders { get; set; }
        public ICollection<Product>? Products { get; set; }
    }

}
