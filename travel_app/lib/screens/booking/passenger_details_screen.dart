import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_constants.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/data/models/passenger_input.dart';
import 'package:voyageur/providers/booking/booking_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/buttons/secondary_button.dart';
import 'package:voyageur/shared_widgets/inputs/app_text_field.dart';

class PassengerDetailsScreen extends ConsumerStatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  ConsumerState<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends ConsumerState<PassengerDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Erreur: réservation non initialisée')));
    }

    final passengers = booking.passengers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Passager ${_currentPage + 1} / ${passengers.length}'),
      ),
      body: Column(
        children: [
          // Indicateur de progression
          _ProgressIndicator(
            total: passengers.length,
            current: _currentPage,
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: passengers.length,
              itemBuilder: (context, index) => _PassengerForm(
                key: ValueKey(passengers[index].id),
                passenger: passengers[index],
                onUpdated: (updated) {
                  ref.read(bookingProvider.notifier)
                      .updatePassenger(passengers[index].id, updated);
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (_currentPage > 0) ...[
                  Expanded(
                    child: SecondaryButton(
                      label: 'Précédent',
                      icon: Icons.arrow_back,
                      onPressed: _previousPage,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _currentPage < passengers.length - 1
                        ? 'Suivant'
                        : 'Sélectionner les sièges',
                    icon: _currentPage < passengers.length - 1
                        ? Icons.arrow_forward
                        : Icons.event_seat,
                    onPressed: _nextPage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage--);
  }

  void _nextPage() {
    final booking = ref.read(bookingProvider);
    if (booking == null) return;

    final passenger = booking.passengers[_currentPage];

    if (!passenger.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validation d'âge
    final error = _validateAge(passenger);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    if (_currentPage < booking.passengers.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      context.push(AppRoutes.bookingSeatOutbound);
    }
  }

  String? _validateAge(PassengerInput p) {
    if (p.dateNaissance == null) return null;
    final age = p.ageActuel;

    switch (p.type) {
      case PassengerType.adulte:
        if (age < AppConstants.ageMinAdulte) {
          return 'Un adulte doit avoir au moins ${AppConstants.ageMinAdulte} ans.';
        }
      case PassengerType.enfant:
        if (age < AppConstants.ageMinEnfant || age >= AppConstants.ageMinAdulte) {
          return 'Un enfant doit avoir entre ${AppConstants.ageMinEnfant} et '
              '${AppConstants.ageMinAdulte - 1} ans.';
        }
      case PassengerType.bebe:
        if (age >= AppConstants.ageMinEnfant) {
          return 'Un bébé doit avoir moins de ${AppConstants.ageMinEnfant} ans.';
        }
    }
    return null;
  }
}

// ── Formulaire d'un passager ─────────────────────────────────────────────────

class _PassengerForm extends StatefulWidget {
  final PassengerInput passenger;
  final ValueChanged<PassengerInput> onUpdated;

  const _PassengerForm({
    super.key,
    required this.passenger,
    required this.onUpdated,
  });

  @override
  State<_PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<_PassengerForm> {
  late TextEditingController _prenomCtrl;
  late TextEditingController _nomCtrl;
  late TextEditingController _passportCtrl;
  DateTime? _dateNaissance;
  Genre? _genre;

  @override
  void initState() {
    super.initState();
    final p = widget.passenger;
    _prenomCtrl   = TextEditingController(text: p.prenom ?? '');
    _nomCtrl      = TextEditingController(text: p.nom ?? '');
    _passportCtrl = TextEditingController(text: p.numeroPasseport ?? '');
    _dateNaissance = p.dateNaissance;
    _genre = p.genre;
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _passportCtrl.dispose();
    super.dispose();
  }

  void _update() {
    widget.onUpdated(widget.passenger.copyWith(
      prenom:          _prenomCtrl.text.trim().isEmpty ? null : _prenomCtrl.text.trim(),
      nom:             _nomCtrl.text.trim().isEmpty ? null : _nomCtrl.text.trim(),
      dateNaissance:   _dateNaissance,
      genre:           _genre,
      numeroPasseport: _passportCtrl.text.trim().isEmpty ? null : _passportCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge type passager
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
            ),
            child: Text(
              widget.passenger.typeLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Prénom
          AppTextField(
            label: 'Prénom *',
            hint: 'Comme sur le passeport',
            controller: _prenomCtrl,
            onChanged: (_) => _update(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Nom
          AppTextField(
            label: 'Nom *',
            hint: 'Comme sur le passeport',
            controller: _nomCtrl,
            onChanged: (_) => _update(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Date de naissance
          const Text(
            'Date de naissance *',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          GestureDetector(
            onTap: () => _pickDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _dateNaissance != null
                        ? '${_dateNaissance!.day.toString().padLeft(2,'0')}/'
                          '${_dateNaissance!.month.toString().padLeft(2,'0')}/'
                          '${_dateNaissance!.year}'
                        : 'Sélectionner',
                    style: TextStyle(
                      color: _dateNaissance != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  if (_dateNaissance != null) ...[
                    const Spacer(),
                    Text(
                      '${_calcAge()} ans',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Genre
          const Text(
            'Genre *',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  label: 'Homme',
                  icon: Icons.male,
                  selected: _genre == Genre.homme,
                  onTap: () {
                    setState(() => _genre = Genre.homme);
                    _update();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _GenderCard(
                  label: 'Femme',
                  icon: Icons.female,
                  selected: _genre == Genre.femme,
                  onTap: () {
                    setState(() => _genre = Genre.femme);
                    _update();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Passeport (optionnel)
          AppTextField(
            label: 'N° Passeport (optionnel)',
            hint: 'Ex: AB123456',
            controller: _passportCtrl,
            onChanged: (_) => _update(),
          ),

          if (widget.passenger.isBebe) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.secondary, size: 18),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Le bébé voyagera sur les genoux d\'un adulte. '
                      'Aucun siège ne lui sera assigné.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _calcAge() {
    if (_dateNaissance == null) return 0;
    return DateTime.now().difference(_dateNaissance!).inDays ~/ 365;
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime firstDate;
    DateTime lastDate;

    switch (widget.passenger.type) {
      case PassengerType.adulte:
        firstDate = DateTime(now.year - 120);
        lastDate  = DateTime(now.year - AppConstants.ageMinAdulte, now.month, now.day);
      case PassengerType.enfant:
        firstDate = DateTime(now.year - AppConstants.ageMinAdulte + 1, now.month, now.day);
        lastDate  = DateTime(now.year - AppConstants.ageMinEnfant, now.month, now.day);
      case PassengerType.bebe:
        firstDate = DateTime(now.year - AppConstants.ageMinEnfant + 1, now.month, now.day);
        lastDate  = now.subtract(const Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateNaissance ?? lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('fr'),
    );

    if (picked != null) {
      setState(() => _dateNaissance = picked);
      _update();
    }
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.08) : AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.shimmerBase,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int total;
  final int current;

  const _ProgressIndicator({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: List.generate(total, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                decoration: BoxDecoration(
                  color: done || active ? AppColors.primary : AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}