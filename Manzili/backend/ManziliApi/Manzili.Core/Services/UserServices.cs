using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Mapster;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
   
    public class UserServices
    {
        #region Field

        private readonly UserManager<User> _userManager;

        #endregion


        #region Constructor
        public UserServices(UserManager<User> userManager)
        {
            _userManager=userManager;
        }
        #endregion


        #region Method
        public async Task<string> AddAsycn(User user, string password)
        {
            var userByEmail = await _userManager.FindByEmailAsync(user.Email);
            if (userByEmail != null)
                return "Email Already Exists";



            var userByName = await _userManager.FindByNameAsync(user.UserName);
            if (userByName != null)
                return "User Name Already Exists";



            var userByPhone = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == user.PhoneNumber);
            if (userByPhone != null)
                return "User PhoneNumber Already Exists";



            //var roleExist = await _roleManager.RoleExistsAsync(role);
            //if (!roleExist)
            //    return "ThisRoleNotExists";



            var reslutCreate = await _userManager.CreateAsync(user, password);


            if (!reslutCreate.Succeeded)
                return string.Join("; ", reslutCreate.Errors.Select(e => e.Description));

            return "Successed";

            


            //await _userManager.AddToRoleAsync(user, role);

            //var token = await _authenticatiomServices.CreateToken(user);

            //return token;

        }
        public async Task<IEnumerable<UserGetDto>> GetListAsync()
        {

            var users = await _userManager.Users.AsNoTracking().ToListAsync();
               
            return users.Adapt<IEnumerable<UserGetDto>>();


        }
        public async Task<string> UpdateAsync(UserUpdateDto newUser)
        {
            var oldUser = await _userManager.FindByIdAsync(newUser.UserId.ToString());
            if (oldUser == null)
                return "User Not Found";

            if (newUser.UserName != oldUser.UserName)
            {
                var userByName = await _userManager.FindByNameAsync(newUser.UserName);
                if (userByName != null)
                    return "User Name Already Exists";
            }


            if (newUser.PhoneNumber != oldUser.PhoneNumber)
            {
                var userByPhone = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newUser.PhoneNumber);
                if (userByPhone != null)
                    return "User PhoneNumber Already Exists";
            }


            oldUser.UserName = newUser.UserName;
            oldUser.PhoneNumber = newUser.PhoneNumber;
            oldUser.City = newUser.City;
            oldUser.Address = newUser.Address;
            oldUser.Email = newUser.Email;
            var resultEdit = await _userManager.UpdateAsync(oldUser);

            if (!resultEdit.Succeeded)
            {
                return string.Join("; ", resultEdit.Errors.Select(e => e.Description));
            }

            return "Successed";
        }
        public async Task<string> DeleteAsync(int id)
        {
            var user = await _userManager.FindByIdAsync(id.ToString());
            if (user == null)
                return "User Not Found";


            await _userManager.DeleteAsync(user);
            return "Deleteed Success";

        }

        #endregion
    }
}
