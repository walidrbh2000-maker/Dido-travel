import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class DestinationFilterBar extends StatelessWidget {
  final String? selectedCountry;
  final ValueChanged<String?>? onCountryChanged;

  const DestinationFilterBar({
    super.key,
    this.selectedCountry,
    this.onCountryChanged,
  });

  static const _countries = ['Tous', 'France', 'Maroc', 'Tunisie', 'Espagne', 'Italie', 'Turquie', 'Grèce'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final country = _countries[index];
          final isSelected = country == (selectedCountry ?? 'Tous');
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (_) => onCountryChanged?.call(
                country == 'Tous' ? null : country,
              ),
            ),
          );
        },
      ),
    );
  }
}
