using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.ProductCatagoryDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        #region Fields

        readonly IProductCategoryServices _categoryServices;
        #endregion

        #region Constructor

        public CategoryController(IProductCategoryServices categoryServices)
        {
            _categoryServices = categoryServices;
        }
        #endregion

        #region Endpoint


        [HttpGet(CategoryRouting.List)]
        public async Task<IActionResult> GetAll()
        {
            var result = await _categoryServices.GetList();
            if (!result.IsSuccess)
                return NotFound(result);

            return Ok(result);
        }

        [HttpPost(CategoryRouting.Create)]
        public async Task<IActionResult> Create(CreateProductCatagoryDto createProductCatagoryDto)
        {
            var result = await _categoryServices.Create(createProductCatagoryDto);
            if(result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPut(CategoryRouting.Update)]
        public async Task<IActionResult> Update(int id, [FromForm] UpdateProdcutCatagoryDto catagoryUpdateDto)
        {
            var result = await _categoryServices.Update(id, catagoryUpdateDto);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpDelete(CategoryRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
          var   result = await _categoryServices.Delete(id);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);

        }


        [HttpGet("store-category/{storeCategoryId}/product-categories")]
        public async Task<IActionResult> GetProductCategoriesByStoreCategory(int storeCategoryId)
        {
            var result = await _categoryServices.GetProductCategoriesByStoreCategoryAsync(storeCategoryId);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }


        [HttpGet("GetStoreCategoriesByStore")]
        public async Task<IActionResult> GetStoreCategoriesByStore(int storeId)
        {
            var result = await _categoryServices.GetStoreCategoriesByStoreIdAsync(storeId);

            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }

        #endregion
    }
}
