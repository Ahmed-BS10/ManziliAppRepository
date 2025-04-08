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
