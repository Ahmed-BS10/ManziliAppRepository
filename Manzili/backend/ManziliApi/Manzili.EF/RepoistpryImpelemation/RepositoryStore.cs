
using Manzili.Core.Entities;
using Manzili.Core.Extension;
using Manzili.EF.RepoistpryImpelemation;
using Microsoft.EntityFrameworkCore;

public class RepositoryStore : Repository<Store>, IRepositoryStore
{
    #region Constructor

    public RepositoryStore(ManziliDbContext dbContext) : base(dbContext)
    {
    }

    #endregion

    #region Method

    public async Task<IEnumerable<Store>> GetListPagination(int page, int pageSize)
    {

        return await _dbSet
        .Include(x => x.storeCategoryStores)
        .ThenInclude(x => x.StoreCategory)
        .ToPageination(page, pageSize)
        .ToListAsync() ?? Enumerable.Empty<Store>();


    }

  

    #endregion
}