using Manzili.Core.Dto.OrderDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public interface IOrdersService
    {
        Task<OperationResult<List<Order>>> GetOrdersAsync();
        Task<OperationResult<List<Order>>> GetOrdersByStatusAsync(enOrderStatus status);
        Task<OperationResult<OrderDetailsDto>> GetOrderDetailsByIdAsync(int id);
    }
}


