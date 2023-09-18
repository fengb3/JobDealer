using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;
using WebAPI.System.DataBase;

namespace WebAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class CompanyController : ControllerBase
{
    [HttpPost("create")]
    public IActionResult CreateCompany([FromBody] Company company)
    {
        DataBaseHandler.Conn.Insert(company);

        return Ok(company);
    }
    
    [HttpGet("get/{id:long}")]
    public IActionResult GetCompany(long id)
    {
        var company = DataBaseHandler.Conn.Find<Company>(id);

        if (company == null) return NotFound("Cannot find company with id " + id);
        
        return Ok(company);
    }
    
    [HttpPost("update")]
    public IActionResult UpdateCompany([FromBody] Company company)
    {
        if(company.Id == 0) return BadRequest("Company id cannot be 0");

        if (DataBaseHandler.Conn.Find<Company>(company.Id) == default)
            return NotFound("Cannot find company with id " + company.Id);
            
        DataBaseHandler.Conn.Update(company);

        return Ok(company);
    }
    
    [HttpPost("delete/{id:long}")]
    public IActionResult DeleteCompany(long id)
    {
        var company = DataBaseHandler.Conn.Find<Company>(id);

        if (company == null) return NotFound("Cannot find company with id " + id);
        
        DataBaseHandler.Conn.Delete(company);

        return Ok();
    }
    
    [HttpGet("getall")]
    public IActionResult GetAllCompanies()
    {
        var companies = DataBaseHandler.Conn.Table<Company>().ToList();

        return Ok(companies);
    }
    
    [HttpGet("search/{name}")]
    public IActionResult SearchCompanies(string name)
    {
        var companies = DataBaseHandler.Conn.Table<Company>().Where(c => c.Name.Contains(name)).ToList();

        return Ok(companies);
    }
}