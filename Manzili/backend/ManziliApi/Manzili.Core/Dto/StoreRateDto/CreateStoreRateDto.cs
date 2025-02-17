using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.StoreRateDto
{
    public sealed record CreateStoreRateDto(int UserId , int StoreId , int valueRate);
    
}
