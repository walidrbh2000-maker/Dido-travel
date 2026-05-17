import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/shared_widgets/navigation/main_navigation_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  /// Utilisé pour le "appuyer deux fois pour quitter"
  DateTime? _lastBackPress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.vols)) {
      _currentIndex = 1;
    } else if (location.startsWith(AppRoutes.hotels)) {
      _currentIndex = 2;
    } else if (location.startsWith(AppRoutes.reservations)) {
      _currentIndex = 3;
    } else if (location.startsWith(AppRoutes.profile)) {
      _currentIndex = 4;
    } else {
      _currentIndex = 0;
    }
  }

  /// Gère le bouton retour physique sur les écrans racines.
  /// Premier appui → snackbar. Deuxième appui (< 2 s) → quitter.
  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop) return;

    final now = DateTime.now();
    final isSecondTap = _lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2);

    if (isSecondTap) {
      await SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Appuyez à nouveau pour quitter'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false → on gère manuellement le comportement du retour
      // sur les onglets racines afin d'éviter une sortie accidentelle.
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: widget.child,
        bottomNavigationBar: MainNavigationBar(currentIndex: _currentIndex),
      ),
    );
  }
}
