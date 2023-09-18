
using System.ComponentModel.DataAnnotations.Schema;
using SQLite;

namespace WebAPI.Models;

[SQLite.Table("Person")]
public class Person : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; }
    
    // foreign key
    [ForeignKey("User")]
    public long UserId { get; set; }
    
    public string FirstName { get; set; } = "";
    public string LastName  { get; set; } = "";
    
    public string Email { get; set; } = "";
    public string Phone { get; set; } = "";
    
    public string ImageUrl { get; set; } = "";
    public string Location { get; set; } = "";
}