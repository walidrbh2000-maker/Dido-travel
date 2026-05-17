import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/providers/destination/destination_provider.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/screens/home/widgets/greeting_header.dart';
import 'package:voyageur/screens/home/widgets/search_bar_home.dart';
import 'package:voyageur/screens/home/widgets/featured_destinations.dart';
import 'package:voyageur/screens/home/widgets/popular_vols.dart';
import 'package:voyageur/screens/home/widgets/promo_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsAsync = ref.watch(destinationsProvider);
    final volsAsync = ref.watch(volsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(destinationsProvider);
            ref.invalidate(volsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GreetingHeader(),
                const SizedBox(height: AppSpacing.lg),
                const SearchBarHome(),
                const SizedBox(height: AppSpacing.xl),
                destinationsAsync.when(
                  loading: () => const FeaturedDestinations(
                    destinations: [],
                    isLoading: true,
                  ),
                  error: (_, __) => const FeaturedDestinations(
                    destinations: [],
                  ),
                  data: (destinations) => FeaturedDestinations(
                    destinations: destinations,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PromoBanner(),
                const SizedBox(height: AppSpacing.xl),
                volsAsync.when(
                  loading: () => const PopularVols(vols: [], isLoading: true),
                  error: (_, __) => const PopularVols(vols: []),
                  data: (vols) => PopularVols(vols: vols),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
