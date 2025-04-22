using Microsoft.AspNetCore.Mvc;
using Manzili.Core.Services;
using System.Threading.Tasks;
using Manzili.Core.Enum;
using Microsoft.AspNetCore.SignalR;
using ManziliApi.Hubs;

namespace Manzili.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly IOrdersService _orderService;
        private readonly IHubContext<NotificationHub> _hubContext;


        public OrdersController(IOrdersService orderService, IHubContext<NotificationHub> hubContext)
        {
            _orderService = orderService;
            _hubContext = hubContext;
        }



        [HttpGet("GetDeliveredOrdersByUserId")]
        public async Task<IActionResult> GetDeliveredOrdersByUserIdAsync(int userId)
        {
            var result = await _orderService.GetDeliveredOrdersByUserIdAsync(userId);
            if (result.IsSuccess)
                return Ok(result);


            return BadRequest(result);
        }


        [HttpGet("GetUnDeliveredOrdersByUserId")]
        public async Task<IActionResult> GetUnDeliveredOrdersByUserIdAsync(int userId)
        {
            var result = await _orderService.GetUnDeliveredOrdersByUserIdAsync(userId);
            if (result.IsSuccess)
                return Ok(result);


            return BadRequest(result);
        }


        [HttpGet("GetOrderDetailsByUserAsync")]
        public async Task<IActionResult> GetOrderDetailsByUserAsync(int userId)
        {
            var result = await _orderService.GetOrderDetailsByUserAsync(userId);
            if (result.IsSuccess)
                return Ok(result);


            return BadRequest(result);
        }

        [HttpPost("AddOrder")]
        public async Task<IActionResult> AddOrderAsync(CreateOrderDto createOrderDto)
        {
            var result = await _orderService.AddOrderAsync(createOrderDto);

            if (result.IsSuccess)
            {
                await _hubContext.Clients.User(createOrderDto.StoreId.ToString())
               .SendAsync("ReceiveNotification", "New order received!");
                return Ok(result);
            }
            return BadRequest(result);
        }

        [HttpPut("UpdateOrderStatus")]
        public async Task<IActionResult> UpdateOrderStatusAsync(int orderId, enOrderStatus status)
        {
            var result = await _orderService.UpdateOrderStatusAsync(orderId, status);
            if (result.IsSuccess)
            {
                var userIdResult = await _orderService.GetUserIdByOrderIdAsync(orderId);
                if (userIdResult.IsSuccess)
                {
                    if (userIdResult.Data.HasValue)
                    {
                        await _hubContext.Clients.User(userIdResult.Data.Value.ToString())
                            .SendAsync("ReceiveNotification", $"Your order status has been updated to {status}");
                    }
                    else
                    {
                        // Log or handle the case where UserId is null
                        Console.WriteLine($"UserId not found for OrderId: {orderId}");
                    }
                }
                else
                {
                    // Log or handle the failure of GetUserIdByOrderIdAsync
                    Console.WriteLine($"Failed to retrieve UserId for OrderId: {orderId}. Reason: {userIdResult.Message}");
                }

                return Ok(result);
            }

            return BadRequest(result);
        }

        [HttpGet("GetOrderTrackingHistory")]
        public async Task<IActionResult> GetOrderTrackingHistoryAsync(int orderId)
        {
            var result = await _orderService.GetOrderTrackingHistoryAsync(orderId);
            if (result.IsSuccess)
            {
                return Ok(result);
            }
            return BadRequest(result);
        }
    }
}
