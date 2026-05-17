import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/inputs/app_text_field.dart';

class HotelSearchForm extends StatefulWidget {
  final void Function({
    String? destination,
    DateTime? dateDebut,
    DateTime? dateFin,
    int? chambres,
    int? guests,
  }) onSearch;

  const HotelSearchForm({super.key, required this.onSearch});

  @override
  State<HotelSearchForm> createState() => _HotelSearchFormState();
}

class _HotelSearchFormState extends State<HotelSearchForm> {
  final _destinationController = TextEditingController();
  DateTime? _dateDebut;
  DateTime? _dateFin;
  int _chambres = 1;
  int _guests = 1;

  @override
  void dispose() {
    _destinationController.dispose();
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

  void _submit() {
    widget.onSearch(
      destination: _destinationController.text.isEmpty ? null : _destinationController.text,
      dateDebut: _dateDebut,
      dateFin: _dateFin,
      chambres: _chambres,
      guests: _guests,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _destinationController,
            hint: 'Destination ou ville',
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'Arrivée',
                  value: _dateDebut,
                  onTap: () => _pickDate(true),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DateField(
                  label: 'Départ',
                  value: _dateFin,
                  onTap: () => _pickDate(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _CounterField(
                  label: 'Chambres',
                  value: _chambres,
                  onMinus: () => setState(() => _chambres = _chambres > 1 ? _chambres - 1 : 1),
                  onPlus: () => setState(() => _chambres++),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _CounterField(
                  label: 'Voyageurs',
                  value: _guests,
                  onMinus: () => setState(() => _guests = _guests > 1 ? _guests - 1 : 1),
                  onPlus: () => setState(() => _guests++),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Rechercher',
            icon: Icons.search,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateField({required this.label, this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.shimmerBase),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                Text(
                  value != null
                      ? '${value!.day}/${value!.month}/${value!.year}'
                      : 'Choisir',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: value != null ? AppColors.textPrimary : AppColors.textSecondary,
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

class _CounterField extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _CounterField({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.shimmerBase),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              Text('$value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            children: [
              _CircleButton(icon: Icons.remove, onTap: onMinus),
              const SizedBox(width: AppSpacing.xs),
              _CircleButton(icon: Icons.add, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
