using Manzili.Core.Dto.ReturnOrder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReturnOrderController : ControllerBase
    {
        readonly IReturnOrderServices _returnOrderServices;

        public ReturnOrderController(IReturnOrderServices returnOrderServices)
        {
            _returnOrderServices = returnOrderServices;
        }



        [HttpPost("CreateReturnOrder")]
        public async Task<IActionResult> Create(CreateReturnOrder createReturnOrder)
        {
            var result = await _returnOrderServices.CreateReturnOrder(createReturnOrder);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }




        [HttpGet("GetList")]
        public async Task<IActionResult> GetList(int pageNumber = 1, int size = 10)
        {
            var result = await _returnOrderServices.GetReturnOrder(pageNumber , size);
            if (result.IsSuccess)
                return Ok(result);


            return BadRequest(result);
        }
    }
}
