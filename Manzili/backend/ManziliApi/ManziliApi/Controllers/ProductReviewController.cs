using Manzili.Core.Dto.ReviewDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductReviewController : ControllerBase
    {
        private readonly IProductReview _productReviewService;

        public ProductReviewController(IProductReview productReviewService)
        {
            _productReviewService = productReviewService;
        }

        [HttpGet("GetProductReviews/{productId}")]
        public async Task<IActionResult> GetProductReviews(int productId)
        {
            var result = await _productReviewService.GetProductReviewsAsync(productId);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPost("SubmitReview")]
        public async Task<IActionResult> SubmitReview([FromBody] SubmitReviewDto reviewDto)
        {
            var result = await _productReviewService.SubmitReviewAsync(reviewDto);
            if (result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }
    }
}
