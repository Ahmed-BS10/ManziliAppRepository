using Manzili.Core.Extension;
using Manzili.Core.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.RepoistpryImpelemation
{
    public class Repository<T> : IRepository<T> where T : class
    {

        #region Field
        protected readonly ManziliDbContext _dbContext;
        protected readonly DbSet<T> _dbSet;

        #endregion

        #region Constructor

        public Repository(ManziliDbContext dbContetx)
        {
            _dbContext = dbContetx;
            _dbSet = _dbContext.Set<T>();
        }

        #endregion

        #region Method
        public async Task<T> Find(Expression<Func<T, bool>> predicate, string[] includes = null)
        {
            IQueryable<T> values = _dbContext.Set<T>();

            if (includes != null)
            {
                foreach (var include in includes)
                {
                    values = values.Include(include);
                }
            }
            return await values.SingleOrDefaultAsync(predicate);
        }
        public async Task AddAsync(T entity)
        {
            await _dbSet.AddAsync(entity);
            await _dbContext.SaveChangesAsync();

        }
        public async Task Update(T entity)
        {
            _dbSet.Update(entity);
           await _dbContext.SaveChangesAsync();


        }
        public async Task Delete(T entity)
        {
            _dbSet.Remove(entity);
            await _dbContext.SaveChangesAsync();


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
        public async Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate)
        {
            return await _dbSet.AnyAsync(predicate); // يستخدم AnyAsync للتحقق من وجود سجل
        }
        #endregion

    }
}
