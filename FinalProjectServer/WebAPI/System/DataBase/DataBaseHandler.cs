using SQLite;
using WebAPI.Models;

// ReSharper disable InconsistentNaming

namespace WebAPI.System.DataBase;

public static class DataBaseHandler
{
    private const string CONNECTION_STRING = "finalproj_1.sqlite3";

    private static readonly Lazy<SQLiteConnection> Lazy = new(CreateDataBase);

    public static SQLiteConnection Conn => Lazy.Value;
    
    private static SQLiteConnection CreateDataBase()
    {
        var connection = new SQLiteConnection(CONNECTION_STRING);
        connection.CreateTable<Company>();
        
        connection.CreateTable<JobSeeker>();
        connection.CreateTable<JobPoster>();
        connection.CreateTable<User>();
        connection.CreateTable<Person>();
        
        connection.CreateTable<JobPost>();
        connection.CreateTable<UserType>();
        
        connection.CreateTable<Models.Chat>();
        connection.CreateTable<ChatMessage>();
        
        
        return connection;
    }
}