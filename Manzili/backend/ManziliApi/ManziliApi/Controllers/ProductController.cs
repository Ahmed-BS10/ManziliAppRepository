using Manzili.Core.Dto.ProductDto;
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

        readonly IProductservices _productservices;

        #endregion

        #region Constructor
        public ProductController(IProductservices productservices)
        {
            _productservices = productservices;
        }
        #endregion

        #region Methods

        [HttpGet(ProductRouting.GetAll)]
        public async Task<IActionResult> GetStoreProducts(int storeId)
        {
            var result = await _productservices.GetStoreProductsAsync(storeId);
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





        [HttpPost("GetStoreProduct")]
        public async Task<IActionResult> GetStoreProduct(int storeId , string n1 , string n2)
        {
            var result = await _productservices.GetStoreProduct(storeId, n1, n2);
            if (result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }

        #endregion
    }
}
