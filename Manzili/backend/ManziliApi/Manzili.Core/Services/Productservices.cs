using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    internal class Productservices
    {
       # region Fields
        private readonly IRepository<Product> _productRepository;
        private readonly IRepository<Category> _categoryRepository;
        private readonly IRepository<Store> _storeRepository;
        #endregion

       #region Constructor
        public Productservices(
            IRepository<Product> productRepository,
            IRepository<Category> categoryRepository,
            IRepository<Store> storeRepository)
        {
            _productRepository = productRepository;
            _categoryRepository = categoryRepository;
            _storeRepository = storeRepository;
        }
        #endregion

       #region Method

        public async Task<Product> CreateProductAsync(Product product)
        {
            if (product == null)
            {
                throw new ArgumentNullException(nameof(product), "Product cannot be null.");
            }

            var category = await _categoryRepository.Find(c => c.CategoryId == product.CategoryId);
            if (category == null)
            {
                throw new ArgumentException("Category not found.", nameof(product.CategoryId));
            }

            var store = await _storeRepository.Find(s => s.Id == product.StoreId);
            if (store == null)
            {
                throw new ArgumentException("Store not found.", nameof(product.StoreId));
            }

            if (string.IsNullOrEmpty(product.ImageUrl))
            {
                throw new ArgumentException("Image URL cannot be null or empty.", nameof(product.ImageUrl));
            }

            if (product.Discount == 0) product.Discount = 0;
            if (product.Quantity == 0) product.Quantity = 0;

            await _productRepository.AddAsync(product);
            await _productRepository.SaveChangesAsync();

            return product;
        }

        public async Task<IEnumerable<Product>> GetAllProductsAsync()
        {
            return await _productRepository.GetListNoTrackingAsync();
        }


        #endregion
    }
}
