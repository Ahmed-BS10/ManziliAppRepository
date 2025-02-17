using Azure;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Manzili.Core.Extension;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.Implementaion
{
    public class StoreServices : IStoreServices
    {
        #region Fields
        readonly ManziliDbContext _db;
        private readonly UserManager<User> _userManager;
        private readonly IFileService _fileService;
        readonly IStoreCategoryServices _storeCategoryServices;
        readonly DbSet<Store> _dbSet;

        #endregion

        #region Constructor

        public StoreServices(UserManager<User> storeManager, IFileService fileService, ManziliDbContext db, IStoreCategoryServices storeCategoryServices)
        {
            _userManager = storeManager;
            _fileService = fileService;
            _db = db;
            _dbSet = db.Set<Store>();
            _storeCategoryServices = storeCategoryServices;
        }

        #endregion

        #region Methods

        public async Task<OperationResult<GetStoreDto>> GetByIdAsync(int id)
        {
            var store = await _dbSet.FindAsync(id);
            if (store == null) return OperationResult<GetStoreDto>.Failure(message: "Store not found");

            return OperationResult<GetStoreDto>.Success(new GetStoreDto(id ,store.ImageUrl ,store.BusinessName ,store.Rate , [""] ,store.Status ));
        }
        public async Task<OperationResult<GetFullInfoStoreDto>> GetWithProductsAsync(int id)
        {
            var store = _dbSet.Include("asassa").FirstOrDefault(x => x.Id == id);
            if (store == null) return OperationResult<GetFullInfoStoreDto>.Failure(message: "Store not found");

            return OperationResult<GetFullInfoStoreDto>.Success(new GetFullInfoStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Description,
                  store.Address,
                  store.BankAccount,
                  store.PhoneNumber,
                  store.Rate,
                  store.Status
                 ));

        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetListAsync()
        {
            var stores = await _dbSet.AsNoTracking().ToListAsync();

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate,
                  [""],
                  store.Status
                  )).ToList();


            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }





        public  async Task<OperationResult<IEnumerable<GetStoreDto>>> GetLatestStoresAsync()
        {
            var stores = await _dbSet.AsNoTracking().OrderByDescending(x => x.CreateAt).ToListAsync();

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize)
        {
            var stores =  _dbSet.ToPageination(page, pageSize);

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto , List<int> categoriesIds)
        {

            if(categoriesIds is null || !categoriesIds.Any())
                return OperationResult<CreateStoreDto>.Failure("يجب تحديد فئات المتجر");

            var storeCategories = await _db.StoreCategories.Where(x => categoriesIds.Contains(x.Id)).ToListAsync();


            if (!storeCategories.Any())
                return OperationResult<CreateStoreDto>.Failure("لم يتم العثور على أي فئات");


            if (await _dbSet.AnyAsync(x => x.BusinessName == storeDto.BusinessName))
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
                PhoneNumber = storeDto.PhoneNumber,

            };

         

            store.storeCategoryStores = storeCategories.Select(storeCategories => new StoreCategoryStore
            {
                Store = store,
                StoreCategoryId = storeCategories.Id
            }).ToList();
            try
            {
              

                if (storeDto.Image != null)
                {
                    if (!ImageValidator.IsValidImage(storeDto.Image, out string errorMessage))
                    {
                        return OperationResult<CreateStoreDto>.Failure(message: errorMessage);
                    }

                    string imagePath = await _fileService.UploadImageAsync("Profile", storeDto.Image);
                    if (imagePath == "FailedToUploadImage")
                    {
                        return OperationResult<CreateStoreDto>.Failure("Failed to upload image");
                    }


                    store.ImageUrl = imagePath;
                    var result = await _userManager.CreateAsync(store, storeDto.Password);
                    if (!result.Succeeded)
                        return OperationResult<CreateStoreDto>.Failure(string.Join("; ", result.Errors.Select(e => e.Description)));

                    return OperationResult<CreateStoreDto>.Success(data: storeDto);



                }
            }

            catch (Exception ex)
            {
                return OperationResult<CreateStoreDto>.Failure(message: ex.Message);
            }


            return OperationResult<CreateStoreDto>.Failure("");

        }
        public async Task<OperationResult<UpdateStoreDto>> UpdateAsync(UpdateStoreDto newStore, int storeId)
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



            var oldStore = await _dbSet.FindAsync(storeId);
            if (oldStore == null) return OperationResult<UpdateStoreDto>.Failure("Store not found");



            if (oldStore.Email != newStore.Email &&
                await _userManager.FindByEmailAsync(newStore.Email) != null)
                return OperationResult<UpdateStoreDto>.Failure("Email already exists");

            if (oldStore.PhoneNumber != newStore.PhoneNumber &&
                await _userManager.Users.AnyAsync(u => u.PhoneNumber == newStore.PhoneNumber))
                return OperationResult<UpdateStoreDto>.Failure("PhoneNumber already exists");

            if (oldStore.BusinessName != newStore.BusinessName &&
                await _dbSet.AnyAsync(x => x.BusinessName == newStore.BusinessName))
                return OperationResult<UpdateStoreDto>.Failure("BusinessName already exists");

            oldStore.UserName = newStore.UserName;
            oldStore.PhoneNumber = newStore.PhoneNumber;
            oldStore.Address = newStore.Address;
            oldStore.Email = newStore.Email;
            oldStore.BusinessName = newStore.BusinessName;
            oldStore.BankAccount = newStore.BankAccount;





            _dbSet.Update(oldStore);
            await _db.SaveChangesAsync();
            return OperationResult<UpdateStoreDto>.Success(newStore);
        }
        public async Task<OperationResult<int>> UpdateToRateAsync(int storeId, int valueRate)
        {   

            var store = await _dbSet.Include("RatingsReceived").FirstOrDefaultAsync( x => x.Id == storeId);
            double avg = store.RatingsReceived.Average(x => x.RatingValue);
            store.Rate = avg;
            _dbSet.Update(store);
            await _db.SaveChangesAsync();
            return OperationResult<int>.Success(valueRate);
        }
        public async Task<OperationResult<Store>> DeleteAsync(int id)
        {
            var store = await _dbSet.FindAsync(id);
            if (store == null) return OperationResult<Store>.Failure("Store not found");

            _dbSet.Remove(store);
            await _db.SaveChangesAsync();
            return OperationResult<Store>.Success(store);
        }

        #endregion
    }
}
