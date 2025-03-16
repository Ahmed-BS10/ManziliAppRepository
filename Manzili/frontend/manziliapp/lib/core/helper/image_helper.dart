import 'package:flutter/material.dart';

class ImageHelper {
  static String getImageUrl(String imageName) {
    return imageName;
  }


  static Widget networkImage({
    required String url,
    required double width,
    required double height,
  }) {
    return Image.network(url, width: width, height: height, fit: BoxFit.fill);
  }
}
