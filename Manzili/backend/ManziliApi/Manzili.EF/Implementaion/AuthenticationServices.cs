using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public class AuthenticationServices : IAuthenticationServices
    {
        #region Field
        private readonly UserServices _userServices;
        private readonly IStoreServices _storeServices;
        private readonly UserManager<User> _userManager;
        private readonly JwtSettings _jwtSettings;

        #endregion

        #region Constructor
        public AuthenticationServices(
            JwtSettings jwtSettings,
            UserManager<User> userManager,
            UserServices userServices,
            IStoreServices storeServices)
        {
            _jwtSettings = jwtSettings;
            _userManager = userManager;
            _userServices = userServices;
            _storeServices = storeServices;
        }
        #endregion

        #region Method

        private async Task<string> GenerateJwtToken(User user)
        {



            // initial claim

            var claims = new List<Claim>()
            {

                new Claim(ClaimTypes.Name , user.UserName),
                new Claim(ClaimTypes.NameIdentifier , user.Id.ToString()),

            };


            // add role to claim
            var roles = await _userManager.GetRolesAsync(user);
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }


            //var userClaims = await _userManager.GetClaimsAsync(user);
            //claims.AddRange(userClaims);




            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.Key));
            var signincred = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);



            // Create Token
            var jwtToken = new JwtSecurityToken(
                issuer: _jwtSettings.Issuer,
                audience: _jwtSettings.Audience,
                claims: claims,
                 expires: DateTime.UtcNow.AddYears(1),
                signingCredentials: signincred
                );

            var accessToken = new JwtSecurityTokenHandler().WriteToken(jwtToken);
            return accessToken;



        }
        public async Task<OperationResult<AuthModel>> RegisterAsUser(CreateUserDto userCreate)
        {

            User user = new User
            {
                UserName = userCreate.UserName,

                PhoneNumber = userCreate.PhoneNumber,
                Address = userCreate.Address,


            };


            var result = await _userServices.CreateAsync(userCreate);
            if (result.IsSuccess)
            {
                var authModel = new AuthModel
                {
                    id = user.Id,
                    token = await GenerateJwtToken(user)
                };


                return OperationResult<AuthModel>.Success(authModel);

            }



            return OperationResult<AuthModel>.Failure(result.Message);


        }
        public async Task<OperationResult<string>> RegisterAsStore(CreateStoreDto storeCreate , List<int> categories)
        {


           

            var user = new Store
            {
                PhoneNumber = storeCreate.PhoneNumber,
                UserName = storeCreate.UserName,

                Email = storeCreate.Email,
                Address = storeCreate.Address,
               
            };

            var result = await _storeServices.CreateAsync(storeCreate , categories);
            if (result.IsSuccess)
            {
                

                return OperationResult<string>.Success(await GenerateJwtToken(user));

            }


            return OperationResult<string>.Failure(result.Message);


        }
        public async Task<OperationResult<AuthModel>> Login(LoginUserDto userLogin)
        {
            var user = await _userManager.FindByEmailAsync(userLogin.Email);
            if (user == null || !await _userManager.CheckPasswordAsync(user, userLogin.Password))
                return OperationResult<AuthModel>.Failure("Invalid email or password");


            var authModel = new AuthModel
            {
                id = user.Id,
                token = await GenerateJwtToken(user)
            };

            return OperationResult<AuthModel>.Success(authModel);

        }
        #endregion  

    }
}
