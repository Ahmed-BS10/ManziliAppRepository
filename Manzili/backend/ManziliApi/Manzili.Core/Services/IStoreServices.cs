using Manzili.Core.Dto.StoreDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Manzili.Core.Services
{
    public interface IStoreServices
    {


        Task<OperationResult<IEnumerable<GetStoreDashbord>>> GetUnBlockeStores(int page, int pageSize);

        // Get
        Task<OperationResult<GetAnalysisStoreDto>> GetAnalysisStoreAsync(int storeId);
        Task<OperationResult<double>> GetTotalSalesAsync(int storeId, int month);
        Task<OperationResult<IEnumerable<CompletedOrderDto>>> GetLastTwoCompletedOrdersAsync(int storeId);
        Task<OperationResult<GetStoreDto>> GetByIdAsync(int id);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetUserFavoriteStores(int userId);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetLatestStoresAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetStoresWithCategory(int storeCategoryId);
        Task<OperationResult<GetInfoStoreDto>> GetInfoStore(int storeId);
        Task<OperationResult<IEnumerable<GetStoreDto>>> SearchStoreByNameAsync(string BusinessName);

        // Create
        Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto, List<int> categories);

        //Delete
        Task<OperationResult<Store>> DeleteAsync(int id);

        // Update 

        Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore, int storeId);
        Task<OperationResult<int>> UpdateToRateAsync(int storeId, int valueRate);
        Task<OperationResult<IEnumerable<GetStoreDashbord>>> GetBlockeStores(int pageNumber, int size);
        Task<OperationResult<bool>> MakeBloke(int Id);
        Task<OperationResult<bool>> UnBloke(int Id);

        Task<OperationResult<GetHomeDashbordDto>> GetHomeDashbord();
      
        Task<OperationResult<IEnumerable<GetProductGategory>>> GetProductGategoriesByStoreId(int storeId);










        Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInPastStatus(int storeId);
        Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInWorkStatus(int storeId);
        Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInNewStatus(int storeId);
        Task<OperationResult<IEnumerable<GetStoreOrders>>> GetAllOrders();

    }

}