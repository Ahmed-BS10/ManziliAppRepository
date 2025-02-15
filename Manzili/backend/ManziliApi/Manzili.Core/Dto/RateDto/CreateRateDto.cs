using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.RateDto
{
    public sealed record CreateRateDto(int UserId , int StoreId , int Rate);
    
}
