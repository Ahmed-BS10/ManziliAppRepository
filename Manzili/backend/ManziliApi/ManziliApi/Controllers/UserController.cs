using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
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
            _userServices=userServices;
        }
        #endregion


        #region Method

        [HttpPost(UserRouting.Create)]
        public async Task<IActionResult> Create(UserCreateDto  user , string password)
        {
            User user1 = new User()
            {
                Name = "hi",
                City = "hi",
                Address = "hi",
                UserName = user.UserName,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,

            };
            var createuser = await _userServices.AddAsycn(user1, password);
            return Ok(createuser);
        }


        [HttpGet(UserRouting.List)]
        public async Task<IActionResult> GetList()
        {
            
            var users = await _userServices.GetListAsync();
            return Ok(users);
        }



        [HttpPut(UserRouting.Edit)]
        public async Task<IActionResult> Update(UserUpdateDto user)
        {
           
            var updateUser = await _userServices.UpdateAsync(user);
            return Ok(updateUser);
        }



        [HttpDelete(UserRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {

            var delteUser = await _userServices.DeleteAsync(id);
            return Ok(delteUser);
        }




        #endregion
    }
}

