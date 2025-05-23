﻿using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public class StoreCategoryServices : IStoreCategoryServices
    {
        #region Fields
        readonly ManziliDbContext _db;
        readonly FileService _fileService;
        readonly DbSet<StoreCategory> _dbSet;
        #endregion

        #region Constructor
        public StoreCategoryServices( FileService fileService, ManziliDbContext db)
        {
            _fileService = fileService;
            _db = db;
            _dbSet = _db.Set<StoreCategory>();
        }
        #endregion

        #region Methods

        public async Task<OperationResult<IEnumerable<GetStoreCategoryDto>>> GetList()
        {
            var result = await _dbSet.Include("StoreCategoriesStores").AsNoTracking().ToListAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<GetStoreCategoryDto>>.Failure("No store categories found.");

            var storeCategoryDtos =
                result.Select(storeCategory => new GetStoreCategoryDto
                (
                    storeCategory.Id ,  storeCategory.Name,  storeCategory.Image,conunt : storeCategory.StoreCategoriesStores?.Count() ?? 0)
                );

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


                    await _dbSet.AddAsync(storeCategory);
                    await _db.SaveChangesAsync();
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



            var existingCategory = await _dbSet.FindAsync(id);
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
                    _dbSet.Update(existingCategory);
                    await _db.SaveChangesAsync();

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
            var existingCategory = await _dbSet.FindAsync(id);
            if (existingCategory == null)
                return OperationResult<bool>.Failure("Stoer Category not found.");


            try
            {
                var deleteReslut = await _fileService.Delete(existingCategory.Image);
                if (deleteReslut.IsSuccess)
                {
                    _dbSet.Remove(existingCategory);
                    await _db.SaveChangesAsync();

                    return OperationResult<bool>.Success(true);
                }
            }

            catch (Exception e)
            {

                return OperationResult<bool>.Failure(message: e.Message);

            }

            return OperationResult<bool>.Failure(message: "");


        }
        public async Task<OperationResult<IEnumerable<GetStoreCategoryIdAndName>>> GetLists()
        {
            var result = await _dbSet.Include("StoreCategoriesStores").AsNoTracking().ToListAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<GetStoreCategoryIdAndName>>.Failure("No store categories found.");

            var storeCategoryDtos =
                result.Select(storeCategory => new GetStoreCategoryIdAndName
                (
                    storeCategory.Id, storeCategory.Name
                    )
                );

            return OperationResult<IEnumerable<GetStoreCategoryIdAndName>>.Success(storeCategoryDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>> GetStoreSubCategoryIdAndNameAsync(int storeId, string storeCategoryName)
        {
            // Find the store category by name and store ID
            var storeCategory = await _db.StoreCategories
                .Include(sc => sc.ProductCategories)
                .FirstOrDefaultAsync(sc => sc.StoreCategoriesStores.Any(scs => scs.StoreId == storeId) && sc.Name == storeCategoryName);

            if (storeCategory == null)
                return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Failure("Store category not found.");

            // Map the product categories to the DTO
            var productCategories = storeCategory.ProductCategories?.Select(pc => new GetStoreSubCategoryIdAndName(pc.Id, pc.Name)).ToList();

            if (productCategories == null || !productCategories.Any())
                return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Failure("No product categories found for the specified store category.");

            return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Success(productCategories);
        }

        public async Task<OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>> GetStoreAllSubCategoryIdAndNameAsync(int storeId)
        {
            // Find the store categories by store ID
            var storeCategories = await _db.StoreCategories
                .Include(sc => sc.ProductCategories)
                .Where(sc => sc.StoreCategoriesStores.Any(scs => scs.StoreId == storeId))
                .ToListAsync();

            if (storeCategories == null || !storeCategories.Any())
                return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Failure("Store categories not found.");

            // Flatten the product categories from all store categories
            var productCategories = storeCategories
                .SelectMany(sc => sc.ProductCategories ?? new List<ProductCategory>())
                .Select(pc => new GetStoreSubCategoryIdAndName(pc.Id, pc.Name))
                .ToList();

            if (productCategories == null || !productCategories.Any())
                return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Failure("No product categories found for the specified store categories.");

            return OperationResult<IEnumerable<GetStoreSubCategoryIdAndName>>.Success(productCategories);
        }


        #endregion
    }

}

