public record GetStoreProductDto(

    int? productId,
    string? name,
    string? imageUrl,
    string? descripation,
    double? price,
    string? states,
    List<string>? productCategory
    );

