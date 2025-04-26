using Manzili.Core.Dto.OrderDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;

public interface IOrdersService
{
    

    Task<OperationResult<IEnumerable<GetOrderDetailsDto>>> GetOrderDetailsAsync(int orderId);
    Task<OperationResult<IEnumerable<GteBaseOrderDto>>> GetDeliveredOrdersByUserIdAsync(int userId);
    Task<OperationResult<IEnumerable<GteBaseOrderDto>>> GetUnDeliveredOrdersByUserIdAsync(int userId);
    Task<OperationResult<bool>> AddOrderAsync(CreateOrderDto createOrderDto);
    Task<OperationResult<bool>> UpdateOrderStatusAsync(int orderId, enOrderStatus status);
    Task<OperationResult<int?>> GetUserIdByOrderIdAsync(int orderId);
    Task<OperationResult<IEnumerable<OrderTracking>>> GetOrderTrackingHistoryAsync(int orderId);

}

