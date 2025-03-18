using Manzili.Core.Dto.StoreRateDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.EntityFrameworkCore;

public class StoreRateServices
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

            }

        }

        var storeRate = new StoreRating
        {

            UserId = createRateDto.UserId,
            StoreId = createRateDto.StoreId,
            RatingValue = createRateDto.valueRate,

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
        var ratings = await _dbSet.Where(r => r.StoreId == storeId).ToListAsync();

        if (!ratings.Any())
            return OperationResult<StoreRatingSummaryDto>.Failure("No ratings found for this store");

        var averageRating = ratings.Average(r => r.RatingValue);

        var result = new StoreRatingSummaryDto
        {
            StoreId = storeId,
            AverageRating = Math.Round(averageRating, 1),
            TotalRatings = ratings.Count,
            RatingsBreakdown = ratings.GroupBy(r => r.RatingValue)
                                      .ToDictionary(g => g.Key, g => g.Count())
        };

        return OperationResult<StoreRatingSummaryDto>.Success(result);
    }




    #endregion
}