using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
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
    public class AuthenticationServices
    {
        #region Field
        private readonly UserServices _userServices;
        private readonly StoreServices _storeServices;
        private readonly UserManager<User> _userManager;
        private readonly IRepository<User> _userRepo;
        private readonly JwtSettings _jwtSettings;

        #endregion


        #region Constructor
        public AuthenticationServices(IRepository<User> userRepo, JwtSettings jwtSettings, UserManager<User> userManager, UserServices userServices, StoreServices storeServices)
        {
            _userRepo=userRepo;
            _jwtSettings=jwtSettings;
            _userManager=userManager;
            _userServices=userServices;
            _storeServices=storeServices;
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
        public async Task<OperationResult<string>> RegisterAsUser(UserCreateDto userCreate)
        {

            User user = new User
            {
                PhoneNumber = userCreate.PhoneNumber,
                UserName = userCreate.UserName,
                FirstName = userCreate.FirstName,
                LastName = userCreate.LastName,
                Email = userCreate.Email,
                City = userCreate.City,
                Address = userCreate.Address
            };

            var result = await _userServices.CreateAsync(userCreate);
            if (result.IsSuccess)
                return OperationResult<string>.Success(await GenerateJwtToken(user));



            return OperationResult<string>.Failure(result.Message);
                

        }
        public async Task<OperationResult<string>> RegisterAsStore(StoreCreateDto storeCreate)
        {

            var user = new Store
            {
                PhoneNumber = storeCreate.PhoneNumber,
                UserName = storeCreate.UserName,
                FirstName = storeCreate.FirstName,
                LastName = storeCreate.LastName,
                Email = storeCreate.Email,
                City = storeCreate.City,
                Address = storeCreate.Address
            };

            var result = await _storeServices.CreateAsync(storeCreate);
            if (result.IsSuccess)
                return OperationResult<string>.Success(await GenerateJwtToken(user));


            return OperationResult<string>.Failure(result.Message);


        }
        public async Task<OperationResult<string>> Login(UserLoginDto userLogin)
        {
            var user = await _userManager.FindByEmailAsync(userLogin.Email);
            if (user == null || !await _userManager.CheckPasswordAsync(user, userLogin.Password))
                return  OperationResult<string>.Failure("Invalid email or password");

            return OperationResult<string>.Success(await GenerateJwtToken(user));

        }
        #endregion  

    }
}
