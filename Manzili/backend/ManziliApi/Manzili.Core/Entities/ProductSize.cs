using Manzili.Core.Entities;

public class ProductSize
{
    public int Id { get; set; }
    public string Size { get; set; } = string.Empty;
    public int Quantity { get; set; } = 0;
    public decimal Price { get; set; } = 0.0m;

    public int ProductId { get; set; }
    public Product Product { get; set; }
}
