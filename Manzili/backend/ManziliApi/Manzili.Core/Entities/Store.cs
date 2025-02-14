using Manzili.Core.Enum;

namespace Manzili.Core.Entities
{
    public class Store : User
    {
        public string BusinessName { get; set; }
        public string Description { get; set; }
        public string BankAccount { get; set; }
        public double ? Rate {  get; set; }
        public string Status = enStoreStatus.Open.ToString();

        public ICollection<StoreCategoryStore> storeCategoryStores { get; set; }

        
    }

}
