using Manzili.Core.Dto.OrderDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
using Manzili.Core.Services;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Manzili.EF.Implementation
{
    public class OrderService : IOrdersService
    {
        private readonly ManziliDbContext _context;

        public OrderService(ManziliDbContext context)
        {
            _context = context;
        }

        public async Task<OperationResult<List<Order>>> GetOrdersAsync()
        {
            var orders = await _context.Orders.ToListAsync();

            if (orders.Count == 0)
            {
                return OperationResult<List<Order>>.Failure("No orders available.");
            }

            return OperationResult<List<Order>>.Success(orders);
        }
        public async Task<OperationResult<List<Order>>> GetOrdersByStatusAsync(enOrderStatus status)
        {
            var orders = await _context.Orders.Where(o => o.Status == status).ToListAsync();

            if (orders.Count == 0)
            {
                return OperationResult<List<Order>>.Failure("No orders found with this status.");
            }

            return OperationResult<List<Order>>.Success(orders);
        }
        public async Task<OperationResult<OrderDetailsDto>> GetOrderDetailsByIdAsync(int id)
        {
            var order = await _context.Orders
                .Include(o => o.OrderProducts)
                .ThenInclude(op => op.Product)
                .ThenInclude(p => p.Images)
                .Include(o => o.Store) // Ensure that Store is included
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null)
            {
                return OperationResult<OrderDetailsDto>.Failure("Order not found.");
            }

            var orderDetails = new OrderDetailsDto
            {
                OrderId = order.OrderId,
                OrderDate = order.CreatedAt,
                OrderStatus = order.Status.ToString(),
                DeliveryAddress = "Sample Address", // Replace with actual address if available
                StoreName = order.Store.BusinessName,
                Products = order.OrderProducts.Select(op => new OrderProductDto
                {
                    Name = op.Product.Name,
                    Description = op.Product.Description,
                    Price = op.Product.Price,
                    Quantity = op.Quantity,
                    ImageUrl = op.Product.Images.FirstOrDefault()?.ImageUrl
                }).ToList(),
                PaymentDetails = new PaymentDetailsDto
                {
                    Subtotal = order.OrderProducts.Sum(op => op.Price * op.Quantity),
                    ShippingCost = 8.00, // Replace with actual shipping cost if available
                    Total = order.OrderProducts.Sum(op => op.Price * op.Quantity) + 8.00
                }
            };

            return OperationResult<OrderDetailsDto>.Success(orderDetails);
        }
    }
}
