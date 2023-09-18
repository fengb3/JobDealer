using System.ComponentModel.DataAnnotations.Schema;
using SQLite;

namespace WebAPI.Models;

[SQLite.Table("Chat")]
public class Chat : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; }
    
    [ForeignKey("User")]
    public long SenderId1 { get; set; }
    
    [ForeignKey("User")]
    public long SenderId2 { get; set; }
    
    public long LastCommunicatedTime { get; set; }

    public long LastMessageId { get; set; }
}