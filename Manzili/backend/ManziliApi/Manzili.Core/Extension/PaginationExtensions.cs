using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Extension
{
    public static class PaginationExtensions
    {
        public static IQueryable<T> ToPageination<T>(this IQueryable<T> query, int page, int pageSize)
        {
            if (page < 1)
                page = 1;

            if (pageSize < 1)
                pageSize = 20;

            return query.Skip((page - 1) * pageSize).Take(pageSize);
        }


    }
}
