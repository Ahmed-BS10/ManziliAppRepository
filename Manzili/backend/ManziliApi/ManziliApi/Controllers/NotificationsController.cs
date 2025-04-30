

using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;

namespace Manzili.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationsController : ControllerBase
    {
        private readonly INotificationService _notifSvc;

        public NotificationsController(INotificationService notifSvc)
        {
            _notifSvc = notifSvc;
        }

        /// <summary>
        /// جلب كل الإشعارات لمستلم معيّن
        /// GET /api/notifications?receiverId=123
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] int receiverId)
        {
            var entities = await _notifSvc.GetByReceiverAsync(receiverId);

            return Ok(entities);
        }

        /// <summary>
        /// تمييز كل الإشعارات كمقروءة
        /// POST /api/notifications/mark-read?receiverId=123
        /// </summary>
        [HttpPost("mark-read")]
        public async Task<IActionResult> MarkAllRead([FromQuery] int receiverId)
        {
            await _notifSvc.MarkAllAsReadAsync(receiverId);
            return NoContent();
        }
    }
}
