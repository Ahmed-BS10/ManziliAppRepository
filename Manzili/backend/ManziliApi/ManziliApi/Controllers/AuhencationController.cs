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

        private readonly IAuthenticationServices _authenticationServices;
        #endregion

        #region Constructor

        public AuhencationController(IAuthenticationServices authenticationServices)
        {
            _authenticationServices=authenticationServices;
        }

        #endregion


        [HttpPost(AuthenticationRouting.RegsiterUser)]
        public async Task<IActionResult> RegisterUser(CreateUserDto userCreate)
        {
            var reslut = await _authenticationServices.RegisterAsUser(userCreate);
            if (reslut.IsSuccess)
                return Ok(reslut);

            return BadRequest(reslut);
        }


        [HttpPost(AuthenticationRouting.Login)]
        public async Task<IActionResult> Login(LoginUserDto userLogin)
        {
            var reslut = await _authenticationServices.Login(userLogin);
            if (reslut.IsSuccess)
                return Ok(reslut);

            return BadRequest(reslut);
        }



        [HttpPost(AuthenticationRouting.RegsiterStore)]
        public async Task<IActionResult> RegisterStore(CreateStoreDto storeCreate)
        {
            var reslut = await _authenticationServices.RegisterAsStore(storeCreate);
            if (reslut.IsSuccess)
                return Ok(reslut);

            return BadRequest(reslut);
        }

    }
}
