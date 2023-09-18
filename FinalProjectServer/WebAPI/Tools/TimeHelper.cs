namespace WebAPI.Tools;

public static class TimeHelper
{
    public static long ToUnixTime(this DateTime dateTime)
    {
        return ((DateTimeOffset) dateTime).ToUnixTimeSeconds();
    }
    
    public static DateTime FromUnixTime(this long unixTime)
    {
        return DateTimeOffset.FromUnixTimeSeconds(unixTime).DateTime;
    }

    public static long UnixTimeNow()
    {
        return DateTime.Now.ToUnixTime();
    }
}