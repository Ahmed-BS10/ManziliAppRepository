using Manzili.Core.Entities;

public class ProductSize
{
    public int Id { get; set; }
    public string Size { get; set; } = string.Empty;
    public int Quantity { get; set; } = 0;

    
    public int ProductId { get; set; }
    public Product Product { get; set; }
}
