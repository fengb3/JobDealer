using WebAPI.Models;
using WebAPI.System.DataBase;

namespace WebAPI.System;

public static class JobPostSystem
{
    private static readonly Dictionary<long, JobPostSearch> UserSearchHistory = new();

    public static IEnumerable<JobPost> SearchJob(JobPostSearch search)
    {
        if (search.Keyword == "")
        {
            return new List<JobPost>();
        }

        var jobPosts = DataBaseHandler.Conn.Table<JobPost>()
                                      .Where(p => p.Title.ToLower().Contains(search.Keyword.ToLower()) ||
                                                  p.Description.ToLower().Contains(search.Keyword.ToLower()));

        UserSearchHistory[search.UserId] = search;

        return jobPosts;
    }

    public static IEnumerable<JobPost> GetUserRecommendation(long userId)
    {
        // get user search history
        if (!UserSearchHistory.TryGetValue(userId, out var search))
        {
            search = new JobPostSearch();
        }

        // search job post with histroy
        IEnumerable<JobPost> searched = DataBaseHandler.Conn.Table<JobPost>()
                                                       .Where(p => p.Title.Contains(search.Keyword) ||
                                                                   p.Description.Contains(search.Keyword));

        if (searched == null || searched.Count() == 0)
        {
            // if no result, search all
            searched = new List<JobPost>();
        }

        // get all job post 

        var all = DataBaseHandler.Conn.Table<JobPost>().Take(10 - searched.Count());

        return all.Concat(searched);
    }

    public static void CreateJobPost(JobPost jobPost)
    {
        DataBaseHandler.Conn.Insert(jobPost);
    }

    private static readonly Dictionary<long, Queue<JobPost>> UserJobPostViewHistory = new();

    public static void ViewJobPost(long userId, long jobPostId)
    {
        if (!UserJobPostViewHistory.TryGetValue(userId, out var history))
        {
            history                        = new Queue<JobPost>();
            UserJobPostViewHistory[userId] = history;
        }

        if (history.Any(j => j.Id == jobPostId))
        {
            return;
        }

        var jobPost = DataBaseHandler.Conn.Find<JobPost>(jobPostId);

        if (jobPost == null)
        {
            return;
        }

        history.Enqueue(jobPost);

        if (history.Count > 5)
        {
            history.Dequeue();
        }
    }

    public static IEnumerable<JobPost> GetUserViewHistory(long userId)
    {
        if (!UserJobPostViewHistory.TryGetValue(userId, out var history))
        {
            history                        = new Queue<JobPost>();
            UserJobPostViewHistory[userId] = history;
        }

        return history.Reverse();
    }
}

public struct JobPostSearch
{
    public string Keyword { get; set; }

    public long UserId { get; set; }
}