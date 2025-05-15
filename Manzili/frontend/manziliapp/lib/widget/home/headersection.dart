import 'dart:async';
import 'package:flutter/material.dart';

/// A modern, responsive header section featuring an auto-scrolling image carousel
/// with smooth transitions and accessibility features.
class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  HeaderSectionState createState() => HeaderSectionState();
}

class HeaderSectionState extends State<HeaderSection>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isHovering = false;

  // Design constants
  static const double _aspectRatio = 16 / 9;
  static const Duration _transitionDuration = Duration(milliseconds: 500);
  static const Duration _autoScrollDuration = Duration(seconds: 5);
  static const Curve _transitionCurve = Curves.easeInOutCubic;

  // Image assets with semantic labels
  static const List<CarouselItem> _carouselItems = [
    CarouselItem(
      imageUrl: 'lib/assets/image/ad1.jpeg',
      label: 'First promotional banner showcasing our latest offerings',
    ),
    CarouselItem(
      imageUrl: 'lib/assets/image/ad2.jpg',
      label: 'Second promotional banner highlighting special deals',
    ),
    CarouselItem(
      imageUrl: 'lib/assets/image/ad3.jpg',
      label: 'Third promotional banner featuring seasonal content',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAutoScroll();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: _transitionDuration,
      vsync: this,
    );
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(_autoScrollDuration, (Timer timer) {
      if (!_isHovering && mounted) {
        final nextPage = (_currentPage + 1) % _carouselItems.length;
        _animateToPage(nextPage);
      }
    });
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: _transitionDuration,
      curve: _transitionCurve,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width / _aspectRatio;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 20,
            ),
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  _buildCarousel(width, height),
                  _buildGradientOverlay(),
                  _buildPageIndicator(context),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarousel(double width, double height) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) => setState(() => _currentPage = page),
      itemCount: _carouselItems.length,
      itemBuilder: (context, index) {
        return Hero(
          tag: 'carousel_image_$index',
          child: _CarouselImage(
            item: _carouselItems[index],
            width: width,
            height: height,
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.5),
            ],
            stops: const [0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: _ModernPageIndicator(
          currentPage: _currentPage,
          itemCount: _carouselItems.length,
          onDotTapped: _animateToPage,
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    if (!_isHovering) return const SizedBox.shrink();

    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavigationButton(
            icon: Icons.chevron_left,
            onPressed: _currentPage > 0
                ? () => _animateToPage(_currentPage - 1)
                : null,
          ),
          _NavigationButton(
            icon: Icons.chevron_right,
            onPressed: _currentPage < _carouselItems.length - 1
                ? () => _animateToPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class CarouselItem {
  final String imageUrl;
  final String label;

  const CarouselItem({
    required this.imageUrl,
    required this.label,
  });
}

class _CarouselImage extends StatelessWidget {
  final CarouselItem item;
  final double width;
  final double height;

  const _CarouselImage({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          item.imageUrl,
          fit: BoxFit.cover,
          width: width,
          height: height,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          },
        ),
        Semantics(
          image: true,
          label: item.label,
          child: const SizedBox.expand(),
        ),
      ],
    );
  }
}

class _ModernPageIndicator extends StatelessWidget {
  final int currentPage;
  final int itemCount;
  final ValueChanged<int> onDotTapped;

  const _ModernPageIndicator({
    required this.currentPage,
    required this.itemCount,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        final isActive = currentPage == index;
        return GestureDetector(
          onTap: () => onDotTapped(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavigationButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
