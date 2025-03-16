import 'package:flutter/material.dart';

class ImageHelper {
  static String getImageUrl(String imageName) {
    return "https://storage.googleapis.com/tagjs-prod.appspot.com/U0msiQhkbO/$imageName";
  }

  static Widget networkImage({
    required String url,
    required double width,
    required double height,
  }) {
    return Image.network(url, width: width, height: height, fit: BoxFit.fill);
  }
}
