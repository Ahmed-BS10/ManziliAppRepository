using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.StoreDtp
{
    public record class CreateStoreDto
    {
   
        public string UserName { get; set; }
        public string BusinessName { get; set; }
        public string Description { get; set; }
        public  IFormFile ? Image {  get; set; } 
        [Phone]
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string? SocileMediaAcount { get; set; }

        public string Address { get; set; }
        public string BankAccount { get; set; }
        public string Password { get; set; }


        [Compare("Password")]
        public string ConfirmPassword12 { get; set; }
    }
}
