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
        #region Field


        private readonly IRepository<Store> _storeRepository;

        private readonly UserManager<User> _storeManager;

        #endregion


        #region Constructor
        public StoreServices(UserManager<User> storeManager, IRepository<Store> storeRepository)
        {
            _storeManager=storeManager;
            _storeRepository=storeRepository;
        }
        #endregion


        #region Method
        public async Task<StoreGetDto> GetByIAsync(int id)
        {

            var store = await _storeRepository.Find(x => x.Id == id);
            StoreGetDto storesDtos = new StoreGetDto()
            {
                PhoneNumber = store.PhoneNumber,
                UserName = store.UserName,
                BusinessName = store.BusinessName,
                City = store.City,
                Address = store.Address,
                Email = store.Email,
                Status = store.Status,
                BankAccount = store.BankAccount,
                Image = store.Image,


            };


            return storesDtos;


        }
        public async Task<IEnumerable<StoreGetDto>> GetListAsync()
        {
            var stores = await _storeRepository.GetListNoTrackingAsync();
            IEnumerable<StoreGetDto> storesDtos = stores.Select(store => new StoreGetDto
            {
                UserName = store.UserName,
                PhoneNumber =store.PhoneNumber,
                Email = store.Email,
                City = store.City,
                Address = store.Address,
                BusinessName = store.BusinessName,
                BankAccount = store.BankAccount,
                Image = store.Image,
                Status = store.Status,



            }).ToList();


            return storesDtos;


        }
        public async Task<string> AddAsycn(StoreCreateDto storeDto)
        {

            var stores = await _storeRepository.ExistsAsync(x => x.BusinessName == storeDto.BusinessName);
            if (stores)
                return "BusinessName Already Exists";



            var storeByEmail = await _storeManager.FindByEmailAsync(storeDto.Email);
            if (storeByEmail != null)
                return "Email Already Exists";


            var storeByPhone = await _storeManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == storeDto.PhoneNumber);
            if (storeByPhone != null)
                return "User PhoneNumber Already Exists";



            User store = new Store()
            {

                UserName = storeDto.UserName,
                FirstName = storeDto.FirstName,
                LastName = storeDto.LastName,
                Email = storeDto.Email,
                City = storeDto.City,
                Address = storeDto.Address,
                BankAccount =storeDto.BankAccount,
                Image = storeDto.Image,
                Status = storeDto.Status,
                BusinessName = storeDto.BusinessName,
                PhoneNumber = storeDto.PhoneNumber,


            };


            var reslutCreate = await _storeManager.CreateAsync(store, storeDto.Password);
            if (!reslutCreate.Succeeded)
                return string.Join("; ", reslutCreate.Errors.Select(e => e.Description));

            return "Added successfully";




            //var userByName = await _storeManager.FindByNameAsync(store.UserName);
            //if (userByName != null)
            //    return "User Name Already Exists";






            //var roleExist = await _roleManager.RoleExistsAsync(role);
            //if (!roleExist)
            //    return "ThisRoleNotExists";


            //await _userManager.AddToRoleAsync(user, role);

            //var token = await _authenticatiomServices.CreateToken(user);

            //return token;

        }
        public async Task<string> UpdateAsync(StoreUpdateDto newStore)
        {
            //  var oldStore2 = await _storeRepository.GetByIdAsync(x => x.Email == newStore.Email);

            var oldStore = await _storeRepository.Find(x => x.Id == newStore.storeId);
            if (oldStore == null)
                return "User Not Exists";


            //if(oldStore.UserName !=  newStore.UserName)
            //{
            //    var userStore = await _storeRepository.ExistsAsync(x => x.UserName == newStore.UserName);
            //    if (userStore)
            //        return "User Already Exists";

            //}

            if (oldStore.UserName != newStore.UserName)
            {
                var userByName = await _storeManager.FindByNameAsync(newStore.UserName);
                if (userByName != null)
                    return "User Name Already Exists";
            }


            var userByEmail = await _storeManager.FindByEmailAsync(newStore.Email);
            if (userByEmail != null)
                return "Email Already Exists";


            if (newStore.BusinessName != oldStore.BusinessName)
            {
                var storeName = await _storeRepository.ExistsAsync(x => x.BusinessName == newStore.BusinessName);
                if (storeName)
                    return "BusinessName Already Exists";
            }


            if (newStore.PhoneNumber != oldStore.PhoneNumber)
            {
                var userByPhone = await _storeManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newStore.PhoneNumber);
                if (userByPhone != null)
                    return "User PhoneNumber Already Exists";
            }


            //if (newStore.PhoneNumber != oldStore.PhoneNumber)
            //{
            //    var userByPhone = await _storeManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == newStore.PhoneNumber);
            //    if (userByPhone != null)
            //        return "User PhoneNumber Already Exists";
            //}


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
            return "Updated successfully";


        }
        public async Task<string> DeleteAsync(int id)
        {
            var user = await _storeRepository.Find(x => x.Id == id);
            if (user == null)
                return "User Not Exists";


            await _storeRepository.Delete(user);
            return "Deleted successfully";

        }

        #endregion
    }
}
