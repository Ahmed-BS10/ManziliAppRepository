using System.ComponentModel.DataAnnotations;

namespace Manzili.Core.Dto.UserDto
{
    public class UpdateUserDto
    {
       
       
        public string UserName { get; set; }

        [Phone]
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string City { get; set; }
        public string Address { get; set; }
       
    }
}
