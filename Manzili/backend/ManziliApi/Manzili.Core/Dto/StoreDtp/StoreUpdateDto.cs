using System.ComponentModel.DataAnnotations;

public class StoreUpdateDto
{

    public int storeId { get; set; }
    public string UserName { get; set; }
  

    [Phone]
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
    public string City { get; set; }
    public string Address { get; set; }
    public string BankAccount { get; set; }
    public string Image { get; set; }
    public string Status { get; set; }
    public string BusinessName { get; set; }


    
}