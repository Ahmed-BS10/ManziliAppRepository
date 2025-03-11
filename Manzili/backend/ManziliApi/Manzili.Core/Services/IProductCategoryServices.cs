using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.ProductCatagoryDto;
using Manzili.Core.Dto.StoreCategoryDto;

namespace Manzili.Core.Services
{
    public interface IProductCategoryServices
    {
        Task<OperationResult<CreateProductCatagoryDto>> Create(CreateProductCatagoryDto createProductCatagoryDto);
        Task<OperationResult<bool>> Delete(int id);
        Task<OperationResult<IEnumerable<GetProductCatagoryDto>>> GetList();
        Task<OperationResult<UpdateProdcutCatagoryDto>> Update(int id, UpdateProdcutCatagoryDto updateProdcutCatagoryDto);
        Task<OperationResult<IEnumerable<string>>> GetProductCategoriesByStoreCategoryAsync(int storeCategoryId);
       

    }
}
