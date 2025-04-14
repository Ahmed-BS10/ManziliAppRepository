using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ProductDto
{
    public class GetStoreProductDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<string> ImageUrls { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string State { get; set; }
        public List<string> Categories { get; set; }

      
    }
}

