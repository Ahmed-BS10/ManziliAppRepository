using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Manzili.EF;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Manzili.Services
{
    public class CartService : ICartService
    {
        private readonly ManziliDbContext _context;

        public CartService(ManziliDbContext context)
        {
            _context = context;
        }

        public async Task<OperationResult<bool>> AddToCartAsync(int userId, int productId, int quantity)
        {
            var product = await _context.Set<Product>().FindAsync(productId);
            if (product == null)
            {
                return OperationResult<bool>.Failure("Product not found");
            }

            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == product.StoreId);

            if (cart == null)
            {
                cart = new Cart
                {
                    UserId = userId,
                    StoreId = product.StoreId,
                    CreatedAt = DateTime.UtcNow,
                    Products = new List<Product>()
                };
                _context.Carts.Add(cart);
            }

            var cartItem = cart.Products.FirstOrDefault(p => p.Id == productId);
            if (cartItem != null)
            {
                cartItem.Quantity += quantity;
            }
            else
            {
                cartItem = new Product
                {
                    Id = product.Id,
                    Name = product.Name,
                    Description = product.Description,
                    Price = product.Price,
                    Quantity = quantity,
                    Sizes = product.Sizes,
                    ImageUrls = product.ImageUrls
                };
                cart.Products.Add(cartItem);
            }

            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Product added to cart successfully");
        }

        public async Task<OperationResult<IEnumerable<CartProductDto>>> GetCartProductsAsync(int userId)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<IEnumerable<CartProductDto>>.Failure("Cart not found");
            }

            var products = cart.Products.Select(p => new CartProductDto(
                p.Id,
                p.Name,
                p.ImageUrls.FirstOrDefault(), 
                p.Description,
                p.Sizes.FirstOrDefault(),
                p.Price,
                p.State,
                p.Quantity
            )).ToList();

            return OperationResult<IEnumerable<CartProductDto>>.Success(products, "Products retrieved successfully");
        }
        public async Task<OperationResult<bool>> IsCartEmptyAsync(int userId)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null || !cart.Products.Any())
            {
                return OperationResult<bool>.Success(true, "Cart is empty");
            }

            return OperationResult<bool>.Success(false, "Cart is not empty");
        }
        public async Task<OperationResult<bool>> EditCartItemAsync(int userId, int productId, int quantity)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            var cartItem = cart.Products.FirstOrDefault(item => item.Id == productId);
            if (cartItem == null)
            {
                return OperationResult<bool>.Failure("Product not found in cart.");
            }

            cartItem.Quantity = quantity;
            _context.Carts.Update(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Cart item updated successfully.");
        }

        public async Task<OperationResult<bool>> DeleteCartItemAsync(int userId, int productId)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            var cartItem = cart.Products.FirstOrDefault(item => item.Id == productId);
            if (cartItem == null)
            {
                return OperationResult<bool>.Failure("Product not found in cart.");
            }

            cart.Products.Remove(cartItem);
            _context.Carts.Update(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Cart item removed successfully.");
        }
        public async Task<OperationResult<bool>> AddOrUpdateNoteAsync(int userId, int productId, string note)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            var cartItem = cart.Products.FirstOrDefault(item => item.Id == productId);
            if (cartItem == null)
            {
                return OperationResult<bool>.Failure("Product not found in cart.");
            }

            cartItem.Note = note;
            _context.Carts.Update(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Note added/updated successfully.");
        }
        public async Task<OperationResult<bool>> AddOrUpdateShippingAddressAsync(int userId, string address)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return OperationResult<bool>.Failure("User not found.");
            }

            user.Address = address;
            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Shipping address added/updated successfully.");
        }
        public async Task<OperationResult<string>> UploadPaymentReceiptAsync(int userId, IFormFile receipt)
        {
            if (receipt == null || receipt.Length == 0)
            {
                return OperationResult<string>.Failure("Invalid receipt file.");
            }

            var filePath = Path.Combine("Receipts", $"{userId}_{DateTime.UtcNow.Ticks}_{receipt.FileName}");
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await receipt.CopyToAsync(stream);
            }

            return OperationResult<string>.Success(filePath, "Receipt uploaded successfully.");
        }
        public async Task<OperationResult<decimal>> CalculateTotalCostAsync(int userId, decimal shippingCost)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<decimal>.Failure("Cart not found.");
            }

            var subtotal = cart.Products.Sum(p => (decimal)p.Price * p.Quantity);
            var total = subtotal + shippingCost;

            return OperationResult<decimal>.Success(total, "Total cost calculated successfully.");
        }
        public async Task<OperationResult<bool>> CompleteOrderAsync(int userId, decimal shippingCost, string receiptPath)
        {
            var cart = await _context.Carts
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            var order = new Order
            {
                UserId = userId,
                CreatedAt = DateTime.UtcNow,
                Total = (double)(cart.Products.Sum(p => (decimal)p.Price * p.Quantity) + shippingCost)
            };

            _context.Orders.Add(order);
            _context.Carts.Remove(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Order completed successfully.");
        }

    }
}
