using Manzili.Core.Repositories;
using Manzili.Core.Services;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Extension
{
    public static class ServiceRegistrationExtensions
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services)
        {



            services.AddScoped(typeof(UserServices));
            services.AddScoped(typeof(StoreServices));
            services.AddScoped(typeof(AuthenticationServices));
            services.AddScoped(typeof(FileService));
            services.AddScoped(typeof(CategoryServices));
            services.AddScoped(typeof(StoreCategoryServices));

            return services;
        }
    }
}
