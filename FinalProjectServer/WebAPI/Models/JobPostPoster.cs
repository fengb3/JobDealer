using System.ComponentModel.DataAnnotations.Schema;
using SQLite;

namespace WebAPI.Models;

[SQLite.Table("JobPoster")]
public class JobPoster : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; }

    [ForeignKey("User")]
    public long UserId { get; set; } = 0;

    [ForeignKey("Company")]
    public long CompanyId { get; set; } = 0;

    [ForeignKey("Person")]
    public long PersonId { get; set; } = 0;
}