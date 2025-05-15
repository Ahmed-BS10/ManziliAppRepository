public class GetOrdeProduct
{
    public int? Id { get; set; }
    public string Name { get; set; }
    public string? ImageUrl { get; set; }
    public int Price { get; set; }
    public double Total { get; set; }
    public int Count { get; set; }

}



public class GetOrdeProductAtStore
{
    public string Name { get; set; }
    public int Price { get; set; }
    public int Count { get; set; }

}