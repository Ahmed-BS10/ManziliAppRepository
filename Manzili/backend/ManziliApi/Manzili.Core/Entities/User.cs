using Microsoft.AspNetCore.Identity;
using System.Reflection.Metadata;

namespace Manzili.Core.Entities
{
    public class User : IdentityUser<int>
    {
       
        public string ? ImageUrl { get; set; }
        public string Address { get; set; }

        // Navigation properties
        public ICollection<Favorite>? FavoritesStore { get; set; } = new List<Favorite>();
        public ICollection<StoreRating>? RatingsGivenStore { get; set; } = new List<StoreRating>();
        //public ICollection<Order> Orders { get; set; }
        //public ICollection<ProductRating> ProductRatings { get; set; }
        //public ICollection<Like> Likes { get; set; }
        //public ICollection<Comment> Comments { get; set; }
    }

}
