using Manzili.Core.Dto.StoreDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Manzili.Core.Services
{
    public interface IStoreServices
    {


        // Get

        Task<OperationResult<GetAnalysisStoreDto>> GetAnalysisStoreAsync(int storeId);
        Task<OperationResult<GetStoreDto>> GetByIdAsync(int id);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetUserFavoriteStores(int userId);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetLatestStoresAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetStoresWithCategory(int storeCategoryId);
        Task<OperationResult<GetInfoStoreDto>> GetInfoStore(int storeId);
        Task<OperationResult<IEnumerable<GetStoreDto>>> SearchStoreByNameAsync(string BusinessName);

        // Create
        Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto , List<int> categories);

        //Delete
        Task<OperationResult<Store>> DeleteAsync(int id);
       
        // Update 

        Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore, int storeId);
        Task<OperationResult<int>> UpdateToRateAsync(int storeId, int valueRate);
    }
}