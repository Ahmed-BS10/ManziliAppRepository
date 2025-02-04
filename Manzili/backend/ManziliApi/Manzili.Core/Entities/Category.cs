namespace Manzili.Core.Entities
{
    public class Category
    {
        public int CategoryId { get; set; }
        public string Name { get; set; }
        public string Image { get; set; }

        public ICollection<Product> Products { get; set; }
        public ICollection<SubCategory> SubCategories { get; set; }
    }

}
