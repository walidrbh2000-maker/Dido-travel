import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class HotelGallery extends StatefulWidget {
  final List<String> images;
  final String? heroTag;

  const HotelGallery({super.key, required this.images, this.heroTag});

  @override
  State<HotelGallery> createState() => _HotelGalleryState();
}

class _HotelGalleryState extends State<HotelGallery> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 220,
        color: AppColors.shimmerBase,
        child: const Center(
          child: Icon(Icons.hotel, size: 48, color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return GestureDetector(
                onTap: () => _openFullView(context, index),
                child: Hero(
                  tag: widget.heroTag ?? 'hotel_gallery_$index',
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.shimmerBase,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.shimmerBase,
                      child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.primary : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _openFullView(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _GalleryFullView(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _GalleryFullView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _GalleryFullView({required this.images, required this.initialIndex});

  @override
  State<_GalleryFullView> createState() => _GalleryFullViewState();
}

class _GalleryFullViewState extends State<_GalleryFullView> {
  late PageController _controller;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('${_currentPage + 1} / ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: widget.images[index],
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
