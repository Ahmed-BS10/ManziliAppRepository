using Microsoft.AspNetCore.Http;
using System.Net.Http.Headers;

public class CreateOrderDto
{
    public int UserId { get; set; }
    public int StoreId { get; set; }
    public string DeliveryAddress { get; set; }
    public string? Note { get; set; }
    public List<CreateOrderProductDto> OrderProducts { get; set; } = new List<CreateOrderProductDto>();


    public IFormFile? PdfFile { get; set; }
}




public class CreateOrderProductDto
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }

}
