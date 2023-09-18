namespace WebAPI.Models;

[Flags]
public enum JobCategoryMask : long
{
    None           = 0,
    Management     = 1 << 0,
    Professional   = 1 << 1,
    Technical      = 1 << 2,
    Sales          = 1 << 3,
    Administrative = 1 << 4,
    Service        = 1 << 5,
    SkilledTrades  = 1 << 6,
}

public static class JobCategoryMaskExtensions
{
    public static string ToName(this JobCategoryMask mask)
    {
        return mask switch
        {
            JobCategoryMask.None           => "None",
            JobCategoryMask.Management     => "Management",
            JobCategoryMask.Professional   => "Professional",
            JobCategoryMask.Technical      => "Technical",
            JobCategoryMask.Sales          => "Sales",
            JobCategoryMask.Administrative => "Administrative",
            JobCategoryMask.Service        => "Service",
            JobCategoryMask.SkilledTrades  => "Skilled Trades",
            _                              => "Unknown"
        };
    }
    
    public static string ToJobCategoryName(this long mask)
    {
        var jobCategoryMask = (JobCategoryMask)mask;
        return jobCategoryMask.ToName();
    }
    
    public static bool HasFlag(this ulong mask, JobCategoryMask flag)
    {
        return ((JobCategoryMask)mask).HasFlag(flag);
    }
}
