using Manzili.Core.Enum;

namespace Manzili.Core.Entities
{
    public class Store : User
    {
        public string BusinessName { get; set; }
        public string Description { get; set; }
        public string BankAccount { get; set; }
        public string BookTime { get; set; }
        public string? SocileMediaAcount { get; set; }
        public double ? Rate {  get; set; }

        public string Status = enStoreStatus.Open.ToString();
        public DateTime CreateAt { get; set; } = DateTime.UtcNow;



        public ICollection<Product>? Products { get; set; } = new List<Product>(); 
        public ICollection<Favorite>? Favorites { get; set; } = new List<Favorite>();
        public ICollection<StoreRating>? RatingsReceived { get; set; } = new List<StoreRating>();
        public ICollection<StoreCategoryStore>? storeCategoryStores { get; set; } = new List<StoreCategoryStore>();
    }

}
