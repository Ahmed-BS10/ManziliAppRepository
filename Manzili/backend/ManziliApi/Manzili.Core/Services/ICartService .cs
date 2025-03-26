using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public interface ICartService
    {

        Task<OperationResult<GetCardDto>> GetCartByUserAndStoreAsync(int userId, int storeId);
        Task<OperationResult<CartProductDto>> AddProductToCartAsync(int userId, int storeId, int productId);
        Task<OperationResult<bool>> AddOrUpdateNoteAsync(int userId, string note);
        Task<OperationResult<IEnumerable<CartProductDto>>> GetCartProductsAsync(int userId);
        Task<OperationResult<bool>> IsCartEmptyAsync(int userId);
        Task<OperationResult<bool>> EditCartItemAsync(int userId, int productId, int quantity);
        Task<OperationResult<bool>> DeleteCartItemAsync(int userId, int productId);

        Task<OperationResult<bool>> AddOrUpdateShippingAddressAsync(int userId, string address);
        Task<OperationResult<string>> UploadPaymentReceiptAsync(int userId, IFormFile receipt);
        Task<OperationResult<decimal>> CalculateTotalCostAsync(int userId, decimal shippingCost);
        //Task<OperationResult<bool>> CompleteOrderAsync(int userId, decimal shippingCost, string receiptPath);
    }
}
