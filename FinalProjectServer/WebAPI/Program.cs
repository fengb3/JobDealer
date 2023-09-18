// using System;
// using Microsoft.AspNetCore.Builder;
// using Microsoft.Extensions.Hosting;
// using Microsoft.AspNetCore.SignalR;
// using Microsoft.Extensions.DependencyInjection;
// using Microsoft.AspNetCore.Http.Features;
// using Microsoft.Extensions.DependencyInjection.Extensions;
// using Microsoft.Extensions.DependencyInjection.Extensions;
// using Microsoft.AspNetCore.Http.Features;
// using Microsoft.OpenApi.Models;
// using WebAPI.System.Chat;
// using WebAPI.Tools;
//
// var builder = WebApplication.CreateBuilder(args);
//
// // Increase the multipart body length limit
// builder.Services.Configure<FormOptions>(options =>
//                                         {
//                                             options.MultipartBodyLengthLimit = 20 * 1024 * 1024; // 20 MB
//                                         });
//
// // Add services to the container.
// builder.Services.AddControllers();
//
// builder.Services.AddEndpointsApiExplorer();
// builder.Services.AddSwaggerGen();
//
// // Add SignalR service
// builder.Services.AddSignalR();
//
// var app = builder.Build();
//
// app.SetLogger();
//
// // Configure the HTTP request pipeline.
// if (app.Environment.IsDevelopment())
// {
//     app.UseSwagger(options =>
//                    {
//                        // Use your local IP address in the URL instead of localhost
//                        options.PreSerializeFilters.Add((swagger, httpReq) =>
//                                                        {
//                                                            Console.WriteLine(httpReq.Host.Value);
//                                                            swagger.Servers = new List<OpenApiServer>
//                                                                              {
//                                                                                  new OpenApiServer
//                                                                                  {
//                                                                                      Url =
//                                                                                          $"http://{httpReq.Host.Value}"
//                                                                                  }
//                                                                              };
//                                                        });
//                    });
//
//     app.UseSwaggerUI(options => { options.SwaggerEndpoint("/swagger/v1/swagger.json", "Your API v1"); });
// }
//
// app.UseStaticFiles(); // Add this line
//
// app.UseRouting();
//
// // app.UseHttpsRedirection();
//
// app.UseAuthorization();
//
// app.MapControllers();
//
// // Map SignalR Hub
// app.MapHub<ChatHub>("/chatHub");
//
// // app.Run("http://10.0.0.215:7202");
// app.Run("http://0.0.0.0:7202");

using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using WebAPI.System.Chat;
using WebAPI.Tools;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.AspNetCore.Http.Features;
using WebAPI.System.DataBase;

var builder = WebApplication.CreateBuilder(args);

// Add this code block
builder.Services.Configure<FormOptions>(options =>
                                        {
                                            options.MultipartBodyLengthLimit = 20 * 1024 * 1024; // 20 MB
                                        });

// Add services to the container.
builder.Services.AddControllers()
       .ConfigureApiBehaviorOptions(options =>
                                    {
                                        options.SuppressModelStateInvalidFilter = true;
                                    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add SignalR service and set the maximum message size
builder.Services.AddSignalR(options =>
                            {
                                options.MaximumReceiveMessageSize = 100_000_000; // Set the maximum message size to 100 MB
                            });

var app = builder.Build();

app.SetLogger();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger(options =>
                   {
                       // Use your local IP address in the URL instead of localhost
                       options.PreSerializeFilters.Add((swagger, httpReq) =>
                                                       {
                                                           Console.WriteLine(httpReq.Host.Value);
                                                           swagger.Servers = new List<OpenApiServer>
                                                                             {
                                                                                 new OpenApiServer { Url = $"http://{httpReq.Host.Value}" }
                                                                             };
                                                       });
                   });

    app.UseSwaggerUI(options =>
                     {
                         options.SwaggerEndpoint("/swagger/v1/swagger.json", "Your API v1");
                     });
}

app.UseStaticFiles(); // Add this line

app.UseRouting();

// app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

var x = DataBaseHandler.Conn;

// Map SignalR Hub
app.MapHub<ChatHub>("/chatHub");

// app.Run("http://10.0.0.215:7202");
app.Run("http://0.0.0.0:7202");


