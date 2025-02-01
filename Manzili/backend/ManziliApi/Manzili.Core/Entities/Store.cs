namespace Manzili.Core.Entities
{
    public class Store : User
    {
        public string BusinessName { get; set; }
        public string BankAccount { get; set; }
        public string Status { get; set; }

      
        public ICollection<Product>? Products { get; set; }
    }

}
