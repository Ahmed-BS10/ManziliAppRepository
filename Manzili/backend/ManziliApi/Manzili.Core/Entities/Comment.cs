using Manzili.Core.Entities;

namespace Manzili.Core.Entities
{
    public class Comment
    {
        public int CommentId { get; set; } // PK
        public string Content { get; set; }
        public int ProductId { get; set; } // FK
        public int UserId { get; set; } // FK
        public DateTime CreatedAt { get; set; }
        public string ReplyComment { get; set; }

        // Navigation properties
      //  public Product Product { get; set; }
      //  public User User { get; set; }
    }

}



public class Image
{
    public int Id { get; set; }
    public string ImageUrl { get; set; }
    public Product Product { get; set; }

}