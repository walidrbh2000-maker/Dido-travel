import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/data/models/guide_model.dart';
import 'package:voyageur/data/models/passenger_input.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/core/constants/app_constants.dart';
import 'package:voyageur/providers/booking/booking_state.dart';

/// Provider global pour le flow de réservation en cours.
/// Une seule réservation active à la fois — reset à la fin ou annulation.
final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState?>(
      (ref) => BookingNotifier(),
    );

class BookingNotifier extends StateNotifier<BookingState?> {
  BookingNotifier() : super(null);

  // ── Initialisation ─────────────────────────────────────────────────────────

  void startBooking(VolEntity flight) {
    state = BookingState(outboundFlight: flight);
  }

  void reset() => state = null;

  // ── Trip type ──────────────────────────────────────────────────────────────

  void setTripType(TripType type) {
    _requireState();
    state = state!.copyWith(
      tripType: type,
      clearReturnFlight: type == TripType.allerSimple,
    );
  }

  void setReturnFlight(VolEntity? flight) {
    _requireState();
    state = flight == null
        ? state!.copyWith(clearReturnFlight: true)
        : state!.copyWith(returnFlight: flight);
  }

  // ── Passagers ──────────────────────────────────────────────────────────────

  void setPassengerCounts({
    required int adultes,
    required int enfants,
    required int bebes,
  }) {
    _requireState();
    assert(adultes >= 1, 'Au moins 1 adulte requis');
    assert(adultes + enfants + bebes <= AppConstants.maxPassengersPerBooking);
    assert(bebes <= adultes, 'Chaque bébé doit être accompagné d\'un adulte');

    final passengers = <PassengerInput>[
      for (int i = 0; i < adultes; i++)
        PassengerInput.adulte(estContact: i == 0),
      for (int i = 0; i < enfants; i++)
        PassengerInput.enfant(),
      for (int i = 0; i < bebes; i++)
        PassengerInput.bebe(),
    ];

    state = state!.copyWith(
      nbAdultes:  adultes,
      nbEnfants:  enfants,
      nbBebes:    bebes,
      passengers: passengers,
    );
  }

  void updatePassenger(String id, PassengerInput updated) {
    _requireState();
    state = state!.copyWith(
      passengers: state!.passengers
          .map((p) => p.id == id ? updated : p)
          .toList(),
    );
  }

  // ── Sièges ─────────────────────────────────────────────────────────────────

  void selectOutboundSeat(String passengerId, int seatId) {
    _requireState();
    state = state!.copyWith(
      passengers: state!.passengers
          .map((p) => p.id == passengerId ? p.copyWith(seatId: seatId) : p)
          .toList(),
    );
  }

  void clearOutboundSeat(String passengerId) {
    _requireState();
    state = state!.copyWith(
      passengers: state!.passengers
          .map((p) => p.id == passengerId ? p.copyWith(clearSeatId: true) : p)
          .toList(),
    );
  }

  void selectReturnSeat(String passengerId, int seatId) {
    _requireState();
    state = state!.copyWith(
      passengers: state!.passengers
          .map((p) => p.id == passengerId ? p.copyWith(seatRetourId: seatId) : p)
          .toList(),
    );
  }

  // ── Extras ─────────────────────────────────────────────────────────────────

  void setHotel(HotelEntity? hotel) {
    _requireState();
    state = hotel == null
        ? state!.copyWith(clearHotel: true)
        : state!.copyWith(selectedHotel: hotel);
  }

  void setGuide(GuideModel? guide) {
    _requireState();
    state = guide == null
        ? state!.copyWith(clearGuide: true)
        : state!.copyWith(selectedGuide: guide);
  }

  // ── Guard ──────────────────────────────────────────────────────────────────

  void _requireState() {
    assert(state != null, 'Booking not initialized. Call startBooking() first.');
  }
}
