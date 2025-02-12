
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace Manzili.Core.Services
{
    public class StoreServices
    {
        #region Fields

        private readonly IRepository<Store> _storeRepository;
        private readonly UserManager<User> _userManager;
        private readonly FileService _fileService;

        #endregion

        #region Constructor

        public StoreServices(UserManager<User> storeManager, IRepository<Store> storeRepository, FileService fileService)
        {
            _userManager = storeManager;
            _storeRepository = storeRepository;
            _fileService = fileService;
        }

        #endregion

        #region Methods

        public async Task<OperationResult<GetStoreDto>> GetByIdAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id);
            if (store == null) return OperationResult<GetStoreDto>.Failure(message: "Store not found");

            return OperationResult<GetStoreDto>.Success(new GetStoreDto
            {
                UserId = store.Id,
                ImageUrl = store.ImageUrl,
                BusinessName = store.BusinessName,
                Description = store.Description,
                Status = store.Status,
                Rate = store.Rate  

            });

               
            
        }
        public async Task<OperationResult<GetFullInfoStoreDto>> GetWithProductsAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id , ["Product"]);
            if (store == null) return OperationResult<GetFullInfoStoreDto>.Failure(message: "Store not found");

            return OperationResult<GetFullInfoStoreDto>.Success(new GetFullInfoStoreDto
            {
                UserId = store.Id,
                ImageUrl = store.ImageUrl,
                BusinessName = store.BusinessName,
                Description = store.Description,
                Address = store.Address,
                BankAccount = store.BankAccount,
                PhoneNumber = store.PhoneNumber,
                Status = store.Status,
                Rate = store.Rate,


            });



        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync()
        {
            var stores = await _storeRepository.GetListNoTrackingAsync();

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto
            {
                UserId = store.Id,
                ImageUrl = store.ImageUrl,
                BusinessName = store.BusinessName,
                Description = store.Description,
                Status = store.Status,
                Rate = store.Rate
            });

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page , int pageSize )
        {
            var stores = await _storeRepository.GetToPagination(page, pageSize);

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto
            {
                UserId = store.Id,
                ImageUrl = store.ImageUrl,
                BusinessName = store.BusinessName,
                Description = store.Description,
                Status = store.Status,
                Rate = store.Rate
            });

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }

        public async Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto)
        {


            if (await _storeRepository.ExistsAsync(x => x.BusinessName == storeDto.BusinessName))
                return OperationResult<CreateStoreDto>.Failure("BusinessName already exists");

            if (await _userManager.FindByEmailAsync(storeDto.Email) != null)
                return OperationResult<CreateStoreDto>.Failure("Email already exists");


            if (await _userManager.Users.AnyAsync(u => u.PhoneNumber == storeDto.PhoneNumber))
                return OperationResult<CreateStoreDto>.Failure("PhoneNumber already exists");

            var store = new Store
            {
                
                UserName = storeDto.UserName,
                BusinessName = storeDto.BusinessName,
                Description = storeDto.Description,
                Email = storeDto.Email,
                Address = storeDto.Address,
                BankAccount = storeDto.BankAccount,
                PhoneNumber = storeDto.PhoneNumber
            };

            var result = await _userManager.CreateAsync(store, storeDto.Password);
            if (!result.Succeeded)
                return OperationResult<CreateStoreDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));



            if(storeDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(storeDto.Image, out string errorMessage))
                {
                    await _userManager.DeleteAsync(store);
                    return OperationResult<CreateStoreDto>.Failure(message: errorMessage);
                }

                string imagePath = await _fileService.UploadImageAsync("Profile", storeDto.Image);
                if (imagePath == "FailedToUploadImage")
                {
                    await _userManager.DeleteAsync(store);
                    return OperationResult<CreateStoreDto>.Failure("Failed to upload image");
                }


                store.ImageUrl = imagePath;
                await _userManager.UpdateAsync(store);
            }

            return OperationResult<CreateStoreDto>.Success(data : storeDto);
        }
        public async Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore , int storeId)
        {

            var olduser = await _userManager.FindByIdAsync(storeId.ToString());
            if (olduser.UserName != newStore.UserName)
            {
                var users = await _userManager.Users.AsNoTracking().AsQueryable().AnyAsync(x => x.UserName == newStore.UserName);

                if (users)
                {
                    return OperationResult<UpdateStoreDto>.Failure("UserName Is Already Used");
                }
            }

            

            var oldStore = await _storeRepository.Find(x => x.Id == storeId);
            if (oldStore == null) return OperationResult<UpdateStoreDto>.Failure("Store not found");

           

            if (oldStore.Email != newStore.Email &&
                await _userManager.FindByEmailAsync(newStore.Email) != null)
                return OperationResult<UpdateStoreDto>.Failure("Email already exists");

            if (oldStore.PhoneNumber != newStore.PhoneNumber &&
                await _userManager.Users.AnyAsync(u => u.PhoneNumber == newStore.PhoneNumber))
                return OperationResult<UpdateStoreDto>.Failure("PhoneNumber already exists");

            if (oldStore.BusinessName != newStore.BusinessName &&
                await _storeRepository.ExistsAsync(x => x.BusinessName == newStore.BusinessName))
                return OperationResult<UpdateStoreDto>.Failure("BusinessName already exists");

            oldStore.UserName = newStore.UserName;
           
            oldStore.PhoneNumber = newStore.PhoneNumber;
            oldStore.Address = newStore.Address;
            oldStore.Email = newStore.Email;
            oldStore.BusinessName = newStore.BusinessName;
            oldStore.BankAccount = newStore.BankAccount;



         

            await _storeRepository.Update(oldStore);
            return OperationResult<UpdateStoreDto>.Success(newStore);
        }
        public async Task<OperationResult<Store>> DeleteAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id);
            if (store == null) return OperationResult<Store>.Failure("Store not found");

            await _storeRepository.Delete(store);
            return OperationResult<Store>.Success(store);
        }

        #endregion
    }
}

