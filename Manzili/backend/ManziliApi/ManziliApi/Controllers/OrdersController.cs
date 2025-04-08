using Microsoft.AspNetCore.Mvc;
using Manzili.Core.Services;
using System.Threading.Tasks;
using Manzili.Core.Enum;

namespace Manzili.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly IOrdersService _orderService;

        public OrdersController(IOrdersService orderService)
        {
            _orderService = orderService;
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
                return Ok(result);
            return BadRequest(result);
        }

        [HttpPut("UpdateOrderStatus")]
        public async Task<IActionResult> UpdateOrderStatusAsync(int orderId, enOrderStatus status)
        {
            var result = await _orderService.UpdateOrderStatusAsync(orderId, status);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);


        }

    }
}
