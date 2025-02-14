using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]

    [ApiController]
    public class UserController : ControllerBase
    {
        #region Field
        private readonly UserServices _userServices;

        #endregion

        #region Constructor
        public UserController(UserServices userServices)
        {
            _userServices = userServices;
        }
        #endregion

        #region Methods


        [HttpGet(UserRouting.List)]
        public async Task<IActionResult> GetList()
        {
            var result = await _userServices.GetListAsync();
            if (result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }

        [HttpGet(UserRouting.GetById)]
        public async Task<IActionResult> GetById(int id)
        {
            var result = await _userServices.GetByIdAsync(id);
            if(result.IsSuccess)
                return Ok(result);

            return NotFound(result);
        }

        [HttpPost(UserRouting.Create)]
        public async Task<IActionResult> Create(CreateUserDto user)
        {
            var result = await _userServices.CreateAsync(user);

            if (result.IsSuccess)
             return Ok(result); 

            return BadRequest(result); 
        }

        [HttpPut(UserRouting.Update)]
        public async Task<IActionResult> Update(UpdateUserDto userDto, int id)
        {
            var result = await _userServices.UpdateAsync(userDto, id);

            if (result.IsSuccess)
                return Ok(result); 
            

            return BadRequest(result);
        }

        [HttpDelete(UserRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _userServices.DeleteAsync(id);

            if (result.IsSuccess)
                return Ok(result); 
            

            return BadRequest(result); 
        }

        #endregion
    }
}


