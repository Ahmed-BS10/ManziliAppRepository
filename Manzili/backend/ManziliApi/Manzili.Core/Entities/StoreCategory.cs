using Manzili.Core.Entities;

public class StoreCategory
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string? Image { get; set; }

    public ICollection<StoreCategoryStore> StoreCategoriesStores { get; set; }
    public ICollection<ProductCategory>? ProductCategories {  get; set; }
}
