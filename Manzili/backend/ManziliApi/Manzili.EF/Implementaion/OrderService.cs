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

        public async Task<OperationResult<IEnumerable<OrderTracking>>> GetOrderTrackingHistoryAsync(int orderId)
        {
            var trackingHistory = await _context.OrderTrackings
                .Where(t => t.OrderId == orderId)
                .OrderBy(t => t.Timestamp)
                .ToListAsync();

            if (!trackingHistory.Any())
            {
                return OperationResult<IEnumerable<OrderTracking>>.Failure("No tracking history found for this order.");
            }

            return OperationResult<IEnumerable<OrderTracking>>.Success(trackingHistory, "Tracking history retrieved successfully.");
        }

        public async Task<OperationResult<int?>> GetUserIdByOrderIdAsync(int orderId)
        {
            // Fix for CS1061: Replace 'Id' with 'OrderId' in the query since the 'Order' class does not have an 'Id' property but has 'OrderId'.
            var userId = await _context.Orders
                .Where(o => o.OrderId == orderId) // Changed 'Id' to 'OrderId'
                .Select(o => o.UserId)
                .FirstOrDefaultAsync();

            if (userId == 0) // Assuming 0 means no user found
            {
                return OperationResult<int?>.Failure("Order not found or no associated user.");
            }

            return OperationResult<int?>.Success(userId, "User ID retrieved successfully.");
        }
        public async Task<OperationResult<bool>> AddOrderAsync(CreateOrderDto createOrderDto)
        {


            var order = new Order
            {
                UserId = createOrderDto.UserId,
                StoreId = createOrderDto.StoreId,
                DeliveryAddress = createOrderDto.DeliveryAddress,
                Note = createOrderDto.Note,
                CreatedAt = DateTime.UtcNow,
                Status = enOrderStatus.Pending,

            };

            foreach (var orderProductDto in createOrderDto.OrderProducts)
            {
                var product = await _context.Products.FindAsync(orderProductDto.ProductId);
                if (product == null)
                {
                    return OperationResult<bool>.Failure($"Product with ID {orderProductDto.ProductId} not found.");
                }
                var orderProduct = new OrderProduct
                {
                    ProductId = orderProductDto.ProductId,
                    Quantity = orderProductDto.Quantity,
                    Price = product.Price,
                    TotlaPrice = product.Price * orderProductDto.Quantity
                };
                order.OrderProducts.Add(orderProduct);
            }

            order.Total = order.OrderProducts.Sum(op => op.TotlaPrice);
            order.NumberOfProducts = order.OrderProducts.Count;

            await _context.Orders.AddAsync(order);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true);
        }

        public async Task<OperationResult<bool>> UpdateOrderStatusAsync(int orderId, enOrderStatus status)
        {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null)
                return OperationResult<bool>.Failure("Order not found");

            order.Status = status;

            // Log the status change in the tracking table
            var trackingEntry = new OrderTracking
            {
                OrderId = orderId,
                Status = status,
                Timestamp = DateTime.UtcNow
            };
            _context.OrderTrackings.Add(trackingEntry);

            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true);
        }



        public async Task<OperationResult<IEnumerable<GteBaseOrderDto>>> GetDeliveredOrdersByUserIdAsync(int userId)
        {
            var orders = await _context.Orders.Include(s => s.Store).Where(x => x.UserId == userId && (int)x.Status == 4)
                .Select(x => new GteBaseOrderDto
                {
                    Id = x.OrderId,
                    StoreName = x.Store.BusinessName,
                    CreatedAt = x.CreatedAt,
                    Statu = x.Status.ToString(),
                    NumberOfProducts = x.NumberOfProducts,
                    TotlaPrice = x.Total


                }).ToListAsync();


            if (!orders.Any())
                return OperationResult<IEnumerable<GteBaseOrderDto>>.Failure("there are no Order");


            return OperationResult<IEnumerable<GteBaseOrderDto>>.Success(orders);




        }

        public async Task<OperationResult<IEnumerable<GetOrderDetailsDto>>> GetOrderDetailsByUserAsync(int userId)
        {
            var orders = await  _context.Orders
                .Include(s => s.Store)
                .ThenInclude(p => p.Products)
                .ThenInclude(i => i.Images)
                .Where(x => x.UserId == userId)
                .Select(x => new GetOrderDetailsDto
                {
                    Id = x.OrderId,
                    StoreName = x.Store.BusinessName,
                    CreatedAt = x.CreatedAt,
                    Status = x.Status.ToString(),
                    NumberOfProducts = x.NumberOfProducts,
                    TotlaPrice = x.Total,
                    DeliveryTime = x.DeliveryTime.ToString(),
                    DeliveryAddress = x.DeliveryAddress,
                    DeliveryFees = x.DeliveryFees,
                    ordeProducts = x.OrderProducts.Select(op => new GetOrdeProduct
                    {
                        Id = op.ProductId,
                        Name = op.Product.Name,
                        ImageUrl = op.Product.Images.Select(x => x.ImageUrl).FirstOrDefault(),
                        Total = op.Price * op.Quantity,
                        Count = op.Quantity
                    }).ToList()
                }).ToListAsync();

            if (orders == null)
            {
                return OperationResult<IEnumerable<GetOrderDetailsDto>>.Failure("there are no order");
            }



            return OperationResult<IEnumerable<GetOrderDetailsDto>>.Success(orders);
        }

        public async Task<OperationResult<IEnumerable<GteBaseOrderDto>>> GetUnDeliveredOrdersByUserIdAsync(int userId)
        {
            var orders = await _context.Orders.Include(s => s.Store).Where(x => x.UserId == userId && (int)x.Status != 4)
                .Select(x => new GteBaseOrderDto
                {
                    Id = x.OrderId,
                    StoreName = x.Store.BusinessName,
                    CreatedAt = x.CreatedAt,
                    Statu = x.Status.ToString(),
                    NumberOfProducts = x.NumberOfProducts,
                    TotlaPrice = x.Total


                }).ToListAsync();


            if (!orders.Any())
                return OperationResult<IEnumerable<GteBaseOrderDto>>.Failure("there are no Order");


            return OperationResult<IEnumerable<GteBaseOrderDto>>.Success(orders);




        }


    }
}
