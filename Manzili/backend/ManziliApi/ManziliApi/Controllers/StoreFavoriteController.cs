using Manzili.Core.Dto.StoreFavoriteDto;
using Manzili.EF.Implementaion;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoreFavoriteController : ControllerBase
    {

        #region Fields
        readonly IStoreFavoriteServices _storeFavoriteServices;

        #endregion

        #region Constructor
        public StoreFavoriteController(IStoreFavoriteServices storeFavoriteServices)
        {
            _storeFavoriteServices = storeFavoriteServices;
        }
        #endregion


        [HttpPost("MakeFavoriteStore")]
        public async Task<IActionResult> Create([FromQuery]CreateStoreFavoriteDto createStoreFavoriteDto)
        {
            var result = await _storeFavoriteServices.Create(createStoreFavoriteDto);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }


        [HttpPost("ToggleFavorite")]
        public async Task<IActionResult> Create2(int userId , int storeId)
        {
            var result = await _storeFavoriteServices.ToggleFavorite(userId , storeId);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }


        [HttpDelete("DeletFavoriteStore")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _storeFavoriteServices.Delete(id);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }



    }
}
