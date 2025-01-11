//using Manzili.Core.Dto.UserDto;
//using Manzili.Core.Entities;
//using Mapster;
//using Microsoft.AspNetCore.Identity;
//using Microsoft.EntityFrameworkCore;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace Manzili.Core.Services
//{

//    public class UserServices
//    {
//        #region Field

//        private readonly UserManager<User> _userManager;

//        #endregion


//        #region Constructor
//        public UserServices(UserManager<User> userManager)
//        {
//            _userManager=userManager;
//        }
//        #endregion


//        #region Method
//        public async Task<string> AddAsycn(UserCreateDto userDto, string password)
//        {


//            var userByEmail = await _userManager.FindByEmailAsync(userDto.Email);
//            if (userByEmail != null)
//                return "Email Already Exists";



//            //var userByName = await _userManager.FindByNameAsync(userDto.UserName);
//            //if (userByName != null)
//            //    return "User Name Already Exists";



//            var userByPhone = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == userDto.PhoneNumber);
//            if (userByPhone != null)
//                return "User PhoneNumber Already Exists";

//            User user = new User()
//            {
//                PhoneNumber = userDto.PhoneNumber,
//                UserName = userDto.UserName,
//                FirstName = userDto.FirstName,
//                LastName = userDto.LastName,
//                Email = userDto.Email,
//                City = userDto.City,
//                Address = userDto.Address
//            };









//            //var roleExist = await _roleManager.RoleExistsAsync(role);
//            //if (!roleExist)
//            //    return "ThisRoleNotExists";



//            var reslutCreate = await _userManager.CreateAsync(user, password);


//            if (!reslutCreate.Succeeded)
//                return string.Join("; ", reslutCreate.Errors.Select(e => e.Description));

//            return "Added Successfully";




//            //await _userManager.AddToRoleAsync(user, role);

//            //var token = await _authenticatiomServices.CreateToken(user);

//            //return token;

//        }
//        public async Task<IEnumerable<UserGetDto>> GetListAsync()
//        {

//            var users = await _userManager.Users.AsNoTracking().ToListAsync();

//            return users.Adapt<IEnumerable<UserGetDto>>();


//        }
//        public async Task<string> UpdateAsync(UserUpdateDto newUser , int id)
//        {


//            var oldUser = await _userManager.FindByIdAsync(id.ToString());
//            if (oldUser == null)
//                return "User Not Found";

//            if (newUser.UserName != oldUser.UserName)
//            {
//                var userByName = await _userManager.FindByNameAsync(newUser.UserName);
//                if (userByName != null)
//                    return "User Name Already Exists";
//            }


//            var userByEmail = await _userManager.FindByEmailAsync(newUser.Email);
//            if (userByEmail != null)
//                return "Email Already Exists";





//            if (newUser.PhoneNumber != oldUser.PhoneNumber)
//            {
//                var userByPhone = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newUser.PhoneNumber);
//                if (userByPhone != null)
//                    return "User PhoneNumber Already Exists";
//            }


//            oldUser.UserName = newUser.UserName;
//            oldUser.FirstName = newUser.FirstName;
//            oldUser.LastName = newUser.LastName;
//            oldUser.PhoneNumber = newUser.PhoneNumber;
//            oldUser.City = newUser.City;
//            oldUser.Address = newUser.Address;
//            oldUser.Email = newUser.Email;


//            var resultEdit = await _userManager.UpdateAsync(oldUser);

//            if (!resultEdit.Succeeded)
//            {
//                return string.Join("; ", resultEdit.Errors.Select(e => e.Description));
//            }

//            return "Successed";
//        }
//        public async Task<string> DeleteAsync(int id)
//        {
//            var user = await _userManager.FindByIdAsync(id.ToString());
//            if (user == null)
//                return "User Not Found";


//            await _userManager.DeleteAsync(user);
//            return "Deleteed Success";

//        }

//        #endregion
//    }
//}



using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using Mapster;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

public class UserServices
{
    private readonly UserManager<User> _userManager;


    public UserServices(UserManager<User> userManager)
    {
        _userManager = userManager;

    }

    //private async Task<OperationResult> CheckUserExistenceAsync(string email, string phoneNumber)
    //{
    //    if (await _userManager.FindByEmailAsync(email) != null)
    //        return OperationResult.Failure("Email Already Exists");

    //    if (await _userManager.Users.AnyAsync(u => u.PhoneNumber == phoneNumber))
    //        return OperationResult.Failure("User PhoneNumber Already Exists");

    //    return OperationResult.Success(string.Empty);
    //}
    public async Task<OperationResult> CreateAsync(UserCreateDto userDto, string password)
    {

        if (await _userManager.FindByEmailAsync(userDto.Email) != null)
            return OperationResult.Failure("Email already exists");

        if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == userDto.PhoneNumber) != null)
            return OperationResult.Failure("PhoneNumber already exists");

        //var existenceCheck = await CheckUserExistenceAsync(userDto.Email, userDto.PhoneNumber);
        //if (!existenceCheck.IsSuccess)
        //    return existenceCheck;

        User user = new User
        {
            PhoneNumber = userDto.PhoneNumber,
            UserName = userDto.UserName,
            FirstName = userDto.FirstName,
            LastName = userDto.LastName,
            Email = userDto.Email,
            City = userDto.City,
            Address = userDto.Address
        };

        var result = await _userManager.CreateAsync(user, password);

        if (!result.Succeeded)
            return OperationResult.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

        return OperationResult.Success("Added Successfully");
    }
    public async Task<IEnumerable<UserGetDto>> GetListAsync()
    {
        var users = await _userManager.Users.AsNoTracking().ToListAsync();
        return users.Adapt<IEnumerable<UserGetDto>>();
    }
    public async Task<OperationResult> UpdateAsync(UserUpdateDto newUser, int id)
    {
        var oldUser = await _userManager.FindByIdAsync(id.ToString());
        if (oldUser == null)
            return OperationResult.Failure("User Not Found");

        if (oldUser.Email != newUser.Email)
        {
            if (await _userManager.FindByEmailAsync(newUser.Email) != null)
                return OperationResult.Failure("Email already exists");

            //var existenceCheck = await CheckEmailExistenceAsync(newUser.Email);
            //if (!existenceCheck.IsSuccess)
            //    return existenceCheck;
        }

        if (oldUser.PhoneNumber != newUser.PhoneNumber)
        {
            if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newUser.PhoneNumber) != null)
                return OperationResult.Failure("PhoneNumber already exists");
        }



        oldUser.UserName = newUser.UserName;
        oldUser.FirstName = newUser.FirstName;
        oldUser.LastName = newUser.LastName;
        oldUser.PhoneNumber = newUser.PhoneNumber;
        oldUser.City = newUser.City;
        oldUser.Address = newUser.Address;
        oldUser.Email = newUser.Email;

        var resultEdit = await _userManager.UpdateAsync(oldUser);
        if (!resultEdit.Succeeded)
            return OperationResult.Failure(string.Join("; ", resultEdit.Errors.Select(e => e.Description)));

        return OperationResult.Success("Successfully Updated");
    }
    public async Task<OperationResult> DeleteAsync(int id)
    {
        var user = await _userManager.FindByIdAsync(id.ToString());
        if (user == null)
            return OperationResult.Failure("User Not Found");

        await _userManager.DeleteAsync(user);
        return OperationResult.Success("Successfully Deleted");
    }







    //private async Task<OperationResult> CheckPhoneNumberExistenceAsync(string phoneNumber)
    //{
       
    //    if (await _userManager.Users.AnyAsync(u => u.PhoneNumber == phoneNumber))
    //        return OperationResult.Failure("User PhoneNumber Already Exists");

    //    return OperationResult.Success(string.Empty);
    //}
    //private async Task<OperationResult> CheckEmailExistenceAsync(string email)
    //{
    //    if (await _userManager.FindByEmailAsync(email) != null)
    //        return OperationResult.Failure("Email Already Exists");

    //    return OperationResult.Success(string.Empty);
    //}




}
