using Manzili.Core.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.RepoistpryImpelemation
{
    public class Repository<T> : IRepository<T> where T : class
    {

        #region Field
        private readonly ManziliDbContext _dbContext;
        private readonly DbSet<T> _dbSet;

        #endregion

        #region Constructor

        public Repository(ManziliDbContext dbContetx)
        {
            _dbContext = dbContetx;
            _dbSet = _dbContext.Set<T>();
        }

        #endregion

        #region Method

        public async Task<T?> GetByIdAsync(int id)
        {

            return await _dbSet.FindAsync(id);
        }
        public async Task AddAsync(T entity)
        {
            await _dbSet.AddAsync(entity);

        }
        public void Update(T entity)
        {
            _dbSet.Update(entity);

        }
        public void Delete(T entity)
        {
            _dbSet.Remove(entity);

        }


        public IDbContextTransaction BeginTransaction()
        {
            return _dbContext.Database.BeginTransaction();
        }
        public void Commit()
        {
            _dbContext.Database.CommitTransaction();
        }
        public void RollBack()
        {
            _dbContext.Database.RollbackTransaction();
        }
        public async Task<bool> SaveChangesAsync()
        {
            return await _dbContext.SaveChangesAsync() > 0;
        }

        public async Task<IEnumerable<T>> GetListNoTrackingAsync()
        {
            var itmes = await _dbContext.Set<T>().AsNoTracking().ToListAsync();

            return (itmes != null ? itmes : Enumerable.Empty<T>());
        }

        #endregion


    }
}
