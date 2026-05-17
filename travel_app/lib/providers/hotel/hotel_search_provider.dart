import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotelSearchParams {
  final String? destination;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final int? chambres;
  final int? guests;
  final double? prixMax;

  const HotelSearchParams({
    this.destination,
    this.dateDebut,
    this.dateFin,
    this.chambres,
    this.guests,
    this.prixMax,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (destination != null) params['destination'] = destination;
    if (dateDebut != null) params['date_debut'] = dateDebut!.toIso8601String();
    if (dateFin != null) params['date_fin'] = dateFin!.toIso8601String();
    if (chambres != null) params['chambres'] = chambres;
    if (guests != null) params['guests'] = guests;
    if (prixMax != null) params['prix_max'] = prixMax;
    return params;
  }
}

final hotelSearchProvider =
    StateProvider<HotelSearchParams>((ref) => const HotelSearchParams());
