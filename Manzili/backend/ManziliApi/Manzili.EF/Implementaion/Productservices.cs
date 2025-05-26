using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
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


        public async Task<OperationResult<List<GetAllProduct>>> GetStoreProductsAsync(int storeId)
        {
            // Ensure null safety and proper async handling
            var products = await _db.Products
                .Where(x => x.StoreId == storeId)
                .Select(x => new GetAllProduct
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description ?? string.Empty, // Fix CS8601: Handle possible null values
                    Price = x.Price,
                    State = x.State,
                    Rate = 45,
                    ImageUrl = x.Images.Count > 0 ? x.Images.FirstOrDefault().ImageUrl : string.Empty // Fix CS8072: Replace null-propagating operator
                })
                .ToListAsync(); // Fix CS1061: Ensure async method is awaited properly

            // Fix CS0103: Correctly use the 'products' variable
            return OperationResult<List<GetAllProduct>>.Success(products, "Store products retrieved successfully.");
        }
        public async Task<OperationResult<List<GetAllProduct>>> SerchByProductName(string name , int storeId)
        {
            // Ensure null safety and proper async handling
            var products = await _db.Products
                .Where(x => x.StoreId == storeId && Microsoft.EntityFrameworkCore.EF.Functions.Like(x.Name, $"%{name}%"))
                .Select(x => new GetAllProduct
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description ?? string.Empty, // Fix CS8601: Handle possible null values
                    Price = x.Price,
                    State = x.State,
                    Rate = 45,
                    ImageUrl = x.Images.Count > 0 ? x.Images.FirstOrDefault().ImageUrl : string.Empty // Fix CS8072: Replace null-propagating operator
                })
                .ToListAsync(); // Fix CS1061: Ensure async method is awaited properly

            // Fix CS0103: Correctly use the 'products' variable
            return OperationResult<List<GetAllProduct>>.Success(products, "Store products retrieved successfully.");
        }




        public async Task<OperationResult<List<GetAllProduct>>> GetStoreProductsAsync(int storeId, int productGategoryId)
        {
            // Ensure null safety and proper async handling
            var products = await _db.Products
                .Where(x => x.StoreId == storeId && x.ProductCategoryId == productGategoryId)
                .Select(x => new GetAllProduct
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description ?? string.Empty, // Fix CS8601: Handle possible null values
                    Price = x.Price,
                    State = x.State,
                    Rate = 45,
                    ImageUrl = x.Images.Count > 0 ? x.Images.FirstOrDefault().ImageUrl : string.Empty // Fix CS8072: Replace null-propagating operator
                })
                .ToListAsync(); // Fix CS1061: Ensure async method is awaited properly

            // Fix CS0103: Correctly use the 'products' variable
            return OperationResult<List<GetAllProduct>>.Success(products, "Store products retrieved successfully.");
        }
        public async Task<OperationResult<GteFullInfoProdcut>> GetProductByIdAsync(int productId)
        {
            var product = await _db.Set<Product>()
                .Include(s => s.Store)
                .Include(im => im.Images)
                .Include(ra => ra.ProductRatings)
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
                Rate = product.ProductRatings != null && product.ProductRatings.Any()
                    ? product.ProductRatings.Average(x => x.RatingValue)
                    : 0, // Fix CS0029, CS1003, CS0029, CS0747, CS8604
                StoreName = product.Store?.UserName ?? "Unknown", // Fix CS8602
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
                ImageUrl = x.Images.Count > 0 ? x.Images.First().ImageUrl : string.Empty // Fix CS8072: Replace null-propagating operator
            }).ToList();

            return OperationResult<IEnumerable<GetAllProduct>>.Success(productDto, "Products retrieved successfully.");
        }
        public async Task<OperationResult<bool>> DeleteProductAsync(int productId)
        {
            var product = await _db.Products.FindAsync(productId);
            if (product == null)
                return OperationResult<bool>.Failure("Product not found.");

            _db.Products.Remove(product);
            await _db.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Product deleted successfully.");
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

            if (productDto.formImages != null && productDto.formImages.Any())
            {
                var imageList = new List<Image>();

                foreach (var imageFrom in productDto.formImages)
                {
                    if (!ImageValidator.IsValidImage(imageFrom, out string errorMessage))
                        return OperationResult<string>.Failure(message: errorMessage);

                    try
                    {
                        string imagePath = await _fileService.UploadImageAsync("Product", imageFrom);
                        if (imagePath == "FailedToUploadImage")
                            return OperationResult<string>.Failure("Failed to upload image");

                        imageList.Add(new Image
                        {
                            ImageUrl = imagePath
                        });
                    }
                    catch (Exception ex)
                    {
                        return OperationResult<string>.Failure(message: ex.Message);
                    }
                }

                var product1 = new Product
                {
                    Name = productDto.Name,
                    Description = productDto.Description,
                    Price = productDto.Price,
                    Quantity = productDto.Quantity,
                    ProductCategoryId = productDto.ProductCategoryId,
                    StoreId = storeId,
                    Images = imageList
                };

                await _dbSet.AddAsync(product1);
                await _db.SaveChangesAsync();
                return OperationResult<string>.Success("Add Successed");
            }

            return OperationResult<string>.Failure("Product not added successfully");
        }
        public async Task<OperationResult<IEnumerable<GetProductRatingsAndCommentsDto>>> GetAllRatingsAndCommentsAsync(int productId)
        {
            // Fetch the product along with its comments and ratings
            var productWithCommentsAndRatings = await _db.Products
                .Include(p => p.Comments)
                .Include(p => p.ProductRatings)
                .FirstOrDefaultAsync(p => p.Id == productId);

            // Check if the product exists
            if (productWithCommentsAndRatings is null)
                return OperationResult<IEnumerable<GetProductRatingsAndCommentsDto>>.Failure("No ratings or comments found for the specified product.");

            // Map the comments and ratings to the DTO
            var result = productWithCommentsAndRatings.Comments.Select(comment => new GetProductRatingsAndCommentsDto
            {
                RatingValue = productWithCommentsAndRatings.ProductRatings
                    .FirstOrDefault(rating => rating.UserId == comment.UserId)?.RatingValue ?? 0, // Match rating by UserId
                Comment = comment.Content,
                UserName = _db.Users.FirstOrDefault(u => u.Id == comment.UserId)?.UserName ?? "Unknown",
                UserImage = _db.Users.FirstOrDefault(u => u.Id == comment.UserId).ImageUrl,

                CreatedAt = comment.CreatedAt
            }).ToList();

            // Add ratings without comments
            var ratingsWithoutComments = productWithCommentsAndRatings.ProductRatings
                .Where(rating => !productWithCommentsAndRatings.Comments.Any(comment => comment.UserId == rating.UserId))
                .Select(rating => new GetProductRatingsAndCommentsDto
                {
                    RatingValue = rating.RatingValue,
                    UserImage = _db.Users.FirstOrDefault(u => u.Id == rating.UserId).ImageUrl,
                    Comment = "No comment",
                    UserName = _db.Users.FirstOrDefault(u => u.Id == rating.UserId)?.UserName ?? "Unknown",
                    CreatedAt = DateTime.MinValue // Default value for ratings without comments
                });

            result.AddRange(ratingsWithoutComments);

            // Return the result
            return OperationResult<IEnumerable<GetProductRatingsAndCommentsDto>>.Success(result);
        }
        public async Task<OperationResult<bool>> UpdateProductAsync(int productId, CreateProductDto productDto)
        {
            var product = await _db.Products.Include(p => p.Images).FirstOrDefaultAsync(p => p.Id == productId);
            if (product == null)
                return OperationResult<bool>.Failure("Product not found.");

            // Update product details
            product.Name = productDto.Name;
            product.Price = productDto.Price;
            product.ProductCategoryId = productDto.ProductCategoryId;
            product.Description = productDto.Description;

            // Handle image updates
            if (productDto.formImages != null && productDto.formImages.Any())
            {
                // Validate and upload new images
                foreach (var imageFrom in productDto.formImages)
                {
                    if (!ImageValidator.IsValidImage(imageFrom, out string errorMessage))
                        return OperationResult<bool>.Failure(message: errorMessage);

                    string imagePath = await _fileService.UploadImageAsync("Product", imageFrom);
                    if (imagePath == "FailedToUploadImage")
                        return OperationResult<bool>.Failure("Failed to upload image");

                    // Add the new image to the product
                    product.Images.Add(new Image
                    {
                        ImageUrl = imagePath,
                        ProductId = product.Id
                    });

                }

                // Delete old images if necessary
                if (product.Images != null && product.Images.Any())
                {
                    foreach (var oldImage in product.Images.ToList())
                    {
                        var deleteResult = await _fileService.Delete(oldImage.ImageUrl);
                        if (!deleteResult.IsSuccess)
                            return OperationResult<bool>.Failure(deleteResult.Message);

                        product.Images.Remove(oldImage);
                    }
                }
            }

            _db.Products.Update(product);
            await _db.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Product updated successfully.");
        }



    }

}
