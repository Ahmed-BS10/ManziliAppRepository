using Manzili.Core.Dto.ProductDto;
using Manzili.Core.Entities;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Manzili.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CartController : ControllerBase
    {
        private readonly ICartService _cartService;

        public CartController(ICartService cartService)
        {
            _cartService = cartService;
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddProductToCart(int userId, int storeId, int productId , int quantity = 1)
        {
            var result = await _cartService.AddProductToCartAsync(userId, storeId, productId , quantity);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Message);
            }

            return Ok(result.Data);
        }
        [HttpPut("AddNote")]
        public async Task<IActionResult> AddONoteAsync(int cartId, string note)
        {
            var result = await _cartService.AddNoteAsync(cartId, note);
            if (result.IsSuccess)
            {
                return Ok(result);
            }
            return BadRequest(result);
        }

        [HttpGet("GetCartByUserAndStoreAsync")]
        public async Task<ActionResult> GetCartByUserAndStoreAsync(int userId, int storeId)
        {
            var result = await _cartService.GetCartByUserAndStoreAsync(userId, storeId);
            if (result.IsSuccess)
            {
                return Ok(result);
            }
            return NotFound(result);
        }

        [HttpDelete("DeleteCartItem")]
        public async Task<IActionResult> DeleteCartItem(int cartId, int productId)
        {
            var result = await _cartService.DeleteCartItemAsync(cartId, productId);
            if (result.IsSuccess)
            {
                return Ok(result);
            }
            return BadRequest(result);
        }


        [HttpPut("UpdateProductQuantityAsync")]
        public async Task<IActionResult> UpdateProductQuantity(int cartId , int productId , int newQuantity)
        {
            var result = await _cartService.UpdateProductQuantityAsync(cartId, productId, newQuantity);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }


        //[HttpGet("{userId}/is-empty")]
        //public async Task<IActionResult> IsCartEmpty(int userId)
        //{
        //    var result = await _cartService.IsCartEmptyAsync(userId);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(new { IsEmpty = result.Data });
        //    }
        //    return BadRequest(result.Message);
        //}

        ////[HttpPut("edit")]
        ////public async Task<IActionResult> EditCartItem(int userId, int productId, int quantity)
        ////{
        ////    var result = await _cartService.EditCartItemAsync(userId, productId, quantity);
        ////    if (result.IsSuccess)
        ////    {
        ////        return Ok(result.Message);
        ////    }
        ////    return BadRequest(result.Message);
        ////}



        //[HttpGet("{userId}/products")]
        //public async Task<ActionResult<IEnumerable<CartProductDto>>> GetCartProducts(int userId)
        //{
        //    var result = await _cartService.GetCartProductsAsync(userId);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(result.Data);
        //    }
        //    return NotFound(result.Message);
        //}


        //[HttpPost("addOrUpdateShippingAddress")]
        //public async Task<IActionResult> AddOrUpdateShippingAddress(int userId, string address)
        //{
        //    var result = await _cartService.AddOrUpdateShippingAddressAsync(userId, address);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(result.Message);
        //    }
        //    return BadRequest(result.Message);
        //}

        //[HttpPost("uploadPaymentReceipt")]
        //public async Task<IActionResult> UploadPaymentReceipt(int userId, IFormFile receipt)
        //{
        //    var result = await _cartService.UploadPaymentReceiptAsync(userId, receipt);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(new { FilePath = result.Data });
        //    }
        //    return BadRequest(result.Message);
        //}

        //[HttpGet("{userId}/calculateTotalCost")]
        //public async Task<IActionResult> CalculateTotalCost(int userId, decimal shippingCost)
        //{
        //    var result = await _cartService.CalculateTotalCostAsync(userId, shippingCost);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(new { TotalCost = result.Data });
        //    }
        //    return BadRequest(result.Message);
        //}

        //[HttpPost("completeOrder")]
        //public async Task<IActionResult> CompleteOrder(int userId, decimal shippingCost, string receiptPath)
        //{
        //    var result = await _cartService.CompleteOrderAsync(userId, shippingCost, receiptPath);
        //    if (result.IsSuccess)
        //    {
        //        return Ok(result.Message);
        //    }
        //    return BadRequest(result.Message);
        //}

    }
}
