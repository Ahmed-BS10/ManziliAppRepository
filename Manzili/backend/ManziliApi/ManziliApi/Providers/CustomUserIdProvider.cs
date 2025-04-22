using Microsoft.AspNetCore.SignalR;

namespace ManziliApi.Providers
{
    public class CustomUserIdProvider : IUserIdProvider
    {
        public string GetUserId(HubConnectionContext connection)
        {
            return connection.User?.FindFirst("UserId")?.Value; // Adjust based on your authentication setup
        }
    }
}
