using System.ComponentModel.DataAnnotations;

public class UpdateStoreDto
{

    public string UserName { get; set; }
    public string BusinessName { get; set; }
    public string Image { get; set; }


    [Phone]
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
    public string Address { get; set; }
    public string BankAccount { get; set; }
    public string Status { get; set; }
   


    
}