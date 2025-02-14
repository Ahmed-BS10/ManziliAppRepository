using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public class StoreCategoryServices
    {
        #region Fields
        readonly IRepository<StoreCategory> _storecategoryRepository;
        readonly FileService _fileService;
        #endregion

        #region Constructor
        public StoreCategoryServices(IRepository<StoreCategory> storecategoryRepository, FileService fileService)
        {
            _storecategoryRepository = storecategoryRepository;
            _fileService = fileService;
        }
        #endregion

        #region Methods

        public async Task<OperationResult<IEnumerable<GetStoreCategoryDto>>> GetList()
        {
            var result = await _storecategoryRepository.GetListNoTrackingAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<GetStoreCategoryDto>>.Failure("No store categories found.");

            var storeCategoryDtos = result.Select(storeCategory => new GetStoreCategoryDto(Id: storeCategory.Id, Name: storeCategory.Name, ImageUrl: storeCategory.Image, conunt: 0));

            return OperationResult<IEnumerable<GetStoreCategoryDto>>.Success(storeCategoryDtos);
        }
        public async Task<OperationResult<CreateStoreCatagoryDto>> Create(CreateStoreCatagoryDto createStoreCategoryDto)
        {
            if (createStoreCategoryDto == null)
                return OperationResult<CreateStoreCatagoryDto>.Failure(message: "Category cannot be null.");


            if (createStoreCategoryDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(createStoreCategoryDto.Image, out string errorMessage))
                    return OperationResult<CreateStoreCatagoryDto>.Failure(message: errorMessage);


                try
                {
                    string imagePath = await _fileService.UploadImageAsync("StoreCategory", createStoreCategoryDto.Image);
                    if (imagePath == "FailedToUploadImage")
                        return OperationResult<CreateStoreCatagoryDto>.Failure("Failed to upload image");


                    var storeCategory = new StoreCategory
                    {
                        Name = createStoreCategoryDto.Name,
                        Image = imagePath
                    };


                    await _storecategoryRepository.AddAsync(storeCategory);

                    return OperationResult<CreateStoreCatagoryDto>.Success(createStoreCategoryDto);
                }

                catch (Exception ex)
                {
                    return OperationResult<CreateStoreCatagoryDto>.Failure(message: ex.Message);
                }

               

            }

            return OperationResult<CreateStoreCatagoryDto>.Failure(message: "Invalid Add Store Category");


        }
        public async Task<OperationResult<UpdateStoreCatagoryDto>> Update(int id, UpdateStoreCatagoryDto updateStoreCatagoryDto)
        {
            if (updateStoreCatagoryDto == null)
                return OperationResult<UpdateStoreCatagoryDto>.Failure("Invalid data.");



            var existingCategory = await _storecategoryRepository.Find(x => x.Id == id);
            if (existingCategory == null)
                return OperationResult<UpdateStoreCatagoryDto>.Failure(" Store Category not found.");
            existingCategory.Name = updateStoreCatagoryDto.Name ?? existingCategory.Name;




            if (updateStoreCatagoryDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(updateStoreCatagoryDto.Image, out string errorMessage))
                    return OperationResult<UpdateStoreCatagoryDto>.Failure(errorMessage);


                try
                {
                    string imagePath = await _fileService.UploadImageAsync("Category", updateStoreCatagoryDto.Image);
                    if (imagePath == "FailedToUploadImage")
                        return OperationResult<UpdateStoreCatagoryDto>.Failure("Failed to upload image");

                    var deleteReslut = await _fileService.Delete(existingCategory.Image);
                   
                    existingCategory.Image = imagePath;
                    await _storecategoryRepository.Update(existingCategory);
                    return OperationResult<UpdateStoreCatagoryDto>.Success(updateStoreCatagoryDto);

                    
                }

                catch (Exception ex)
                {
                    return OperationResult<UpdateStoreCatagoryDto>.Failure(message: ex.Message);

                }



            }

            return OperationResult<UpdateStoreCatagoryDto>.Failure(message: "Image cannt be empty");

        }
        public async Task<OperationResult<bool>> Delete(int id)
        {
            var existingCategory = await _storecategoryRepository.Find(x => x.Id == id);
            if (existingCategory == null)
                return OperationResult<bool>.Failure("Stoer Category not found.");


            try
            {
                var deleteReslut = await _fileService.Delete(existingCategory.Image);
                if (deleteReslut.IsSuccess)
                {
                    await _storecategoryRepository.Delete(existingCategory);
                    return OperationResult<bool>.Success(true);
                }
            }

            catch (Exception e)
            {

                return OperationResult<bool>.Failure(message: e.Message);

            }

            return OperationResult<bool>.Failure(message: "");


        }

        #endregion
    }

}

