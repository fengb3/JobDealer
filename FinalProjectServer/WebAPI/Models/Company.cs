namespace WebAPI.Models;

using SQLite;

[Table("Company")]
public class Company : IModel
{
    [PrimaryKey, AutoIncrement]
    public long   Id          { get; set; } = 0;
    public string Name        { get; set; } = "";
    public string Address     { get; set; } = "";
    public string Description { get; set; } = "";
    public string LogoUrl     { get; set; } = "";
}