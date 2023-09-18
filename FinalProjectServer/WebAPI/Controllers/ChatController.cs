using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System.DataBase;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class ChatController : ControllerBase
{
    // create a new chat with 2 users
    [HttpPost("create")]
    public IActionResult CreateChat([FromBody] Chat chat)
    {
        var find = DataBaseHandler.Conn.Find<Chat>(c => c.SenderId1 == chat.SenderId1 && c.SenderId2 == chat.SenderId2);

        if (find != null) return Ok(MakeChatWithNames(find));
        
        DataBaseHandler.Conn.Insert(chat);
        return Ok(MakeChatWithNames(chat));
    }

    // join a chat
    [HttpPost("join")]
    public IActionResult JoinChat([FromBody] Chat chat)
    {
        var find = DataBaseHandler.Conn.Find<Chat>(chat.Id);

        if (find != null)
        {
            return Ok(find);
        }

        return NotFound($"Cannot find chat with userId {chat.Id}");
    }

    // get all chats associated with a user
    [HttpGet("get/{userId:long}")]
    public IActionResult GetChats(long userId)
    {
        var chats = DataBaseHandler.Conn.Table<Chat>().Where(c => c.SenderId1 == userId || c.SenderId2 == userId)
                                   .ToList();

        // var lastMessage = DataBaseHandler.Conn.Find<ChatMessage>()

        var chatsWithName = chats.Select(MakeChatWithNames).ToList();

        if (chats.Count > 0)
        {
            return Ok(chatsWithName);
        }

        return NotFound($"Cannot find any chats for user {userId}");
    }

    [HttpGet("getMessages/{chatId:long}")]
    public IActionResult GetChatMessages(long chatId)
    {
        var messages = DataBaseHandler.Conn.Table<ChatMessage>().Where(cm => cm.ChatId == chatId).ToList();

        if (messages.Count > 0)
        {
            // take the last 20 messages
            messages = messages[^Math.Min(20, messages.Count)..];
            return Ok(messages);
        }

        return NotFound($"Cannot find any messages for chat {chatId}");
    }

    [HttpGet("getLastMessages/{chatId:long}")]
    public IActionResult GetLastChatMessage(long chatId)
    {
        var messages = DataBaseHandler.Conn.Table<ChatMessage>().Where(cm => cm.ChatId == chatId).ToList();
        
        if(messages.Count > 0)
        {
            return Ok(messages[^1]);
        }
        
        return NotFound($"Cannot find any messages for chat {chatId}");
    }

    private object MakeChatWithNames(Chat chat)
    {
        var lastMessage =
            DataBaseHandler.Conn.Find<ChatMessage>(chat.LastMessageId);
        
        var senderName1 =
            DataBaseHandler.Conn.Find<Person>(p => p.UserId == chat.SenderId1);
        var senderName2 =
            DataBaseHandler.Conn.Find<Person>(p => p.UserId == chat.SenderId2);
        
        return new
               {
                   chat.Id,
                   chat.SenderId1,
                   chat.SenderId2,
                   chat.LastCommunicatedTime,
                   SenderName1 = senderName1 == default
                       ? ""
                       : senderName1.FirstName + " " + senderName1.LastName,
                   SenderName2 = senderName2 == default
                       ? ""
                       : senderName2.FirstName + " " + senderName2.LastName,
                   LastMessageContent = lastMessage == default
                       ? ""
                       : lastMessage.Message
               };
    }
}