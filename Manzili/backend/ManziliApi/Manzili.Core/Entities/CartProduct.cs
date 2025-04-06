using Manzili.Core.Entities;

public class CartProduct
{
    public int CartProductId { get; set; }
    public int? CartId { get; set; }
    public int ProductId { get; set; }
  

    // العلاقات
    public Cart? Cart { get; set; }
    public Product Product { get; set; }
}
