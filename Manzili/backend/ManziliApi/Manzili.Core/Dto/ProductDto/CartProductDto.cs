﻿using System;
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
       double Price,
       string State,
       int Quantity);
}




public class GetProductGategory
{
    public int Id { get; set; }
    public string Name { get; set; }
}