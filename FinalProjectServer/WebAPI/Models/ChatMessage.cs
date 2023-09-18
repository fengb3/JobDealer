using SQLite;

namespace WebAPI.Models;

public class ChatMessage : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; }
    
    public long ChatId { get; set; }
    
    public string Message { get; set; } = "";
    
    public long Time { get; set; }
    
    public long SenderId { get; set; }
}