using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Entities;

namespace Manzili.Core.Services
{
    public interface IProductservices
    {

        Task<OperationResult<List<Product>>> GetStoreProductsAsync(int storeId);
        Task<OperationResult<Product>> GetProductByIdAsync(int productId);

        Task<OperationResult<Product>> AddProductToStoreAsync(int storeId, CreateProductDto productDto);
        
        
        //Task<OperationResult<IEnumerable<GetStoreProductDto>>> GetStoreProduct(int storeId, string storeCategory, string productCategory);
        //Task<Product> CreateProductAsync(Product product);
        //Task DeleteProductAsync(int productId);
        //Task<IEnumerable<Product>> GetAllProductsAsync();
        //Task<Product> GetProductByIdAsync(int productId);
        //Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId);
        //Task<IEnumerable<Product>> GetProductsByStoreAsync(int storeId);
        //Task<IEnumerable<Product>> SearchProductsAsync(string searchTerm);
        //Task<Product> UpdateProductAsync(Product product);
    }
}