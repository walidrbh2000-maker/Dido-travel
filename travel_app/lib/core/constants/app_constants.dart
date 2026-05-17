class AppConstants {
  const AppConstants._();

  /// URL de base de l'API.
  ///
  /// Android émulateur  → http://10.0.2.2:8080/api/v1
  /// Appareil physique  → URL ngrok (ex. https://tiger-sudoku-tiara.ngrok-free.dev/api/v1)
  /// iOS simulateur     → http://localhost:8080/api/v1
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int defaultPageSize = 15;
  static const int splashDurationSeconds = 2;
  static const int carouselAutoScrollDuration = 4000;
  static const int debounceMilliseconds = 500;

  // ── Règles métier réservation ─────────────────────────────────────────────
  static const int maxPassengersPerBooking = 6;
  static const int ageMinAdulte = 12;   // ≥ 12 ans = adulte
  static const int ageMinEnfant = 2;    // 2–11 ans = enfant
  // < 2 ans = bébé (pas de siège propre)
  static const int ageMinorLegal = 18;  // < 18 = mineur légal
  static const int seatLockMinutes = 10;
}