
using Manzili.Core.Dto.StoreDtp;
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
        private readonly UserManager<User> _storeManager;

        #endregion

        #region Constructor

        public StoreServices(UserManager<User> storeManager, IRepository<Store> storeRepository)
        {
            _storeManager = storeManager;
            _storeRepository = storeRepository;
        }

        #endregion

        #region Methods

        public async Task<StoreGetDto> GetByIdAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id);
            if (store == null) return null;

            return new StoreGetDto
            {
                PhoneNumber = store.PhoneNumber,
                UserName = store.UserName,
                BusinessName = store.BusinessName,
                City = store.City,
                Address = store.Address,
                Email = store.Email,
                Status = store.Status,
                BankAccount = store.BankAccount,
                Image = store.Image
            };

               
            
        }

        public async Task<IEnumerable<StoreGetDto>> GetListAsync()
        {
            var stores = await _storeRepository.GetListNoTrackingAsync();
            return stores.Select(store => new StoreGetDto
            {
                UserName = store.UserName,
                PhoneNumber = store.PhoneNumber,
                Email = store.Email,
                City = store.City,
                Address = store.Address,
                BusinessName = store.BusinessName,
                BankAccount = store.BankAccount,
                Image = store.Image,
                Status = store.Status
            }).ToList();
        }

        public async Task<OperationResult<StoreCreateDto>> CreateAsync(StoreCreateDto storeDto)
        {


            if (await _storeRepository.ExistsAsync(x => x.BusinessName == storeDto.BusinessName))
                return OperationResult<StoreCreateDto>.Failure("BusinessName already exists");

            if (await _storeManager.FindByEmailAsync(storeDto.Email) != null)
                return OperationResult<StoreCreateDto>.Failure("Email already exists");

            if (await _storeManager.Users.AnyAsync(u => u.PhoneNumber == storeDto.PhoneNumber))
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

            var result = await _storeManager.CreateAsync(store, storeDto.Password);
            if (!result.Succeeded)
                return OperationResult<StoreCreateDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

            return OperationResult<StoreCreateDto>.Success(data : storeDto);
        }

        public async Task<OperationResult<StoreUpdateDto>> UpdateAsync(StoreUpdateDto newStore)
        {
            var oldStore = await _storeRepository.Find(x => x.Id == newStore.storeId);
            if (oldStore == null) return OperationResult<StoreUpdateDto>.Failure("Store not found");

           

            if (oldStore.Email != newStore.Email &&
                await _storeManager.FindByEmailAsync(newStore.Email) != null)
                return OperationResult<StoreUpdateDto>.Failure("Email already exists");

            if (oldStore.PhoneNumber != newStore.PhoneNumber &&
                await _storeManager.Users.AnyAsync(u => u.PhoneNumber == newStore.PhoneNumber))
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
            return OperationResult<StoreUpdateDto>.Success(data : newStore);
        }

        public async Task<OperationResult<Store>> DeleteAsync(int id)
        {
            var store = await _storeRepository.Find(x => x.Id == id);
            if (store == null) return OperationResult<Store>.Failure("Store not found");

            await _storeRepository.Delete(store);
            return OperationResult<Store>.Success(data : store);
        }

        #endregion
    }
}

