
using Manzili.Core.Services;
using Manzili.EF.Implementaion;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.Extension
{
    public static class ServiceRegistrationExtensions
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection services)
        {

            services.AddScoped(typeof(UserServices));
            services.AddScoped(typeof(IStoreServices) , typeof(StoreServices));
            services.AddScoped(typeof(IAuthenticationServices) , typeof(AuthenticationServices));
            services.AddScoped(typeof(IFileService) , typeof(FileService));
            services.AddScoped(typeof(ICategoryServices) , typeof (CategoryServices));
            services.AddScoped(typeof(IStoreCategoryServices), typeof(StoreCategoryServices));
            services.AddScoped(typeof(StoreRateServices));

            return services;
        }
    }
}








public static class ServiceRegistrationExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {



        services.AddScoped(typeof(UserServices));
        services.AddScoped(typeof(StoreServices));
        services.AddScoped(typeof(AuthenticationServices));
        services.AddScoped(typeof(FileService));
        services.AddScoped(typeof(CategoryServices));

        return services;
    }
}