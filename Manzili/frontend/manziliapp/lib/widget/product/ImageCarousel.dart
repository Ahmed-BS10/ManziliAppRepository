import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'CircleButton.dart';




// Component for Image Carousel
class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final Function(int) onPageChanged;
  
  const ImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blue background for top section
        Container(
          height: 300,
          color: const Color(0xFFffffff),
        ),
        
        // Image carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
          items: images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Image.network(
                    'http://man.runasp.net/$imageUrl',
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
        
        
        
        // Back button
        Positioned(
          left: 20,
          top: 40,
          child: CircleButton(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}