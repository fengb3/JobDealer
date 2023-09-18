using SQLite;

namespace WebAPI.Models;

[Table("JobSeeker")]
public class JobSeeker : IModel
{
    [PrimaryKey, AutoIncrement]
    public long Id { get; set; } = 0;

    public long UserId   { get; set; } = 0;
    public long PersonId { get; set; } = 0;


    public string School         { get; set; } = "";
    public string Major          { get; set; } = "";
    public string Degree         { get; set; } = "";
    public long   GraduationYear { get; set; } = 0;

    public string Experience  { get; set; } = "";
    public string Skills      { get; set; } = "";
    public string Description { get; set; } = "";
}