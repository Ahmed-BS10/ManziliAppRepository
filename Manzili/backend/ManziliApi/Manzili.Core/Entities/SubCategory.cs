namespace Manzili.Core.Entities
{
    public class SubCategory
    {
        public int SubCategoryId { get; set; } // PK
        public int CategoryId { get; set; } // FK
        public string Name { get; set; }

        // Navigation properties
        public Category Category { get; set; }
    }

}
