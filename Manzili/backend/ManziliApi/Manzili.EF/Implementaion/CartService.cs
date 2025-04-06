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
        //public async Task<OperationResult<GetCardDto>> GetCartByUserAndStoreAsync(int userId, int storeId)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);

        //    if (cart == null)
        //    {
        //        return OperationResult<GetCardDto>.Failure("Cart not found");
        //    }

        //    var getCardDto = new GetCardDto
        //    {
        //        UserId = cart.UserId,
        //        StoreId = cart.StoreId,
        //        TotalPrice = cart.TotalPrice,
        //        CreatedAt = cart.CreatedAt,
        //        Note = cart.Note,
        //        getProductCardDtos = cart.Products.Select(product => new GetProductCardDto
        //        {
        //            ProductId = product.Id,
        //            Description = product.Description,
        //            Name = product.Name,
        //            Price = product.Price,
        //            ImageUrl = product.Images.FirstOrDefault()?.ImageUrl ?? string.Empty,
        //            Quantity = product.Quantity ?? 1 // Provide a default value if Quantity is null
        //        }).ToList()
        //    };

        //    return OperationResult<GetCardDto>.Success(getCardDto, "Cart retrieved successfully");
        //}
        public async Task<OperationResult<bool>> AddProductToCartAsync(int userId, int storeId, int productId)
        {
           
            var cart = await _context.Carts
                 .Include(c => c.CartProducts)
                .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);

            // إذا لم تكن هناك سلة، نقوم بإنشائها
            if (cart == null)
            {
                cart = new Cart
                {
                    UserId = userId,
                    StoreId = storeId,
                    CreatedAt = DateTime.UtcNow,
                    Note = string.Empty
                };
                await _context.Carts.AddAsync(cart);
                await _context.SaveChangesAsync(); // نحفظ هنا للحصول على CartId
            }

            // البحث عن المنتج
            var product = await _context.Products.FindAsync(productId);
            if (product == null)
            {
                return OperationResult<bool>.Failure("المنتج غير موجود");
            }

            // البحث عن المنتج داخل السلة
            var cartProduct = cart.CartProducts.FirstOrDefault(cp => cp.ProductId == productId);

            if (cartProduct == null)
            {
                // المنتج غير موجود في السلة، نقوم بإضافته
                cartProduct = new CartProduct
                {
                    CartId = cart.CartId,
                    ProductId = productId,
                  
                };
                cart.CartProducts.Add(cartProduct);
            }
            else
            {
                
            }

            // تحديث السعر الإجمالي للسلة

            // حفظ التغييرات
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "تمت إضافة المنتج إلى السلة بنجاح");

        }
        //public async Task<OperationResult<bool>> EditCartItemAsync(int userId, int productId, int quantity)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.CartProducts)
        //        .ThenInclude(cp => cp.Product)
        //        .FirstOrDefaultAsync(c => c.UserId == userId && c.CartProducts.Any(cp => cp.ProductId == productId));

        //    if (cart == null)
        //    {
        //        return OperationResult<bool>.Failure("Cart not found.");
        //    }

        //    var cartProduct = cart.CartProducts.FirstOrDefault(cp => cp.ProductId == productId);
        //    if (cartProduct == null)
        //    {
        //        return OperationResult<bool>.Failure("Product not found in cart.");
        //    }

        //    cartProduct.Quantity = quantity;

        //    cart.TotalPrice = cart.CartProducts.Sum(cp => cp.Quantity * cp.Product.Price);

        //    await _context.SaveChangesAsync();

        //    return OperationResult<bool>.Success(true, "Cart item updated successfully.");
        //}
        public async Task<OperationResult<bool>> AddNoteAsync(int cartId, string note)
        {
            var cart = await _context.Carts
                .FirstOrDefaultAsync(c => c.CartId == cartId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            cart.Note = note;
            _context.Carts.Update(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Note added successfully.");
        }

      
        public Task<OperationResult<IEnumerable<CartProductDto>>> GetCartProductsAsync(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<OperationResult<bool>> IsCartEmptyAsync(int userId)
        {
            throw new NotImplementedException();
        }


        public Task<OperationResult<bool>> DeleteCartItemAsync(int userId, int productId)
        {
            throw new NotImplementedException();
        }

        public Task<OperationResult<bool>> AddOrUpdateShippingAddressAsync(int userId, string address)
        {
            throw new NotImplementedException();
        }

        public Task<OperationResult<string>> UploadPaymentReceiptAsync(int userId, IFormFile receipt)
        {
            throw new NotImplementedException();
        }

        public Task<OperationResult<decimal>> CalculateTotalCostAsync(int userId, decimal shippingCost)
        {
            throw new NotImplementedException();
        }

        public Task<OperationResult<GetCardDto>> GetCartByUserAndStoreAsync(int userId, int storeId)
        {
            throw new NotImplementedException();
        }

        //public async Task<OperationResult<bool>> IsCartEmptyAsync(int userId)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null || !cart.Products.Any())
        //    {
        //        return OperationResult<bool>.Success(true, "Cart is empty");
        //    }

        //    return OperationResult<bool>.Success(false, "Cart is not empty");
        //}

        //public async Task<OperationResult<bool>> EditCartItemAsync(int userId, int productId, int quantity)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null)
        //    {
        //        return OperationResult<bool>.Failure("Cart not found.");
        //    }

        //    var cartItem = cart.Products.FirstOrDefault(item => item.Id == productId);
        //    if (cartItem == null)
        //    {
        //        return OperationResult<bool>.Failure("Product not found in cart.");
        //    }

        //    cartItem.Quantity = quantity;
        //    _context.Carts.Update(cart);
        //    await _context.SaveChangesAsync();

        //    return OperationResult<bool>.Success(true, "Cart item updated successfully.");
        //}
        //public async Task<OperationResult<bool>> DeleteCartItemAsync(int userId, int productId)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null)
        //    {
        //        return OperationResult<bool>.Failure("Cart not found.");
        //    }

        //    var cartItem = cart.Products.FirstOrDefault(item => item.Id == productId);
        //    if (cartItem == null)
        //    {
        //        return OperationResult<bool>.Failure("Product not found in cart.");
        //    }

        //    cart.Products.Remove(cartItem);
        //    _context.Carts.Update(cart);
        //    await _context.SaveChangesAsync();

        //    return OperationResult<bool>.Success(true, "Cart item removed successfully.");
        //}
        //public async Task<OperationResult<IEnumerable<CartProductDto>>> GetCartProductsAsync(int userId)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null)
        //    {
        //        return OperationResult<IEnumerable<CartProductDto>>.Failure("Cart not found");
        //    }

        //    var products = cart.Products.Select(p => new CartProductDto(
        //        p.Id,
        //        p.Name,
        //        p.Images.FirstOrDefault()?.ImageUrl ?? string.Empty,
        //        p.Description,
        //        p.Price,
        //        p.State,
        //        p.Quantity ?? 0 // Provide a default value if Quantity is null
        //    )).ToList();

        //    return OperationResult<IEnumerable<CartProductDto>>.Success(products, "Products retrieved successfully");
        //}

        //public async Task<OperationResult<bool>> AddOrUpdateShippingAddressAsync(int userId, string address)
        //{
        //    var user = await _context.Users.FindAsync(userId);
        //    if (user == null)
        //    {
        //        return OperationResult<bool>.Failure("User not found.");
        //    }

        //    user.Address = address;
        //    _context.Users.Update(user);
        //    await _context.SaveChangesAsync();

        //    return OperationResult<bool>.Success(true, "Shipping address added/updated successfully.");
        //}

        //public async Task<OperationResult<string>> UploadPaymentReceiptAsync(int userId, IFormFile receipt)
        //{
        //    if (receipt == null || receipt.Length == 0)
        //    {
        //        return OperationResult<string>.Failure("Invalid receipt file.");
        //    }

        //    var filePath = Path.Combine("Receipts", $"{userId}_{DateTime.UtcNow.Ticks}_{receipt.FileName}");
        //    using (var stream = new FileStream(filePath, FileMode.Create))
        //    {
        //        await receipt.CopyToAsync(stream);
        //    }

        //    return OperationResult<string>.Success(filePath, "Receipt uploaded successfully.");
        //}

        //public async Task<OperationResult<decimal>> CalculateTotalCostAsync(int userId, decimal shippingCost)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null)
        //    {
        //        return OperationResult<decimal>.Failure("Cart not found.");
        //    }

        //    var subtotal = cart.Products.Sum(p => (decimal)p.Price * p.Quantity);
        //    var total = subtotal + shippingCost;

        //    return OperationResult<decimal>.Success((decimal)total, "Total cost calculated successfully.");
        //}

        //public Task<OperationResult<bool>> AddProductToCartAsync(int userId, int storeId, int productId)
        //{
        //    throw new NotImplementedException();
        //}

        //public async Task<OperationResult<bool>> CompleteOrderAsync(int userId, decimal shippingCost, string receiptPath)
        //{
        //    var cart = await _context.Carts
        //        .Include(c => c.Products)
        //        .FirstOrDefaultAsync(c => c.UserId == userId);

        //    if (cart == null)
        //    {
        //        return OperationResult<bool>.Failure("Cart not found.");
        //    }

        //    var order = new Order
        //    {
        //        UserId = userId,
        //        CreatedAt = DateTime.UtcNow,
        //        Total = (double)(cart.Products.Sum(p => (decimal)p.Price * p.Quantity) + shippingCost),
        //        ReceiptPath = receiptPath
        //    };

        //    _context.Orders.Add(order);
        //    _context.Carts.Remove(cart);
        //    await _context.SaveChangesAsync();

        //    return OperationResult<bool>.Success(true, "Order completed successfully.");
        //}
    }
}
