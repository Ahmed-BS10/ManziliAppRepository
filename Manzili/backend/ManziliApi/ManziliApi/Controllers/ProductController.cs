using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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



        [HttpGet("GetProductById")]
        public async Task<IActionResult> GetProductById(int productId)
        {
            var result = await _productservices.GetProductByIdAsync(productId);
            if (result.IsSuccess)
                return Ok(result);
            return NotFound(result);
        }



        [HttpPost("AddProductToStore")]
        public async Task<IActionResult> AddProductToStore(CreateProductDto createProductDto, int storeId)
        {
            var result = await _productservices.CreateToStoreAsync(createProductDto, storeId);
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
