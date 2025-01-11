using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoreController : ControllerBase
    {
        private readonly StoreServices _storeServices;

        public StoreController(StoreServices storeServices)
        {
            _storeServices= storeServices;
        }


        [HttpGet(UserRouting.List)]
        public async Task<IActionResult> GetList()
        {

            var users = await _storeServices.GetListAsync();
            return Ok(users);
        }


        [HttpGet("jo")]
        public async Task<IActionResult> Get(int id)
        {

            var users = await _storeServices.GetByIAsync(id);
            return Ok(users);
        }


        [HttpPost(UserRouting.Create)]
        public async Task<IActionResult> Create(StoreCreateDto store)
        {
           
            var createStore = await _storeServices.AddAsycn(store);
            return Ok(createStore);
        }


        [HttpPut(UserRouting.Edit)]
        public async Task<IActionResult> Update(StoreUpdateDto store)
        {

            var updateStore = await _storeServices.UpdateAsync(store);
            return Ok(updateStore);
        }



        [HttpDelete(UserRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {

            var delteUser = await _storeServices.DeleteAsync(id);
            return Ok(delteUser);
        }

    }
}
