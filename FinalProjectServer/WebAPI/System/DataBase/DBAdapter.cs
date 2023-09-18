using WebAPI.Models;

namespace WebAPI.System.DataBase;

// ReSharper disable once InconsistentNaming
public class DBAdapter<T> : IDB<T> where T : IModel, new()
{
    public T? Get(long id)
    {
        return DataBaseHandler.Conn.Find<T>(id);
    }

    public IEnumerable<T> GetAll()
    {
        return DataBaseHandler.Conn.Table<T>();
    }

    public void Insert(T model)
    {
        DataBaseHandler.Conn.Insert(model);
    }

    public void Update(T model)
    {
        DataBaseHandler.Conn.Update(model);
    }

    public void Delete(long id)
    {
        DataBaseHandler.Conn.Delete<T>(id);
    }
    
    public bool TryGet(long id, out T? model)
    {
        model = DataBaseHandler.Conn.Find<T>(id);
        
        return model != null;
    }
}
