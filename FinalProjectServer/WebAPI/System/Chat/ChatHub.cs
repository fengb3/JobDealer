using Microsoft.AspNetCore.SignalR;
using WebAPI.Models;
using WebAPI.System.DataBase;
using WebAPI.Tools;

// ReSharper disable UnusedMember.Global

namespace WebAPI.System.Chat;

public class ChatHub : Hub
{
    public ChatHub()
    {
        Log.Info("ChatHub created");
    }

    public override Task OnConnectedAsync()
    {
        // Log.Info($"A user connected to chat hub {Context.ConnectionId}");

        // send ask client for user Id
        Clients.Client(Context.ConnectionId).SendAsync("SubscribeUserId");

        return base.OnConnectedAsync();
    }

    public override Task OnDisconnectedAsync(Exception? exception)
    {
        Log.Info($"A user disconnected from chat hub {Context.ConnectionId}");

        // remove connection from chat connections
        UserSystem.ChatConnections.Remove(UserSystem.ChatConnections
                                                    .FirstOrDefault(c => c.Value == Context.ConnectionId).Key);

        return base.OnDisconnectedAsync(exception);
    }

    public async Task JoinChat(long fromUserId, long toUserId)
    {
        Log.Info($"user Joined chat {fromUserId} - {toUserId} - {Context.ConnectionId}");

        var find = DataBaseHandler.Conn.Find<Models.Chat>(c => 
                                                              (c.SenderId1 == fromUserId && c.SenderId2 == toUserId) ||
                                                              (c.SenderId1 == toUserId   && c.SenderId2 == fromUserId));
        if (find == default)
        {
            if (DataBaseHandler.Conn.Find<Models.User>(toUserId) == default)
            {
                Log.Error($"toUser not found - {toUserId}");
                return;
            }

            if (DataBaseHandler.Conn.Find<Models.User>(fromUserId) == default)
            {
                Log.Error("from user not found - {fromUserId}");
                return;
            }

            // create new chat
            find = new Models.Chat
                   {
                       SenderId1 = fromUserId,
                       SenderId2 = toUserId
                   };

            DataBaseHandler.Conn.Insert(find);
        }

        // toUserContextConnectionId
        // if (UserSystem.ChatConnections.TryGetValue(toUserId, out var toUserContextConnectionId))
        // {
        //     Log.Info($"user {toUserId} is online");
        //     // await Clients.Client(toUserContextConnectionId).SendAsync("ReceiveMessage", fromUserId, toUserId, "joined chat");
        // }

        await Groups.AddToGroupAsync(Context.ConnectionId, find.Id.ToString());
    }

    public async Task SendMessage(long fromUserId, long toUserId, string message)
    {
        Log.Info($"user {fromUserId} sent message to {toUserId} with text {message}");

        var chat = DataBaseHandler.Conn.Find<Models.Chat>(c => c.SenderId1 == fromUserId && c.SenderId2 == toUserId ||
                                                               c.SenderId1 == toUserId   && c.SenderId2 == fromUserId);

        if (chat == default)
        {
            // create new chat
            chat = new Models.Chat
                   {
                       SenderId1 = fromUserId,
                       SenderId2 = toUserId
                   };

            DataBaseHandler.Conn.Insert(chat);
        }

        var currUnixTime = DateTime.Now.ToUnixTime();

        var chatMessage = new ChatMessage
                          {
                              ChatId   = chat.Id,
                              Message  = message,
                              SenderId = fromUserId,
                              Time     = currUnixTime
                          };

        // insert chat history
        DataBaseHandler.Conn.Insert(chatMessage);

        chat.LastCommunicatedTime = currUnixTime;
        chat.LastMessageId        = chatMessage.Id;

        // update chat
        DataBaseHandler.Conn.Update(chat);

        await Clients.Group(chat.Id.ToString())
                     .SendAsync("ReceiveMessage", fromUserId, toUserId, message, chat.Id, chatMessage.Id);
    }


    public Task SubscribeUserId(long userId)
    {
        Log.Info($"user {userId} subscribed to chat hub {Context.ConnectionId}");

        UserSystem.ChatConnections[userId] = Context.ConnectionId;

        return Task.CompletedTask;

        // await Groups.AddToGroupAsync(Context.ConnectionId, userId.ToString());
    }

    #region File Transfer

    public async Task SendFile(int senderId, int receiverId, byte[] fileData, string fileName, string fileType)
    {
        Log.Info($"{senderId} wants to send file to {receiverId} with name {fileName} and type {fileType}");
        
        var chat = DataBaseHandler.Conn.Find<Models.Chat>(c => (c.SenderId1 == senderId && c.SenderId2 == receiverId) ||
                                                               (c.SenderId1 == receiverId && c.SenderId2 == senderId));

        if (chat == default)
        {
            Log.Warning("chat not found can't send file");
            return;
        }

        await Clients.Group(chat.Id.ToString()).SendAsync("ReceiveFile", senderId, fileName, fileType, fileData);
    }

    #endregion
}