


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  HeaderSectionState createState() => HeaderSectionState();
}

class HeaderSectionState extends State<HeaderSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _imageUrls = [
    ImageHelper.getImageUrl('w8bfd62n.png'),
    ImageHelper.getImageUrl('w8bfd62n.png'),
    ImageHelper.getImageUrl('w8bfd62n.png'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 23,
      ),
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imageUrls.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                _imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
          Positioned(
            top: 150,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: PageIndicator(
                currentPage: _currentPage,
                itemCount: _imageUrls.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int itemCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? AppColors.primaryColor
                : AppColors.white.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        );
      }),
    );
  }
}