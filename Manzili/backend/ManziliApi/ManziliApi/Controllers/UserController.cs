using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
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


        [HttpGet(UserRouting.GetById)]
        public async Task<IActionResult> GetById(int id)
        {
            var user = await _userServices.GetByIdAsync(id);
            return Ok(user);
        }

        [HttpPost(UserRouting.Create)]
        public async Task<IActionResult> Create(UserCreateDto user)
        {
            var result = await _userServices.CreateAsync(user);

            if (result.IsSuccess)
            {
                return Ok(result); // Success message
            }

            return BadRequest(result); // Error message
        }

        [HttpGet(UserRouting.List)]
        public async Task<IActionResult> GetList()
        {
            var users = await _userServices.GetListAsync();
            return Ok(users);
        }

        [HttpPut(UserRouting.Edit)]
        public async Task<IActionResult> Update(UserUpdateDto userDto, int id)
        {
            var result = await _userServices.UpdateAsync(userDto, id);

            if (result.IsSuccess)
            {
                return Ok(result); // Success message
            }

            return BadRequest(result); // Error message
        }

        [HttpDelete(UserRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _userServices.DeleteAsync(id);

            if (result.IsSuccess)
            {
                return Ok(result); // Success message
            }

            return BadRequest(result); // Error message
        }

        #endregion
    }
}


