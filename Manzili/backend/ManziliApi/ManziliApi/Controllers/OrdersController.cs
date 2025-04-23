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

        // هذه التعليمة تخبر ASP.NET أن هذا الأكشن يتوقع body من نوع multipart/form-data
        [HttpPost("AddOrder")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> AddOrderAsync([FromForm] CreateOrderDto createOrderDto)
        {
            // 1. التحقق من صحة البيانات المجلوبة
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // 2. (اختياري) التحقق من نوع وحجم الملف قبل الإرسال للـ Service
            if (createOrderDto.PdfFile != null)
            {
                if (createOrderDto.PdfFile.ContentType != "application/pdf")
                    return BadRequest("الملف المرفوع ليس PDF.");
                if (createOrderDto.PdfFile.Length > 5 * 1024 * 1024) // مثلاً 5 ميغا كحد أقصى
                    return BadRequest("حجم الملف يتجاوز 5 ميغا.");
            }

            // 3. تمرير الـ DTO للـ Service لمعالجة المنطق وحفظه
            var result = await _orderService.AddOrderAsync(createOrderDto);

            // 4. إرجاع الاستجابة المناسبة
            if (result.IsSuccess)
                // - يمكنك استخدام CreatedAtAction إذا كان لديك GetById لترجيع URI للموارد الجديدة
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

    }
}
