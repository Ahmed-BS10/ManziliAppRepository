using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.StoreCategoryDto
{
    public sealed record GetStoreCategoryDto(
        string Name,
        string ImageUrl,
        int ? conunt,
        List<int> StoreIdList
        );
    
}
