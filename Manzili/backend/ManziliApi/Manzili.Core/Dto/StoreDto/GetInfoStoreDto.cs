namespace Manzili.Core.Dto.StoreDto
{
    public record GetInfoStoreDto(
        int Id,
        string ImageUrl,
        string BusinessName,
        string Description,
        List<string> CategoryNames,
        string BookTime,
        string BankAccount,
        string Address,
        string PhoneNumber,
        string? SocileMediaAcount,
        double? Rate,
        string Status
    );
}