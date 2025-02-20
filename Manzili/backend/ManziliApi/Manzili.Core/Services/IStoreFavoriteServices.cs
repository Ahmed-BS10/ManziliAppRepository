using Manzili.Core.Dto.StoreFavoriteDto;

namespace Manzili.EF.Implementaion
{
    public interface IStoreFavoriteServices
    {
        Task<OperationResult<CreateStoreFavoriteDto>> Create(CreateStoreFavoriteDto createStoreFavoriteDto);
        Task<OperationResult<bool>> Delete(int id);
    }
}