using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System;
using WebAPI.System.DataBase;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class JobPosterController : ControllerBase
{
    [HttpPost("create")]
    public IActionResult CreatePoster()
    {
        // // check validation
        // if (DataBaseHandler.Conn.Find<Company>(poster.CompanyId) == default)
        // {
        //     return NotFound($"Company Id not found - {poster.CompanyId}");
        // }
        //
        // if (DataBaseHandler.Conn.Find<User>(poster.UserId) == default)
        // {
        //     return NotFound($"user id does not exist - {poster.UserId}");
        // }
        //
        // if (DataBaseHandler.Conn.Find<Person>(poster.PersonId) == default)
        // {
        //     return NotFound($"person id does not exist - {poster.PersonId}");
        // }
        //
        // DataBaseHandler.Conn.Insert(poster);
        
        return BadRequest("this one is deprecated");
    }
    
    [HttpGet("profile/{id:long}")]
    public IActionResult GetProfile(long id)
    {
        var user = DataBaseHandler.Conn.Find<User>(id);
        
        if(user == null) return NotFound("Cannot find user with id " + id);
        
        var poster = DataBaseHandler.Conn.Find<JobPoster>(jp => jp.UserId == id);
        
        if (poster == null) return NotFound("Cannot find poster with id " + id);
        
        var company = DataBaseHandler.Conn.Find<Company>(poster.CompanyId);
        
        if(company == null) return NotFound("Cannot find company with id " + poster.CompanyId);
        // var user = DataBaseHandler.Conn.Find<User>(poster.UserId);
        var person = DataBaseHandler.Conn.Find<Person>(poster.PersonId);
        
        return Ok(new {poster, company, user, person});
    }
    
    
}