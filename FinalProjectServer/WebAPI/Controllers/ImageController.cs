
using System.IO;
using System.Net.Http.Headers;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ImageController : ControllerBase
{
    private readonly IWebHostEnvironment _environment;

    public ImageController(IWebHostEnvironment environment)
    {
        _environment = environment;
    }

    [HttpPost("upload")]
    public async Task<IActionResult> UploadImage()
    {
        var httpRequest = HttpContext.Request;

        if (httpRequest.Form.Files.Count == 0)
        {
            return BadRequest("No files found in the request.");
        }

        var file = httpRequest.Form.Files[0];

        // Validate file type
        var supportedFileTypes = new[] { "image/jpeg", "image/png", "image/gif" };
        if (!supportedFileTypes.Contains(file.ContentType))
        {
            return BadRequest("Invalid file type. Only JPEG, PNG, and GIF images are supported.");
        }

        // Validate file size
        var maxFileSize = 5 * 1024 * 1024; // 5 MB
        if (file.Length > maxFileSize)
        {
            return BadRequest("File size exceeds the 5 MB limit.");
        }

        var fileName       = file.FileName;
        var uniqueFileName = $"{Guid.NewGuid()}_{fileName}";
        var imagePath      = Path.Combine("wwwroot", "images", uniqueFileName);

        using (var fileStream = new FileStream(imagePath, FileMode.Create))
        {
            await file.CopyToAsync(fileStream);
        }

        return Ok(new { fileName = uniqueFileName });
    }

}