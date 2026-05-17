import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _promos = [
    _PromoData(
      title: 'Offre spéciale été',
      subtitle: 'Jusqu\'à -30% sur les vols',
      color: AppColors.primary,
      icon: Icons.flight,
    ),
    _PromoData(
      title: 'Séjours tout compris',
      subtitle: 'Hôtel + Vol dès 499€',
      color: AppColors.accent,
      icon: Icons.beach_access,
    ),
    _PromoData(
      title: 'Dernière minute',
      subtitle: 'Départs ce week-end !',
      color: AppColors.secondary,
      icon: Icons.access_time,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      _currentPage = (_currentPage + 1) % _promos.length;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      child: PageView.builder(
        controller: _controller,
        itemCount: _promos.length,
        itemBuilder: (context, index) {
          final promo = _promos[index];
          return Container(
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [promo.color, promo.color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(promo.icon, size: 48, color: Colors.white30),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PromoData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _PromoData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}
