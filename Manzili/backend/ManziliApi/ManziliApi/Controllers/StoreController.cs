using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    public class StoreController : ControllerBase
    {
        private readonly IStoreServices _storeServices;

        public StoreController(IStoreServices storeServices)
        {
            _storeServices = storeServices;
        }

        [HttpGet("FullStoreInfo")]
        public async Task<IActionResult> GetList()
        {
            var result = await _storeServices.GetInfoStore(1);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);

        }




        [HttpGet("GetUserFavoriteStores")]
        public async Task<IActionResult> GetUserFavoriteStores(int userId)
        {
            var result = await _storeServices.GetUserFavoriteStores(userId);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);

        }

        [HttpGet("StoresByCategore")]
        public async Task<IActionResult> GetStoresWithCategory(string categoryName)
        {
            var result = await _storeServices.GetStoresWithCategory(categoryName);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);

        }

        [HttpGet("OrderByDescending")]
        public async Task<IActionResult> GetListOrderByDescending()
        {
            var result = await _storeServices.GetLatestStoresAsync();
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);

        }
        [HttpGet("ToPage")]
        public async Task<IActionResult> GetListToPage([FromQuery] int size , [FromQuery] int pageSize)
        {
            var result = await _storeServices.GetListToPageinationAsync(size , pageSize);
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);

        }

        //[HttpGet(StoreRouting.GetById)]
        //public async Task<IActionResult> Get(int id)
        //{
        //    var result = await _storeServices.GetByIdAsync(id);
        //    if (result.IsSuccess)
        //        return Ok(result);

        //    return NotFound(result);


        //}

        [HttpPost(StoreRouting.Create)]
        public async Task<IActionResult> Create(CreateStoreDto storeDto , List<int> categories)
        {
            var result = await _storeServices.CreateAsync(storeDto , categories);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPut(StoreRouting.Update)]
        public async Task<IActionResult> Update(UpdateStoreDto storeDto , int storeId)
        {
            var result = await _storeServices.UpdateAsync(storeDto , storeId);
            if (result.IsSuccess)
                return Ok(result.Data);


            return BadRequest(result);

        }

        [HttpDelete(StoreRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _storeServices.DeleteAsync(id);
            if (result.IsSuccess)

                return Ok(result);

            return NotFound(result);

        }
    }
}
