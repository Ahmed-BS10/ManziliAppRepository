public class GetProductRatingsAndCommentsDto
{
    public double? RatingValue { get; set; }
    public string? Comment { get; set; }
    public string UserName { get; set; }
    public string UserImage { get; set; }
    public DateTime CreatedAt { get; set; }
}
