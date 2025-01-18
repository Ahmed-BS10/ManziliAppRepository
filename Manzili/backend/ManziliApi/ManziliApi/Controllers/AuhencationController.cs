using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuhencationController : ControllerBase
    {
        #region Field

        private readonly AuthenticationServices _authenticationServices;
        #endregion

        #region Constructor

        public AuhencationController(AuthenticationServices authenticationServices)
        {
            _authenticationServices=authenticationServices;
        }

        #endregion


        [HttpPost(AuthenticationRouting.RegsiterUser)]
        public async Task<IActionResult> RegisterUser(UserCreateDto userCreate)
        {
            var reslut = await _authenticationServices.RegisterUser(userCreate);
            if (reslut !=  null)
                return Ok(reslut);

            return BadRequest();
        }


        [HttpPost(AuthenticationRouting.Login)]
        public async Task<IActionResult> Login(UserLoginDto userLogin)
        {
            var reslut = await _authenticationServices.Login(userLogin);
            if (reslut !=  null)
                return Ok(reslut);

            return BadRequest();
        }



        [HttpPost(AuthenticationRouting.RegsiterStore)]
        public async Task<IActionResult> RegisterStore(StoreCreateDto storeCreate)
        {
            var reslut = await _authenticationServices.RegisterStore(storeCreate);
            if (reslut !=  null)
                return Ok(reslut);

            return BadRequest();
        }

    }
}
