using Manzili.Core.Entities;

namespace Manzili.Core.Services
{
    public interface INotificationService
    {
        Task<List<Nofiy>> GetByReceiverAsync(int receiverId);
        Task MarkAllAsReadAsync(int receiverId);
        Task SendAsync(int senderId, int receiverId, string type, string payload);
    }
}