namespace Manzili.Core.Entities
{
    public class StoreCategoryStore
    {
        public int Id {  get; set; }
        public int StoreId { get; set; }
        public Store Store { get; set; }

        public int StoreCategoryId { get; set; }
        public StoreCategory StoreCategory { get; set; }
    }


}
