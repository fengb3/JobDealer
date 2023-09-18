using System.Runtime;
using SQLite;

namespace WebAPI.Models;

[Table("JobPost")]
public class JobPost : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; } = 0;

    public string Title             { get; set; } = "";
    public string Description       { get; set; } = "";
    public double Salary            { get; set; } = 0;
    public string Location          { get; set; } = "";
    public long   CompanyId         { get; set; } = 0;
    public long   JobCategoriesMask { get; set; } = 0;
    public long   PosterId          { get; set; } = 0;
}