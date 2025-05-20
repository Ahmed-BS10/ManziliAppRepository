using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Enum;
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



        [HttpPut("ChangeStoreStatsu")]
        public async Task<IActionResult> ChangeStoreStatsu(int storeId , enStoreStatus enStore)
        {
            var result = await _storeServices.ChangeStoreStatsu(storeId, enStore);
            return Ok(result);
        }

        [HttpGet("GetProfileStore")]
        public async Task<IActionResult> GetProfileStore(int storeId)
        {
            var result = await _storeServices.GetProfileStore(storeId);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        }

        [HttpGet("GetAllOrders")]
        public async Task<IActionResult> GetAllOrders()
        {
            var result = await _storeServices.GetAllOrders();
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        }


        [HttpGet("GetLastTwoCompletedOrders")]
        public async Task<IActionResult> GetLastTwoCompletedOrdersAsync(int storeId)
        {
            var result = await _storeServices.GetLastTwoCompletedOrdersAsync(storeId);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        } 



        [HttpGet("GetStoreOrdersInWorkStatus")]
        public async Task<IActionResult> GetStoreOrdersInWorkStatus(int storeId)
        {
            var result = await _storeServices.GetStoreOrdersInWorkStatus(storeId);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        } 



        [HttpGet("GetStoreOrdersInNewStatus")]
        public async Task<IActionResult> GetStoreOrdersInNewStatus(int storeId)
        {
            var result = await _storeServices.GetStoreOrdersInNewStatus(storeId);
            if (result.IsSuccess)
                return Ok(result.Data);

            return BadRequest(result.Message);
        }

        [HttpGet("GetStoreOrdersInPastStatus")]
        public async Task<IActionResult> GetStoreOrdersInPastStatus(int storeId)
        {
            var result = await _storeServices.GetStoreOrdersInPastStatus(storeId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result.Message);
        }

        [HttpGet("GetTotalSales")]
        public async Task<IActionResult> GetTotalSalesAsync(int storeId, int month)
        {
            var result = await _storeServices.GetTotalSalesAsync(storeId, month);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpGet("GetAnalysisStore")]
        public async Task<IActionResult> GetAnalysisStoreAsync(int storeId)
        {
            var result = await _storeServices.GetAnalysisStoreAsync(storeId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);


        }

        [HttpGet("GetInfoStore")]
        public async Task<IActionResult> GetInfoStore(int storeId)
        {
            var result = await _storeServices.GetInfoStore(storeId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);


        }

        [HttpGet("SearchStoreByName")]
        public async Task<IActionResult> SearchStoreByNameAsync(string businessName)
        {
            var result = await _storeServices.SearchStoreByNameAsync(businessName);
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
        public async Task<IActionResult> GetStoresWithCategory(int storecCategoryId)
        {
            var result = await _storeServices.GetStoresWithCategory(storecCategoryId);
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



        [HttpGet("GetProductGategoriesByStoreId")]
        public async Task<IActionResult> GetProductGategoriesByStoreId(int storeId)
        {
            var result = await _storeServices.GetProductGategoriesByStoreId(storeId);

            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }
    }
}
