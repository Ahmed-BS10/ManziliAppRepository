using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [ApiController]
    public class StoreController : ControllerBase
    {
        private readonly StoreServices _storeServices;

        public StoreController(StoreServices storeServices)
        {
            _storeServices = storeServices;
        }

        [HttpGet(StoreRouting.List)]
        public async Task<IActionResult> GetList()
        {
            var result = await _storeServices.GetListAsync();
            return Ok(result);
        }

        [HttpGet(StoreRouting.GetById)]
        public async Task<IActionResult> Get(int id)
        {
            var result = await _storeServices.GetByIdAsync(id);
            if (result == null)
                return NotFound(OperationResult.Failure("Store not found."));

            return Ok(result);
        }

        [HttpPost(StoreRouting.Create)]
        public async Task<IActionResult> Create(StoreCreateDto store)
        {
            var result = await _storeServices.CreateAsync(store);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpPut(StoreRouting.Edit)]
        public async Task<IActionResult> Update(StoreUpdateDto store)
        {
            var result = await _storeServices.UpdateAsync(store);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpDelete(StoreRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _storeServices.DeleteAsync(id);
            if (!result.IsSuccess)
                return NotFound(result);

            return Ok(result);
        }
    }
}
