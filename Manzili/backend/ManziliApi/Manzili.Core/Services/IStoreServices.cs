using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;

namespace Manzili.Core.Services
{
    public interface IStoreServices
    {
        Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto);
        Task<OperationResult<Store>> DeleteAsync(int id);
        Task<OperationResult<GetStoreDto>> GetByIdAsync(int id);
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync();
        Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize);
        Task<OperationResult<GetFullInfoStoreDto>> GetWithProductsAsync(int id);
        Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore, int storeId);
    }
}