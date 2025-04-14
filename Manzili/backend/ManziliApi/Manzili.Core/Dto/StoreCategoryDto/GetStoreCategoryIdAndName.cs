using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.StoreCategoryDto
{

    public sealed record GetStoreCategoryIdAndName(
           int Id,
           string Name

           );
}


public sealed record GetStoreSubCategoryIdAndName(
         int Id,
         string Name

         );
