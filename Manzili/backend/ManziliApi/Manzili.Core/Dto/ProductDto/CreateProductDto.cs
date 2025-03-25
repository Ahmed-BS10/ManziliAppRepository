using Microsoft.AspNetCore.Http;

public class CreateProductDto
{
    public string Name { get; set; }
    public double Price { get; set; }
    public int ProductCategoryId { get; set; }
    public string? Description { get; set; }
    public int Quantity { get; set; } = 0;
    public List<IFormFile> formImages { get; set; }

   
}
