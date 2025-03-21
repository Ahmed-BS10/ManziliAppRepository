using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ProductDto
{
    public record CartProductDto(
       int Id,
       string Name,
       string ImageUrl,
       string Description,
       ProductSize? ProductSize,
       double Price,
       string State,
       int Quantity);
}
