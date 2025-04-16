
public class GetCartDto
{
    public int CartId { get; set; }
    public int UserId { get; set; }
    public int StoreId { get; set; }
    public string? Note { get; set; }

    public List<GetProductCartDto>? getProductCardDtos { get; set; }


}


public class GetProductCartDto
{
    public int? ProductId { get; set; }
    public string? Name { get; set; }
    public string? ImageUrl { get; set; }
    public double? Price { get; set; }

    public int Quantity { get; set; }
   
 
}