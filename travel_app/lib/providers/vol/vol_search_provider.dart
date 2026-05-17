import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolSearchParams {
  final String? destination;
  final DateTime? dateDepart;
  final int? passagers;
  final String? classe;
  final double? prixMax;

  const VolSearchParams({
    this.destination,
    this.dateDepart,
    this.passagers,
    this.classe,
    this.prixMax,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (destination != null) params['destination'] = destination;
    if (dateDepart != null) params['date_depart'] = dateDepart!.toIso8601String();
    if (passagers != null) params['passagers'] = passagers;
    if (classe != null) params['classe'] = classe;
    if (prixMax != null) params['prix_max'] = prixMax;
    return params;
  }
}

final volSearchProvider =
    StateProvider<VolSearchParams>((ref) => const VolSearchParams());
