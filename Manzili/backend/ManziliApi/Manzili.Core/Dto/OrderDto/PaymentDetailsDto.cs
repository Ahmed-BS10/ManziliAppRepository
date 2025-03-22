using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.OrderDto
{
    public class PaymentDetailsDto
    {
        public double Subtotal { get; set; }
        public double ShippingCost { get; set; }
        public double Total { get; set; }
    }
}
