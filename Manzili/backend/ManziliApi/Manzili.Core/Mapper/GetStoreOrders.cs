public class GetStoreOrders
{
    public int Id { get; set; }
    public string CustomerName { get; set; }
    public string CustomerPhoneNumber { get; set; }
    public string CustomerAddress { get; set; }
    public DateTime CreatedAt { get; set; }
    public double TotalPrice { get; set; }
    public double TotalOfEachProduct { get; set; }
    public string Status { get; set; }
    public string? Note { get; set; }

    public byte[] FileContent { get; set; }


    public List<GetOrdeProduct> OrderProducts { get; set; }
}