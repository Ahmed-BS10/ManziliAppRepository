using Manzili.Core.Dto.OrderDto;
using Manzili.Core.Entities;
using Manzili.Core.Enum;
using Manzili.Core.Services;
using Manzili.EF.Implementaion;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Drawing;
using System.Threading.Tasks;

namespace Manzili.EF.Implementation
{
    public class OrderService : IOrdersService
    {
        private readonly ManziliDbContext _context;
        private readonly INotificationService _notificationService;

        public OrderService(ManziliDbContext context, INotificationService notificationService)
        {
            _context = context;
            _notificationService = notificationService;
        }

        public async Task<OperationResult<bool>> AddOrderAsync(CreateOrderDto createOrderDto)
        {
            var store = await _context.Stores.FindAsync(createOrderDto.StoreId);
            if (store == null)
                return OperationResult<bool>.Failure("Store not found.");

            // 1. بناء كائن الـ Order الأساسي
            var order = new Order
            {
                UserId = createOrderDto.UserId,
                StoreId = createOrderDto.StoreId,
                DeliveryAddress = createOrderDto.DeliveryAddress,
                Note = createOrderDto.Note,
                DeliveryFees = store.DeliveryFees,
                DeliveryTime = store.BookTime,
                CreatedAt = DateTime.UtcNow,
                Status = enOrderStatus.التجهيز
            };

            // 2. قراءة ملف PDF إن وُجد
            if (createOrderDto.PdfFile != null && createOrderDto.PdfFile.Length > 0)
            {
                using var ms = new MemoryStream();
                await createOrderDto.PdfFile.CopyToAsync(ms);
                order.PdfFile = ms.ToArray();
            }

            // 3. معالجة عناصر الطلب
            foreach (var dto in createOrderDto.OrderProducts)
            {
                var product = await _context.Products.FindAsync(dto.ProductId);
                if (product == null)
                    return OperationResult<bool>.Failure($"Product with ID {dto.ProductId} not found.");

                order.OrderProducts.Add(new OrderProduct
                {
                    ProductId = dto.ProductId,
                    Quantity = dto.Quantity,
                    Price = product.Price,
                    TotlaPrice = product.Price * dto.Quantity
                });
            }

            // 4. حساب المجاميع
            order.Total = order.OrderProducts.Sum(op => op.TotlaPrice) + store.DeliveryFees;
            order.NumberOfProducts = order.OrderProducts.Count;

            // 5. حفظ الطلب
            await _context.Orders.AddAsync(order);
            await _context.SaveChangesAsync();

            // 6. إرسال الإشعار للمتجر
            await _notificationService.SendAsync(
                senderId: createOrderDto.UserId,
                receiverId: createOrderDto.StoreId,
                type: "OrderRequest",
                payload: "Your Order Is Send Plase wait for Respons"

            );

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
        public async Task<OperationResult<IEnumerable<GetOrderDetailsDto>>> GetOrderDetailsAsync(int orderId)
        {
            // Fetch orders with related data
            var orders = await _context.Orders
                .Include(o => o.Store)
                .ThenInclude(s => s.Products)
                .ThenInclude(p => p.Images)
                .Where(o => o.OrderId == orderId)
                .Select(o => new GetOrderDetailsDto
                {
                    Id = o.OrderId,
                    StoreName = o.Store.BusinessName,
                    CreatedAt = o.CreatedAt,
                    Status = o.Status.ToString(),
                    NumberOfProducts = o.NumberOfProducts,
                    TotlaPrice = o.Total,
                    DeliveryTime = o.DeliveryTime,
                    DeliveryAddress = o.DeliveryAddress,
                    DeliveryFees = o.DeliveryFees,
                    ordeProducts = o.OrderProducts.Select(op => new GetOrdeProduct
                    {
                        Id = op.ProductId,
                        Name = op.Product.Name,
                        ImageUrl = op.Product.Images.Select(img => img.ImageUrl).FirstOrDefault(),
                        Total = op.Price * op.Quantity,
                        Count = op.Quantity
                    }).ToList()
                })
                .ToListAsync();

            // Check if no orders were found
            if (orders == null || !orders.Any())
            {
                return OperationResult<IEnumerable<GetOrderDetailsDto>>.Failure("There are no orders.");
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
        public Task<OperationResult<int?>> GetUserIdByOrderIdAsync(int orderId)
        {
            throw new NotImplementedException();
        }
        public Task<OperationResult<IEnumerable<OrderTracking>>> GetOrderTrackingHistoryAsync(int orderId)
        {
            throw new NotImplementedException();
        }

        public async Task<OperationResult<IEnumerable<GteOrdersDashbordDto>>> GetAllOrderDashbordAsync(int pageNumber, int size)
        {
            var orders = await _context.Orders
                .Include(s => s.Store)
                .Skip((pageNumber - 1) * size)
                .Take(size)
                .Select(x => new GteOrdersDashbordDto
                {
                    Id = x.OrderId,
                    StoreName = x.Store.BusinessName,
                    UserName = x.User.UserName,
                    CreatedAt = x.CreatedAt,
                    Statu = x.Status.ToString(),
                    TotlaPrice = x.Total


                }).ToListAsync();


            if (!orders.Any())
                return OperationResult<IEnumerable<GteOrdersDashbordDto>>.Failure("there are no Order");


            return OperationResult<IEnumerable<GteOrdersDashbordDto>>.Success(orders);


        }

        public OperationResult<bool> DeleteOrder(int orderId)
        {
           var order = _context.Orders.Find(orderId);
            if (order == null)
                return OperationResult<bool>.Failure("Order not found");
            _context.Orders.Remove(order);
            _context.SaveChanges();
            return OperationResult<bool>.Success(true);
        }
    }
}
