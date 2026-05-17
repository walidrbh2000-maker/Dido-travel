import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/inputs/app_text_field.dart';

class VolSearchForm extends StatefulWidget {
  /// Appelé lorsque l'utilisateur lance la recherche.
  /// Tous les paramètres sont optionnels.
  final void Function({
    String? destination,
    DateTime? dateDepart,
    int? passagers,
  })? onSearch;

  const VolSearchForm({super.key, this.onSearch});

  @override
  State<VolSearchForm> createState() => _VolSearchFormState();
}

class _VolSearchFormState extends State<VolSearchForm> {
  final _toController = TextEditingController();
  DateTime? _departureDate;
  int _passengers = 1;

  @override
  void dispose() {
    _toController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _departureDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _departureDate = date);
  }

  void _submit() {
    widget.onSearch?.call(
      destination:
          _toController.text.trim().isEmpty ? null : _toController.text.trim(),
      dateDepart: _departureDate,
      passagers: _passengers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Destination',
          hint: 'Où souhaitez-vous aller ?',
          controller: _toController,
          prefixIcon: const Icon(Icons.flight_land),
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: AppTextField(
              label: 'Date de départ',
              hint: _departureDate != null
                  ? '${_departureDate!.day}/${_departureDate!.month}/${_departureDate!.year}'
                  : 'Sélectionner une date',
              prefixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Text(
              'Passagers',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                if (_passengers > 1) setState(() => _passengers--);
              },
              icon: const Icon(
                Icons.remove_circle_outline,
                color: AppColors.primary,
              ),
            ),
            Text(
              '$_passengers',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: () {
                if (_passengers < 10) setState(() => _passengers++);
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: 'Rechercher',
          icon: Icons.search,
          onPressed: _submit,
        ),
      ],
    );
  }
}
