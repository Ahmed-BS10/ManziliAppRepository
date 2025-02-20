public record GetStoreDto(
    int Id,
    string ImageUrl,
    string BusinessName,
    double? Rate ,
    List<string> CategoryNames,
    string Status
);

