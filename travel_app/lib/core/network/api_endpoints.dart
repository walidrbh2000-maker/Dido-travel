class ApiEndpoints {
  const ApiEndpoints._();

  // Auth
  static const String register = '/register';
  static const String login    = '/login';
  static const String logout   = '/logout';
  static const String me       = '/me';

  // Destinations
  static const String destinations = '/destinations';
  static String destinationDetail(int id) => '/destinations/$id';

  // Vols
  static const String vols = '/vols';
  static String volDetail(int id) => '/vols/$id';

  // Sièges
  static String volSeats(int volId) => '/vols/$volId/seats';
  static String lockSeat(int volId, int seatId) => '/vols/$volId/seats/$seatId/lock';
  static String unlockSeat(int volId, int seatId) => '/vols/$volId/seats/$seatId/lock';

  // Hotels
  static const String hotels = '/hotels';
  static String hotelDetail(int id) => '/hotels/$id';

  // Reservations
  static const String reservations = '/reservations';
  static String reservationDetail(int id) => '/reservations/$id';
  static String reservationTicket(int id) => '/reservations/$id/ticket';

  // Payments
  static const String payments = '/payments/process';
  static String paymentDetail(int id) => '/payments/$id';

  // Guides
  static const String guides = '/guides';
  static String guideDetail(int id) => '/guides/$id';
}