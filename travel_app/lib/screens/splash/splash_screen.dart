import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_constants.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/storage/secure_storage.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/screens/splash/widgets/animated_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  /// Whether the splash delay is done and we can show the action buttons
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _initApp();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initApp() async {
    await Future.delayed(
      Duration(seconds: AppConstants.splashDurationSeconds),
    );
    if (!mounted) return;

    final secureStorage = SecureStorage();
    final hasToken = await secureStorage.hasToken();
    final hasSeenOnboarding = await secureStorage.hasSeenOnboarding();

    if (!mounted) return;

    if (hasToken) {
      // Authenticated — verify token and go home
      ref.read(authProvider.notifier).checkAuth();
      context.go(AppRoutes.home);
    } else if (!hasSeenOnboarding) {
      // First launch — show onboarding
      context.go(AppRoutes.onboarding);
    } else {
      // Returning visitor but not logged in — show action buttons
      setState(() => _showActions = true);
      _fadeController.forward();
    }
  }

  void _continueAsGuest() {
    ref.read(authProvider.notifier).enterGuestMode();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Logo (expanded, vertically centred) ──────────────────────
              const Expanded(
                child: Center(child: AnimatedLogo()),
              ),

              // ── Action buttons (fade in after splash delay) ───────────────
              if (_showActions)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      0,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Login ──────────────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: AppSpacing.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => context.go(AppRoutes.login),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusMd),
                              ),
                            ),
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // ── Register ───────────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: AppSpacing.buttonHeight,
                          child: OutlinedButton(
                            onPressed: () => context.go(AppRoutes.register),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Colors.white70, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusMd),
                              ),
                            ),
                            child: const Text(
                              'Créer un compte',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // ── Continue as guest ──────────────────────────────
                        TextButton(
                          onPressed: _continueAsGuest,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.explore_outlined,
                                  size: 16, color: Colors.white70),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Continuer en mode invité',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
