using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System.DataBase;
using WebAPI.Tools;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class JobSeekerController : ControllerBase
{
    [HttpPost("update")]
    public IActionResult UpdateProfile([FromBody] JobSeeker seeker)
    {
        var find = DataBaseHandler.Conn.Find<JobSeeker>(seeker.Id);

        if (find == null) return NotFound($"Cannot find seeker with id {seeker.Id}");

        DataBaseHandler.Conn.Update(seeker);
        return Ok(seeker);
    }

    [HttpGet("profile/{id:long}")]
    public IActionResult GetProfile(long id)
    {
        var user = DataBaseHandler.Conn.Find<User>(id);
        
        if(user == null) return NotFound("Cannot find user with id " + id);
        
        var seeker = DataBaseHandler.Conn.Find<JobSeeker>(js => js.UserId == id);

        if (seeker == null) return NotFound("Cannot find seeker with id " + id);

        // var user   = DataBaseHandler.Conn.Find<User>(seeker.UserId);
        var person = DataBaseHandler.Conn.Find<Person>(seeker.PersonId);

        return Ok(new { seeker, user, person });
    }

    [HttpGet("getAll")]
    public IActionResult GetAll()
    {
        Log.Info("Get all seekers");
        var seekers = DataBaseHandler.Conn.Table<JobSeeker>().ToList();
        var seekersWithPerson = seekers
                               .Select(seeker => new
                                                 {
                                                     seeker,
                                                     person = DataBaseHandler.Conn.Find<Person>(seeker.PersonId)
                                                 }).ToList();

        return Ok(seekersWithPerson);
    }

    [HttpPost("search")]
    public IActionResult Search([FromBody] JobSeekerSearch search)
    {
        var keyword = search.Keyword;
        
        Log.Info($"Search seekers by keyword - {keyword}");
        var seekers = DataBaseHandler.Conn.Table<JobSeeker>().ToList();

        seekers = seekers.Where(seeker => seeker.Degree.ToLower().Contains(keyword.ToLower()) ||
                                          seeker.Major.ToLower().Contains(keyword.ToLower()) ||
                                          seeker.Skills.ToLower().Contains(keyword.ToLower())).ToList();

        var seekersWithPerson = seekers
                               .Select(seeker => new
                                                 {
                                                     seeker,
                                                     person = DataBaseHandler.Conn.Find<Person>(seeker.PersonId)
                                                 }).ToList();

        return Ok(seekersWithPerson);
    }

    public class JobSeekerSearch
    {
        public string Keyword { get; set; } = "";
    }
}