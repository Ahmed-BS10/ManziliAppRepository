using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Entities;

namespace Manzili.Core.Services
{
    public interface IProductServices
    {

        Task<OperationResult<IEnumerable<GetAllProduct>>> SearchProductByNameInStore(int storeId , string name);
        Task<OperationResult<List<GetAllProduct>>> GetStoreProductsAsync(int storeId);
        Task<OperationResult<GteFullInfoProdcut>> GetProductByIdAsync(int productId);

        Task<OperationResult<string>> AddProductToStoreAsync(int storeId, CreateProductDto productDto);
        Task<OperationResult<IEnumerable<GetAllProduct>>> GetProductsByStoreAndCategoriesAsync(int storeId, int storeCategoryId, int productCategoryId);
        Task<OperationResult<IEnumerable<GetAllProduct>>> GetProductsByStoreAndProductCategoriesAsync(int storeId, int productCategoryId);




        Task<OperationResult<IEnumerable<GetProductRatingsAndCommentsDto>>> GetAllRatingsAndCommentsAsync(int productId);



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