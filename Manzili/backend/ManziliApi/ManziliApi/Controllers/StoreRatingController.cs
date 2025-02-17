using Manzili.Core.Dto.StoreRateDto;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoreRatingController : ControllerBase
    {
        #region Feilds
        readonly StoreRateServices _storeRateServices;

        #endregion

        #region Constrcutor

        public StoreRatingController(StoreRateServices storeRateServices)
        {
            _storeRateServices = storeRateServices;
        }
        #endregion

        #region Method

        [HttpPost(StoreRatingRouting.Create)]
        public async Task<IActionResult> Create(CreateStoreRateDto createRateDto)
        {
            var result = await _storeRateServices.CreateOrUpdate(createRateDto);
            if (result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }
        #endregion
    }
}
