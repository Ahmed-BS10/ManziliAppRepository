using Manzili.Core.Dto.StoreCategoryDto;

namespace Manzili.Core.Services
{
    public interface IStoreCategoryServices
    {
        Task<OperationResult<CreateStoreCatagoryDto>> Create(CreateStoreCatagoryDto createStoreCategoryDto);
        Task<OperationResult<bool>> Delete(int id);
        Task<OperationResult<IEnumerable<GetStoreCategoryDto>>> GetList();
        Task<OperationResult<UpdateStoreCatagoryDto>> Update(int id, UpdateStoreCatagoryDto updateStoreCatagoryDto);
        Task<OperationResult<IEnumerable<string>>> GetProductCategoriesByStoreCategoryAsync(int storeCategoryId);
    }
}