﻿using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        #region Fields

        readonly IProductServices _productservices;

        #endregion

        #region Constructor
        public ProductController(IProductServices productservices)
        {
            _productservices = productservices;
        }
        #endregion

        #region Methods



        [HttpGet("GetStoreProducts")]
        public async Task<IActionResult> GetStoreProducts(int storeId)
        {
            var result = await _productservices.GetStoreProductsAsync(storeId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        } 
        
        
        [HttpGet("SerchByProductName")]
        public async Task<IActionResult> SerchByProductName(string name ,int storeId)
        {
            var result = await _productservices.SerchByProductName(name , storeId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpGet(ProductRouting.GetAll)]
        public async Task<IActionResult> GetStoreProducts(int storeId , int productCategoryId)
        {
            var result = await _productservices.GetStoreProductsAsync(storeId , productCategoryId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpGet(ProductRouting.GetById)]
        public async Task<IActionResult> GetProductById(int productId)
        {
            var result = await _productservices.GetProductByIdAsync(productId);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }


        [HttpPost(ProductRouting.Create)]
        public async Task<IActionResult> AddProductToStore(int storeId, [FromForm] CreateProductDto productDto)
        {
            var result = await _productservices.AddProductToStoreAsync(storeId, productDto);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }


        [HttpGet("GetProductsByStoreAndCategories")]
        public async Task<IActionResult> GetProductsByStoreAndCategories(int storeId, int storeCategoryId, int productCategoryId)
        {
            var result = await _productservices.GetProductsByStoreAndCategoriesAsync(storeId, storeCategoryId, productCategoryId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpGet("SearchProductByNameInStore")]
        public async Task<IActionResult> SearchProductByNameInStoreAsync(int storeId , string name )
        {
            var result = await _productservices.SearchProductByNameInStore(storeId , name);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }


        [HttpGet("GetProductsByStoreAndProductCategories")]
        public async Task<IActionResult> GetProductsByStoreAndProductCategoriesAsync(int storeId, int storeProductCategoryI)
        {
            var result = await _productservices.GetProductsByStoreAndProductCategoriesAsync(storeId, storeProductCategoryI);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }



        [HttpGet("GetAllRatingsAndComments")]
        public async Task<IActionResult> GetAllRatingsAndCommentsAsync(int productId)
        {
            var result = await _productservices.GetAllRatingsAndCommentsAsync(productId);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }

        [HttpDelete("DeleteProduct")]
        public async Task<IActionResult> DeleteProductAsync(int productId)
        {
            var result = await _productservices.DeleteProductAsync(productId);
            if (result.IsSuccess)
                return Ok(result.Message);

            return BadRequest(result.Message);
        }
        [HttpPut("UpdateProduct")]
        public async Task<IActionResult> UpdateProductAsync(int productId, [FromForm] CreateProductDto productDto)
        {
            var result = await _productservices.UpdateProductAsync(productId, productDto);
            if (result.IsSuccess)
                return Ok(result.Message);

            return BadRequest(result.Message);
        }



       

        #endregion
    }
}
