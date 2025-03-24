using Microsoft.AspNetCore.Http;

public class CreateProductDto
{
    public string Name { get; set; }
    public double Price { get; set; }
    public int ProductCategoryId { get; set; }
    public int StoreCategoryId { get; set; }
    public string Description { get; set; }
    public int? Quantity { get; set; } // Default quantity if no sizes provided

    public List<IFormFile> formImages { get; set; }

    // Accept sizes and quantities as form-data fields
    public List<string>? Sizes { get; set; } // e.g., ["Small", "Large"]
    public List<int>? Quantities { get; set; } // e.g., [10, 5]
    public List<decimal> Prices { get; set; }
}
