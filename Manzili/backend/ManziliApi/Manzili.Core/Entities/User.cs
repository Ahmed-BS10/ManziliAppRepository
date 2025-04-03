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
        public ICollection<Cart>? Carts { get; set; } = new List<Cart>();



   
    }

}
