using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace Manzili.Core.Services
{
    internal class Productservices : IProductServices
    {
       
        readonly ManziliDbContext _db;
        readonly DbSet<Product> _dbSet;  
        readonly FileService _fileService;



        public Productservices(ManziliDbContext db, FileService fileService)
        {
            _db = db;
            _dbSet = _db.Set<Product>();
            _fileService = fileService;
        }


        public async Task<OperationResult<IEnumerable<GetAllProduct>>> GetProductsByStoreAndCategoriesAsync(int storeId, int storeCategoryId, int productCategoryId)
        {
            var products = await _db.Set<Product>()
                .Include(im => im.Images)
                .Include(p => p.ProductCategory)
                .ThenInclude(scs => scs.StoreCategory)
                .Include(p => p.Store)



               .Where(p => p.StoreId == storeId && p.ProductCategoryId == productCategoryId && p.ProductCategory.StoreCategoryId == storeCategoryId)

                .ToListAsync();

            if (!products.Any())
            {
                return OperationResult<IEnumerable<GetAllProduct>>.Failure("No products found for the specified categories.");
            }

            var productDto = products.Select(x => new GetAllProduct
            {
                Id = x.Id,
                Name = x.Name,
                Description = x.Description,
                Price = x.Price,
                State = x.State,
                Rate = x.Rate,
                ImageUrl = x.Images.First().ImageUrl,

            }).ToList();
                
                
 

            return OperationResult<IEnumerable<GetAllProduct>>.Success(productDto, "Products retrieved successfully.");
        }
        public async Task<OperationResult<List<GetAllProduct>>> GetStoreProductsAsync(int storeId)
        {
            var store = await _db.Stores
                .Include(s => s.Products)
                .ThenInclude(p => p.Images)
                .FirstOrDefaultAsync(s => s.Id == storeId);

            if (store == null)
            {
                return OperationResult<List<GetAllProduct>>.Failure("Store not found.");
            }

            var productsDto = store.Products.Select(x => new GetAllProduct
            {
                Id = x.Id,
                Name = x.Name,
                Description = x.Description,
                Price = x.Price,
                State = x.State,
                Rate = 45,
                ImageUrl = x.Images.First().ImageUrl,
            }).ToList();


            return OperationResult<List<GetAllProduct>>.Success(productsDto, "Store products retrieved successfully.");
        }
        public async Task<OperationResult<string>> AddProductToStoreAsync(int storeId, CreateProductDto productDto)
        {
            var store = await _db.Stores
                .FirstOrDefaultAsync(s => s.Id == storeId);

            if (store == null)
            {
                return OperationResult<string>.Failure("Store not found");
            }

            if (productDto.ProductCategoryId <= 0)
            {
                return OperationResult<string>.Failure("Product category must be chosen.");

            }


            if (productDto.formImages != null)
            {
                foreach (var imageFrom in productDto.formImages)
                {
                    if (!ImageValidator.IsValidImage(imageFrom, out string errorMessage))
                        return OperationResult<string>.Failure(message: errorMessage);


                    try
                    {
                        string imagePath = await _fileService.UploadImageAsync("Product", imageFrom);
                        if (imagePath == "FailedToUploadImage")
                            return OperationResult<string>.Failure("Failed to upload image");


                        var product1 = new Product
                        {
                            Name = productDto.Name,
                            Description = productDto.Description,
                            Price = productDto.Price,
                            Quantity = productDto.Quantity,


                            ProductCategoryId = productDto.ProductCategoryId,
                            StoreId = storeId,

                            Images = new List<Image>
                            {
                                new Image
                                {
                                    ImageUrl = imagePath
                                }
                            }

                        };


                        await _dbSet.AddAsync(product1);
                        await _db.SaveChangesAsync();
                        return OperationResult<string>.Success("Add Successed");
                    }

                    catch (Exception ex)
                    {
                        return OperationResult<string>.Failure(message: ex.Message);
                    }




                }


            }


            return OperationResult<string>.Failure("Product not added successfully");
        }
        public async Task<OperationResult<GteFullInfoProdcut>> GetProductByIdAsync(int productId)
        {
            var product = await _db.Set<Product>()
                .Include(s => s.Store)
                .Include(im => im.Images)
                .FirstOrDefaultAsync(p => p.Id == productId);

            if (product == null)
            {
                return OperationResult<GteFullInfoProdcut>.Failure("Product not found.");
            }

            var productDto = new GteFullInfoProdcut
            {
                Id = product.Id,
                Name = product.Name,
                Description = product.Description,
                Price = product.Price,
                State = product.State,
                Quantity = product.Quantity,
                Rate = product.Rate,
                StoreName = product.Store.BusinessName,
                images = product.Images.Select(i => i.ImageUrl).ToList() ?? [],
                StoreImage = product.Store.ImageUrl ?? "/Profile/383ba157cb9f4367b67f7baeea98097d.jpg",
            };

            return OperationResult<GteFullInfoProdcut>.Success(productDto, "Product retrieved successfully.");
        }
        public async Task<OperationResult<IEnumerable<GetAllProduct>>> SearchProductByNameInStore(int storeId, string name)
        {
            var store = await _db.Stores
            .Include(s => s.Products)
            .ThenInclude(p => p.Images)
            .FirstOrDefaultAsync(s => s.Id == storeId);

            if (store is null)
                return OperationResult<IEnumerable<GetAllProduct>>.Failure("Store not found.");

            var productsDto = store.Products
                .Where(x => x.Name.Contains(name))
                .Select(x => new GetAllProduct
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    Price = x.Price,
                    State = x.State,
                    Rate = x.Rate,
                    ImageUrl = x.Images?.FirstOrDefault()?.ImageUrl ?? string.Empty
                }).ToList();

            if (!productsDto.Any())
                return OperationResult<IEnumerable<GetAllProduct>>.Failure($"not {name} product in store {storeId}");

            return OperationResult<IEnumerable<GetAllProduct>>.Success(productsDto, "Store products retrieved successfully.");

        }
        public async Task<OperationResult<IEnumerable<GetAllProduct>>> GetProductsByStoreAndProductCategoriesAsync(int storeId, int productCategoryId)
        {
            // Query the database for products matching the storeId and productCategoryId
            var products = await _dbSet
                .Include(p => p.Images) // Include related images
                .Where(p => p.StoreId == storeId && p.ProductCategoryId == productCategoryId)
                .ToListAsync();

            // Check if no products were found
            if (!products.Any())
            {
                return OperationResult<IEnumerable<GetAllProduct>>.Failure("No products found for the specified store and product category.");
            }

            // Map the products to the GetAllProduct DTO
            var productDtos = products.Select(p => new GetAllProduct
            {
                Id = p.Id,
                Name = p.Name,
                Description = p.Description,
                Price = p.Price,
                State = p.State,
                Rate = p.Rate,
                ImageUrl = p.Images?.FirstOrDefault()?.ImageUrl ?? string.Empty
            }).ToList();

            // Return the result
            return OperationResult<IEnumerable<GetAllProduct>>.Success(productDtos, "Products retrieved successfully.");
        }

    }

}
