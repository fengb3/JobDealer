using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System;
using WebAPI.System.DataBase;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class JobPostController : ControllerBase
{
    [HttpPost("search")]
    public IActionResult Search([FromBody] JobPostSearch search)
    {
        var posts = JobPostSystem.SearchJob(search);
        
        if (posts.Count()==0)
        {
            return NotFound($"There is no post with this keyword {search.Keyword}");
        }
        
        return Ok(posts);
    }
    
    [HttpPost("create")]
    public IActionResult Create([FromBody] JobPost jobPost)
    {
        // DataBaseHandler.Conn.Insert(jobPost);
        
        if(jobPost == null)
        {
            return BadRequest("Job post cannot be null");
        }
        
        if(jobPost.Title == "")
        {
            return BadRequest("Job post title cannot be null or empty");
        }
        
        if(jobPost.Location == "")
        {
            return BadRequest("Job post location cannot be null or empty");
        }
        
        // if(jobPost.JobCategoriesMask == 0)
        // {
        //     return BadRequest("Job post category cannot be null or empty");
        // }

        if (DataBaseHandler.Conn.Find<Company>(c => c.Id == jobPost.CompanyId) == default)
        {
            return NotFound($"Company Id not found - {jobPost.CompanyId}");
        }
        
        JobPostSystem.CreateJobPost(jobPost);
        
        return Ok(jobPost);
    }

    [HttpPost("update")]
    public IActionResult UpdateJobPost([FromBody] JobPost jobPost)
    {
        if(jobPost == null)
        {
            return BadRequest("Job post cannot be null");
        }

        var find = DataBaseHandler.Conn.Find<JobPost>(jobPost.Id);
        
        if (find == null) return NotFound($"Cannot find job post with id {jobPost.Id}");
        
        if(jobPost.Title == "")
        {
            return BadRequest("Job post title cannot be null or empty");
        }
        
        if(jobPost.Location == "")
        {
            return BadRequest("Job post location cannot be null or empty");
        }
        
        // if(jobPost.JobCategoriesMask == 0)
        // {
        //     return BadRequest("Job post category cannot be null or empty");
        // }

        if (DataBaseHandler.Conn.Find<Company>(c => c.Id == jobPost.CompanyId) == default)
        {
            return NotFound($"Company Id not found - {jobPost.CompanyId}");
        }
        
        DataBaseHandler.Conn.Update(jobPost);

        return Ok(jobPost);
    }
    
    [HttpPost("delete")]
    public IActionResult DeleteJobPost([FromBody] JobPost jobPost)
    {
        if (DataBaseHandler.Conn.Find<JobPost>(jobPost.Id) == default) return NotFound("Cannot find job post with id " + jobPost.Id);
        
        DataBaseHandler.Conn.Delete(jobPost);

        return Ok();
    }
    
    [HttpGet("getRecommend/{userId:long}")]
    public IActionResult GetRecommendation(long userId)
    {
        if (!DataBaseHandler.Conn.Table<User>().Any(u => u.Id == userId))
        {
            return NotFound($"User id not found - {userId}");
        }
        
        var posts = JobPostSystem.GetUserRecommendation(userId);

        return Ok(posts);
    }
    
    [HttpGet("viewed/{userId:long}/{jobPostId:long}")]
    public IActionResult ViewJobPost(long userId, long jobPostId)
    {
        if (!DataBaseHandler.Conn.Table<User>().Any(u => u.Id == userId))
        {
            return NotFound($"User id not found - {userId}");
        }
        
        if (!DataBaseHandler.Conn.Table<JobPost>().Any(j => j.Id == jobPostId))
        {
            return NotFound($"Job post id not found - {jobPostId}");
        }
        
        JobPostSystem.ViewJobPost(userId, jobPostId);
        
        return Ok();
    }
    
    [HttpGet("getViewHistory/{userId:long}")]
    public IActionResult GetViewHistory(long userId)
    {
        if (!DataBaseHandler.Conn.Table<User>().Any(u => u.Id == userId))
        {
            return NotFound($"User id not found - {userId}");
        }
        
        var history = JobPostSystem.GetUserViewHistory(userId);
        
        return Ok(history);
    }
    
    [HttpGet("getByPoster/{id:long}")]
    public IActionResult GetByPoster(long id)
    {
        var user = DataBaseHandler.Conn.Find<User>(id);
        
        if (user == null) return NotFound("Cannot find user with id " + id);
        
        // var jobPoster = DataBaseHandler.Conn.Find<JobPoster>(jp => jp.UserId == id);
        //
        // if(jobPoster == null) return NotFound("Cannot find job poster with user id " + id);

        var find = DataBaseHandler.Conn.Table<JobPost>().ToList().Where(p => p.PosterId == id).ToList();

        if (find.Count == 0) return NotFound("Cannot find job post with poster id " + id);

        return Ok(find);
    }
    
    
}