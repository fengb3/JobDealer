using System.ComponentModel.DataAnnotations;
using SQLite;

namespace WebAPI.Models;

[Table("User")]
public class User : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; } = 0;

    [Unique, Required, MinLength(1)]
    public string UserName { get; set; } = "";

    public string Password { get; set; } = "";

    public int TypeMask { get; set; } = 0;
}