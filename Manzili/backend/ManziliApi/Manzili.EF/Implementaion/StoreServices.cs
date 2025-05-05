using Azure;
using Manzili.Core.Dto.StoreDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
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



        // Get List

        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetUserFavoriteStores(int userId)
        {
            var storesWithUserFavorite = await _dbSet
                .Include(x => x.storeCategoryStores!)
                .ThenInclude(x => x.StoreCategory)
                .Where(x => x.Favorites.Any(f => f.UserId == userId))
                .ToListAsync();

            if (!storesWithUserFavorite.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = storesWithUserFavorite.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate ?? 0,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetStoresWithCategory(int storeCategoryId)
        {
            var stores = await _dbSet
                .Include(s => s.storeCategoryStores)
                .ThenInclude(scs => scs.StoreCategory)
                .AsNoTracking()
                .Where(s => s.storeCategoryStores.Any(scs => scs.StoreCategoryId == storeCategoryId))
                .ToListAsync();

            if (!stores.Any())
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");

            var storeDtos = stores.Select(store => new GetStoreDto(
                store.Id,
                store.ImageUrl,
                store.BusinessName,
                store.Rate ?? 0,
                store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                store.Status
            )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
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
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetLatestStoresAsync()
        {


            var stores = await _dbSet
                .Include(sci => sci.storeCategoryStores)
                .ThenInclude(sc => sc.StoreCategory)
                .AsNoTracking().OrderByDescending(x => x.CreateAt).ToListAsync();

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate ?? 0,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> GetListToPageinationAsync(int page, int pageSize)
        {
            var stores = _dbSet.ToPageination(page, pageSize);

            if (!stores.Any())
            {
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");
            }

            var storeDtos = stores.Select(store => new GetStoreDto(
                  store.Id,
                  store.ImageUrl,
                  store.BusinessName,
                  store.Rate ?? 0,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> SearchStoreByNameAsync(string BusinessName)
        {
            var stores = await _dbSet.Where(x => x.BusinessName.Contains(BusinessName)).ToListAsync();
            if (!stores.Any())
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");


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


        // Get

        //public async Task<OperationResult<GetInfoStoreDto>> GetInfoStore(int storeId)
        //{
        //    var store = await _dbSet
        //        .Include(x => x.storeCategoryStores!)
        //        .ThenInclude(s => s.StoreCategory)
        //        .FirstOrDefaultAsync(x => x.Id == storeId);
        //    if (store == null) return OperationResult<GetInfoStoreDto>.Failure("Store not found");

        //    return OperationResult<GetInfoStoreDto>.Success(new GetInfoStoreDto(
        //          store.Id,
        //          store.ImageUrl,
        //          store.BusinessName,
        //          store.Description,
        //          store.storeCategoryStores!.Select(x => x.StoreCategory.Name).ToList(),
        //          store.BookTime,
        //          store.Address,
        //          store.BankAccount,
        //          store.PhoneNumber,
        //          store.SocileMediaAcount,
        //          store.Rate ?? 0,
        //          store.Status
        //         ));
        //}
        public async Task<OperationResult<GetStoreDto>> GetByIdAsync(int id)
        {
            var store = await _dbSet.FindAsync(id);
            if (store == null) return OperationResult<GetStoreDto>.Failure(message: "Store not found");

            return OperationResult<GetStoreDto>.Success(new GetStoreDto(id, store.ImageUrl, store.BusinessName, store.Rate, [""], store.Status));
        }


        // Anther
        public async Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto, List<int> categoriesIds)
        {

            if (categoriesIds is null || !categoriesIds.Any())
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
                SocileMediaAcount = storeDto.SocileMediaAcount,
                BookTime = "حجز قبل يومين قبل الطلب"

            };



            store.storeCategoryStores = storeCategories.Select(storeCategories => new StoreCategoryStore
            {
                Store = store,
                StoreCategory = storeCategories,
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

                else if (storeDto.Image == null)
                {
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


            return OperationResult<CreateStoreDto>.Failure("hi");

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

            var store = await _dbSet.Include("RatingsReceived").FirstOrDefaultAsync(x => x.Id == storeId);
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

        public async Task<OperationResult<GetInfoStoreDto>> GetInfoStore(int storeId)
        {
            var store = await _db.Stores
                .Include(x => x.storeCategoryStores!)
                .ThenInclude(s => s.StoreCategory)
                .FirstOrDefaultAsync(x => x.Id == storeId);

            if (store == null)
                return OperationResult<GetInfoStoreDto>.Failure("Store not found");

            var storeInfo = new GetInfoStoreDto(
                store.Id,
                store.ImageUrl!,
                store.BusinessName,
                store.Description,
                store.storeCategoryStores!.Select(x => x.StoreCategory.Name).ToList(),
                store.DeliveryFees,
                store.BookTime,
                store.BankAccount,
                store.Address,
                store.PhoneNumber!,
                store.SocileMediaAcount,
                store.Rate ?? 0,
                store.Status
            );

            return OperationResult<GetInfoStoreDto>.Success(storeInfo);
        }

        public async Task<OperationResult<GetAnalysisStoreDto>> GetAnalysisStoreAsync(int storeId)
        {
            // التأكد من وجود المتجر
            var exists = await _db.Stores
                .AnyAsync(s => s.Id == storeId);
            if (!exists)
                return OperationResult<GetAnalysisStoreDto>
                    .Failure("المتجر غير موجود");

            // جلب جميع الطلبات الخاصة بالمتجر
            var ordersQuery = _db.Orders
                .Where(o => o.StoreId == storeId);

            // عدد الطلبات
            var numberOfOrders = await ordersQuery.CountAsync();

            // مجموع المبيعات (نجمع قيمة Total لكل الطلبات المنتهية أو الجارية)
            var totalSales = await ordersQuery
                .SumAsync(o => (double?)o.Total) ?? 0.0;

            // عدد الطلبات قيد التنفيذ (الحالات: التجهيز، الشحن، في_الطريق)
            var inProgressCount = await ordersQuery
                .CountAsync(o =>
                    o.Status == enOrderStatus.التجهيز ||
                    o.Status == enOrderStatus.الشحن ||
                    o.Status == enOrderStatus.في_الطريق);

            // تجهيز DTO
            var dto = new GetAnalysisStoreDto
            {
                StoreId = storeId,
                NumberOfOrders = numberOfOrders,
                TotalSales = totalSales,
                OrderInProgress = inProgressCount
            };

            return OperationResult<GetAnalysisStoreDto>.Success(dto);
        }

        public async Task<OperationResult<double>> GetTotalSalesAsync(int storeId, int month)
        {
            var exists = await _db.Stores.AnyAsync(s => s.Id == storeId);
            if (!exists)
                return OperationResult<double>.Failure("المتجر غير موجود");

            var totalSales = await _db.Orders
                .Where(o => o.StoreId == storeId && o.CreatedAt.Month == month)
                .SumAsync(o => (double?)o.Total) ?? 0.0;

            return OperationResult<double>.Success(totalSales);
        }



        #endregion
    }
}
