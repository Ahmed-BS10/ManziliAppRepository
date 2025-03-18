using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.ReviewDto
{
    public class SubmitReviewDto
    {
        public int ProductId { get; set; }
        public int UserId { get; set; }
        public string Content { get; set; }
        public double Rating { get; set; }
        public string ReplyComment { get; set; } = string.Empty;
    }
}
