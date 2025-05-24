using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ReturnOrder
{
    public class CreateReturnOrder
    {
        public string UserName { get; set; }
        public string StoreName { get; set; }
        public IFormFile pdf { get; set; }

    }
}
