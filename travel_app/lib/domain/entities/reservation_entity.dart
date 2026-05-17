import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final int id;
  final int userId;
  final int volId;
  final int? hotelId;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int nombrePersonnes;
  final double prixTotal;
  final String statut;
  final String reference;

  const ReservationEntity({
    required this.id,
    required this.userId,
    required this.volId,
    this.hotelId,
    required this.dateDebut,
    required this.dateFin,
    required this.nombrePersonnes,
    required this.prixTotal,
    required this.statut,
    required this.reference,
  });

  bool get isActive => statut == 'en_attente' || statut == 'confirmee';
  bool get isCancelled => statut == 'annulee';
  bool get isPaid => statut == 'payee';

  String get statutLabel {
    switch (statut) {
      case 'en_attente':
        return 'En attente';
      case 'confirmee':
        return 'Confirmée';
      case 'annulee':
        return 'Annulée';
      case 'payee':
        return 'Payée';
      default:
        return statut;
    }
  }

  @override
  List<Object?> get props => [id, reference, statut];
}
