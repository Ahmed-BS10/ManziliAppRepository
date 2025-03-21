using Manzili.Core.Dto.StoreRateDto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
   public interface IStoreRateServices
    {
        Task<OperationResult<CreateStoreRateDto>> CreateOrUpdate(CreateStoreRateDto createRateDto);
        Task<OperationResult<StoreRatingSummaryDto>> GetStoreRatingsAsync(int storeId);
    }
}
