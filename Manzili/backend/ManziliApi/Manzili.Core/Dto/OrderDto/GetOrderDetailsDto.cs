using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.OrderDto
{
    public class GetOrderDetailsDto
    {

        public int Id { get; set; }
        public string? NumberOrder { get; set; } = "45454";
        public string StoreName { get; set; }
        public DateTime CreatedAt { get; set; }
        public string Status { get; set; }
        public double TotlaPrice { get; set; }
        public int NumberOfProducts { get; set; }


        public string DeliveryTime { get; set; }
        public string DeliveryAddress { get; set; }


        public int? DeliveryFees { get; set; }



        public List<GetOrdeProduct> ordeProducts { get; set; }
    }
}
