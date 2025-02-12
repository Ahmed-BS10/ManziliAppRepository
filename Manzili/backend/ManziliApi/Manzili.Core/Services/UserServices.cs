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

    public async Task<OperationResult<GetUserDto>> GetByIdAsync(int id)
    {
        var user = await _userManager.FindByIdAsync(id.ToString());
        if (user == null) return OperationResult<GetUserDto>.Failure(message: "User not found");

        return OperationResult<GetUserDto>.Success(new GetUserDto
        {
            UserName = user.UserName, 
           
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            Address = user.Address,
        });
        

    }
    public async Task<OperationResult<CreateUserDto>> CreateAsync(CreateUserDto userDto)
    {

      
        if (await _userManager.FindByEmailAsync(userDto.Email) != null)
            return OperationResult<CreateUserDto>.Failure("Email already exists");

        if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == userDto.PhoneNumber) != null)
            return OperationResult<CreateUserDto>.Failure("PhoneNumber already exists");


        User user = new User
        {
            PhoneNumber = userDto.PhoneNumber,
            UserName = userDto.UserName,
           
            Email = userDto.Email,
            Address = userDto.Address
            
        };



        var result = await _userManager.CreateAsync(user, userDto.Password);

        if (!result.Succeeded)
            return OperationResult<CreateUserDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

        if(userDto.Image != null)
        {

            if (!ImageValidator.IsValidImage(userDto.Image, out string errorMessage))
            {
                await _userManager.DeleteAsync(user);
                return OperationResult<CreateUserDto>.Failure(message: errorMessage);
            }

            string imagePath = await _fileService.UploadImageAsync("Profile", userDto.Image);
            if (imagePath == "FailedToUploadImage")
            {
                await _userManager.DeleteAsync(user);
                return OperationResult<CreateUserDto>.Failure("Failed to upload image");
            }

            user.ImageUrl = imagePath;
            await _userManager.UpdateAsync(user);
        }
           

      
        return OperationResult<CreateUserDto>.Success(userDto);
    }
    public async Task<OperationResult<IEnumerable<GetUserDto>>> GetListAsync()
    {
        var users = await _userManager.Users.AsNoTracking().ToListAsync();
        if(users is null)
             return OperationResult<IEnumerable<GetUserDto>>.Failure(message: "Users not found");


        return OperationResult<IEnumerable<GetUserDto>>.Success(


            users.Adapt<IEnumerable<GetUserDto>>()

            );
        
           

    }
    public async Task<OperationResult<UpdateUserDto>> UpdateAsync(UpdateUserDto newUser, int id)
    {
        var oldUser = await _userManager.FindByIdAsync(id.ToString());
        if (oldUser == null)
            return OperationResult<UpdateUserDto>.Failure("User Not Found");

        if (oldUser.Email != newUser.Email)
        {
            if (await _userManager.FindByEmailAsync(newUser.Email) != null)
                return OperationResult<UpdateUserDto>.Failure("Email already exists");

            //var existenceCheck = await CheckEmailExistenceAsync(newUser.Email);
            //if (!existenceCheck.IsSuccess)
            //    return existenceCheck;
        }

        if (oldUser.PhoneNumber != newUser.PhoneNumber)
        {
            if (await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newUser.PhoneNumber) != null)
                return OperationResult<UpdateUserDto>.Failure("PhoneNumber already exists");
        }



        oldUser.UserName = newUser.UserName;
       
        oldUser.PhoneNumber = newUser.PhoneNumber;
        oldUser.Address = newUser.Address;
        oldUser.Email = newUser.Email;

        var resultEdit = await _userManager.UpdateAsync(oldUser);
        if (!resultEdit.Succeeded)
            return OperationResult<UpdateUserDto>.Failure(string.Join("; ", resultEdit.Errors.Select(e => e.Description)));

        return OperationResult<UpdateUserDto>.Success(newUser);
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
