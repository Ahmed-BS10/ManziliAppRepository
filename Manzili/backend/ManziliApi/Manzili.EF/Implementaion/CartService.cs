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

        public async Task<OperationResult<GetCartDto>> GetCartByUserAndStoreAsync(int userId, int storeId)
        {
            var cart = await _context.Carts
                 .Include(c => c.CartProducts)
                 .ThenInclude(cp => cp.Product)
                 .ThenInclude(im => im.Images)
                 .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);
            if (cart == null)
            {
                return OperationResult<GetCartDto>.Failure("Cart not found");
            }
            var getCardDto = new GetCartDto
            {
                CartId = cart.CartId,
                UserId = cart.UserId,
                StoreId = cart.StoreId,
                Note = cart.Note,
                getProductCardDtos = cart.CartProducts.Select(product => new GetProductCartDto
                {
                    ProductId = product.Product.Id,
                    Name = product.Product.Name,
                    Price = product.Product.Price,
                    ImageUrl = product.Product.Images.FirstOrDefault()?.ImageUrl ?? string.Empty,
                    Quantity = product.Quantity
                }).ToList()
            };
            return OperationResult<GetCartDto>.Success(getCardDto, "Cart retrieved successfully");
        }
        public async Task<OperationResult<bool>> DeleteCartItemAsync(int cartId, int productId)
        {
            var cart = _context.Carts
                 .Include(c => c.CartProducts)
                 .FirstOrDefault(c => c.CartId == cartId);

            var cartProduct = cart.CartProducts.FirstOrDefault(cp => cp.ProductId == productId);

            cart.CartProducts.Remove(cartProduct);
            _context.Carts.Update(cart);
            _context.SaveChanges();
            return OperationResult<bool>.Success(true, "Product removed from cart successfully.");
        }
        public async Task<OperationResult<bool>> AddProductToCartAsync(int userId, int storeId, int productId , int quantity )
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
                    Quantity = quantity
                  
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
      
        public Task<OperationResult<bool>> IsCartEmptyAsync(int userId)
        {
            throw new NotImplementedException();
        }
        public async Task<OperationResult<bool>> UpdateProductQuantityAsync(int cartId, int productId, int newQuantity)
        {
            // Validate the new quantity
            if (newQuantity <= 0)
            {
                return OperationResult<bool>.Failure("Quantity must be greater than zero.");
            }

            // Fetch the cart product
            var cartProduct = await _context.CartProducts
                .FirstOrDefaultAsync(cp => cp.CartId == cartId && cp.ProductId == productId);

            // Check if the cart product exists
            if (cartProduct == null)
            {
                return OperationResult<bool>.Failure("Product not found in the cart.");
            }

            // Update the quantity
            cartProduct.Quantity = newQuantity;

            // Save changes to the database
            _context.CartProducts.Update(cartProduct);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Product quantity updated successfully.");
        }

        public async Task<OperationResult<bool>> DeleteCartItemAsync(int storeId, int userId, int productId)
        {
            // Retrieve the cart based on userId and storeId
            var cart = await _context.Carts
                .Include(c => c.CartProducts)
                .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);

            // Check if the cart exists
            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found.");
            }

            // Find the product in the cart
            var cartProduct = cart.CartProducts.FirstOrDefault(cp => cp.ProductId == productId);

            // Check if the product exists in the cart
            if (cartProduct == null)
            {
                return OperationResult<bool>.Failure("Product not found in the cart.");
            }

            // Remove the product from the cart
            cart.CartProducts.Remove(cartProduct);

            // Update the cart in the database
            _context.Carts.Update(cart);
            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Product removed from cart successfully.");
        }

        public async Task<OperationResult<GetCartDto>> AllCartItemByUserIdAndStoreId(int userId, int storeId)
        {
            var cart = await _context.Carts
                .Include(c => c.CartProducts)
                    .ThenInclude(cp => cp.Product)
                        .ThenInclude(p => p.Images)
                .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);

            if (cart == null)
            {
                return OperationResult<GetCartDto>.Failure("Cart not found for the specified user and store.");
            }

            var cartDto = new GetCartDto
            {
                CartId = cart.CartId,
                UserId = cart.UserId,
                StoreId = cart.StoreId,
                Note = cart.Note,
                getProductCardDtos = cart.CartProducts?.Select(product => new GetProductCartDto
                {
                    ProductId = product.Product.Id,
                    Name = product.Product.Name,
                    Price = product.Product.Price,
                    ImageUrl = product.Product.Images.FirstOrDefault()?.ImageUrl ?? string.Empty,
                    Quantity = product.Quantity
                }).ToList()
            };

            return OperationResult<GetCartDto>.Success(cartDto, "Cart retrieved successfully.");
        }
        public async Task<OperationResult<bool>> DeleteCartByUserIdAndStoreId(int userId, int storeId)
        {
            var cart = await _context.Carts
                .Include(c => c.CartProducts)
                .FirstOrDefaultAsync(c => c.UserId == userId && c.StoreId == storeId);

            if (cart == null)
            {
                return OperationResult<bool>.Failure("Cart not found for the specified user and store.");
            }

            // Remove associated cart products
            if (cart.CartProducts != null && cart.CartProducts.Any())
            {
                _context.CartProducts.RemoveRange(cart.CartProducts);
            }

            // Remove the cart itself
            _context.Carts.Remove(cart);

            await _context.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Cart deleted successfully.");
        }

    }


}
