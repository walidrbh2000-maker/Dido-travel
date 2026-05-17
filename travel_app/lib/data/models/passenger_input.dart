import 'package:uuid/uuid.dart';
import 'package:voyageur/core/constants/app_constants.dart';

enum PassengerType { adulte, enfant, bebe }
enum Genre { homme, femme }

/// Modèle local (non sérialisé depuis l'API) représentant
/// un passager en cours de saisie dans le flow de réservation.
class PassengerInput {
  final String id;
  final PassengerType type;
  final String? prenom;
  final String? nom;
  final DateTime? dateNaissance;
  final String? numeroPasseport;
  final String? nationalite;
  final Genre? genre;
  final int? seatId;
  final int? seatRetourId;
  final bool estContactPrincipal;

  const PassengerInput({
    required this.id,
    required this.type,
    this.prenom,
    this.nom,
    this.dateNaissance,
    this.numeroPasseport,
    this.nationalite,
    this.genre,
    this.seatId,
    this.seatRetourId,
    this.estContactPrincipal = false,
  });

  factory PassengerInput.adulte({bool estContact = false}) => PassengerInput(
    id: const Uuid().v4(),
    type: PassengerType.adulte,
    estContactPrincipal: estContact,
  );

  factory PassengerInput.enfant() => PassengerInput(
    id: const Uuid().v4(),
    type: PassengerType.enfant,
  );

  factory PassengerInput.bebe() => PassengerInput(
    id: const Uuid().v4(),
    type: PassengerType.bebe,
  );

  PassengerInput copyWith({
    PassengerType? type,
    String? prenom,
    String? nom,
    DateTime? dateNaissance,
    String? numeroPasseport,
    String? nationalite,
    Genre? genre,
    int? seatId,
    int? seatRetourId,
    bool? estContactPrincipal,
    bool clearSeatId = false,
    bool clearSeatRetourId = false,
  }) => PassengerInput(
    id:                   id,
    type:                 type ?? this.type,
    prenom:               prenom ?? this.prenom,
    nom:                  nom ?? this.nom,
    dateNaissance:        dateNaissance ?? this.dateNaissance,
    numeroPasseport:      numeroPasseport ?? this.numeroPasseport,
    nationalite:          nationalite ?? this.nationalite,
    genre:                genre ?? this.genre,
    seatId:               clearSeatId ? null : (seatId ?? this.seatId),
    seatRetourId:         clearSeatRetourId ? null : (seatRetourId ?? this.seatRetourId),
    estContactPrincipal:  estContactPrincipal ?? this.estContactPrincipal,
  );

  // ── Getters utiles ─────────────────────────────────────────────────────────

  bool get isComplete =>
      prenom != null && prenom!.isNotEmpty &&
      nom != null && nom!.isNotEmpty &&
      dateNaissance != null &&
      genre != null;

  bool get isBebe => type == PassengerType.bebe;
  bool get needsSeat => type != PassengerType.bebe;

  int get ageActuel {
    if (dateNaissance == null) return 0;
    return DateTime.now().difference(dateNaissance!).inDays ~/ 365;
  }

  String get displayName =>
      (prenom != null && nom != null) ? '$prenom $nom' : typeLabel;

  String get typeLabel => switch (type) {
    PassengerType.adulte => 'Adulte',
    PassengerType.enfant => 'Enfant (2–11 ans)',
    PassengerType.bebe   => 'Bébé (< 2 ans)',
  };

  /// Payload JSON à envoyer à l'API.
  Map<String, dynamic> toJson() => {
    'prenom':               prenom,
    'nom':                  nom,
    'date_naissance':       dateNaissance?.toIso8601String().split('T').first,
    'genre':                genre?.name,
    'numero_passeport':     numeroPasseport,
    'nationalite':          nationalite,
    if (seatId != null)       'seat_id':        seatId,
    if (seatRetourId != null) 'seat_retour_id': seatRetourId,
    'est_contact_principal': estContactPrincipal,
  };
}