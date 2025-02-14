using Manzili.Core.Dto.CatagoryDto;

namespace Manzili.Core.Services
{
    public interface ICategoryServices
    {
        Task<OperationResult<CreateCatagoryDto>> Create(CreateCatagoryDto catagoryCreateDto);
        Task<OperationResult<bool>> Delete(int id);
        Task<OperationResult<IEnumerable<GetCatagoryDto>>> GetList();
        Task<OperationResult<UpdateCatagoryDto>> Update(int id, UpdateCatagoryDto catagoryUpdateDto);
    }
}