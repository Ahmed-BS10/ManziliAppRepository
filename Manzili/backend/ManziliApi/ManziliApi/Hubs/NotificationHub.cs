using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace ManziliApi.Hubs
{
    public class NotificationHub : Hub
    {
        public async Task SendNotification(string userId, string message)
        {
            await Clients.User(userId).SendAsync("ReceiveNotification", message);
        }
    }
}

//using Microsoft.AspNetCore.SignalR;
//using System.Collections.Concurrent;

//public class NotificationHub : Hub
//{
//    private static ConcurrentDictionary<string, string> UserConnections = new();

//    public override Task OnConnectedAsync()
//    {
//        var userId = Context.GetHttpContext()?.Request.Query["userId"];
//        if (!string.IsNullOrEmpty(userId))
//            UserConnections[userId] = Context.ConnectionId;

//        return base.OnConnectedAsync();
//    }

//    public override Task OnDisconnectedAsync(Exception? exception)
//    {
//        var userId = UserConnections.FirstOrDefault(x => x.Value == Context.ConnectionId).Key;
//        if (!string.IsNullOrEmpty(userId))
//            UserConnections.TryRemove(userId, out _);

//        return base.OnDisconnectedAsync(exception);
//    }

//    public static string? GetConnectionId(string userId)
//    {
//        UserConnections.TryGetValue(userId, out var connectionId);
//        return connectionId;
//    }
//}
