using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.UserDto
{
    public class CreateUserDto
    {
   
        public string UserName { get; set;}
        public IFormFile? Image {  get; set;} 
       
        [Phone]
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Password { get; set; }

        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }
}



public class GetUserDashbordDto
{
    public int Id { get; set; }
    public string UserName { get; set; }
    public string ImageUrl { get; set; }
    public DateTime CreateAy { get; set; }
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
    public string Address { get; set; }
}