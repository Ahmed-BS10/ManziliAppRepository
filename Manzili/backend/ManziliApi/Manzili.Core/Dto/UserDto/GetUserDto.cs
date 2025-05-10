namespace Manzili.Core.Dto.UserDto
{
    public class GetUserDto
    {

        public int Id { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime CreateAt { get; set; }
        public string Address { get; set; }

    }
}
