
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

        #endregion

        #region Constructor

        public StoreServices(UserManager<User> storeManager, IRepository<Store> storeRepository)
        {
            _userManager = storeManager;
            _storeRepository = storeRepository;
        }

        #endregion

        #region Methods

        public async Task<OperationResult<StoreGetDto>> GetByIdAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id);
            if (store == null) return OperationResult<StoreGetDto>.Failure(message: "Store not found");

            return OperationResult<StoreGetDto>.Success(new StoreGetDto
            {
                PhoneNumber = store.PhoneNumber,
                UserName = store.UserName,
                FirstName = store.FirstName,
                LastName = store.LastName,
                BusinessName = store.BusinessName,
                City = store.City,
                Address = store.Address,
                Email = store.Email,
                Status = store.Status,
                BankAccount = store.BankAccount,
                Image = store.Image
            });

               
            
        }

        public async Task<OperationResult<IEnumerable<StoreGetDto>>> GetListAsync()
        {
            var stores = await _storeRepository.GetListNoTrackingAsync();

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<StoreGetDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new StoreGetDto
            {
                UserName = store.UserName,
                FirstName = store.FirstName,
                LastName = store.LastName,
                PhoneNumber = store.PhoneNumber,
                Email = store.Email,
                City = store.City,
                Address = store.Address,
                BusinessName = store.BusinessName,
                BankAccount = store.BankAccount,
                Image = store.Image,
                Status = store.Status
            });

            return OperationResult<IEnumerable<StoreGetDto>>.Success(storeDtos);
        }

        public async Task<OperationResult<StoreCreateDto>> CreateAsync(StoreCreateDto storeDto)
        {


            if (await _storeRepository.ExistsAsync(x => x.BusinessName == storeDto.BusinessName))
                return OperationResult<StoreCreateDto>.Failure("BusinessName already exists");

            if (await _userManager.FindByEmailAsync(storeDto.Email) != null)
                return OperationResult<StoreCreateDto>.Failure("Email already exists");


            if (await _userManager.Users.AnyAsync(u => u.PhoneNumber == storeDto.PhoneNumber))
                return OperationResult<StoreCreateDto>.Failure("PhoneNumber already exists");

            var store = new Store
            {
                UserName = storeDto.UserName,
                FirstName = storeDto.FirstName,
                LastName = storeDto.LastName,
                Email = storeDto.Email,
                City = storeDto.City,
                Address = storeDto.Address,
                BankAccount = storeDto.BankAccount,
                Image = storeDto.Image,
                Status = storeDto.Status,
                BusinessName = storeDto.BusinessName,
                PhoneNumber = storeDto.PhoneNumber
            };

            var result = await _userManager.CreateAsync(store, storeDto.Password);
            if (!result.Succeeded)
                return OperationResult<StoreCreateDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

            return OperationResult<StoreCreateDto>.Success(data : storeDto);
        }

        public async Task<OperationResult<StoreUpdateDto>> UpdateAsync(StoreUpdateDto newStore)
        {

            var olduser = await _userManager.FindByIdAsync(newStore.storeId.ToString());
            if (olduser.UserName != newStore.UserName)
            {
                var users = await _userManager.Users.AsNoTracking().AsQueryable().AnyAsync(x => x.UserName == newStore.UserName);

                if (users)
                {
                    return OperationResult<StoreUpdateDto>.Failure("UserName Is Already Used");
                }
            }

            

            var oldStore = await _storeRepository.Find(x => x.Id == newStore.storeId);
            if (oldStore == null) return OperationResult<StoreUpdateDto>.Failure("Store not found");

           

            if (oldStore.Email != newStore.Email &&
                await _userManager.FindByEmailAsync(newStore.Email) != null)
                return OperationResult<StoreUpdateDto>.Failure("Email already exists");

            if (oldStore.PhoneNumber != newStore.PhoneNumber &&
                await _userManager.Users.AnyAsync(u => u.PhoneNumber == newStore.PhoneNumber))
                return OperationResult<StoreUpdateDto>.Failure("PhoneNumber already exists");

            if (oldStore.BusinessName != newStore.BusinessName &&
                await _storeRepository.ExistsAsync(x => x.BusinessName == newStore.BusinessName))
                return OperationResult<StoreUpdateDto>.Failure("BusinessName already exists");

            oldStore.UserName = newStore.UserName;
            oldStore.FirstName = newStore.FirstName;
            oldStore.LastName = newStore.LastName;
            oldStore.PhoneNumber = newStore.PhoneNumber;
            oldStore.City = newStore.City;
            oldStore.Address = newStore.Address;
            oldStore.Email = newStore.Email;
            oldStore.BusinessName = newStore.BusinessName;
            oldStore.BankAccount = newStore.BankAccount;



         

            await _storeRepository.Update(oldStore);
            return OperationResult<StoreUpdateDto>.Success(newStore);
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

