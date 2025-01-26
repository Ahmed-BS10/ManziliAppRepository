using Microsoft.AspNetCore.Identity;

namespace Manzili.Core.Entities
{
    public class User : IdentityUser<int>
    {
        public string Image { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string City { get; set; } // New attribute
        public string Address { get; set; } // New attribute

        // Navigation properties
        public ICollection<Favorite> Favorites { get; set; }
        public ICollection<StoreRating> StoreRatings { get; set; }
        public ICollection<Order> Orders { get; set; }
        public ICollection<ProductRating> ProductRatings { get; set; }
        public ICollection<Like> Likes { get; set; }
        public ICollection<Comment> Comments { get; set; }
    }

}
