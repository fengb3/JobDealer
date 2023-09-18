using System.Collections;
using System.Diagnostics;

namespace WebAPI.Tools;

public static class Log
{
    private static ILogger? _logger;
    
    public static void SetLogger(this WebApplication app)
    {
        _logger = app.Logger;
    }
    
    public static void Info(object message)
    {
        _logger?.LogInformation(message.ToString());
    }
    
    public static void Warning(object message)
    {
        _logger?.LogWarning(message.ToString());
    }
    
    public static void Error(object message)
    {
        _logger?.LogError(message.ToString());
    }
    
    public static void Trace(object message)
    {
        _logger?.LogTrace(message.ToString());
    }
}