using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Manzili.Core.Dto.ReviewDto;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace Manzili.Core.Services
{
    public class ProductReviewService : IProductReview
    {
        private readonly ManziliDbContext _db;

        public ProductReviewService(ManziliDbContext db)
        {
            _db = db;
        }

        public async Task<OperationResult<IEnumerable<ProductReviewDto>>> GetProductReviewsAsync(int productId)
        {
            var reviews = await _db.Comments
                .Where(c => c.ProductId == productId)
                .Join(_db.ProductRatings,
                      c => new { c.ProductId, c.UserId },
                      r => new { r.ProductId, r.UserId },
                      (c, r) => new ProductReviewDto
                      {
                          CommentId = c.CommentId,
                          Content = c.Content,
                          ProductId = c.ProductId,
                          UserId = c.UserId,
                          UserName = _db.Users.FirstOrDefault(u => u.Id == c.UserId).UserName,
                          ReplyComment = c.ReplyComment,
                          Rating = r.RatingValue,
                          CreatedAt = c.CreatedAt
                      })
                .ToListAsync();

            if (!reviews.Any())
            {
                return OperationResult<IEnumerable<ProductReviewDto>>.Failure("No reviews found for this product.");
            }

            return OperationResult<IEnumerable<ProductReviewDto>>.Success(reviews, "Reviews retrieved successfully.");
        }

        public async Task<OperationResult<bool>> SubmitReviewAsync(SubmitReviewDto reviewDto)
        {
            var comment = new Comment
            {
                Content = reviewDto.Content,
                ProductId = reviewDto.ProductId,
                UserId = reviewDto.UserId,
                ReplyComment = reviewDto.ReplyComment ?? string.Empty,
                CreatedAt = DateTime.UtcNow
            };

            var rating = new ProductRating
            {
                ProductId = reviewDto.ProductId,
                UserId = reviewDto.UserId,
                RatingValue = (int)reviewDto.Rating,
                CreatedAt = DateTime.UtcNow
            };

            await _db.Comments.AddAsync(comment);
            await _db.ProductRatings.AddAsync(rating);
            await _db.SaveChangesAsync();

            return OperationResult<bool>.Success(true, "Review submitted successfully.");
        }
    }
}

 // Add this using directive at the top of the file

// The rest of the file remains unchanged
