namespace WebAPI.Models;

[Flags]
public enum UserTypeMask : int
{
    Admin = JobPoster | JobSeeker,
    //employer = 2,
    //employee = 4,
    JobSeeker = 8,
    JobPoster = 16
}

public static class UserTypeMaskExtensions
{
    public static string ToName(this UserTypeMask mask)
    {
        return mask switch
        {
            UserTypeMask.Admin     => "Admin",
            //UserTypeMask.employer  => "Employer",
            //UserTypeMask.employee  => "Employee",
            UserTypeMask.JobSeeker => "Job Seeker",
            UserTypeMask.JobPoster => "Job Poster",
            _                      => "Unknown"
        };
    }
    
    public static string ToUserTypeName(this long mask)
    {
        var userTypeMask = (UserTypeMask)mask;
        return userTypeMask.ToName();
    }
    
    public static bool HasFlag(this long mask, UserTypeMask flag)
    {
        return ((UserTypeMask)mask).HasFlag(flag);
    }
}