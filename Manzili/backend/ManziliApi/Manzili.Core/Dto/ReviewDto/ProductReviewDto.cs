public class ProductReviewDto
{
    public int CommentId { get; set; }
    public string Content { get; set; }
    public int ProductId { get; set; }
    public int UserId { get; set; }
    public string UserName { get; set; }
    public string ReplyComment { get; set; } = string.Empty;
    public double Rating { get; set; }
    public DateTime CreatedAt { get; set; }
}


