using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System;
using WebAPI.System.DataBase;
using WebAPI.Tools;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login([FromBody] User user)
    {
        Log.Info($"Login user {user.UserName} - {user.Id}");

        var find = DataBaseHandler.Conn.Find<User>(u => u.UserName == user.UserName);

        if (find == default)
        {
            return NotFound($"Cannot find user with id {user.UserName}");
        }

        if (find.Password != user.Password)
        {
            return Unauthorized("Incorrect password");
        }

        // if (UserSystem.IsLoggedIn(user.Id))
        // {
        //     return Conflict($"User {user.UserName} is already logged in");
        // }

        UserSystem.Login(user.Id, find);

        // todo: return object that user needs, such as chats, faves, etc.
        return Ok(find);
    }

    [HttpPost("logout")]
    public IActionResult Logout([FromBody] User user)
    {
        Log.Info($"Logout user {user.UserName} - {user.Id}");

        if (!UserSystem.IsLoggedIn(user.Id))
        {
            return NotFound($"User {user.UserName} is not logged in");
        }

        UserSystem.Logout(user.Id);

        return Ok();
    }

    [HttpPost("check")]
    public IActionResult Check([FromBody] User user)
    {
        Log.Info($"Check user {user.UserName}");

        if (DataBaseHandler.Conn.Find<User>(u => u.UserName == user.UserName) != default)
        {
            return Conflict($"User name already exists - {user.UserName}");
        }

        return Ok();
    }

    public struct UserAndPerson
    {
        public User   User   { get; set; }
        public Person Person { get; set; }
    }

    [HttpPost("register")]
    public IActionResult Register([FromBody] UserAndPerson userAndPerson)
    {
        Log.Info($"Register user {userAndPerson.User.UserName}");
        
        var user = userAndPerson.User;
        
        if (user == null)
        {
            return BadRequest("User cannot be null");
        }
        
        if (user.UserName == "")
        {
            return BadRequest("User name cannot be null or empty");
        }
        
        if (user.Password == "")
        {
            return BadRequest("User password cannot be null or empty");
        }
        
        if (user.TypeMask == 0)
        {
            return BadRequest("User type cannot be null or empty");
        }
        
        var person = userAndPerson.Person;
        
        if (person == null)
        {
            return BadRequest("Person cannot be null");
        }
        
        if (person.FirstName == "")
        {
            return BadRequest("Person first name cannot be null or empty");
        }
        
        if (person.LastName == "")
        {
            return BadRequest("Person last name cannot be null or empty");
        }
        
        if (person.Email == "")
        {
            return BadRequest("Person email cannot be null or empty");
        }
        
        // check if email is valid
        if (!person.Email.IsValidEmail())
        {
            return BadRequest("Person email is not valid");
        }
        
        if (person.Phone == "")
        {
            return BadRequest("Person phone cannot be null or empty");
        }
        
        if (person.Location == "")
        {
            return BadRequest("Person location cannot be null or empty");
        }


        if (DataBaseHandler.Conn.Find<User>(u => u.UserName == userAndPerson.User.UserName) != default)
        {
            return Conflict($"User name already exists - {userAndPerson.User.UserName}");
        }
        
        DataBaseHandler.Conn.Insert(userAndPerson.User);
        
        userAndPerson.Person.UserId = userAndPerson.User.Id;
        
        DataBaseHandler.Conn.Insert(userAndPerson.Person);

        if ((userAndPerson.User.TypeMask & (int)UserTypeMask.JobPoster) != 0)
        {
            var company = new Company()
                          {
                             Name = "undefined"
                          };

            DataBaseHandler.Conn.Insert(company);
            
            var jobPoster = new JobPoster()
                            {
                                UserId   = userAndPerson.User.Id,
                                PersonId = userAndPerson.Person.Id,
                                CompanyId = company.Id
                            };
            
            DataBaseHandler.Conn.Insert(jobPoster);
        }
        
        if((userAndPerson.User.TypeMask & (int)UserTypeMask.JobSeeker) != 0)
        {
            var jobSeeker = new JobSeeker()
                            {
                                UserId   = userAndPerson.User.Id,
                                PersonId = userAndPerson.Person.Id,
                            };
            
            DataBaseHandler.Conn.Insert(jobSeeker);
        }
        
        return Ok(userAndPerson);
    }

    [HttpGet("profile/{userId:long}")]
    public IActionResult GetUserProfile(long userId)
    {
        Log.Info($"Get User Profile {userId}");

        var findUser = DataBaseHandler.Conn.Find<User>(u => u.Id == userId);
        if (findUser == default)
        {
            return NotFound($"User id not found - {userId}");
        }

        var findPerson = DataBaseHandler.Conn.Find<Person>(p => p.UserId == userId);

        if (findPerson == default)
        {
            return NotFound($"Person id not found - {userId}");
        }

        return Ok(new
                  {
                      User   = findUser,
                      Person = findPerson
                  });
    }

    [HttpPost("update")]
    public IActionResult UpdateUser(Person person)
    {
        Log.Info($"Update User Profile {person.UserId}");

        var findUser = DataBaseHandler.Conn.Find<User>(u => u.Id == person.UserId);

        if (findUser == default)
        {
            return NotFound($"User id not found - {person.UserId}");
        }

        var findPerson = DataBaseHandler.Conn.Find<Person>(person.Id);

        if (findPerson == default)
        {
            return NotFound($"Person id not found - {person.UserId}");
        }

        DataBaseHandler.Conn.Update(person);

        return Ok(person);
    }

    [HttpGet("imageUrl/{id:long}")]
    public IActionResult GetPersonUrl(long id)
    {
        var user = DataBaseHandler.Conn.Find<User>(u => u.Id == id);
        
        if (user == default)
        {
            return NotFound($"User id not found - {id}");
        }
        
        var person = DataBaseHandler.Conn.Find<Person>(p => p.UserId == id);
        
        if (person == default)
        {
            Log.Error("Database error: person not found but user exists");
            return NotFound($"Person id not found - {id}");
        }
        
        return Ok(person.ImageUrl);
    }
}