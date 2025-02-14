using Manzili.Core.Constant;
using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
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
    public class CategoryServices : ICategoryServices
    {

        #region Fields
        readonly ManziliDbContext _db;
        readonly FileService _fileService;
        readonly DbSet<Category> _dbSet;
        #endregion

        #region Constructor
        public CategoryServices( FileService fileService, ManziliDbContext db)
        {
            _fileService = fileService;
            _db = db;
            _dbSet = _db.Set<Category>();
        }
        #endregion

        #region Methods

        public async Task<OperationResult<IEnumerable<GetCatagoryDto>>> GetList()
        {
            var result = await _dbSet.AsNoTracking().ToListAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<GetCatagoryDto>>.Failure("No categories found.");

            var categoryDtos = result.Select(category => new GetCatagoryDto
            {
                Id = category.CategoryId,
                Name = category.Name,
                Image = $"{Constants.baseurl}{category.Image}"
            });

            return OperationResult<IEnumerable<GetCatagoryDto>>.Success(categoryDtos);
        }
        public async Task<OperationResult<CreateCatagoryDto>> Create(CreateCatagoryDto catagoryCreateDto)
        {
            if (catagoryCreateDto == null)
                return OperationResult<CreateCatagoryDto>.Failure(message: "Category cannot be null.");


            if (catagoryCreateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryCreateDto.Image, out string errorMessage))
                    return OperationResult<CreateCatagoryDto>.Failure(message: errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryCreateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<CreateCatagoryDto>.Failure("Failed to upload image");


                var category = new Category
                {
                    Name = catagoryCreateDto.Name,
                    Image = imagePath
                };


                await _dbSet.AddAsync(category);

                return OperationResult<CreateCatagoryDto>.Success(catagoryCreateDto);


            }

            return OperationResult<CreateCatagoryDto>.Failure(message: "Image cannt be null");




        }
        public async Task<OperationResult<UpdateCatagoryDto>> Update(int id, UpdateCatagoryDto catagoryUpdateDto)
        {
            if (catagoryUpdateDto == null)
                return OperationResult<UpdateCatagoryDto>.Failure("Invalid data.");



            var existingCategory = await _dbSet.FindAsync(id);
            if (existingCategory == null)
                return OperationResult<UpdateCatagoryDto>.Failure("Category not found.");

            existingCategory.Name = catagoryUpdateDto.Name ?? existingCategory.Name;




            if (catagoryUpdateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryUpdateDto.Image, out string errorMessage))
                    return OperationResult<UpdateCatagoryDto>.Failure(errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryUpdateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<UpdateCatagoryDto>.Failure("Failed to upload image");

                var deleteReslut = await _fileService.Delete(existingCategory.Image);
                if (deleteReslut.IsSuccess)
                {
                    existingCategory.Image = imagePath;
                    _dbSet.Update(existingCategory);
                    return OperationResult<UpdateCatagoryDto>.Success(catagoryUpdateDto);

                }

                return OperationResult<UpdateCatagoryDto>.Failure(message: deleteReslut.Message);
            }

            return OperationResult<UpdateCatagoryDto>.Failure(message: "Image cannt be empty");

        }
        public async Task<OperationResult<bool>> Delete(int id)
        {
            var existingCategory = await _dbSet.FindAsync(id);
            if (existingCategory == null)
                return OperationResult<bool>.Failure("Category not found.");


            try
            {
                var deleteReslut = await _fileService.Delete(existingCategory.Image);
                if (deleteReslut.IsSuccess)
                {
                    _dbSet.Remove(existingCategory);
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
