using Manzili.Core.Constant;
using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace Manzili.Core.Services
{
    public class CategoryServices
    {

        #region Fields
        readonly IRepository<Category> _categoryRepository;
        readonly FileService _fileService;
        #endregion

        #region Constructor
        public CategoryServices(IRepository<Category> categoryRepository, FileService fileService)
        {
            _categoryRepository = categoryRepository;
            _fileService = fileService;
        }
        #endregion

        #region Methods

        public async Task<OperationResult<IEnumerable<CatagoryGetDto>>> GetList()
        {
            var result = await _categoryRepository.GetListNoTrackingAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<CatagoryGetDto>>.Failure("No categories found.");

            var categoryDtos = result.Select(category => new CatagoryGetDto
            {
                Id = category.CategoryId,
                Name = category.Name,
                Image = $"{Constants.baseurl}{category.Image}"
            });

            return OperationResult<IEnumerable<CatagoryGetDto>>.Success(categoryDtos);
        }
        public async Task<OperationResult<CatagoryCreateDto>> Create(CatagoryCreateDto catagoryCreateDto)
        {
            if (catagoryCreateDto == null)
                return OperationResult<CatagoryCreateDto>.Failure(message: "Category cannot be null.");


            if (catagoryCreateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryCreateDto.Image, out string errorMessage))
                    return OperationResult<CatagoryCreateDto>.Failure(message: errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryCreateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<CatagoryCreateDto>.Failure("Failed to upload image");


                var category = new Category
                {
                    Name = catagoryCreateDto.Name,
                    Image = imagePath
                };


                await _categoryRepository.AddAsync(category);

                return OperationResult<CatagoryCreateDto>.Success(catagoryCreateDto);


            }

            return OperationResult<CatagoryCreateDto>.Failure(message : "Image cannt be null");




        }
        public async Task<OperationResult<CatagoryUpdateDto>> Update(int id, CatagoryUpdateDto catagoryUpdateDto)
        {
            if (catagoryUpdateDto == null)
                return OperationResult<CatagoryUpdateDto>.Failure("Invalid data.");



            var existingCategory = await _categoryRepository.Find(x => x.CategoryId == id);
            if (existingCategory == null)
                return OperationResult<CatagoryUpdateDto>.Failure("Category not found.");

            existingCategory.Name = catagoryUpdateDto.Name ?? existingCategory.Name;




            if (catagoryUpdateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryUpdateDto.Image, out string errorMessage))
                    return OperationResult<CatagoryUpdateDto>.Failure(errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryUpdateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<CatagoryUpdateDto>.Failure("Failed to upload image");

                var deleteReslut =  await _fileService.Delete(existingCategory.Image);
                if(deleteReslut.IsSuccess)
                {
                    existingCategory.Image = imagePath;
                    await _categoryRepository.Update(existingCategory);
                    return OperationResult<CatagoryUpdateDto>.Success(catagoryUpdateDto);

                }

                return OperationResult<CatagoryUpdateDto>.Failure(message : deleteReslut.Message);
            }

            return OperationResult<CatagoryUpdateDto>.Failure(message : "Image cannt be empty");

        }



        #endregion


    }
}
