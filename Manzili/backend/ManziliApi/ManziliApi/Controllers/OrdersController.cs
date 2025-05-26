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



        [HttpGet("GetOrderDetails2")]
        public async Task<IActionResult> GetOrderDetailsAsync2(int orderId)
        {
            var result = await _orderService.GetOrderDetailsAsync2(orderId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        
        [HttpGet("IsCanChnageTodeliveredStatus")]
        public async Task<IActionResult> IsCanChnageTodeliveredStatus(int orderId)
        {
            var result = await _orderService.IsCanChnageTodeliveredStatus(orderId);
            if (result)
                return Ok(result);

            return BadRequest(result);
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

        [HttpGet("GetOrderDetails")]
        public async Task<IActionResult> GetOrderDetailsAsync(int orderId)
        {
            var result = await _orderService.GetOrderDetailsAsync(orderId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPost("AddOrder")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> AddOrderAsync([FromForm] CreateOrderDto createOrderDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            //if (createOrderDto.PdfFile != null)
            //{
            //    if (createOrderDto.PdfFile.ContentType != "application/pdf")
            //        return BadRequest("الملف المرفوع ليس PDF.");
            //    if (createOrderDto.PdfFile.Length > 5 * 1024 * 1024)
            //        return BadRequest("حجم الملف يتجاوز 5 ميغا.");
            //}

            var result = await _orderService.AddOrderAsync(createOrderDto);

            if (result.IsSuccess)
                return Ok(result);
            else
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


        [HttpDelete("{orderId}")]
        public  IActionResult DeleteOrder(int orderId)
        {
            var result = _orderService.DeleteOrder(orderId);
            if(result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }
    }

   
}
