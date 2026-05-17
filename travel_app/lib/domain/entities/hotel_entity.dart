import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final int id;
  final String nom;
  final int destinationId;
  final int etoiles;
  final double prixNuit;
  final String adresse;
  final String? description;
  final String? image;
  final bool disponible;

  const HotelEntity({
    required this.id,
    required this.nom,
    required this.destinationId,
    this.etoiles = 3,
    required this.prixNuit,
    required this.adresse,
    this.description,
    this.image,
    this.disponible = true,
  });

  @override
  List<Object?> get props => [id, nom, prixNuit, etoiles];
}
