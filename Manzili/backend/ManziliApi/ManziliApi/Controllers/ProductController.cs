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

        [HttpPost("AddProductToStore")]
        public async Task<IActionResult> AddProductToStore(CreateProductDto createProductDto, int storeId)
        {
            var result = await _productservices.CreateToStoreAsync(createProductDto, storeId);
            if (result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }

        #endregion
    }
}
