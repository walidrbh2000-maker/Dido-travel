import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/providers/auth/guest_provider.dart';
import 'package:voyageur/providers/booking/booking_provider.dart';
import 'package:voyageur/providers/booking/booking_state.dart';
import 'package:voyageur/screens/auth/guest_prompt_sheet.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';

class TripTypeScreen extends ConsumerStatefulWidget {
  final VolEntity outboundFlight;

  const TripTypeScreen({super.key, required this.outboundFlight});

  @override
  ConsumerState<TripTypeScreen> createState() => _TripTypeScreenState();
}

class _TripTypeScreenState extends ConsumerState<TripTypeScreen> {
  TripType _selected = TripType.allerSimple;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Rediriger les invités immédiatement — filet de sécurité
      // (le router bloque déjà l'accès, mais on garde cette garde
      // pour les deep links ou toute navigation directe non filtrée).
      final isGuest = ref.read(isGuestProvider);
      if (isGuest) {
        GuestPromptSheet.show(context, reason: 'pour réserver ce vol');
        context.pop();
        return;
      }
      ref.read(bookingProvider.notifier).startBooking(widget.outboundFlight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);

    // Garde rendue — en cas de race condition avant le pop
    if (isGuest) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Type de voyage')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              'Choisissez votre type de trajet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xl),

            _TripTypeCard(
              type: TripType.allerSimple,
              selected: _selected == TripType.allerSimple,
              onTap: () => setState(() => _selected = TripType.allerSimple),
            ),
            const SizedBox(height: AppSpacing.md),
            _TripTypeCard(
              type: TripType.allerRetour,
              selected: _selected == TripType.allerRetour,
              onTap: () => setState(() => _selected = TripType.allerRetour),
            ),

            const Spacer(),
            PrimaryButton(
              label: 'Continuer',
              icon: Icons.arrow_forward,
              onPressed: _onContinue,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    ref.read(bookingProvider.notifier).setTripType(_selected);

    if (_selected == TripType.allerRetour) {
      context.push(AppRoutes.bookingReturnFlight);
    } else {
      context.push(AppRoutes.bookingPassengers);
    }
  }
}

// ── Carte type de trajet ──────────────────────────────────────────────────────

class _TripTypeCard extends StatelessWidget {
  final TripType type;
  final bool selected;
  final VoidCallback onTap;

  const _TripTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRoundTrip = type == TripType.allerRetour;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.07)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.shimmerBase,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.background,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: Icon(
                isRoundTrip ? Icons.compare_arrows : Icons.arrow_forward,
                color:
                    selected ? AppColors.primary : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRoundTrip ? 'Aller-Retour' : 'Aller Simple',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRoundTrip
                        ? 'Sélectionnez un vol aller et un vol retour'
                        : 'Un seul vol, sans retour prévu',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
