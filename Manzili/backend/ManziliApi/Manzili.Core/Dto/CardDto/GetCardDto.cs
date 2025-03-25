
public class GetCardDto
{
    public int UserId { get; set; }
    public int StoreId { get; set; }



    public double TotalPrice { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string? Note { get; set; }



    public List<GetProductCardDto> getProductCardDtos { get; set; }

  

}


public class GetProductCardDto
{
    public int ProductId { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Size
    {
        get; set;
    }
    public double Price { get; set; }
    public string ImageUrl { get; set; }
    public int Quantity { get; set; } // Total quantity

}