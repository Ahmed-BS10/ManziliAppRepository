using Manzili.Core.Entities;
using Manzili.Core.Repositories;

public interface IRepositoryStore : IRepository<Store>
{
    Task<IEnumerable<Store>> GetListPagination(int page, int pageSize);
}
