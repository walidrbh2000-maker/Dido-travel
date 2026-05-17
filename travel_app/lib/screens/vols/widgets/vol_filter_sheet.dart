import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class VolFilterSheet extends StatefulWidget {
  final double? prixMax;
  final String? classe;
  final ValueChanged<Map<String, dynamic>> onApply;

  const VolFilterSheet({
    super.key,
    this.prixMax,
    this.classe,
    required this.onApply,
  });

  @override
  State<VolFilterSheet> createState() => _VolFilterSheetState();
}

class _VolFilterSheetState extends State<VolFilterSheet> {
  late double _prixMax;
  late String? _classe;

  @override
  void initState() {
    super.initState();
    _prixMax = widget.prixMax ?? 2000;
    _classe = widget.classe;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtrer les vols', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xl),
          const Text('Prix maximum', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Slider(
            value: _prixMax,
            min: 50,
            max: 5000,
            divisions: 49,
            label: '${_prixMax.round()} €',
            onChanged: (v) => setState(() => _prixMax = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Classe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: ['economique', 'affaires', 'premiere'].map((c) {
              final labels = {'economique': 'Économique', 'affaires': 'Affaires', 'premiere': 'Première'};
              final isSelected = _classe == c;
              return ChoiceChip(
                label: Text(labels[c]!),
                selected: isSelected,
                onSelected: (_) => setState(() => _classe = isSelected ? null : c),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply({'prix_max': _prixMax, if (_classe != null) 'classe': _classe});
                Navigator.pop(context);
              },
              child: const Text('Appliquer'),
            ),
          ),
        ],
      ),
    );
  }
}
