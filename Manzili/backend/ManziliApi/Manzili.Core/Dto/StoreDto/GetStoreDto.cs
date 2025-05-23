public record GetStoreDto(
    int Id,
    string ImageUrl,
    string UserName,
    double? Rate ,
    List<string> CategoryNames,
    string Status
);







public class GetStoreDashbord
{
    public int Id { get; set; }
    public string Name { get; set; }
    public DateTime CreateAt { get; set; }
    public string Statu {  get; set; }
    public string Location { get; set; }
    public double TotalSale { get; set; }

}


