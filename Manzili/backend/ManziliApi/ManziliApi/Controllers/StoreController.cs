using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [ApiController]
    public class StoreController : ControllerBase
    {
        private readonly IStoreServices _storeServices;

        public StoreController(IStoreServices storeServices)
        {
            _storeServices = storeServices;
        }

        //[HttpGet(StoreRouting.List)]
        //public async Task<IActionResult> GetList()
        //{
        //    var result = await _storeServices.GetListAsync();
        //    if (result.IsSuccess)
        //        return Ok(result);

        //    return NotFound(result);

        //}


        [HttpGet("ToPage")]
        public async Task<IActionResult> GetListToPage(int size , int pageSize)
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
        public async Task<IActionResult> Create(CreateStoreDto storeDto)
        {
            var result = await _storeServices.CreateAsync(storeDto);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPut(StoreRouting.Edit)]
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
