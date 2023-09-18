namespace WebAPI.System.DataBase;

public interface IDB<T> where T : new()
{
    T?             Get(long id);
    IEnumerable<T> GetAll();
    void           Insert(T    model);
    void           Update(T    model);
    void           Delete(long id);
    bool TryGet(long id, out T? model);
}
