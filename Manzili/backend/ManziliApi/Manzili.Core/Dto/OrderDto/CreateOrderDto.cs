using Microsoft.AspNetCore.Http;

public class CreateOrderDto
{
    public int UserId { get; set; }
    public int StoreId { get; set; }
    public string DeliveryAddress { get; set; }
    public string? Note { get; set; }
    public List<CreateOrderProductDto> OrderProducts { get; set; }


    public IFormFile PdfFile { get; set; }
}
