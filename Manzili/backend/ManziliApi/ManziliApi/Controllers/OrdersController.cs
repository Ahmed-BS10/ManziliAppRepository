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

        [HttpGet("get order")]
        public async Task<IActionResult> GetOrders()
        {
            var result = await _orderService.GetOrdersAsync();
            if (!result.IsSuccess)
            {
                return NotFound(new { Message = result.Message });
            }
            return Ok(result.Data);
        }
        [HttpGet("status/{status}")]
        public async Task<IActionResult> GetOrdersByStatus(enOrderStatus status)
        {
            var result = await _orderService.GetOrdersByStatusAsync(status);
            if (!result.IsSuccess)
            {
                return NotFound(new { Message = result.Message });
            }
            return Ok(result.Data);
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetOrderById(int id)
        {
            var result = await _orderService.GetOrderDetailsByIdAsync(id);
            if (!result.IsSuccess)
            {
                return NotFound(new { Message = result.Message });
            }
            return Ok(result.Data);
        }
    }
}
