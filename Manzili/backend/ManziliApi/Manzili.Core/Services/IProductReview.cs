using System.Collections.Generic;
using System.Threading.Tasks;
using Manzili.Core.Dto.ReviewDto;

namespace Manzili.Core.Services
{
    public interface IProductReview
    {
        Task<OperationResult<IEnumerable<ProductReviewDto>>> GetProductReviewsAsync(int productId);
        Task<OperationResult<bool>> SubmitReviewAsync(SubmitReviewDto reviewDto);
    }
}
