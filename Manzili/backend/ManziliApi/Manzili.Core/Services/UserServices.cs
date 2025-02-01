using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using Manzili.Core.Services;
using Mapster;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using static System.Formats.Asn1.AsnWriter;

public class UserServices
{
    private readonly UserManager<User> _userManager;
    private readonly FileService _fileService;


    public UserServices(UserManager<User> userManager, FileService fileService)
    {
        _userManager = userManager;
        _fileService = fileService;
    }

    public async Task<OperationResult<UserGetDto>> GetByIdAsync(int id)
    {
        var user = await _userManager.FindByIdAsync(id.ToString());
        if (user == null) return OperationResult<UserGetDto>.Failure(message: "User not found");

        return OperationResult<UserGetDto>.Success(new UserGetDto
        {
            UserName = user.UserName, 
            FirstName = user.FirstName,
            LastName = user.LastName,
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            City = user.City,
            Address = user.Address,
        });
        

    }
    public async Task<OperationResult<UserCreateDto>> CreateAsync(UserCreateDto userDto)
    {

      
        if (await _userManager.FindByEmailAsync(userDto.Email) != null)
            return OperationResult<UserCreateDto>.Failure("Email already exists");

        if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == userDto.PhoneNumber) != null)
            return OperationResult<UserCreateDto>.Failure("PhoneNumber already exists");


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
            return OperationResult<UserCreateDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

        if(userDto.Image != null)
        {

            if (!ImageValidator.IsValidImage(userDto.Image, out string errorMessage))
            {
                await _userManager.DeleteAsync(user);
                return OperationResult<UserCreateDto>.Failure(message: errorMessage);
            }

            string imagePath = await _fileService.UploadImageAsync("Profile", userDto.Image);
            if (imagePath == "FailedToUploadImage")
            {
                await _userManager.DeleteAsync(user);
                return OperationResult<UserCreateDto>.Failure("Failed to upload image");
            }

            user.Image = imagePath;
            await _userManager.UpdateAsync(user);
        }
           

      
        return OperationResult<UserCreateDto>.Success(userDto);
    }
    public async Task<OperationResult<IEnumerable<UserGetDto>>> GetListAsync()
    {
        var users = await _userManager.Users.AsNoTracking().ToListAsync();
        if(users is null)
             return OperationResult<IEnumerable<UserGetDto>>.Failure(message: "Users not found");


        return OperationResult<IEnumerable<UserGetDto>>.Success(


            users.Adapt<IEnumerable<UserGetDto>>()

            );
        
           

    }
    public async Task<OperationResult<UserUpdateDto>> UpdateAsync(UserUpdateDto newUser, int id)
    {
        var oldUser = await _userManager.FindByIdAsync(id.ToString());
        if (oldUser == null)
            return OperationResult<UserUpdateDto>.Failure("User Not Found");

        if (oldUser.Email != newUser.Email)
        {
            if (await _userManager.FindByEmailAsync(newUser.Email) != null)
                return OperationResult<UserUpdateDto>.Failure("Email already exists");

            //var existenceCheck = await CheckEmailExistenceAsync(newUser.Email);
            //if (!existenceCheck.IsSuccess)
            //    return existenceCheck;
        }

        if (oldUser.PhoneNumber != newUser.PhoneNumber)
        {
            if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newUser.PhoneNumber) != null)
                return OperationResult<UserUpdateDto>.Failure("PhoneNumber already exists");
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
            return OperationResult<UserUpdateDto>.Failure(string.Join("; ", resultEdit.Errors.Select(e => e.Description)));

        return OperationResult<UserUpdateDto>.Success(newUser);
    }
    public async Task<OperationResult<User>> DeleteAsync(int id)
    {
        var user = await _userManager.FindByIdAsync(id.ToString());
        if (user == null)
            return OperationResult<User>.Failure("User Not Found");

        await _userManager.DeleteAsync(user);
        return OperationResult<User>.Success(user);
    }







   

}
