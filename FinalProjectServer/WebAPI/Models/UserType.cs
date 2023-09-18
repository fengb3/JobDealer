using SQLite;

namespace WebAPI.Models;

public class UserType : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; } = 0;

    public string Name { get; set; } = "";
    public long  Mask { get; set; } = 0;
}