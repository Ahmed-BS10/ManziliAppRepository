using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.OrderDto
{
    public class GteBaseOrderDto
    {
        public int Id { get; set; }
        public string? NumberOrder { get; set; } = "45454";
        public string StoreName { get; set; }
        public DateTime CreatedAt { get; set; }
        public string Statu { get; set; }
        public double TotlaPrice { get; set; }
        public int NumberOfProducts { get; set; }
    }
}
