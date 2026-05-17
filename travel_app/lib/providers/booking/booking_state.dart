import 'package:voyageur/data/models/guide_model.dart';
import 'package:voyageur/data/models/passenger_input.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';

enum TripType { allerSimple, allerRetour }

class BookingState {
  final VolEntity outboundFlight;
  final TripType tripType;
  final VolEntity? returnFlight;
  final int nbAdultes;
  final int nbEnfants;
  final int nbBebes;
  final List<PassengerInput> passengers;
  final HotelEntity? selectedHotel;
  final GuideModel? selectedGuide;

  const BookingState({
    required this.outboundFlight,
    this.tripType = TripType.allerSimple,
    this.returnFlight,
    this.nbAdultes = 1,
    this.nbEnfants = 0,
    this.nbBebes = 0,
    this.passengers = const [],
    this.selectedHotel,
    this.selectedGuide,
  });

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalPassengers => nbAdultes + nbEnfants + nbBebes;
  int get totalNonBebes   => nbAdultes + nbEnfants;

  bool get isRoundTrip => tripType == TripType.allerRetour;

  bool get isPassengerDetailsComplete =>
      passengers.isNotEmpty && passengers.every((p) => p.isComplete);

  bool get isOutboundSeatsComplete =>
      passengers
          .where((p) => p.needsSeat)
          .every((p) => p.seatId != null);

  bool get isReturnSeatsComplete {
    if (!isRoundTrip) return true;
    return passengers
        .where((p) => p.needsSeat)
        .every((p) => p.seatRetourId != null);
  }

  bool get isReadyToBook =>
      isPassengerDetailsComplete &&
      isOutboundSeatsComplete &&
      isReturnSeatsComplete;

  String get tripTypeLabel =>
      isRoundTrip ? 'Aller-Retour' : 'Aller Simple';

  double get estimatedTotal {
    double total = 0;
    for (final p in passengers) {
      final mult = switch (p.type) {
        PassengerType.bebe   => 0.10,
        PassengerType.enfant => 0.75,
        PassengerType.adulte => 1.00,
      };
      total += outboundFlight.prix * mult;
      if (isRoundTrip && returnFlight != null) {
        total += returnFlight!.prix * mult;
      }
    }
    return total;
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  BookingState copyWith({
    TripType? tripType,
    VolEntity? returnFlight,
    bool clearReturnFlight = false,
    int? nbAdultes,
    int? nbEnfants,
    int? nbBebes,
    List<PassengerInput>? passengers,
    HotelEntity? selectedHotel,
    bool clearHotel = false,
    GuideModel? selectedGuide,
    bool clearGuide = false,
  }) => BookingState(
    outboundFlight: outboundFlight,
    tripType:       tripType ?? this.tripType,
    returnFlight:   clearReturnFlight ? null : (returnFlight ?? this.returnFlight),
    nbAdultes:      nbAdultes ?? this.nbAdultes,
    nbEnfants:      nbEnfants ?? this.nbEnfants,
    nbBebes:        nbBebes ?? this.nbBebes,
    passengers:     passengers ?? this.passengers,
    selectedHotel:  clearHotel ? null : (selectedHotel ?? this.selectedHotel),
    selectedGuide:  clearGuide ? null : (selectedGuide ?? this.selectedGuide),
  );

  /// Payload final pour l'API
  Map<String, dynamic> toApiPayload(DateTime dateDebut, DateTime dateFin) => {
    'type_trajet':  isRoundTrip ? 'aller_retour' : 'aller_simple',
    'vol_id':       outboundFlight.id,
    if (isRoundTrip && returnFlight != null)
      'vol_retour_id': returnFlight!.id,
    'date_debut':   dateDebut.toIso8601String().split('T').first,
    'date_fin':     dateFin.toIso8601String().split('T').first,
    if (selectedHotel != null) 'hotel_id': selectedHotel!.id,
    if (selectedGuide != null) 'guide_id': selectedGuide!.id,
    'passengers':   passengers.map((p) => p.toJson()).toList(),
  };
}