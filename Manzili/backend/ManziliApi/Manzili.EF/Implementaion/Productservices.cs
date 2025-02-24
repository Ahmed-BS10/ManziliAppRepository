using Manzili.Core.Dto.ProductDto;
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

        public Productservices(ManziliDbContext db)
        {
            _db = db;
            _dbSet = _db.Set<Product>();
        }

        public async Task<OperationResult<CreateProductDto>> CreateProductAsync(CreateProductDto createProductDto , int storeId)
        {
           
            var existCategory = await _db.ProductCategories.FindAsync(createProductDto.ProductCategoryId);
            if (existCategory is null)
                return OperationResult<CreateProductDto>.Failure("Category not found");
                        

            var existStore = await _db.Stores.FindAsync(storeId);
            if (existStore is null)
                return OperationResult<CreateProductDto>.Failure("Store not found.");


            if (createProductDto.formImages is null)
                return OperationResult<CreateProductDto>.Failure("Image URL cannot be null or empty");



            Product Product = new Product
            {
                Name = createProductDto.Name,
                Description = createProductDto.Description,
                ProductCategoryId = createProductDto.ProductCategoryId,
                StoreId = storeId,


            };

            await _dbSet.AddAsync()
           

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
