using Manzili.Core.Dto.CatagoryDto;
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

        readonly CategoryServices _categoryServices;
        #endregion

        #region Constructor

        public CategoryController(CategoryServices categoryServices)
        {
            _categoryServices = categoryServices;
        }
        #endregion

        #region Endpoint

        [HttpPost(CategoryRouting.Create)]
        public async Task<IActionResult> Create(CatagoryCreateDto catagoryCreate)
        {
            var result = await _categoryServices.Create(catagoryCreate);
            if(result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        #endregion
    }
}
