using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.OrderDto
{
    public class OrderDetailsDto
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public string OrderStatus { get; set; }
        public string DeliveryAddress { get; set; }
        public string StoreName { get; set; }
        public List<OrderProductDto> Products { get; set; }
        public PaymentDetailsDto PaymentDetails { get; set; }
    }
}
