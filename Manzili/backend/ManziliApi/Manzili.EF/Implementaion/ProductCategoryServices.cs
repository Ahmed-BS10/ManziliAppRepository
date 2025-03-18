using Manzili.Core.Constant;
using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Dto.ProductCatagoryDto;
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
    public class ProductCategoryServices : IProductCategoryServices
    {

        #region Fields
        readonly ManziliDbContext _db;
        readonly FileService _fileService;
        readonly DbSet<ProductCategory> _dbSet;
        #endregion

        #region Constructor
        public ProductCategoryServices( FileService fileService, ManziliDbContext db)
        {
            _fileService = fileService;
            _db = db;
            _dbSet = _db.Set<ProductCategory>();
        }
        #endregion

        #region Methods

        public async Task<OperationResult<IEnumerable<GetProductCatagoryDto>>> GetList()
        {
            var result = await _dbSet.AsNoTracking().ToListAsync();

            if (result == null || !result.Any())
                return OperationResult<IEnumerable<GetProductCatagoryDto>>.Failure("No categories found.");

            var categoryDtos = result.Select(category => new GetProductCatagoryDto
            {
                Id = category.Id,
                Name = category.Name,
                Image = $"{Constants.baseurl}{category.Image}",
                StoreCategoryId = category.StoreCategoryId,
            });

            return OperationResult<IEnumerable<GetProductCatagoryDto>>.Success(categoryDtos);
        }
        public async Task<OperationResult<CreateProductCatagoryDto>> Create(CreateProductCatagoryDto createProductCatagoryDto)
        {
            if (createProductCatagoryDto == null)
                return OperationResult<CreateProductCatagoryDto>.Failure(message: "Category cannot be null.");


            if (createProductCatagoryDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(createProductCatagoryDto.Image, out string errorMessage))
                    return OperationResult<CreateProductCatagoryDto>.Failure(message: errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", createProductCatagoryDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<CreateProductCatagoryDto>.Failure("Failed to upload image");


                var category = new ProductCategory
                {
                    Name = createProductCatagoryDto.Name,
                    Image = imagePath,
                    StoreCategoryId = createProductCatagoryDto.StoreCategoryId
                };


                await _dbSet.AddAsync(category);
                await _db.SaveChangesAsync();

                return OperationResult<CreateProductCatagoryDto>.Success(createProductCatagoryDto);


            }

            return OperationResult<CreateProductCatagoryDto>.Failure(message: "Image cannt be null");




        }
        public async Task<OperationResult<UpdateProdcutCatagoryDto>> Update(int id, UpdateProdcutCatagoryDto catagoryUpdateDto)
        {
            if (catagoryUpdateDto == null)
                return OperationResult<UpdateProdcutCatagoryDto>.Failure("Invalid data.");



            var existingCategory = await _dbSet.FindAsync(id);
            if (existingCategory == null)
                return OperationResult<UpdateProdcutCatagoryDto>.Failure("Category not found.");

            existingCategory.Name = catagoryUpdateDto.Name ?? existingCategory.Name;




            if (catagoryUpdateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryUpdateDto.Image, out string errorMessage))
                    return OperationResult<UpdateProdcutCatagoryDto>.Failure(errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryUpdateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<UpdateProdcutCatagoryDto>.Failure("Failed to upload image");

                var deleteReslut = await _fileService.Delete(existingCategory.Image);
                if (deleteReslut.IsSuccess)
                {
                    existingCategory.Image = imagePath;
                    _dbSet.Update(existingCategory);
                    return OperationResult<UpdateProdcutCatagoryDto>.Success(catagoryUpdateDto);

                }

                return OperationResult<UpdateProdcutCatagoryDto>.Failure(message: deleteReslut.Message);
            }

            return OperationResult<UpdateProdcutCatagoryDto>.Failure(message: "Image cannt be empty");

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
        public async Task<OperationResult<IEnumerable<string>>> GetProductCategoriesByStoreCategoryAsync(int storeCategoryId)
        {
            var productCategories = await _db.ProductCategories
                .Where(pc => pc.StoreCategoryId == storeCategoryId)
                .Select(pc => pc.Name)
                .Distinct()
                .ToListAsync();

            if (!productCategories.Any())
            {
                return OperationResult<IEnumerable<string>>.Failure("No product categories found for this store category.");
            }

            return OperationResult<IEnumerable<string>>.Success(productCategories, "Product categories retrieved successfully.");
        }

        public async Task<OperationResult<List<string>>> GetStoreCategoriesByStoreIdAsync(int storeId)
        {
            var store = await _db.Set<Store>()
                .Include(s => s.storeCategoryStores)
                .ThenInclude(scs => scs.StoreCategory)
                .FirstOrDefaultAsync(s => s.Id == storeId);

            if (store == null || store.storeCategoryStores == null || !store.storeCategoryStores.Any())
            {
                return OperationResult<List<string>>.Failure("Store or associated store categories not found.");
            }

            var storeCategories = store.storeCategoryStores
                .Select(scs => scs.StoreCategory?.Name)
                .Where(name => name != null)
                .ToList();

            return OperationResult<List<string>>.Success(storeCategories, "Store categories retrieved successfully.");
        }



        #endregion


    }
}
