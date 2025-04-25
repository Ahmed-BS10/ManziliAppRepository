import 'package:flutter/material.dart';

class StoreImage extends StatelessWidget {
  /// The URL to load. If null or empty → shows [placeholder].
  final String? imageUrl;

  /// Diameter of the circle.
  final double size;

  /// Widget to show on error or when there's no [imageUrl].
  final Widget placeholder;

  const StoreImage({
    Key? key,
    this.imageUrl,
    this.size = 80.0,
    this.placeholder = const Icon(
      Icons.storefront_outlined,
      size: 40,
      color: Colors.grey,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We'll stack the loading/error states on top of the image.
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Container(
          color: Colors.grey.shade200,
          child: (imageUrl?.isNotEmpty == true)
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    // The network image itself
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: size * 0.5,
                            height: size * 0.5,
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return Center(child: placeholder);
                      },
                    ),
                  ],
                )
              : Center(child: placeholder),
        ),
      ),
    );
  }
}
