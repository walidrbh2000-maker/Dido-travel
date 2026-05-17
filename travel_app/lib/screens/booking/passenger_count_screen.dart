import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_constants.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/booking/booking_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';

class PassengerCountScreen extends ConsumerStatefulWidget {
  const PassengerCountScreen({super.key});

  @override
  ConsumerState<PassengerCountScreen> createState() =>
      _PassengerCountScreenState();
}

class _PassengerCountScreenState extends ConsumerState<PassengerCountScreen> {
  int _adultes = 1;
  int _enfants = 0;
  int _bebes   = 0;

  int get _total => _adultes + _enfants + _bebes;

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passagers')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nombre de passagers',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Maximum ${AppConstants.maxPassengersPerBooking} passagers par réservation',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.xl),

            _PassengerRow(
              label: 'Adultes',
              subLabel: '12 ans et plus',
              icon: Icons.person,
              count: _adultes,
              onMinus: _adultes > 1 ? () => setState(() => _adultes--) : null,
              onPlus: _total < AppConstants.maxPassengersPerBooking
                  ? () => setState(() => _adultes++)
                  : null,
            ),
            const Divider(height: AppSpacing.xl),

            _PassengerRow(
              label: 'Enfants',
              subLabel: '2 à 11 ans • siège inclus',
              icon: Icons.child_care,
              count: _enfants,
              onMinus: _enfants > 0 ? () => setState(() => _enfants--) : null,
              onPlus: _total < AppConstants.maxPassengersPerBooking
                  ? () => setState(() => _enfants++)
                  : null,
            ),
            const Divider(height: AppSpacing.xl),

            _PassengerRow(
              label: 'Bébés',
              subLabel: 'Moins de 2 ans • sur les genoux',
              icon: Icons.baby_changing_station,
              count: _bebes,
              onMinus: _bebes > 0 ? () => setState(() => _bebes--) : null,
              onPlus: (_total < AppConstants.maxPassengersPerBooking &&
                      _bebes < _adultes)
                  ? () => setState(() => _bebes++)
                  : null,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Règles d'information
            _InfoBox(
              children: [
                _InfoItem(
                  icon: Icons.info_outline,
                  text: '1 adulte minimum requis pour toute réservation.',
                ),
                _InfoItem(
                  icon: Icons.baby_changing_station,
                  text: 'Un bébé (< 2 ans) voyage sur les genoux d\'un adulte, '
                      'sans siège propre, au tarif de 10 % du prix adulte.',
                ),
                _InfoItem(
                  icon: Icons.person_outline,
                  text: 'Un mineur (< 18 ans) doit être accompagné d\'un adulte.',
                ),
              ],
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // Récapitulatif
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total passagers',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$_total / ${AppConstants.maxPassengersPerBooking}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            PrimaryButton(
              label: 'Continuer',
              icon: Icons.arrow_forward,
              onPressed: _validate,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _validate() {
    setState(() => _errorMessage = null);

    if (_adultes < 1) {
      setState(() => _errorMessage = 'Au moins 1 adulte est requis.');
      return;
    }
    if (_bebes > _adultes) {
      setState(() => _errorMessage =
          'Le nombre de bébés ne peut pas dépasser le nombre d\'adultes.');
      return;
    }
    if (_total > AppConstants.maxPassengersPerBooking) {
      setState(() => _errorMessage =
          'Maximum ${AppConstants.maxPassengersPerBooking} passagers.');
      return;
    }

    ref.read(bookingProvider.notifier).setPassengerCounts(
      adultes: _adultes,
      enfants: _enfants,
      bebes: _bebes,
    );
    context.push(AppRoutes.bookingPassengerDetails);
  }
}

// ── Sous-composants ──────────────────────────────────────────────────────────

class _PassengerRow extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final int count;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _PassengerRow({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.count,
    this.onMinus,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(subLabel, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        _CircleBtn(icon: Icons.remove, onTap: onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        _CircleBtn(icon: Icons.add, onTap: onPlus),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.shimmerBase,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final List<Widget> children;

  const _InfoBox({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}