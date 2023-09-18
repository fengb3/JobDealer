using System.Text.RegularExpressions;

namespace WebAPI.Tools;

public static class StringHelper
{
    public static bool IsValidEmail(this string email)
    {
        // check is email is valid using regex
        var regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
        
        if (!regex.IsMatch(email))
        {
            return false;
        }
        
        return true;
    }
}