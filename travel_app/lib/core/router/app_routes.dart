class AppRoutes {
  const AppRoutes._();

  static const String splash      = '/splash';
  static const String onboarding  = '/onboarding';
  static const String login       = '/auth/login';
  static const String register    = '/auth/register';
  static const String home        = '/home';

  // Vols
  static const String vols      = '/vols';
  static const String volList   = '/vols/list';
  static const String volDetail = '/vols/:id';

  // Booking flow
  static const String bookingTripType       = '/booking/trip-type';
  static const String bookingReturnFlight   = '/booking/return-flight';
  static const String bookingPassengers     = '/booking/passengers';
  static const String bookingPassengerDetails = '/booking/passenger-details';
  static const String bookingSeatOutbound   = '/booking/seats/outbound';
  static const String bookingSeatReturn     = '/booking/seats/return';
  static const String bookingExtras         = '/booking/extras';
  static const String bookingSummary        = '/booking/summary';

  // Hotels
  static const String hotels      = '/hotels';
  static const String hotelList   = '/hotels/list';
  static const String hotelDetail = '/hotels/:id';

  // Reservations
  static const String reservations      = '/reservations';
  static const String createReservation = '/reservations/create';
  static const String reservationDetail = '/reservations/:id';

  // Payment
  static const String payment        = '/payment';
  static const String paymentSuccess = '/payment/success';

  // Destinations
  static const String destinations     = '/destinations';
  static const String destinationDetail = '/destinations/:id';

  // Guides
  static const String guides      = '/guides';
  static const String guideDetail = '/guides/:id';

  // Profile
  static const String profile     = '/profile';
  static const String editProfile = '/profile/edit';

  // Helpers
  static String volDetailPath(int id)         => '/vols/$id';
  static String hotelDetailPath(int id)       => '/hotels/$id';
  static String reservationDetailPath(int id) => '/reservations/$id';
  static String destinationDetailPath(int id) => '/destinations/$id';
  static String guideDetailPath(int id)       => '/guides/$id';
}