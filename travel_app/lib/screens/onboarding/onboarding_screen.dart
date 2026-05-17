import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/storage/secure_storage.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/screens/onboarding/widgets/onboarding_page.dart';
import 'package:voyageur/screens/onboarding/widgets/onboarding_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    OnboardingPage(
      title: 'Découvrez le monde',
      subtitle: 'Des milliers de destinations vous attendent',
      icon: Icons.explore,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Réservez facilement',
      subtitle: 'Vols et hôtels en quelques clics',
      icon: Icons.book_online,
      color: AppColors.accent,
    ),
    OnboardingPage(
      title: 'Voyagez sereinement',
      subtitle: 'Votre voyage, notre priorité',
      icon: Icons.flight_takeoff,
      color: AppColors.secondary,
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  Future<void> _onGetStarted() async {
    final secureStorage = SecureStorage();
    await secureStorage.setOnboardingSeen();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  Future<void> _continueAsGuest() async {
    final secureStorage = SecureStorage();
    await secureStorage.setOnboardingSeen();
    if (!mounted) return;
    ref.read(authProvider.notifier).enterGuestMode();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ───────────────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onGetStarted,
                child: const Text(
                  'Passer',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => _pages[index],
              ),
            ),

            // ── Bottom controls ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  OnboardingIndicator(
                    controller: _pageController,
                    count: _pages.length,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Primary CTA
                  if (_isLastPage)
                    PrimaryButton(
                      label: 'Commencer',
                      onPressed: _onGetStarted,
                    )
                  else
                    PrimaryButton(
                      label: 'Suivant',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                    ),

                  // Guest option — only visible on the last page
                  if (_isLastPage) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextButton.icon(
                      onPressed: _continueAsGuest,
                      icon: const Icon(
                        Icons.explore_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      label: const Text(
                        'Continuer en mode invité',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
