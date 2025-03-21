using Manzili.Core.Dto.StoreFavoriteDto;

namespace Manzili.EF.Implementaion
{
    public interface IStoreFavoriteServices
    {
        Task<OperationResult<CreateStoreFavoriteDto>> Create(CreateStoreFavoriteDto createStoreFavoriteDto);
        Task<OperationResult<int>> Create(int userId, int storeId);

        Task<OperationResult<int>> ToggleFavorite(int userId, int storeId);
        Task<OperationResult<bool>> Delete(int id);
    }
}