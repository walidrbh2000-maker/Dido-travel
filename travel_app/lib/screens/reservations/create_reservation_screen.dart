import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/reservation/reservation_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/inputs/app_text_field.dart';

class CreateReservationScreen extends ConsumerStatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  ConsumerState<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState
    extends ConsumerState<CreateReservationScreen> {
  final _personsController = TextEditingController(text: '1');
  DateTime? _dateDebut;
  DateTime? _dateFin;
  bool _isLoading = false;

  @override
  void dispose() {
    _personsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('fr'),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _dateDebut = picked;
      } else {
        _dateFin = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (_dateDebut == null || _dateFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les dates'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success =
        await ref.read(reservationsProvider.notifier).create({
      'date_debut': _dateDebut!.toIso8601String(),
      'date_fin': _dateFin!.toIso8601String(),
      'nombre_personnes': int.tryParse(_personsController.text) ?? 1,
    });

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // push() → retour possible vers le détail vol / hôtel
      context.push(AppRoutes.payment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la création'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle réservation'),
        // Bouton retour automatique
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails de la réservation',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _personsController,
              hint: 'Nombre de personnes',
              prefixIcon: const Icon(Icons.people),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DateField(
              label: 'Date de début',
              value: _dateDebut,
              onTap: () => _pickDate(true),
            ),
            const SizedBox(height: AppSpacing.md),
            _DateField(
              label: 'Date de fin',
              value: _dateFin,
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Confirmer la réservation',
              icon: Icons.check,
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.shimmerBase),
          borderRadius:
              BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value != null
                      ? '${value!.day.toString().padLeft(2, '0')}/${value!.month.toString().padLeft(2, '0')}/${value!.year}'
                      : 'Choisir une date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: value != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
