import 'package:equatable/equatable.dart';

class VolEntity extends Equatable {
  final int id;
  final String compagnie;
  final String numeroVol;
  final int destinationId;
  final String? destinationName;
  final String? destinationCountry;
  final DateTime dateDepart;
  final DateTime dateArrivee;
  final double prix;
  final int placesDisponibles;
  final String classe;
  final String statut;

  const VolEntity({
    required this.id,
    required this.compagnie,
    required this.numeroVol,
    required this.destinationId,
    this.destinationName,
    this.destinationCountry,
    required this.dateDepart,
    required this.dateArrivee,
    required this.prix,
    required this.placesDisponibles,
    this.classe = 'economique',
    this.statut = 'programme',
  });

  String get classeLabel {
    switch (classe) {
      case 'affaires':
        return 'Affaires';
      case 'premiere':
        return 'Première';
      default:
        return 'Économique';
    }
  }

  @override
  List<Object?> get props => [id, compagnie, numeroVol, dateDepart, prix];
}
