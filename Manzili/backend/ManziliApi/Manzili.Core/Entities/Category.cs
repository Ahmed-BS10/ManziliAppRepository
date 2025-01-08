namespace Manzili.Core.Entities
{
    public class Category
    {
        public int CategoryId { get; set; } // PK
        public string Name { get; set; }

        // Navigation properties
        public ICollection<Product> Products { get; set; }
        public ICollection<SubCategory> SubCategories { get; set; }
    }

}
