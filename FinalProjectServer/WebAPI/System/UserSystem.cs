using WebAPI.Models;
using WebAPI.System.DataBase;

namespace WebAPI.System;

public static class UserSystem
{
    public static Dictionary<long, User> LoggedInUsers { get; } = new();
    
    public static Dictionary<long, string> ChatConnections { get; } = new();

    public static void Login(long id, User user)
    {
        LoggedInUsers[id] = user;
    }
    
    public static void Logout(long id)
    {
        LoggedInUsers.Remove(id);
    }
    
    public static bool IsLoggedIn(long id)
    {
        return LoggedInUsers.ContainsKey(id);
    }
    
}