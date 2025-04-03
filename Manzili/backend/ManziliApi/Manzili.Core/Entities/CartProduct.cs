using Manzili.Core.Entities;

public class CartProduct
{
    public int CartProductId { get; set; }
    public int CartId { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; } = 1; // الكمية الافتراضية للمنتج في السلة

    // العلاقات
    public Cart Cart { get; set; }
    public Product Product { get; set; }
}
