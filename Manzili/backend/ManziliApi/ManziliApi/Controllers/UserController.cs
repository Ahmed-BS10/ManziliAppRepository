//using Manzili.Core.Dto.UserDto;
//using Manzili.Core.Entities;
//using Manzili.Core.Services;
//using Microsoft.AspNetCore.Mvc;
//using static Manzili.Core.Routes.Route;

//namespace ManziliApi.Controllers
//{
//    [ApiController]
//    public class UserController : ControllerBase
//    {
//        #region Field
//        private readonly UserServices _userServices;

//        #endregion

//        #region Constructor
//        public UserController(UserServices userServices)
//        {
//            _userServices=userServices;
//        }
//        #endregion


//        #region Method

//        [HttpPost(UserRouting.Create)]
//        public async Task<IActionResult> Create(UserCreateDto  user )
//        {

//            var createuser = await _userServices.AddAsycn(user, user.Password);
//            switch (createuser)
//            {
//                case "Email Already Exists": return BadRequest("Email Already Exists");
//                case "User PhoneNumber Already Exists": return BadRequest("User PhoneNumber Already Exists");
//                case "Added Successfully": return Ok("Added Successfully");
//                default: return BadRequest(createuser);
//            }
//        }


//        [HttpGet(UserRouting.List)]
//        public async Task<IActionResult> GetList()
//        {

//            var users = await _userServices.GetListAsync();
//            return Ok(users);
//        }



//        [HttpPut(UserRouting.Edit)]
//        public async Task<IActionResult> Update(UserUpdateDto userDto, int id)
//        {

//            var updateUser = await _userServices.UpdateAsync(userDto , id);
//            return Ok(updateUser);
//        }



//        [HttpDelete(UserRouting.Delete)]
//        public async Task<IActionResult> Delete(int id)
//        {

//            var delteUser = await _userServices.DeleteAsync(id);
//            return Ok(delteUser);
//        }

//        #endregion
//    }
//}






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

        [HttpPost(UserRouting.Create)]
        public async Task<IActionResult> Create(UserCreateDto user)
        {
            var result = await _userServices.CreateAsync(user, user.Password);

            if (result.IsSuccess)
            {
                return Ok(result.Message); // Success message
            }

            return BadRequest(result.Message); // Error message
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
                return Ok(result.Message); // Success message
            }

            return BadRequest(result.Message); // Error message
        }

        [HttpDelete(UserRouting.Delete)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _userServices.DeleteAsync(id);

            if (result.IsSuccess)
            {
                return Ok(result.Message); // Success message
            }

            return BadRequest(result.Message); // Error message
        }

        #endregion
    }
}


