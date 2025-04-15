using Manzili.Core.Dto.StoreRateDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.EntityFrameworkCore;

public class StoreRateServices : IStoreRateServices
{
    #region Feilds

    private readonly ManziliDbContext _db;
    private readonly IStoreServices _storeServices;
    private readonly DbSet<StoreRating> _dbSet;



    #endregion

    #region Constrcutor
    public StoreRateServices(ManziliDbContext db, IStoreServices storeServices)
    {
        _db = db;
        _dbSet = _db.Set<StoreRating>();
        _storeServices = storeServices;
    }

    #endregion


    #region Methode


    public async Task<OperationResult<CreateStoreRateDto>> CreateOrUpdate(CreateStoreRateDto createRateDto)
    {
        var existRate = await _dbSet.FirstOrDefaultAsync(r => r.UserId == createRateDto.UserId && r.StoreId == createRateDto.StoreId);
        if (existRate != null)
        {
            try
            {
                existRate.RatingValue = createRateDto.valueRate;
                await _storeServices.UpdateToRateAsync(createRateDto.StoreId, createRateDto.valueRate);
                _db.SaveChanges();
                return OperationResult<CreateStoreRateDto>.Success(createRateDto);
            }

            catch (Exception e)
            {
                return OperationResult<CreateStoreRateDto>.Failure(e.Message);
            }

        }

        var storeRate = new StoreRating
        {

            UserId = createRateDto.UserId,
            StoreId = createRateDto.StoreId,
            RatingValue = createRateDto.valueRate,
            CreatedAt = DateTime.UtcNow,

        };

        try
        {
            var result = await _dbSet.AddAsync(storeRate);
            await _storeServices.UpdateToRateAsync(createRateDto.StoreId, createRateDto.valueRate);
            return OperationResult<CreateStoreRateDto>.Success(createRateDto);

        }

        catch (Exception e)
        {
            return OperationResult<CreateStoreRateDto>.Failure("Failed to create rate");
        }
    }

    public async Task<OperationResult<StoreRatingSummaryDto>> GetStoreRatingsAsync(int storeId)
    {
        // Fetch all ratings for the specified store
        var ratings = await _dbSet
            .Where(r => r.StoreId == storeId)
            .ToListAsync();

        // Check if no ratings exist
        if (!ratings.Any())
            return OperationResult<StoreRatingSummaryDto>.Failure("No ratings found for this store");

        // Calculate the average rating
        var averageRating = ratings.Average(r => r.RatingValue);

        // Map ratings to CreateUserRateDto
        // Map ratings to CreateUserRateDto
        var userRatings = ratings.Select(r => new CreateUserRateDto
        {
         
            UserName = _db.Users.FirstOrDefault(u => u.Id == r.UserId)?.UserName ?? "Unknown", // Fetch UserName
            ImageUser = _db.Users.FirstOrDefault(u => u.Id == r.UserId)?.ImageUrl ?? "/default-user-image.jpg", // Fetch User Image or default
            valueRate = r.RatingValue,
            DateTime = r.CreatedAt,

        }).ToList();


        // Create the result DTO
        var result = new StoreRatingSummaryDto
        {
            StoreId = storeId,
            AverageRating = Math.Round(averageRating, 1),
            TotalRatings = ratings.Count,
            Ratings = userRatings
        };

        // Return the result
        return OperationResult<StoreRatingSummaryDto>.Success(result);
    }









    #endregion
}