namespace Manzili.Core.Dto.StoreDto
{
    public record GetInfoStoreDto(
        int Id,
        string ImageUrl,
        string UserName,
        string Description,
        List<string> CategoryNames,
        int deliveryFee,
        string BookTime,
        string BankAccount,
        string Address,
        string PhoneNumber,
        string? SocileMediaAcount,
        double? Rate,
        string Status
    );
}