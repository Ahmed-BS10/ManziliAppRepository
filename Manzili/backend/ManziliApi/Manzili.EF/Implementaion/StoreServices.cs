using Manzili.Core.Dto.StoreDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
using Manzili.Core.Extension;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

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

        public async Task<OperationResult<IEnumerable<CompletedOrderDto>>> GetLastTwoCompletedOrdersAsync(int storeId)
        {
            var orders = await _db.Orders
                .Where(o => o.StoreId == storeId && o.Status == enOrderStatus.تم_التسليم)
                .OrderByDescending(o => o.CreatedAt)
                .Take(2)
                .Select(o => new CompletedOrderDto
                {
                    BuyerName = o.User.UserName,
                    Price = o.Total,
                    Date = o.CreatedAt
                })
                .ToListAsync();

            return OperationResult<IEnumerable<CompletedOrderDto>>.Success(orders);
        }
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
                  store.UserName,
                  store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
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
                store.UserName,
                store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
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
                  store.UserName,
                 store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
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
                  store.UserName,
                  store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
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
                  store.UserName,
                  store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
                  store.storeCategoryStores.Select(scs => scs.StoreCategory.Name).ToList(),
                  store.Status
                  )).ToList();

            return OperationResult<IEnumerable<GetStoreDto>>.Success(storeDtos);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDto>>> SearchStoreByNameAsync(string userName)
        {
            var stores = await _db.Stores
                .Include(sci => sci.storeCategoryStores)
                .ThenInclude(sc => sc.StoreCategory)
                 .Where(x =>  Microsoft.EntityFrameworkCore.EF.Functions.Like(x.UserName, $"%{userName}%")).ToListAsync();



            if (!stores.Any())
                return OperationResult<IEnumerable<GetStoreDto>>.Failure("No stores found.");

            var storeDtos = stores.Select(store => new GetStoreDto(
                 store.Id,
                 store.ImageUrl,
                 store.UserName,
                store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
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

            return OperationResult<GetStoreDto>.Success(new GetStoreDto(id, store.ImageUrl, store.UserName, store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0, [""], store.Status));
        }

        public async Task<OperationResult<StoreBasicInfoDto>> GetProfileStore(int storeId)
        {
            var store = await _dbSet.AsNoTracking().FirstOrDefaultAsync(s => s.Id == storeId);
            if (store == null)
                return OperationResult<StoreBasicInfoDto>.Failure("Store not found.");

            var dto = new StoreBasicInfoDto
            {
                Id = store.Id,
                UserName = store.UserName ?? "Ali",
                Image = store.ImageUrl,
                Phone = store.PhoneNumber,
                Status = store.Status ?? "o",
                Description = store.Description,
                Location = store.Address
            };

            return OperationResult<StoreBasicInfoDto>.Success(dto);
        }

        // Anther
        public async Task<OperationResult<CreateStoreDto>> CreateAsync(CreateStoreDto storeDto, List<int> categoriesIds)
        {

            if (categoriesIds is null || !categoriesIds.Any())
                return OperationResult<CreateStoreDto>.Failure("يجب تحديد فئات المتجر");

            var storeCategories = await _db.StoreCategories.Where(x => categoriesIds.Contains(x.Id)).ToListAsync();


            if (!storeCategories.Any())
                return OperationResult<CreateStoreDto>.Failure("لم يتم العثور على أي فئات");


            if (await _dbSet.AnyAsync(x => x.UserName == storeDto.UserName))
                return OperationResult<CreateStoreDto>.Failure("BusinessName already exists");

            if (await _userManager.FindByEmailAsync(storeDto.Email) != null)
                return OperationResult<CreateStoreDto>.Failure("Email already exists");


            if (await _userManager.Users.AnyAsync(u => u.PhoneNumber == storeDto.PhoneNumber))
                return OperationResult<CreateStoreDto>.Failure("PhoneNumber already exists");

            var store = new Store
            {
                Status = enStoreStatus.Open.ToString(),
                UserName = storeDto.UserName,
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

            if (oldStore.UserName != newStore.BusinessName &&
                await _dbSet.AnyAsync(x => x.UserName == newStore.BusinessName))
                return OperationResult<UpdateStoreDto>.Failure("BusinessName already exists");

            oldStore.UserName = newStore.UserName;
            oldStore.PhoneNumber = newStore.PhoneNumber;
            oldStore.Address = newStore.Address;
            oldStore.Email = newStore.Email;
            oldStore.UserName = newStore.BusinessName;
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
                store.UserName,
                store.Description,
                store.storeCategoryStores!.Select(x => x.StoreCategory.Name).ToList(),
                store.DeliveryFees,
                store.BookTime,
                store.BankAccount,
                store.Address,
                store.PhoneNumber!,
                store.SocileMediaAcount,
                store.Rate.HasValue ? (int)Math.Round(store.Rate.Value) : 0,
                store.Status
            );

            return OperationResult<GetInfoStoreDto>.Success(storeInfo);
        }

        public async Task<OperationResult<GetAnalysisStoreDto>> GetAnalysisStoreAsync(int storeId)
        {
            // Ensure the ordersQuery is defined and properly initialized
            var ordersQuery = _db.Orders.Where(o => o.StoreId == storeId);

            var result = await ordersQuery
                .GroupBy(o => 1)
                .Select(g => new
                {
                    TotalOrders = g.Count(),
                    TotalSales = g.Sum(o => (double?)o.Total) ?? 0.0,
                    InProgress = g.Count(o =>
                        o.Status == enOrderStatus.التجهيز ||
                        o.Status == enOrderStatus.الشحن ||
                        o.Status == enOrderStatus.في_الطريق)
                })
                .FirstOrDefaultAsync();

            if (result == null)
                return OperationResult<GetAnalysisStoreDto>.Success(new GetAnalysisStoreDto
                {
                    StoreId = storeId,
                    NumberOfOrders = 0,
                    TotalSales = 0.0,
                    OrderInProgress = 0
                });

            var dto = new GetAnalysisStoreDto
            {
                StoreId = storeId,
                NumberOfOrders = result.TotalOrders,
                TotalSales = result.TotalSales,
                OrderInProgress = result.InProgress
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

        public async Task<OperationResult<IEnumerable<GetStoreDashbord>>> GetUnBlockeStores(int page, int pageSize)
        {


            var storesQuery = await _db.Stores
                // .Include(s => s.StoreOrders) // Include related orders to calculate TotalSale
                .AsNoTracking()
                .Where(x => x.IsBlocked == false)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(s => new GetStoreDashbord
                {
                    Id = s.Id,
                    Name = s.UserName,
                    CreateAt = s.CreateAt,
                    Statu = s.Status,
                    Location = s.Address, // Assuming `Address` represents the location
                                          // Calculate total sales from orders
                })
                .ToListAsync();

            if (storesQuery is null)
            {
                return OperationResult<IEnumerable<GetStoreDashbord>>.Failure("No stores found.");
            }

            return OperationResult<IEnumerable<GetStoreDashbord>>.Success(storesQuery);
        }
        public async Task<OperationResult<bool>> MakeBloke(int Id)
        {
            var user = await _db.Users.FindAsync(Id);
            if (user == null) return OperationResult<bool>.Failure("User not found");
            user.IsBlocked = true;


            await _db.SaveChangesAsync();
            return OperationResult<bool>.Success(true);
        }
        public async Task<OperationResult<bool>> UnBloke(int Id)
        {
            var user = await _db.Users.FindAsync(Id);
            if (user == null) return OperationResult<bool>.Failure("User not found");
            user.IsBlocked = false;


            await _db.SaveChangesAsync();
            return OperationResult<bool>.Success(true);
        }
        public async Task<OperationResult<IEnumerable<GetStoreDashbord>>> GetBlockeStores(int pageNumber, int size)
        {

            var storesQuery = await _db.Stores
                // .Include(s => s.StoreOrders) // Include related orders to calculate TotalSale
                .AsNoTracking()
                .Where(s => s.IsBlocked == true) // Filter for blocked stores
                .Skip((pageNumber - 1) * size)
                .Take(size)
                .Select(s => new GetStoreDashbord
                {
                    Id = s.Id,
                    Name = s.UserName,
                    CreateAt = s.CreateAt,
                    Statu = s.Status,
                    Location = s.Address, // Assuming `Address` represents the location
                                          // Calculate total sales from orders
                })
                .ToListAsync();

            if (storesQuery is null)
            {
                return OperationResult<IEnumerable<GetStoreDashbord>>.Failure("No stores found.");
            }

            return OperationResult<IEnumerable<GetStoreDashbord>>.Success(storesQuery);
        }
        public async Task<OperationResult<GetHomeDashbordDto>> GetHomeDashbord()
        {
            var totalUsers = await _db.Users.CountAsync();
            var totalStores = await _db.Stores.CountAsync();
            var totalOrders = await _db.Orders.CountAsync();
            var totalSales = await _db.Orders.SumAsync(o => (double?)o.Total) ?? 0.0;

            var result = new GetHomeDashbordDto
            {
                TotalUsers = totalUsers,
                TotalStores = totalStores,
                TotalOrders = totalOrders,
                TotalSales = totalSales
            };

            return OperationResult<GetHomeDashbordDto>.Success(result);
        }
        public async Task<OperationResult<IEnumerable<GetProductGategory>>> GetProductGategoriesByStoreId(int storeId)
        {
            var storeProductCategories = await _db.Products
                .Where(p => p.StoreId == storeId && p.ProductCategory != null)
                .Select(p => new GetProductGategory
                {
                    Id = p.ProductCategoryId.Value, // Assuming ProductCategoryId is not null
                    Name = p.ProductCategory.Name
                })
                .Distinct()
                .ToListAsync();

            return OperationResult<IEnumerable<GetProductGategory>>.Success(storeProductCategories);
        }







        public async Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInPastStatus(int storeId)
        {
            var orders = await _db.Orders
               .Include(o => o.OrderProducts)
               .ThenInclude(op => op.Product)
               .Include(o => o.User) // Ensure User is included for Customer details
               .Where(o => o.StoreId == storeId && o.Status == enOrderStatus.تم_التسليم)
               .Select(o => new GetStoreOrders
               {
                  // FileContent = o.PdfFile,
                   Id = o.OrderId,
                   CustomerName = o.User != null ? o.User.UserName : "Unknown", // Replace null-propagating operator
                   CustomerPhoneNumber = o.User != null ? o.User.PhoneNumber : "Unknown", // Replace null-propagating operator
                   CustomerAddress = o.User != null ? o.User.Address : "Unknown", // Replace null-propagating operator
                   CreatedAt = o.CreatedAt,
                   TotalPrice = Math.Round(o.Total, 2), // Ensure proper rounding for TotalPrice
                   TotalOfEachProduct = o.OrderProducts.Sum(op => op.Quantity),
                   Status = o.Status.ToString(),
                   Note = o.Note,
                   OrderProducts = o.OrderProducts.Select(op => new GetOrdeProduct
                   {
                       Id = op.ProductId ?? 0, // Handle null ProductId
                       Name = op.Product != null ? op.Product.Name : "Unknown", // Replace null-propagating operator
                       Price = (int)Math.Round(op.Product != null ? op.Price : 0), // Replace null-propagating operator
                       Total = Math.Round(op.TotlaPrice, 2), // Ensure proper rounding for Total
                       Count = op.Quantity
                   }).ToList()
               })
               .ToListAsync();

            if (!orders.Any())
                return OperationResult<IEnumerable<GetStoreOrders>>.Failure("No orders found.");

            return OperationResult<IEnumerable<GetStoreOrders>>.Success(orders);
        }
        public async Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInWorkStatus(int storeId)
        {
            var orders = await _db.Orders
                .Include(o => o.OrderProducts)
                .ThenInclude(op => op.Product)
                .Include(o => o.User) // Ensure User is included for Customer details
                .Where(o => o.StoreId == storeId && (o.Status == enOrderStatus.في_الطريق || o.Status == enOrderStatus.الشحن))
                .Select(o => new GetStoreOrders
                {
                    Id = o.OrderId,
                    CustomerName = o.User != null ? o.User.UserName : "Unknown", // Replace null-propagating operator
                    CustomerPhoneNumber = o.User != null ? o.User.PhoneNumber : "Unknown", // Replace null-propagating operator
                    CustomerAddress = o.User != null ? o.User.Address : "Unknown", // Replace null-propagating operator
                    CreatedAt = o.CreatedAt,
                    TotalPrice = Math.Round(o.Total, 2), // Ensure proper rounding for TotalPrice
                    TotalOfEachProduct = o.OrderProducts.Sum(op => op.Quantity),
                    Status = o.Status.ToString(),
                    Note = o.Note,
                   // FileContent = o.PdfFile,
                    OrderProducts = o.OrderProducts.Select(op => new GetOrdeProduct
                    {
                        Id = op.ProductId ?? 0, // Handle null ProductId
                        Name = op.Product != null ? op.Product.Name : "Unknown", // Replace null-propagating operator
                        Price = (int)Math.Round(op.Product != null ? op.Price : 0), // Replace null-propagating operator
                        Total = Math.Round(op.TotlaPrice, 2), // Ensure proper rounding for Total
                        Count = op.Quantity
                    }).ToList()
                })
                .ToListAsync();

            if (!orders.Any())
                return OperationResult<IEnumerable<GetStoreOrders>>.Failure("No orders found.");

            return OperationResult<IEnumerable<GetStoreOrders>>.Success(orders);
        }
        public async Task<OperationResult<IEnumerable<GetStoreOrders>>> GetStoreOrdersInNewStatus(int storeId) 
        {
            var orders = await _db.Orders
                .Include(o => o.OrderProducts)
                .ThenInclude(op => op.Product)
                .Include(o => o.User) // Ensure User is included for Customer details
                .Where(o => o.StoreId == storeId && o.Status == enOrderStatus.التجهيز)
                .Select(o => new GetStoreOrders
                {
                    StoreName = o.Store.UserName,
                    Id = o.OrderId,
                    CustomerName = o.User != null ? o.User.UserName : "Unknown", // Replace null-propagating operator
                    CustomerPhoneNumber = o.User != null ? o.User.PhoneNumber : "Unknown", // Replace null-propagating operator
                    CustomerAddress = o.User != null ? o.User.Address : "Unknown", // Replace null-propagating operator
                    CreatedAt = o.CreatedAt,
                    TotalPrice = Math.Round(o.Total, 2), // Ensure proper rounding for TotalPrice
                    TotalOfEachProduct = o.OrderProducts.Sum(op => op.Quantity),
                    Status = o.Status.ToString(),
                    Note = o.Note,
                    FileContent = o.pathPdfFile,
                    OrderProducts = o.OrderProducts.Select(op => new GetOrdeProduct
                    {
                        Id = op.ProductId ?? 0, // Handle null ProductId
                        Name = op.Product != null ? op.Product.Name : "Unknown", // Replace null-propagating operator
                        Price = (int)Math.Round(op.Product != null ? op.Price : 0), // Replace null-propagating operator
                        Total = Math.Round(op.TotlaPrice, 2), // Ensure proper rounding for Total
                        Count = op.Quantity
                    }).ToList()
                })
                .ToListAsync();

            if (!orders.Any())
                return OperationResult<IEnumerable<GetStoreOrders>>.Failure("No orders found.");

            return OperationResult<IEnumerable<GetStoreOrders>>.Success(orders);
        }
        public async Task<OperationResult<IEnumerable<GetStoreOrders>>> GetAllOrders()
        {
            var orders = await _db.Orders
                .Include(o => o.OrderProducts)
                .ThenInclude(op => op.Product)
                .Include(o => o.User) // Ensure User is included for Customer details
                .Select(o => new GetStoreOrders
                {
                    Id = o.OrderId, // Corrected property name
                    CustomerName = o.User != null ? o.User.UserName : "Unknown", // Replace null-propagating operator
                    CustomerPhoneNumber = o.User != null ? o.User.PhoneNumber : "Unknown", // Replace null-propagating operator
                    CustomerAddress = o.User != null ? o.User.Address : "Unknown", // Replace null-propagating operator
                    CreatedAt = o.CreatedAt,
                    TotalPrice = Math.Round(o.Total, 2), // Ensure proper rounding for TotalPrice
                    TotalOfEachProduct = o.OrderProducts.Sum(op => op.Quantity),
                    Status = o.Status.ToString(),
                    Note = o.Note,
                   // FileContent = o.PdfFile,
                    OrderProducts = o.OrderProducts.Select(op => new GetOrdeProduct
                    {
                        Id = op.ProductId ?? 0, // Handle null ProductId
                        Name = op.Product != null ? op.Product.Name : "Unknown", // Replace null-propagating operator
                        Price = (int)Math.Round(op.Product != null ? op.Price : 0), // Replace null-propagating operator
                        Total = Math.Round(op.TotlaPrice, 2), // Ensure proper rounding for Total
                        Count = op.Quantity
                    }).ToList()
                })
                .ToListAsync();

            if (!orders.Any())
                return OperationResult<IEnumerable<GetStoreOrders>>.Failure("No orders found.");

            return OperationResult<IEnumerable<GetStoreOrders>>.Success(orders); // Corrected to match the expected type
        }






        public async Task<OperationResult<bool>>ChangeStoreStatsu(int store , enStoreStatus enStore)
        {
            var storeToUpdate = await _db.Stores.FindAsync(store);
            if (storeToUpdate == null)
                return OperationResult<bool>.Failure("Store not found");

            storeToUpdate.Status = enStore.ToString();
            
            await _db.SaveChangesAsync();

            return OperationResult<bool>.Success(true);
        }

    }
}
