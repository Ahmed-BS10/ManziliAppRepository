using System.ComponentModel.DataAnnotations;
public record UpdateStoreDto(
    string UserName,
    string BusinessName,
    string Image,
    [Phone] string PhoneNumber,
    string Email,
    string Address,
    string BankAccount,
    string Status
);
