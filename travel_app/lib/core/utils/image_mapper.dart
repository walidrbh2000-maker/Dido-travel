/// Génère des URLs d'images déterministes pour les hôtels.
///
/// Utilise [picsum.photos](https://picsum.photos) avec un seed numérique
/// calculé via FNV-1a (hash stable, indépendant de la plateforme).
/// Un même [hotelId] + [starRating] retourne toujours la même URL,
/// ce qui garantit la cohérence visuelle entre les sessions sans assets
/// locaux.
///
/// Niveaux d'étoiles → plages de seeds distinctes :
///   • 3★  → seeds 101–300  (photos sobres)
///   • 4★  → seeds 401–600  (photos plus soignées)
///   • 5★  → seeds 701–900  (photos luxueuses)
class HotelImageMapper {
  const HotelImageMapper._();

  static const String _base = 'https://picsum.photos/seed';

  static const Map<int, int> _tierOffset = {5: 700, 4: 400, 3: 100};

  // ── API publique ─────────────────────────────────────────────────

  /// Vignette pour les cartes de liste (400 × 260).
  static String thumbnail(int hotelId, int starRating) =>
      _build('ext-$hotelId', starRating, 400, 260);

  /// Grande image extérieure pour l'écran de détail (800 × 500).
  static String mainImage(int hotelId, int starRating) =>
      _build('ext-$hotelId', starRating, 800, 500);

  /// Image intérieure / chambre (800 × 500).
  static String roomImage(int hotelId, int starRating) =>
      _build('int-$hotelId', starRating, 800, 500);

  // ── Implémentation interne ────────────────────────────────────────

  static String _build(String tag, int stars, int w, int h) {
    final offset = _tierOffset[stars.clamp(3, 5)] ?? 100;
    // 200 seeds disponibles par tier, décalés pour éviter les collisions.
    final seed = (_fnv1a(tag) % 200) + offset + 1;
    return '$_base/$seed/$w/$h';
  }

  /// Hash FNV-1a 32 bits — résultat toujours positif et portable.
  static int _fnv1a(String s) {
    var h = 2166136261; // FNV offset basis
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 16777619) & 0xFFFFFFFF; // FNV prime + masque 32 bits
    }
    return h;
  }
}