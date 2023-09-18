using SQLite;

namespace WebAPI.Models;

public class JobCategory : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; } = 0;

    public string Name { get; set; } = "";
}