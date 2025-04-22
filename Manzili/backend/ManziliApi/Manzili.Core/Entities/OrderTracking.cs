using Manzili.Core.Entities;
using Manzili.Core.Enum;

public class OrderTracking
{
    public int Id { get; set; }
    public int OrderId { get; set; }
    public enOrderStatus Status { get; set; }
    public DateTime Timestamp { get; set; }
    public string? Location { get; set; }

    public Order Order { get; set; }
}
