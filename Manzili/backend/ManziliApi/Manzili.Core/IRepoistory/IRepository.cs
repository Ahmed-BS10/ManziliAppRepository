using Manzili.Core.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Repositories
{
    public interface IRepository<T> where T : class
    {
        Task<T> Find(Expression<Func<T, bool>> predicate, string[] includes = null);
        Task<IEnumerable<T>> GetListNoTrackingAsync();
        Task AddAsync(T entity);
        Task Update(T entity);
        Task Delete(T entity);
        Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate); 



        Task<bool> SaveChangesAsync();
        IDbContextTransaction BeginTransaction();
        void Commit();
        void RollBack();

    }
}



