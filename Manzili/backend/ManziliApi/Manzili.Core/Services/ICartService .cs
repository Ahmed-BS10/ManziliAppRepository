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

        Task<OperationResult<bool>> AddProductToCartAsync(int userId, int storeId, int productId , int quantity);
        Task<OperationResult<bool>> AddNoteAsync(int userId, string note);
        Task<OperationResult<GetCartDto>> GetCartByUserAndStoreAsync(int userId, int storeId);
        Task<OperationResult<bool>> DeleteCartItemAsync(int cartId, int productId);
        Task<OperationResult<bool>> IsCartEmptyAsync(int userId);


        Task<OperationResult<bool>> DeleteCartItemAsync(int storeId, int userId, int productId);


        Task<OperationResult<bool>> UpdateProductQuantityAsync(int cartId, int productId, int newQuantity);



    }
}
