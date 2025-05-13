using Manzili.Core.Services;
using Manzili.EF.Implementation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DashbordController : ControllerBase
    {
        readonly UserServices _userServices;
        readonly IStoreServices _storeServices;
        readonly IOrdersService _ordersService;

        public DashbordController(UserServices userServices, IStoreServices storeServices, IOrdersService ordersService)
        {
            _userServices = userServices;
            _storeServices = storeServices;
            _ordersService = ordersService;
        }
        
        // User

        [HttpGet("GetUnBlockeUser")]
        public async Task<IActionResult> GetUnBlockeUser(int pageNumber = 1, int size = 10)
        {
            var result = await _userServices.GetUnBlockeUser(pageNumber, size);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        } 
        
        [HttpGet("GetBlockeUser")]
        public async Task<IActionResult> GetBlockeUser(int pageNumber = 1, int size = 10)
        {
            var result = await _userServices.GetBlockeUser(pageNumber, size);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        // Store

        [HttpGet("GetUnBlockeStores")]
        public async Task<IActionResult> GetUnBlockeStores(int page = 1, int pageSize = 10)
        {
            var result = await _storeServices.GetUnBlockeStores(page, pageSize);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        }
        [HttpGet("GetBlockeStores")]
        public async Task<IActionResult> GetBlockeStores(int page = 1, int pageSize = 10)
        {
            var result = await _storeServices.GetBlockeStores(page, pageSize);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        }


        // Order


        [HttpGet("GetAllOrderDashbord")]
        public async Task<IActionResult> GetAllOrderDashbord(int pageNumber = 1, int size = 10)
        {
            var result = await _ordersService.GetAllOrderDashbordAsync(pageNumber, size);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        // Bolke
    
        [HttpPut("MakeBloke/{Id}")]
        public async Task<IActionResult> MakeBloke(int Id)
        {
            var result = await _storeServices.MakeBloke(Id);
            if(result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }

        [HttpPut("UnBloke/{Id}")]
        public async Task<IActionResult> UnBloke(int Id)
        {
            var result = await _storeServices.UnBloke(Id);
            if(result.IsSuccess)
                return Ok(result);
            return BadRequest(result);
        }
    }
}
