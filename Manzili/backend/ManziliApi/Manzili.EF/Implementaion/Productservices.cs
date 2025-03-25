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
    internal class Productservices : IProductservices
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
                .Include(p => p.Store)
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
                StoreName = product.Store.BusinessName,
                images = product.Images.Select(i => i.ImageUrl).ToList()
            };

            return OperationResult<GteFullInfoProdcut>.Success(productDto, "Product retrieved successfully.");
        }

     

        

      

        //public async Task<OperationResult<IEnumerable<GetStoreProductDto>>> GetStoreProduct(int storeId, string storeCategory, string productCategory)
        //{
        //    var products = await _dbSet
        //        .Include(p => p.ProductCategory)
        //        .ThenInclude(pc => pc.StoreCategory)
        //        .Where(p => p.StoreId == storeId &&
        //                    p.ProductCategory.StoreCategory.Name == storeCategory &&
        //                    p.ProductCategory.Name == productCategory)
        //        .AsNoTracking()
        //        .ToListAsync();

        //    // Convert products to DTO
        //    var result = products.Select(p => new GetStoreProductDto(
        //        p.Id,                         // productId
        //        p.Name,                       // name
        //        p.ImageUrls.FirstOrDefault(),                  // imageUrls
        //        p.Description,                // description
        //        p.Price,                      // price
        //        p.State,                      // states
        //        new List<string> { p.ProductCategory.Name } // List containing the category name
        //    ));

        //    return OperationResult<IEnumerable<GetStoreProductDto>>.Success(result);
        //}


        //public async Task<IEnumerable<Product>> GetAllProductsAsync()
        //{
        //    return await _productRepository.GetListNoTrackingAsync();
        //}

        //public async Task<Product> GetProductByIdAsync(int productId)
        //{
        //    var product = await _productRepository.Find(p => p.ProductId == productId);
        //    if (product == null)
        //    {
        //        throw new KeyNotFoundException($"Product with ID {productId} not found.");
        //    }
        //    return product;
        //}

        //public async Task<Product> UpdateProductAsync(Product product)
        //{
        //    if (product == null)
        //    {
        //        throw new ArgumentNullException(nameof(product), "Product cannot be null.");
        //    }

        //    var existingProduct = await _productRepository.Find(p => p.ProductId == product.ProductId);
        //    if (existingProduct == null)
        //    {
        //        throw new KeyNotFoundException($"Product with ID {product.ProductId} not found.");
        //    }


        //    existingProduct.Name = product.Name;
        //    existingProduct.Description = product.Description;
        //    existingProduct.Price = product.Price;
        //    existingProduct.CategoryId = product.CategoryId;
        //    existingProduct.StoreId = product.StoreId;
        //    existingProduct.ImageUrl = product.ImageUrl;
        //    existingProduct.Discount = product.Discount;
        //    existingProduct.Quantity = product.Quantity;

        //    await _productRepository.Update(existingProduct);
        //    await _productRepository.SaveChangesAsync();

        //    return existingProduct;
        //}

        //public async Task DeleteProductAsync(int productId)
        //{
        //    var product = await _productRepository.Find(p => p.ProductId == productId);
        //    if (product == null)
        //    {
        //        throw new KeyNotFoundException($"Product with ID {productId} not found.");
        //    }

        //    await _productRepository.Delete(product);
        //    await _productRepository.SaveChangesAsync();
        //}

        //public async Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId)
        //{
        //    var products = await _productRepository.GetListNoTrackingAsync();
        //    var filteredProducts = products.Where(p => p.CategoryId == categoryId).ToList();

        //    if (filteredProducts == null || !filteredProducts.Any())
        //    {
        //        throw new KeyNotFoundException($"No products found for Category ID {categoryId}.");
        //    }

        //    return filteredProducts;
        //}

        //public async Task<IEnumerable<Product>> GetProductsByStoreAsync(int storeId)
        //{
        //    var store = await _storeRepository.Find(s => s.Id == storeId);
        //    if (store == null)
        //    {
        //        throw new KeyNotFoundException($"Store with ID {storeId} not found.");
        //    }

        //    var products = await _productRepository.GetListNoTrackingAsync();
        //    var filteredProducts = products.Where(p => p.StoreId == storeId).ToList();

        //    if (!filteredProducts.Any())
        //    {
        //        throw new KeyNotFoundException($"No products found for Store ID {storeId}.");
        //    }

        //    return filteredProducts;
        //}

        //public async Task<IEnumerable<Product>> SearchProductsAsync(string searchTerm)
        //{
        //    if (string.IsNullOrEmpty(searchTerm))
        //    {
        //        throw new ArgumentException("Search term cannot be null or empty.", nameof(searchTerm));
        //    }

        //    var products = await _productRepository.GetListNoTrackingAsync();
        //    var filteredProducts = products.Where(p => p.Name.Contains(searchTerm, StringComparison.OrdinalIgnoreCase)).ToList();

        //    if (!filteredProducts.Any())
        //    {
        //        throw new KeyNotFoundException($"No products found for the search term: {searchTerm}");
        //    }

        //    return filteredProducts;
        //}

        //#endregion
    }
  
}
