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

    public async Task<UserGetDto> GetByIdAsync(int id)
    {
        var user = await _userManager.FindByIdAsync(id.ToString());
        return new UserGetDto { UserName = user.UserName , FirstName = user.FirstName, LastName = user.LastName, Email = user.Email,PhoneNumber = user.PhoneNumber ,City = user.City , Address = user.Address };

    }
    public async Task<OperationResult> CreateAsync(UserCreateDto userDto)
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

        var result = await _userManager.CreateAsync(user, userDto.Password);

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







   

}
