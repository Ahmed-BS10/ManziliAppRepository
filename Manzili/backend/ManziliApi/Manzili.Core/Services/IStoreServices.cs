using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Manzili.Core.Services
{
    public interface IStoreServices
    {
        Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto , List<int> categories);
        Task<OperationResult<Store>> DeleteAsync(int id);
        Task<OperationResult<GetStoreDto>> GetByIdAsync(int id);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetUserFavoriteStores(int userId);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetLatestStoresAsync();
        Task<OperationResult<GetFullInfoStoreDto>> GetWithProductsAsync(int id);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetStoresWithCategory(string categoryName);
        
        Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore, int storeId);
        Task<OperationResult<int>> UpdateToRateAsync(int storeId, int valueRate);
    }
}