using Manzili.Core.Dto.ProductDto;
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
    internal class Productservices : IProductservices
    {
       
        readonly ManziliDbContext _db;
        readonly DbSet<Product> _dbSet;  
        readonly FileService _fileService;

        public async Task<OperationResult<Product>> AddProductToStoreAsync(int storeId, CreateProductDto productDto)
        {
            var store = await _db.Stores.Include(s => s.Products).FirstOrDefaultAsync(s => s.Id == storeId);
            if (store == null)
            {
                return OperationResult<Product>.Failure("Store not found.");
            }

            var imageUrls = new List<string>();
            if (productDto.formImages != null)
            {
                foreach (var image in productDto.formImages)
                {
                    var imageUrl = await _fileService.UploadImageAsync("product-images", image);
                    imageUrls.Add(imageUrl);
                }
            }

            var product = new Product
            {
                Name = productDto.Name,
                Description = productDto.Description,
                Price = productDto.Price,
                Quantity = productDto.Quantity ?? 0,
                ImageUrls = imageUrls,
                ProductCategoryId = productDto.ProductCategoryId,
                StoreId = storeId
            };

            store.Products.Add(product);
            await _db.SaveChangesAsync();

            return OperationResult<Product>.Success(product, "Product added successfully.");
        }
        public async Task<OperationResult<Product>> GetProductByIdAsync(int productId)
        {
            var product = await _dbSet
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.Id == productId);

            if (product == null)
            {
                return OperationResult<Product>.Failure($"Product with ID {productId} not found.");
            }

          

            return OperationResult<Product>.Success(product);
        }


        public Productservices(ManziliDbContext db, FileService fileService)
        {
            _db = db;
            _dbSet = _db.Set<Product>();
            _fileService = fileService;
        }
        public async Task<OperationResult<IEnumerable<GetStoreProductDto>>> GetStoreProduct(int storeId, string storeCategory, string productCategory)
        {
            var products = await _dbSet
                .Include(p => p.ProductCategory)
                .ThenInclude(pc => pc.StoreCategory)
                .Where(p => p.StoreId == storeId &&
                            p.ProductCategory.StoreCategory.Name == storeCategory &&
                            p.ProductCategory.Name == productCategory)
                .AsNoTracking()
                .ToListAsync();

            // Convert products to DTO
            var result = products.Select(p => new GetStoreProductDto(
                p.Id,                         // productId
                p.Name,                       // name
                p.ImageUrls.FirstOrDefault(),                  // imageUrls
                p.Description,                // description
                p.Price,                      // price
                p.State,                      // states
                new List<string> { p.ProductCategory.Name } // List containing the category name
            ));

            return OperationResult<IEnumerable<GetStoreProductDto>>.Success(result);
        }


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
