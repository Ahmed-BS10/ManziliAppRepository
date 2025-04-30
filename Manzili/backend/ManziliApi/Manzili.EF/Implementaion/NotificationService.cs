using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.Implementaion
{
    public class NotificationService : INotificationService
    {
        private readonly ManziliDbContext _db;
        private readonly IHubContext<NotificationHub> _hub;

        public NotificationService(ManziliDbContext db, IHubContext<NotificationHub> hub)
        {
            _db = db;
            _hub = hub;
        }

        // وظيفة موجودة سابقاً: إرسال الإشعار
        public async Task SendAsync(int senderId, int receiverId, string type, string payload)
        {
            // 1. إنشاء كيان الإشعار
            var notif = new Nofiy
            {
                SenderId = senderId,
                ReceiverId = receiverId,
                Type = type,
                Payload = payload,
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            };

            // 2. حفظ الإشعار في قاعدة البيانات
            _db.Nofiys.Add(notif);
            await _db.SaveChangesAsync();

            // 3. بث الإشعار عبر SignalR للمجموعة المسماة بمعرف المتلقي
            await _hub.Clients
                .Group(receiverId.ToString())
                .SendAsync(
                    "ReceiveNotification",
                    new
                    {
                        Id = notif.Id,
                        Type = notif.Type,
                        Payload = payload,
                        CreatedAt = notif.CreatedAt
                    }
                );
        }

        // ١. جلب الإشعارات لكل متلقي
        public async Task<List<Nofiy>> GetByReceiverAsync(int receiverId)
        {
            return await _db.Nofiys
                .Where(n => n.ReceiverId == receiverId)
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        // ٢. (اختياري) علامة "مقروء" على جميع الإشعارات
        public async Task MarkAllAsReadAsync(int receiverId)
        {
            var list = await _db.Nofiys
                .Where(n => n.ReceiverId == receiverId && !n.IsRead)
                .ToListAsync();

            list.ForEach(n => n.IsRead = true);
            await _db.SaveChangesAsync();
        }
    }
}





public class NotificationHub : Hub
{
    // يُستدعى من العميل لتسجيل نفسه في مجموعة معرف المستلم
    public Task Register(string userId) =>
        Groups.AddToGroupAsync(Context.ConnectionId, userId);

    // (اختياري) دالة لفصل المستخدم من المجموعة
    public Task Unregister(string userId) =>
        Groups.RemoveFromGroupAsync(Context.ConnectionId, userId);
}

