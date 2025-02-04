using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.CatagoryDto
{
    public class CatagoryCreateDto
    {
        public string Name { get; set; }

        public IFormFile Image { get; set; }
        
    }
}
