using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreCategoryDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoreCategoryController : ControllerBase
    {
        #region Fields

        readonly IStoreCategoryServices _storeCategoryServices;
        #endregion

        #region Constructor

        public StoreCategoryController(IStoreCategoryServices storeCategoryServices)
        {
            _storeCategoryServices = storeCategoryServices;
        }
        #endregion

        #region Endpoint
        [HttpGet(StoreCategoryRouting.List)]
        public async Task<IActionResult> GetAll()
        {
            var result = await _storeCategoryServices.GetList();
            if (!result.IsSuccess)
                return NotFound(result);

            return Ok(result);
        }

        [HttpPost(StoreCategoryRouting.Create)]
        public async Task<IActionResult> Create([FromForm] CreateStoreCatagoryDto createStoreCategoryDto)
        {
            var result = await _storeCategoryServices.Create(createStoreCategoryDto);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpPut(StoreCategoryRouting.Update)]
        public async Task<IActionResult> Update(int id, [FromForm] UpdateStoreCatagoryDto updateStoreCategoryDto)
        {
            var result = await _storeCategoryServices.Update(id, updateStoreCategoryDto);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpDelete(StoreCategoryRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _storeCategoryServices.Delete(id);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }
        #endregion

    }
}

